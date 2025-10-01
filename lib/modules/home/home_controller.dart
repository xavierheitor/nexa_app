import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
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

  /// Controlador global de turno.
  final TurnoController turnoController = Get.find<TurnoController>();

  /// Construtor do controlador.
  HomeController({
    required SessionManager sessionManager,
    required AuthService authService,
  })  : _sessionManager = sessionManager,
        _authService = authService;

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

  // ============================================================================
  // MÉTODOS DE INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController inicializado', tag: 'HomeController');
  }

  // ============================================================================
  // AÇÕES DE NAVEGAÇÃO
  // ============================================================================

  /// Ação do botão Turno.
  /// - Se turno fechado: Abre tela de abrir turno
  /// - Se turno aberto: Abre tela de serviços executados
  void abrirTurno() {
    AppLogger.i('Ação botão Turno', tag: 'HomeController');

    if (turnoController.hasTurnoAberto) {
      // Turno aberto → Abre lista de serviços
      Get.toNamed(Routes.turnoServicos);
    } else {
      // Turno fechado → Abre tela para abrir turno
      Get.toNamed(Routes.turnoAbrir);
    }
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
    await turnoController.atualizar();
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onClose() {
    AppLogger.d('HomeController finalizado', tag: 'HomeController');
    super.onClose();
  }
}
