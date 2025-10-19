import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/services/error_message_service.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controlador responsável pelo gerenciamento da tela principal (home).
class HomeController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Gerenciador de sessão para acesso aos dados do usuário.
  final SessionManager _sessionManager;

  /// Serviço de autenticação para operações de logout.
  final AuthService _authService;

  /// Serviço de sincronização para atualização de dados.
  final SyncService _syncService;

  /// Serviço de mensagens de erro.
  final ErrorMessageService _errorMessageService =
      Get.find<ErrorMessageService>();

  /// Controlador global de turno.
  final TurnoController turnoController = Get.find<TurnoController>();

  /// Construtor do controlador.
  HomeController({
    required SessionManager sessionManager,
    required AuthService authService,
    required SyncService syncService,
  })  : _sessionManager = sessionManager,
        _authService = authService,
        _syncService = syncService;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se está carregando dados.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Nome do usuário logado.
  String get nomeUsuario => _sessionManager.usuario?.nome ?? 'Usuário';

  /// Matrícula do usuário logado.
  String get matriculaUsuario => _sessionManager.usuario?.matricula ?? 'N/A';

  /// Verifica se há turno aberto.
  bool get hasTurnoAberto => turnoController.hasTurnoAberto;

  /// Verifica se há erro de abertura de turno
  bool get temErroAberturaTurno => _errorMessageService.temErro;

  /// Mensagem de erro de abertura de turno
  String? get mensagemErroAberturaTurno => _errorMessageService.mensagemErro;

  // ============================================================================
  // MÉTODOS DE INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController inicializado', tag: 'HomeController');
    // Garante que o turno seja carregado quando a home for inicializada
    _carregarTurnoSeNecessario();
  }

  @override
  void onReady() {
    super.onReady();
    // Recarrega o turno quando a página está pronta
    // Isso garante que o estado mais recente seja exibido
    _recarregarTurnoAtivo();
  }

  /// Carrega o turno ativo se ainda não foi carregado
  Future<void> _carregarTurnoSeNecessario() async {
    try {
      // Se o turnoController não tem turno carregado, força o carregamento
      if (!turnoController.hasTurno && !turnoController.isLoading.value) {
        AppLogger.d('Forçando carregamento do turno ativo na home',
            tag: 'HomeController');
        await turnoController.carregarTurnoAtivo();
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar turno na inicialização da home',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
    }
  }

  /// Recarrega o turno ativo (útil quando volta para a home)
  Future<void> _recarregarTurnoAtivo() async {
    try {
      AppLogger.d('Recarregando turno ativo na home', tag: 'HomeController');
      await turnoController.carregarTurnoAtivo();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao recarregar turno na home',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
    }
  }

  // ============================================================================
  // AÇÕES DE NAVEGAÇÃO
  // ============================================================================

  /// Ação do botão Turno.
  ///
  /// **NOVO FLUXO INTELIGENTE:**
  /// - Navega para tela de loading que analisa o estado do turno
  /// - A tela de loading decide automaticamente para onde ir:
  ///   - Nenhum turno → Abrir turno
  ///   - Turno em abertura → Próximo checklist pendente
  ///   - Turno aberto → Lista de serviços
  ///
  /// Isso evita abrir múltiplas telas desnecessariamente.
  void abrirTurno() {
    AppLogger.i('🧭 [HOME] Navegando para decisão inteligente de turno',
        tag: 'HomeController');

    // Navega para a tela que decide automaticamente o próximo passo
    Get.toNamed(Routes.turnoNavigationLoading);
  }

  /// Navega para tela de APR (Análise Preliminar de Risco).
  void abrirAPR() {
    AppLogger.i('Navegando para tela de APR', tag: 'HomeController');
    Get.snackbar(
      'APR',
      'Tela de APR em desenvolvimento',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navega para tela de checklist.
  void abrirChecklist() {
    AppLogger.i('Navegando para tela de checklist', tag: 'HomeController');
    Get.snackbar(
      'Checklist',
      'Tela de checklist em desenvolvimento',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navega para tela de almoxarifado.
  void abrirAlmoxarifado() {
    AppLogger.i('Navegando para tela de almoxarifado', tag: 'HomeController');
  }

  // ============================================================================
  // AÇÕES DO USUÁRIO
  // ============================================================================

  /// Executa logout do usuário.
  Future<void> logout() async {
    try {
      AppLogger.i('Iniciando logout', tag: 'HomeController');

      // Verifica se há turno aberto
      if (hasTurnoAberto) {
        AppLogger.w('Tentativa de logout com turno aberto',
            tag: 'HomeController');

        Get.snackbar(
          'Turno Aberto',
          'Não é possível fazer logout com turno aberto. Por favor, feche o turno antes de sair.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
        );
        return;
      }

      isLoading.value = true;

      await _authService.logout();

      AppLogger.i('Logout realizado com sucesso', tag: 'HomeController');

      Get.offAllNamed(Routes.login);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fazer logout',
          tag: 'HomeController', error: e, stackTrace: stackTrace);

      Get.snackbar(
        'Erro',
        'Erro ao fazer logout. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Atualiza dados da tela.
  Future<void> atualizar() async {
    AppLogger.d('Atualizando dados da home', tag: 'HomeController');
    
    try {
      // Executa sincronização completa
      final sucesso = await _syncService.sincronizarTudo();

      if (sucesso) {
        AppLogger.i('Sincronização concluída com sucesso',
            tag: 'HomeController');
        Get.snackbar(
          'Sincronização',
          'Dados atualizados com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          colorText: Get.theme.colorScheme.onPrimaryContainer,
          duration: const Duration(seconds: 3),
        );
      } else {
        AppLogger.w('Sincronização falhou', tag: 'HomeController');
        Get.snackbar(
          'Erro na Sincronização',
          'Falha ao atualizar dados. Tente novamente.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro durante sincronização',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Erro na Sincronização',
        'Erro inesperado durante sincronização.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 4),
      );
    }

    // Atualiza dados do turno após sincronização
    await turnoController.atualizar();
  }

  /// Limpa a mensagem de erro de abertura de turno
  void limparErroAberturaTurno() {
    _errorMessageService.limparErro();
  }

  // ============================================================================
  // MÉTODOS AUXILIARES PARA DADOS DO TURNO
  // ============================================================================

  /// Busca o nome da equipe pelo ID.
  Future<String> buscarNomeEquipe(int equipeId) async {
    try {
      final equipeRepo = Get.find<EquipeRepo>();
      final equipe = await equipeRepo.buscarPorId(equipeId.toString());
      return equipe?.nome ?? 'Equipe $equipeId';
    } catch (e) {
      AppLogger.w('Erro ao buscar nome da equipe: $e', tag: 'HomeController');
      return 'Equipe $equipeId';
    }
  }

  /// Busca a placa do veículo pelo ID.
  Future<String> buscarPlacaVeiculo(int veiculoId) async {
    try {
      final veiculoRepo = Get.find<VeiculoRepo>();
      final veiculo = await veiculoRepo.buscarPorId(veiculoId);
      return veiculo.placa;
    } catch (e) {
      AppLogger.w('Erro ao buscar placa do veículo: $e', tag: 'HomeController');
      return 'Veículo $veiculoId';
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - Estados reativos (isLoading)
  /// - Qualquer listener ou subscription ativa
  /// - Referências a serviços (já gerenciados pelo GetX)
  @override
  void onClose() {
    /// Limpa estados reativos.
    isLoading.value = false;

    /// Registra finalização do controlador.
    AppLogger.d('HomeController finalizado e recursos liberados',
        tag: 'HomeController');

    super.onClose();
  }
}
