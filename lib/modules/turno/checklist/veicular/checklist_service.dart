import 'package:get/get.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/models/checklist_model.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Service responsável por buscar e montar checklists completos.
class ChecklistService extends GetxService {
  /// Repositório responsável pelos modelos de checklist persistidos localmente.
  final ChecklistModeloRepo _checklistModeloRepo;

  /// Repositório que expõe as perguntas vinculadas a um modelo de checklist.
  final ChecklistPerguntaRepo _checklistPerguntaRepo;

  /// Repositório que recupera as opções de resposta disponíveis por modelo.
  final ChecklistOpcaoRespostaRepo _checklistOpcaoRespostaRepo;

  /// Repositório que oferece operações de consulta para os turnos abertos.
  final TurnoRepo _turnoRepo;

  /// Repositório que disponibiliza informações detalhadas dos veículos.
  final VeiculoRepo _veiculoRepo;

  /// Construtor com injeção explícita de dependências utilizadas pelo serviço.
  ///
  /// A adoção da injeção por construtor facilita testes unitários (permitindo
  /// substituir os repositórios por fakes/mocks) e deixa explícito quais
  /// camadas de dados o serviço consome para montar o checklist completo.
  ChecklistService({
    required ChecklistModeloRepo checklistModeloRepo,
    required ChecklistPerguntaRepo checklistPerguntaRepo,
    required ChecklistOpcaoRespostaRepo checklistOpcaoRespostaRepo,
    required TurnoRepo turnoRepo,
    required VeiculoRepo veiculoRepo,
  })  : _checklistModeloRepo = checklistModeloRepo,
        _checklistPerguntaRepo = checklistPerguntaRepo,
        _checklistOpcaoRespostaRepo = checklistOpcaoRespostaRepo,
        _turnoRepo = turnoRepo,
        _veiculoRepo = veiculoRepo;

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
          '🔍 [DIAGNÓSTICO] Chamando ChecklistModeloRepo.buscarPorTipoVeiculo($tipoVeiculoId)',
          tag: 'ChecklistService');
      final modelos =
          await _checklistModeloRepo.buscarPorTipoVeiculo(tipoVeiculoId);

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
      if (modelo.remoteId == null) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Checklist ${modelo.nome} não possui remoteId para buscar relacionamentos',
            tag: 'ChecklistService');
        return ChecklistCompletoModel(
          id: modelo.id,
          remoteId: modelo.remoteId ?? modelo.id,
          nome: modelo.nome,
          tipoChecklistId: modelo.tipoChecklistId,
          perguntas: const [],
        );
      }
      AppLogger.i('✅ Checklist encontrado: ${modelo.nome}',
          tag: 'ChecklistService');

      // 2. Buscar as perguntas deste checklist
      final perguntas =
          await _checklistPerguntaRepo.buscarPorModelo(modelo.remoteId!);

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
      final opcoes =
          await _checklistOpcaoRespostaRepo.buscarPorModelo(modelo.remoteId!);
      final opcoesModel = opcoes.map((opcao) {
        if (opcao.remoteId == null) {
          AppLogger.w(
              '⚠️ [DIAGNÓSTICO] Opção ${opcao.nome} sem remoteId vinculada ao checklist ${modelo.nome}',
              tag: 'ChecklistService');
        }
        return ChecklistOpcaoRespostaModel(
          id: opcao.id,
          remoteId: opcao.remoteId ?? opcao.id,
          nome: opcao.nome,
          geraPendencia: opcao.geraPendencia,
        );
      }).toList();

      final List<ChecklistPerguntaModel> perguntasCompletas = [];

      for (final pergunta in perguntas) {
        if (pergunta.remoteId == null) {
          AppLogger.w(
              '⚠️ [DIAGNÓSTICO] Pergunta ${pergunta.nome} não possui remoteId; mantendo opções, mas sem associação remota',
              tag: 'ChecklistService');
        }

        AppLogger.d(
          '✅ [VALIDAÇÃO] Pergunta ${pergunta.nome} recebeu ${opcoesModel.length} opções convertidas',
          tag: 'ChecklistService',
        );

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
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d('✅ Turno ativo encontrado: ID ${turnoAtivo.id}',
          tag: 'ChecklistService');

      // 2. Buscar o veículo do turno pelo remoteId (correção)
      VeiculoTableDto? veiculoDto;
      try {
        veiculoDto = await _veiculoRepo.buscarPorId(turnoAtivo.veiculoId);
      } catch (error, stackTrace) {
        AppLogger.e(
          '❌ Erro ao buscar veículo ${turnoAtivo.veiculoId} via VeiculoRepo',
          tag: 'ChecklistService',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final veiculo = veiculoDto;

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
