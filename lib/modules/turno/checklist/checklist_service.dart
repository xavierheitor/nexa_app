import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_pergunta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_resposta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Modelo para checklist completo
class ChecklistCompletoModel {
  final ChecklistModeloTableDto modelo;
  final List<ChecklistPerguntaModel> perguntas;

  ChecklistCompletoModel({
    required this.modelo,
    required this.perguntas,
  });
}

/// Modelo para pergunta do checklist
class ChecklistPerguntaModel {
  final int id;
  final String nome;
  final List<ChecklistOpcaoRespostaModel> opcoes;
  int? respostaSelecionada;

  ChecklistPerguntaModel({
    required this.id,
    required this.nome,
    required this.opcoes,
    this.respostaSelecionada,
  });
}

/// Modelo para opção de resposta
class ChecklistOpcaoRespostaModel {
  final int id;
  final String nome;
  final bool geraPendencia;

  ChecklistOpcaoRespostaModel({
    required this.id,
    required this.nome,
    required this.geraPendencia,
  });
}

/// Serviço para gerenciar checklists
class ChecklistService {
  final AppDatabase _db;
  final ChecklistPreenchidoRepo _checklistPreenchidoRepo;
  final ChecklistRespostaRepo _checklistRespostaRepo;

  ChecklistService(
      this._db, this._checklistPreenchidoRepo, this._checklistRespostaRepo);

  /// Busca o checklist do turno ativo
  Future<ChecklistCompletoModel?> buscarChecklistDoTurnoAtivo() async {
    AppLogger.d(
        '🔍 [DIAGNÓSTICO] Iniciando busca de checklist para turno ativo',
        tag: 'ChecklistService');

    // 1. Buscar o turno ativo
    final turnoDao = _db.turnoDao;
    final turnos = await turnoDao.listar();
    final turnoAtivo =
        turnos.where((t) => t.situacaoTurno == 'em_abertura').firstOrNull;

    if (turnoAtivo == null) {
      AppLogger.w('⚠️ Nenhum turno em abertura encontrado',
          tag: 'ChecklistService');
      return null;
    }

    AppLogger.d('✅ Turno ativo encontrado: ${turnoAtivo.id}',
        tag: 'ChecklistService');

    // 2. Buscar o veículo do turno
    final veiculoDao = _db.veiculoDao;
    final veiculo = await veiculoDao.buscarPorIdOuNull(turnoAtivo.veiculoId);

    if (veiculo == null) {
      AppLogger.w(
          '⚠️ Veículo do turno não encontrado (ID: ${turnoAtivo.veiculoId})',
          tag: 'ChecklistService');
      return null;
    }
    AppLogger.d(
        '✅ Veículo encontrado: ${veiculo.placa} (Tipo: ${veiculo.tipoVeiculoId})',
        tag: 'ChecklistService');

    // 3. Buscar checklist diretamente pelo tipoVeiculoId do veículo
    AppLogger.d(
        '🔍 [SIMPLIFICADO] Buscando checklist para tipoVeiculoId: ${veiculo.tipoVeiculoId}',
        tag: 'ChecklistService');
    
    return await buscarChecklistPorTipoVeiculo(veiculo.tipoVeiculoId);
  }

  /// Busca checklist por tipo de veículo
  Future<ChecklistCompletoModel?> buscarChecklistPorTipoVeiculo(
      int tipoVeiculoId) async {
    AppLogger.d(
        '🔍 [DIAGNÓSTICO] Iniciando busca de checklist para tipoVeiculoId: $tipoVeiculoId',
        tag: 'ChecklistService');
    AppLogger.d(
        '🔍 [DIAGNÓSTICO] Chamando checklistModeloDao.buscarPorTipoVeiculo($tipoVeiculoId)',
        tag: 'ChecklistService');

    final checklistModeloDao = _db.checklistModeloDao;
    final modelos =
        await checklistModeloDao.buscarPorTipoVeiculo(tipoVeiculoId);

    AppLogger.d(
        '🔍 [DIAGNÓSTICO] Resultado da busca: ${modelos.length} modelos encontrados',
        tag: 'ChecklistService');
    for (int i = 0; i < modelos.length; i++) {
      final modelo = modelos[i];
      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Modelo $i: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
          tag: 'ChecklistService');
    }

    if (modelos.isEmpty) {
      AppLogger.w(
          '⚠️ Nenhum modelo de checklist encontrado para tipoVeiculoId: $tipoVeiculoId',
          tag: 'ChecklistService');
      return null;
    }

