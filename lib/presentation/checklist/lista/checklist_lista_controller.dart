import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/data/models/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/enums/checklist_tipo.dart';
import 'package:nexa_app/app/routes/routes.dart';

/// Controller responsável pela listagem de checklists preenchidos do turno.
///
/// Este controller gerencia a exibição de todos os checklists preenchidos
/// durante o turno ativo, permitindo ao usuário visualizar as respostas
/// de cada checklist.
///
/// ## Responsabilidades:
///
/// 1. **Carregamento de Dados**: Busca checklists preenchidos do turno
/// 2. **Formatação de Dados**: Prepara dados para exibição na UI
/// 3. **Navegação**: Redireciona para visualização detalhada
/// 4. **Gerenciamento de Estado**: Controla loading e erros
///
/// ## Funcionalidades:
///
/// - Lista checklists por tipo (Veicular, EPC, EPI)
/// - Mostra informações do eletricista para checklists EPI
/// - Permite navegar para visualização detalhada
/// - Atualização automática quando turno muda
///
/// ## Uso:
///
/// ```dart
/// final controller = Get.find<ChecklistListaController>();
/// await controller.carregarChecklists();
/// ```
class ChecklistListaController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  late final TurnoController _turnoController;
  late final ChecklistPreenchidoRepo _checklistPreenchidoRepo;
  late final EletricistaRepo _eletricistaRepo;
  late final ChecklistModeloRepo _checklistModeloRepo;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Lista de checklists preenchidos do turno atual.
  final RxList<ChecklistPreenchidoTableDto> checklists =
      <ChecklistPreenchidoTableDto>[].obs;

  /// Lista formatada para exibição na UI.
  final RxList<ChecklistItem> checklistsFormatados = <ChecklistItem>[].obs;

  /// Flag indicando se está carregando dados.
  final RxBool isLoading = false.obs;

  /// Flag indicando se há erro.
  final RxBool temErro = false.obs;

  /// Mensagem de erro.
  final RxString mensagemErro = ''.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Verifica se há checklists preenchidos.
  bool get temChecklists => checklists.isNotEmpty;

  /// Retorna o turno ativo atual.
  dynamic get turnoAtivo => _turnoController.turnoAtivo.value;

  /// Retorna o prefixo do turno (ex: "A-123").
  String get prefixoTurno => _turnoController.prefixoTurno ?? 'N/A';

  // ============================================================================
  // INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _inicializarDependencias();
    AppLogger.i('ChecklistListaController inicializado',
        tag: 'ChecklistListaController');
  }

  @override
  void onReady() {
    super.onReady();
    carregarChecklists();
  }

  /// Inicializa as dependências necessárias.
  void _inicializarDependencias() {
    _turnoController = Get.find<TurnoController>();
    _checklistPreenchidoRepo = Get.find<ChecklistPreenchidoRepo>();
    _eletricistaRepo = Get.find<EletricistaRepo>();
    _checklistModeloRepo = Get.find<ChecklistModeloRepo>();
  }

  // ============================================================================
  // MÉTODOS DE CARREGAMENTO
  // ============================================================================

  /// Carrega todos os checklists preenchidos do turno ativo.
  Future<void> carregarChecklists() async {
    try {
      isLoading.value = true;
      temErro.value = false;

      AppLogger.d('Carregando checklists do turno ativo',
          tag: 'ChecklistListaController');

      final turno = _turnoController.turnoAtivo.value;
      if (turno == null) {
        throw Exception('Nenhum turno ativo encontrado');
      }

      // Busca checklists preenchidos do turno
      final checklistsTurno =
          await _checklistPreenchidoRepo.buscarPorTurno(turno.id);

      AppLogger.d('${checklistsTurno.length} checklists encontrados',
          tag: 'ChecklistListaController');

      checklists.value = checklistsTurno;
      await _formatarChecklistsParaExibicao();

      AppLogger.i('Checklists carregados com sucesso',
          tag: 'ChecklistListaController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar checklists',
          tag: 'ChecklistListaController', error: e, stackTrace: stackTrace);

      temErro.value = true;
      mensagemErro.value = 'Erro ao carregar checklists: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Formata os checklists para exibição na UI.
  ///
  /// Para checklists Veicular e EPC, mantém apenas um de cada tipo do turno ativo.
  /// Para checklists EPI, mantém todos (1 por eletricista) do turno ativo.
  Future<void> _formatarChecklistsParaExibicao() async {
    try {
      final List<ChecklistItem> formatados = [];

      // Mapas para rastrear um checklist de cada tipo não-EPI do turno ativo
      final Map<int, ChecklistPreenchidoTableDto> checklistsVeicularEPC = {};

      for (final checklist in checklists) {
        AppLogger.d(
            '🔍 Processando checklist ID: ${checklist.id}, modeloId: ${checklist.checklistModeloId}, eletricistaRemoteId: ${checklist.eletricistaRemoteId}',
            tag: 'ChecklistListaController');

        // Busca informações do modelo do checklist pelo remoteId
        final modelo = await _checklistModeloRepo
            .buscarPorRemoteId(checklist.checklistModeloId);

        if (modelo == null) {
          AppLogger.w(
              '⚠️ Modelo não encontrado para checklistModeloId: ${checklist.checklistModeloId}',
              tag: 'ChecklistListaController');
          continue;
        }

        AppLogger.d(
            '📋 Modelo encontrado - ID: ${modelo.id}, remoteId: ${modelo.remoteId}, Nome: ${modelo.nome}, tipoChecklistId: ${modelo.tipoChecklistId}',
            tag: 'ChecklistListaController');

        // CORREÇÃO TEMPORÁRIA: Mapeia tipos baseado nos IDs dos modelos
        // Modelo remoteId 1 = Veicular, Modelo remoteId 2 = EPC, Modelo remoteId 3 = EPI
        ChecklistTipo tipo;
        if (modelo.remoteId == 1) {
          tipo = ChecklistTipo.veicular;
          AppLogger.d('🔧 CORREÇÃO: Modelo remoteId 1 mapeado como Veicular',
              tag: 'ChecklistListaController');
        } else if (modelo.remoteId == 2) {
          tipo = ChecklistTipo.epc;
          AppLogger.d('🔧 CORREÇÃO: Modelo remoteId 2 mapeado como EPC',
              tag: 'ChecklistListaController');
        } else if (modelo.remoteId == 3) {
          tipo = ChecklistTipo.epi;
          AppLogger.d('🔧 CORREÇÃO: Modelo remoteId 3 mapeado como EPI',
              tag: 'ChecklistListaController');
        } else {
          AppLogger.w('⚠️ Modelo desconhecido: ${modelo.remoteId}',
              tag: 'ChecklistListaController');
          continue;
        }

        AppLogger.d('🏷️ Tipo do checklist: ${tipo.name}',
            tag: 'ChecklistListaController');

        // Para checklists EPI (modelo remoteId 3), adiciona sempre (um por eletricista)
        if (modelo.remoteId == 3) {
          // EPI
          AppLogger.d(
              '👷 Checklist EPI (tipo 3) - Adicionando diretamente à lista',
              tag: 'ChecklistListaController');
          String nomeChecklist = modelo.nome;
          String subtitulo = '';

          // Para EPI, busca eletricista se houver eletricistaRemoteId
          if (checklist.eletricistaRemoteId != null) {
            final eletricistas = await _eletricistaRepo.listar();
            final eletricista = eletricistas.firstWhereOrNull((e) =>
                e.remoteId.toString() ==
                checklist.eletricistaRemoteId.toString());
            if (eletricista != null) {
              subtitulo = 'Eletricista: ${eletricista.nome}';
              AppLogger.d('👷 Eletricista encontrado: ${eletricista.nome}',
                  tag: 'ChecklistListaController');
            } else {
              AppLogger.w(
                  '⚠️ Eletricista não encontrado para remoteId: ${checklist.eletricistaRemoteId}',
                  tag: 'ChecklistListaController');
            }
          } else {
            AppLogger.d('👷 Checklist EPI sem eletricista específico',
                tag: 'ChecklistListaController');
          }

          formatados.add(ChecklistItem(
            checklist: checklist,
            nome: nomeChecklist,
            subtitulo: subtitulo,
            tipo: tipo,
          ));
        } else {
          // Para Veicular e EPC (não EPI), mantém apenas um de cada tipo (primeiro encontrado)
          if (modelo.remoteId != 3) {
            // Não é EPI (modelo remoteId 3)
            AppLogger.d(
                '🚗 Checklist ${tipo.name} (Veicular/EPC) - Adicionando ao mapa',
                tag: 'ChecklistListaController');
            if (modelo.remoteId != null &&
                !checklistsVeicularEPC.containsKey(modelo.remoteId)) {
              checklistsVeicularEPC[modelo.remoteId!] = checklist;
              AppLogger.d(
                  '✅ Checklist ${tipo.name} adicionado ao mapa (primeiro encontrado)',
                  tag: 'ChecklistListaController');
            } else {
              AppLogger.d(
                  '⏭️ Checklist ${tipo.name} já existe no mapa, pulando',
                  tag: 'ChecklistListaController');
            }
          } else {
            AppLogger.w(
                '⚠️ Checklist EPI (tipo 3) não deveria estar no else - verificar lógica',
                tag: 'ChecklistListaController');
          }
        }
      }

      // Adiciona os checklists Veicular e EPC (um de cada tipo)
      AppLogger.d(
          '📦 Adicionando ${checklistsVeicularEPC.length} checklists Veicular/EPC à lista formatada',
          tag: 'ChecklistListaController');
      for (final checklist in checklistsVeicularEPC.values) {
        final modelo = await _checklistModeloRepo
            .buscarPorRemoteId(checklist.checklistModeloId);
        if (modelo != null) {
          // CORREÇÃO TEMPORÁRIA: Mapeia tipos baseado nos IDs dos modelos
          ChecklistTipo tipo;
          if (modelo.remoteId == 1) {
            tipo = ChecklistTipo.veicular;
          } else if (modelo.remoteId == 2) {
            tipo = ChecklistTipo.epc;
          } else {
            continue; // Pula modelos desconhecidos
          }
          AppLogger.d(
              '➕ Adicionando checklist formatado - Tipo: ${tipo.name}, Nome: ${modelo.nome}',
              tag: 'ChecklistListaController');
          formatados.add(ChecklistItem(
            checklist: checklist,
            nome: modelo.nome,
            subtitulo: '', // Veicular e EPC não mostram eletricista
            tipo: tipo,
          ));
        }
      }

      // Ordena por data de preenchimento (mais recente primeiro)
      formatados.sort((a, b) => b.checklist.dataPreenchimento
          .compareTo(a.checklist.dataPreenchimento));

      checklistsFormatados.value = formatados;

      AppLogger.d(
          '${formatados.length} checklists formatados para exibição do turno ativo (${checklists.length} encontrados no banco)',
          tag: 'ChecklistListaController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao formatar checklists',
          tag: 'ChecklistListaController', error: e, stackTrace: stackTrace);
    }
  }

  // ============================================================================
  // AÇÕES
  // ============================================================================

  /// Navega para a tela de visualização de um checklist específico.
  void visualizarChecklist(ChecklistItem item) {
    AppLogger.i('Navegando para visualização do checklist ${item.checklist.id}',
        tag: 'ChecklistListaController');

    Get.toNamed(
      Routes.checklistVisualizacao,
      arguments: {
        'checklistId': item.checklist.id,
        'checklistNome': item.nome,
        'checklistSubtitulo': item.subtitulo,
      },
    );
  }

  /// Recarrega os checklists.
  Future<void> recarregar() async {
    await carregarChecklists();
  }

  /// Volta para a tela anterior.
  void voltar() {
    Get.back();
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onClose() {
    AppLogger.d('ChecklistListaController sendo removido',
        tag: 'ChecklistListaController');
    super.onClose();
  }
}

/// Classe para representar um item de checklist formatado para exibição.
class ChecklistItem {
  final ChecklistPreenchidoTableDto checklist;
  final String nome;
  final String subtitulo;
  final ChecklistTipo tipo;

  ChecklistItem({
    required this.checklist,
    required this.nome,
    required this.subtitulo,
    required this.tipo,
  });
}
