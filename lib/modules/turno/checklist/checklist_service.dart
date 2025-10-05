import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_table_dto.dart';
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
          '🔍 [DIAGNÓSTICO] Iniciando busca de checklist para tipoVeiculoId: $tipoVeiculoId',
          tag: 'ChecklistService');

      // 1. Buscar o modelo de checklist pelo tipo de veículo
      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Chamando checklistModeloDao.buscarPorTipoVeiculo($tipoVeiculoId)',
          tag: 'ChecklistService');
      final checklistModeloDao = _db.checklistModeloDao;
      final modelos =
          await checklistModeloDao.buscarPorTipoVeiculo(tipoVeiculoId);

      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Resultado da busca: ${modelos.length} modelos encontrados',
          tag: 'ChecklistService');

      if (modelos.isNotEmpty) {
        for (int i = 0; i < modelos.length; i++) {
          final modelo = modelos[i];
          AppLogger.d(
              '🔍 [DIAGNÓSTICO] Modelo $i: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
              tag: 'ChecklistService');
        }
      }

      if (modelos.isEmpty) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Nenhum checklist encontrado para tipo de veículo $tipoVeiculoId',
            tag: 'ChecklistService');
        return null;
      }

      // Pega o primeiro modelo encontrado
      final modelo = modelos.first;
      AppLogger.i('✅ Checklist encontrado: ${modelo.nome}',
          tag: 'ChecklistService');

      // 2. Buscar as perguntas deste checklist
      final checklistPerguntaDao = _db.checklistPerguntaDao;
      final perguntas =
          await checklistPerguntaDao.buscarPorModelo(modelo.remoteId!);

      if (perguntas.isEmpty) {
        AppLogger.w('⚠️ Nenhuma pergunta encontrada para o checklist',
            tag: 'ChecklistService');
        return ChecklistCompletoModel(
          id: modelo.id,
          remoteId: modelo.remoteId!,
          nome: modelo.nome,
          tipoChecklistId: modelo.tipoChecklistId,
          perguntas: [],
        );
      }

      AppLogger.d('📋 ${perguntas.length} perguntas encontradas',
          tag: 'ChecklistService');

      // 3. Para cada pergunta, buscar suas opções de resposta
      final checklistOpcaoRespostaDao = _db.checklistOpcaoRespostaDao;

      // ----------------------------------------------------------------------
      // 🧠 Cache das opções por modelo
      // ----------------------------------------------------------------------
      // Para evitar leituras repetidas do banco (uma por pergunta) fazemos a
      // consulta apenas uma vez e armazenamos o resultado localmente. Caso a
      // base evolua para disponibilizar subconjuntos por pergunta, o mapa
      // abaixo permite distribuir cada fatia sem novas idas ao banco.
      final opcoesPorModelo =
          await checklistOpcaoRespostaDao.buscarPorModelo(modelo.remoteId!);
      final Map<int, List<ChecklistOpcaoRespostaTableDto>> opcoesPorPergunta =
          {};

      for (final pergunta in perguntas) {
        final chavePergunta = pergunta.remoteId ?? pergunta.id;
        opcoesPorPergunta[chavePergunta] =
            List<ChecklistOpcaoRespostaTableDto>.from(opcoesPorModelo);
        AppLogger.d(
          '♻️ [CACHE] Pergunta ${pergunta.nome} (chave $chavePergunta) recebeu ${opcoesPorPergunta[chavePergunta]!.length} opções em memória',
          tag: 'ChecklistService',
        );
      }

      final List<ChecklistPerguntaModel> perguntasCompletas = [];

      for (final pergunta in perguntas) {
        final chavePergunta = pergunta.remoteId ?? pergunta.id;
        final opcoes = opcoesPorPergunta[chavePergunta] ?? opcoesPorModelo;

        final opcoesModel = opcoes.map((opcao) {
          return ChecklistOpcaoRespostaModel(
            id: opcao.id,
            remoteId: opcao.remoteId!,
            nome: opcao.nome,
            geraPendencia: opcao.geraPendencia,
          );
        }).toList();

        AppLogger.d(
          '✅ [VALIDAÇÃO] Pergunta ${pergunta.nome} recebeu ${opcoesModel.length} opções convertidas',
          tag: 'ChecklistService',
        );

        perguntasCompletas.add(ChecklistPerguntaModel(
          id: pergunta.id,
          remoteId: pergunta.remoteId!,
          nome: pergunta.nome,
          opcoes: opcoesModel,
        ));
      }

      AppLogger.i('✅ Checklist completo montado com sucesso',
          tag: 'ChecklistService');

      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modelo.remoteId!,
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: perguntasCompletas,
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
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

      // 2. Buscar o veículo do turno pelo remoteId (correção)
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
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist do turno ativo',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
