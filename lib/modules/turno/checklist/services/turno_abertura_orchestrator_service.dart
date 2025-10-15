import 'dart:convert';

import 'package:get/get.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/domain/dto/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_resposta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável por reunir todas as informações necessárias para a
/// abertura do turno e enviá-las para a API através do [TurnoRepo].
class TurnoAberturaOrchestratorService extends GetxService {
  final TurnoRepo _turnoRepo;
  final EletricistaRepo _eletricistaRepo;
  final ChecklistPreenchidoRepo _checklistPreenchidoRepo;
  final ChecklistRespostaRepo _checklistRespostaRepo;
  final ChecklistModeloRepo _checklistModeloRepo;

  TurnoAberturaOrchestratorService({
    required TurnoRepo turnoRepo,
    required EletricistaRepo eletricistaRepo,
    required ChecklistPreenchidoRepo checklistPreenchidoRepo,
    required ChecklistRespostaRepo checklistRespostaRepo,
    required ChecklistModeloRepo checklistModeloRepo,
  })  : _turnoRepo = turnoRepo,
        _eletricistaRepo = eletricistaRepo,
        _checklistPreenchidoRepo = checklistPreenchidoRepo,
        _checklistRespostaRepo = checklistRespostaRepo,
        _checklistModeloRepo = checklistModeloRepo;

  /// Orquestra a abertura do turno: coleta dados locais, envia para a API e
  /// atualiza o status do turno quando a operação for bem sucedida.
  Future<bool> enviarAberturaDoTurno() async {
    try {
      final turno = await _turnoRepo.buscarTurnoAtivo();
      if (turno == null) {
        throw Exception('Nenhum turno em abertura encontrado');
      }

      final eletricistas = await _turnoRepo.buscarEletricistasDoTurno(turno.id);

      final checklists =
          await _checklistPreenchidoRepo.buscarPorTurno(turno.id);

      final payload = await _montarPayload(
        turno: turno,
        eletricistas: eletricistas,
        checklists: checklists,
      );

      AppLogger.v(
        '📦 Payload abertura turno: ${jsonEncode(payload)}',
        tag: 'TurnoAberturaService',
      );

      final remoteId = await _turnoRepo.enviarAberturaTurno(payload);

      final turnoAtualizado = turno.copyWith(
        remoteId: remoteId,
        situacaoTurno: SituacaoTurno.aberto,
      );

      final atualizado = await _turnoRepo.atualizarTurno(turnoAtualizado);
      if (!atualizado) {
        AppLogger.w('Não foi possível atualizar o turno localmente após envio',
            tag: 'TurnoAberturaService');
      }

      AppLogger.i('Turno ${turno.id} sincronizado com remoteId=$remoteId',
          tag: 'TurnoAberturaService');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao orquestrar abertura do turno',
          tag: 'TurnoAberturaService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<Map<String, dynamic>> _montarPayload({
    required TurnoTableDto turno,
    required List<TurnoEletricistasTableDto> eletricistas,
    required List<ChecklistPreenchidoTableDto> checklists,
  }) async {
    final turnoPayload = _mapearTurno(turno);
    final eletricistasPayload = await _mapearEletricistas(eletricistas);
    final checklistsPayload = await _mapearChecklists(checklists);

    return {
      'turno': turnoPayload,
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
      List<ChecklistPreenchidoTableDto> checklists) async {
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

      lista.add({
        'idLocal': checklistIdLocal,
        'checklistModeloId': checklist.checklistModeloId,
        'checklistNome': checklistNome,
        'eletricistaRemoteId': checklist.eletricistaRemoteId,
        'latitude': checklist.latitude,
        'longitude': checklist.longitude,
        'dataPreenchimento': checklist.dataPreenchimento.toIso8601String(),
        'respostas': respostas,
      });
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
