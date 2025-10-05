import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/models/checklist_model.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Service responsável por buscar e montar checklists completos.
class ChecklistService extends GetxService {
  final AppDatabase _db = Get.find<AppDatabase>();

  /// Busca o checklist completo para um tipo de veículo específico.
  /// 
  /// Retorna o checklist com todas as perguntas e opções de resposta.
  Future<ChecklistCompletoModel?> buscarChecklistPorTipoVeiculo(
      int tipoVeiculoId) async {
    try {
      AppLogger.d(
          '🔍 Buscando checklist para tipo de veículo: $tipoVeiculoId',
          tag: 'ChecklistService');

      // 1. Buscar o modelo de checklist pelo tipo de veículo
      final checklistModeloDao = _db.checklistModeloDao;
      final modelos =
          await checklistModeloDao.buscarPorTipoVeiculo(tipoVeiculoId);

      if (modelos.isEmpty) {
        AppLogger.w(
            '⚠️ Nenhum checklist encontrado para tipo de veículo $tipoVeiculoId',
            tag: 'ChecklistService');
        return null;
      }

      // Pega o primeiro modelo encontrado
      final modelo = modelos.first;
      AppLogger.i('✅ Checklist encontrado: ${modelo.nome}',
          tag: 'ChecklistService');

      // 2. Buscar as perguntas deste checklist
      final checklistPerguntaDao = _db.checklistPerguntaDao;
      final perguntas = await checklistPerguntaDao.buscarPorModelo(
          modelo.remoteId ?? modelo.id);

      if (perguntas.isEmpty) {
        AppLogger.w('⚠️ Nenhuma pergunta encontrada para o checklist',
            tag: 'ChecklistService');
        return ChecklistCompletoModel(
          id: modelo.id,
          remoteId: modelo.remoteId ?? modelo.id,
          nome: modelo.nome,
          tipoChecklistId: modelo.tipoChecklistId,
          perguntas: [],
        );
      }

      AppLogger.d('📋 ${perguntas.length} perguntas encontradas',
          tag: 'ChecklistService');

      // 3. Para cada pergunta, buscar suas opções de resposta
      final checklistOpcaoRespostaDao = _db.checklistOpcaoRespostaDao;
      final List<ChecklistPerguntaModel> perguntasCompletas = [];

      for (final pergunta in perguntas) {
        // Buscar opções de resposta desta pergunta através do modelo
        final opcoes = await checklistOpcaoRespostaDao.buscarPorModelo(
            modelo.remoteId ?? modelo.id);

        final opcoesModel = opcoes.map((opcao) {
          return ChecklistOpcaoRespostaModel(
            id: opcao.id,
            remoteId: opcao.remoteId ?? opcao.id,
            nome: opcao.nome,
            geraPendencia: opcao.geraPendencia,
          );
        }).toList();

        perguntasCompletas.add(ChecklistPerguntaModel(
          id: pergunta.id,
          remoteId: pergunta.remoteId ?? pergunta.id,
          nome: pergunta.nome,
          opcoes: opcoesModel,
        ));
      }

      AppLogger.i('✅ Checklist completo montado com sucesso',
          tag: 'ChecklistService');

      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modelo.remoteId ?? modelo.id,
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: perguntasCompletas,
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist', tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca o checklist para o turno ativo.
  /// 
  /// Busca o veículo do turno e retorna o checklist correspondente.
  Future<ChecklistCompletoModel?> buscarChecklistDoTurnoAtivo() async {
    try {
      AppLogger.d('🔍 Buscando checklist do turno ativo',
          tag: 'ChecklistService');

      // 1. Buscar o turno ativo
      final turnoDao = _db.turnoDao;
      final turnoAtivo = await turnoDao.buscarTurnoAtivo();

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d('✅ Turno ativo encontrado: ID ${turnoAtivo.id}',
          tag: 'ChecklistService');

      // 2. Buscar o veículo do turno
      final veiculoDao = _db.veiculoDao;
      final veiculo = await veiculoDao.buscarPorId(turnoAtivo.veiculoId);

      if (veiculo == null) {
        AppLogger.w('⚠️ Veículo do turno não encontrado',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d('✅ Veículo encontrado: ${veiculo.placa}',
          tag: 'ChecklistService');

      // 3. Buscar o checklist pelo tipo de veículo
      return await buscarChecklistPorTipoVeiculo(veiculo.tipoVeiculoId);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist do turno ativo',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}

