import 'dart:convert';

import 'package:get/get.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/domain/dto/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_resposta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável por reunir todas as informações necessárias para a
/// abertura do turno e enviá-las para a API através do [TurnoRepo].
class TurnoAberturaOrchestratorService extends GetxService {
  final TurnoRepo _turnoRepo;
  final EletricistaRepo _eletricistaRepo;
  final ChecklistPreenchidoRepo _checklistPreenchidoRepo;
  final ChecklistRespostaRepo _checklistRespostaRepo;
  final ChecklistModeloRepo _checklistModeloRepo;
  final VeiculoRepo _veiculoRepo;
  final EquipeRepo _equipeRepo;

  TurnoAberturaOrchestratorService({
    required TurnoRepo turnoRepo,
    required EletricistaRepo eletricistaRepo,
    required ChecklistPreenchidoRepo checklistPreenchidoRepo,
    required ChecklistRespostaRepo checklistRespostaRepo,
    required ChecklistModeloRepo checklistModeloRepo,
    required VeiculoRepo veiculoRepo,
    required EquipeRepo equipeRepo,
  })  : _turnoRepo = turnoRepo,
        _eletricistaRepo = eletricistaRepo,
        _checklistPreenchidoRepo = checklistPreenchidoRepo,
        _checklistRespostaRepo = checklistRespostaRepo,
        _checklistModeloRepo = checklistModeloRepo,
        _veiculoRepo = veiculoRepo,
        _equipeRepo = equipeRepo;

  /// Orquestra a abertura do turno: coleta dados locais, envia para a API e
  /// atualiza o status do turno quando a operação for bem sucedida.
  Future<Map<String, dynamic>> enviarAberturaDoTurno() async {
    try {
      AppLogger.d('🚀 [ABERTURA TURNO] Iniciando processo de abertura de turno',
          tag: 'TurnoAberturaService');

      // 1. Buscar turno ativo
      final turno = await _turnoRepo.buscarTurnoAtivo();
      if (turno == null) {
        throw Exception('Nenhum turno em abertura encontrado');
      }

      AppLogger.d('📦 [ABERTURA TURNO] Turno encontrado: ID=${turno.id}',
          tag: 'TurnoAberturaService');

      // 2. Buscar dados relacionados
      final eletricistas = await _turnoRepo.buscarEletricistasDoTurno(turno.id);
      final checklists =
          await _checklistPreenchidoRepo.buscarPorTurno(turno.id);

      AppLogger.d(
          '👷 [ABERTURA TURNO] ${eletricistas.length} eletricistas encontrados',
          tag: 'TurnoAberturaService');
      AppLogger.d(
          '📋 [ABERTURA TURNO] ${checklists.length} checklists encontrados',
          tag: 'TurnoAberturaService');

      // 3. Buscar informações da viatura e equipe
      final veiculo = await _veiculoRepo.buscarPorId(turno.veiculoId);
      final equipe = await _equipeRepo.buscarPorId(turno.equipeId.toString());

      // VeiculoRepo.buscarPorId não retorna null, mas EquipeRepo sim
      if (equipe == null) {
        throw Exception('Equipe não encontrada para o turno');
      }

      AppLogger.d(
          '🚗 [ABERTURA TURNO] Viatura: ${veiculo.placa} (ID=${veiculo.remoteId})',
          tag: 'TurnoAberturaService');
      AppLogger.d(
          '👥 [ABERTURA TURNO] Equipe: ${equipe.nome} (ID=${equipe.remoteId})',
          tag: 'TurnoAberturaService');

      // 4. Montar payload completo
      final payload = await _montarPayload(
        turno: turno,
        eletricistas: eletricistas,
        checklists: checklists,
        veiculo: veiculo,
        equipe: equipe,
      );

      AppLogger.v(
        '📦 [ABERTURA TURNO] Payload montado: ${jsonEncode(payload)}',
        tag: 'TurnoAberturaService',
      );

      // 5. Enviar para API
      AppLogger.d('📡 [ABERTURA TURNO] Enviando dados para API...',
          tag: 'TurnoAberturaService');

      final remoteId = await _turnoRepo.enviarAberturaTurno(payload);

      AppLogger.i('✅ [ABERTURA TURNO] Resposta da API: remoteId=$remoteId',
          tag: 'TurnoAberturaService');

      // 6. Atualizar turno local
      final turnoAtualizado = turno.copyWith(
        remoteId: remoteId,
        situacaoTurno: SituacaoTurno.aberto,
      );

      final atualizado = await _turnoRepo.atualizarTurno(turnoAtualizado);
      if (!atualizado) {
        AppLogger.w(
            '⚠️ [ABERTURA TURNO] Não foi possível atualizar o turno localmente após envio',
            tag: 'TurnoAberturaService');
      }

      AppLogger.i(
          '✅ [ABERTURA TURNO] Turno ${turno.id} aberto com sucesso! RemoteID: $remoteId',
          tag: 'TurnoAberturaService');

      return {
        'success': true,
        'remoteId': remoteId,
        'message': 'Turno aberto com sucesso',
      };
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ABERTURA TURNO] Erro ao abrir turno',
          tag: 'TurnoAberturaService', error: e, stackTrace: stackTrace);

      // Captura erro específico de abertura de turno
      if (e is TurnoAberturaException) {
        return {
          'success': false,
          'statusCode': e.statusCode,
          'message': e.message,
          'isConflictError': e.isConflictError,
          'isValidationError': e.isValidationError,
          'isServerError': e.isServerError,
          'originalError': e.toString(),
        };
      }