    final modelo = modelos.first;
    AppLogger.i('✅ Checklist encontrado: ${modelo.nome}',
        tag: 'ChecklistService');

    // Buscar perguntas e opções
    final checklistPerguntaDao = _db.checklistPerguntaDao;
    final checklistOpcaoRespostaDao = _db.checklistOpcaoRespostaDao;

    final perguntas =
        await checklistPerguntaDao.buscarPorModelo(modelo.remoteId!);
    AppLogger.d('📋 ${perguntas.length} perguntas encontradas',
        tag: 'ChecklistService');

    final perguntasComOpcoes = <ChecklistPerguntaModel>[];

    for (final pergunta in perguntas) {
      final opcoes =
          await checklistOpcaoRespostaDao.buscarPorModelo(modelo.remoteId!);
      final opcoesFiltradas = opcoes
          .where((opcao) => opcao.perguntaId == pergunta.remoteId)
          .toList();

      final opcoesModel = opcoesFiltradas
          .map((opcao) => ChecklistOpcaoRespostaModel(
                id: opcao.remoteId!,
                nome: opcao.nome,
                geraPendencia: opcao.geraPendencia,
              ))
          .toList();

      perguntasComOpcoes.add(ChecklistPerguntaModel(
        id: pergunta.remoteId!,
        nome: pergunta.nome,
        opcoes: opcoesModel,
      ));
    }

    AppLogger.i('✅ Checklist completo montado com sucesso',
        tag: 'ChecklistService');

    return ChecklistCompletoModel(
      modelo: modelo,
      perguntas: perguntasComOpcoes,
    );
  }

  /// Salva o checklist preenchido
  Future<bool> salvarChecklistPreenchido({
    required ChecklistCompletoModel checklist,
    required List<ChecklistPerguntaModel> perguntasRespondidas,
    double? latitude,
    double? longitude,
  }) async {
    AppLogger.d('💾 Salvando checklist preenchido', tag: 'ChecklistService');

    try {
      // 1. Buscar o turno ativo
      final turnoDao = _db.turnoDao;
      final turnos = await turnoDao.listar();
      final turnoAtivo =
          turnos.where((t) => t.situacaoTurno == 'em_abertura').firstOrNull;

      if (turnoAtivo == null) {
        AppLogger.e('❌ Nenhum turno em abertura encontrado',
            tag: 'ChecklistService');
        return false;
      }

      // 2. Salvar o checklist preenchido
      final checklistPreenchidoId =
          await _checklistPreenchidoRepo.salvarChecklistCompleto(
        turnoId: turnoAtivo.id,
        checklistModeloId: checklist.modelo.remoteId!,
        respostas: [], // Será preenchido abaixo
        latitude: latitude,
        longitude: longitude,
      );

      AppLogger.d('✅ Checklist preenchido salvo com ID: $checklistPreenchidoId',
          tag: 'ChecklistService');

      // 3. Preparar respostas
      final respostas = <Map<String, dynamic>>[];
      for (final pergunta in perguntasRespondidas) {
        if (pergunta.respostaSelecionada != null) {
          respostas.add({
            'perguntaId': pergunta.id,
            'opcaoRespostaId': pergunta.respostaSelecionada!,
          });
        }
      }

      // 4. Salvar as respostas
      if (respostas.isNotEmpty) {
        await _checklistRespostaRepo.salvarRespostas(
          checklistPreenchidoId: checklistPreenchidoId,
          respostas: respostas,
        );
        AppLogger.d('✅ ${respostas.length} respostas salvas',
            tag: 'ChecklistService');
      }

      AppLogger.i('✅ Checklist preenchido salvo com sucesso',
          tag: 'ChecklistService');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao salvar checklist preenchido: $e',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Verifica se o checklist já foi preenchido para o turno ativo
  Future<bool> checklistJaPreenchido() async {
    AppLogger.d('🔍 Verificando se checklist já foi preenchido',
        tag: 'ChecklistService');

    try {
      // 1. Buscar o turno ativo
      final turnoDao = _db.turnoDao;
      final turnos = await turnoDao.listar();
      final turnoAtivo =
          turnos.where((t) => t.situacaoTurno == 'em_abertura').firstOrNull;

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno em abertura encontrado',
            tag: 'ChecklistService');
        return false;
      }

      // 2. Verificar se existe checklist preenchido para este turno
      final existe =
          await _checklistPreenchidoRepo.existeParaTurno(turnoAtivo.id);
      
      AppLogger.d('🔍 Checklist já preenchido: $existe',
          tag: 'ChecklistService');
      return existe;

    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar se checklist foi preenchido: $e',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