      // Erro genérico
      return {
        'success': false,
        'statusCode': 0,
        'message': 'Erro inesperado ao abrir turno',
        'isConflictError': false,
        'isValidationError': false,
        'isServerError': false,
        'originalError': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _montarPayload({
    required TurnoTableDto turno,
    required List<TurnoEletricistasTableDto> eletricistas,
    required List<ChecklistPreenchidoTableDto> checklists,
    required VeiculoTableDto veiculo,
    required EquipeTableDto equipe,
  }) async {
    final turnoPayload = _mapearTurno(turno);
    final veiculoPayload = _mapearVeiculo(veiculo);
    final equipePayload = _mapearEquipe(equipe);
    final eletricistasPayload = await _mapearEletricistas(eletricistas);
    final checklistsPayload = await _mapearChecklists(checklists, eletricistas);

    return {
      'turno': turnoPayload,
      'veiculo': veiculoPayload,
      'equipe': equipePayload,
      'eletricistas': eletricistasPayload,
      'checklists': checklistsPayload,
    };
  }

  Map<String, dynamic> _mapearTurno(TurnoTableDto turno) {
    return {
      'idLocal': turno.id,
      'remoteId': turno.remoteId,
      'veiculoId': turno.veiculoId,
      'equipeId': turno.equipeId,
      'kmInicial': turno.kmInicial,
      'kmFinal': turno.kmFinal,
      'horaInicio': turno.horaInicio.toIso8601String(),
      'horaFim': turno.horaFim?.toIso8601String(),
      'latitude': turno.latitude,
      'longitude': turno.longitude,
    };
  }

  Map<String, dynamic> _mapearVeiculo(VeiculoTableDto veiculo) {
    return {
      'idLocal': int.parse(veiculo.id), // Converte String para int
      'remoteId': veiculo.remoteId,
      'placa': veiculo.placa,
      'tipoVeiculoId': veiculo.tipoVeiculoId,
      'sincronizado': veiculo.sincronizado,
      'createdAt': veiculo.createdAt.toIso8601String(),
      'updatedAt': veiculo.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _mapearEquipe(EquipeTableDto equipe) {
    return {
      'idLocal': int.parse(equipe.id), // Converte String para int
      'remoteId': equipe.remoteId,
      'nome': equipe.nome,
      'descricao': equipe.descricao,
      'tipoEquipeId': equipe.tipoEquipeId,
      'sincronizado': equipe.sincronizado,
      'createdAt': equipe.createdAt.toIso8601String(),
      'updatedAt': equipe.updatedAt.toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> _mapearEletricistas(
      List<TurnoEletricistasTableDto> relacionamentos) async {
    final lista = <Map<String, dynamic>>[];

    for (final rel in relacionamentos) {
      try {
        final eletricista =
            await _eletricistaRepo.buscarPorRemoteId(rel.eletricistaId);
        lista.add({
          'remoteId': int.parse(eletricista.remoteId),
          'nome': eletricista.nome,
          'matricula': eletricista.matricula,
          'motorista': rel.motorista,
        });
      } catch (e, stackTrace) {
        AppLogger.e('Erro ao mapear eletricista ${rel.eletricistaId}',
            tag: 'TurnoAberturaService', error: e, stackTrace: stackTrace);
      }
    }

    return lista;
  }

  Future<List<Map<String, dynamic>>> _mapearChecklists(
      List<ChecklistPreenchidoTableDto> checklists,
      List<TurnoEletricistasTableDto> eletricistas) async {
    final lista = <Map<String, dynamic>>[];

    for (final checklist in checklists) {
      final checklistIdLocal = int.tryParse(checklist.id) ?? 0;
      final respostas = await _buscarRespostas(checklistIdLocal);

      String? checklistNome;
      try {
        final modelo = await _checklistModeloRepo
            .buscarPorRemoteId(checklist.checklistModeloId);
        checklistNome = modelo?.nome;
      } catch (_) {
        // ignora falha ao buscar nome
      }

      final checklistMap = <String, dynamic>{
        'idLocal': checklistIdLocal,
        'checklistModeloId': checklist.checklistModeloId,
        'checklistNome': checklistNome,
        'latitude': checklist.latitude,
        'longitude': checklist.longitude,
        'dataPreenchimento': checklist.dataPreenchimento.toIso8601String(),
        'respostas': respostas,
      };

      // Inclui eletricistaRemoteId apenas se for válido (> 0)
      // A API irá aplicar fallback se não for fornecido ou for inválido
      final eletricistaRemoteId = checklist.eletricistaRemoteId;
      if (eletricistaRemoteId != null && eletricistaRemoteId > 0) {
        checklistMap['eletricistaRemoteId'] = eletricistaRemoteId;
        AppLogger.d(
          'Checklist $checklistIdLocal associado ao eletricista $eletricistaRemoteId',
          tag: 'TurnoAberturaService',
        );
      } else {
        AppLogger.d(
          'Checklist $checklistIdLocal sem eletricistaRemoteId válido - API aplicará fallback',
          tag: 'TurnoAberturaService',
        );
      }

      lista.add(checklistMap);
    }

    return lista;
  }

  Future<List<Map<String, dynamic>>> _buscarRespostas(int checklistId) async {
    final respostasDto =
        await _checklistRespostaRepo.buscarPorChecklistPreenchido(checklistId);

    return respostasDto
        .map((ChecklistRespostaTableDto resposta) => {
              'perguntaId': resposta.perguntaId,
              'opcaoRespostaId': resposta.opcaoRespostaId,
              'dataResposta': resposta.dataResposta.toIso8601String(),
            })
        .toList();
  }
}
