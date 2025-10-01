import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/domain/models/turno_model.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controlador responsável pelo gerenciamento da tela principal (home).
///
/// Este controlador gerencia o estado da tela principal, incluindo
/// informações do usuário logado, turno ativo, e navegação para
/// diferentes funcionalidades da aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Gerenciamento de Turno**: Controla turno aberto/fechado
/// 2. **Informações do Usuário**: Exibe dados do usuário logado
/// 3. **Navegação**: Gerencia navegação para outras telas
/// 4. **Logout**: Controla processo de desautenticação
/// 5. **Estado Reativo**: Atualização automática da UI
///
/// ## Arquitetura:
///
/// - **GetX Controller**: Gerenciamento de estado reativo
/// - **Dependency Injection**: Recebe SessionManager e AuthService
/// - **Navigation**: Integração com sistema de rotas
///
/// ## Uso:
///
/// ```dart
/// final controller = Get.find<HomeController>();
/// ```
class HomeController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Gerenciador de sessão para acesso aos dados do usuário.
  final SessionManager _sessionManager;

  /// Serviço de autenticação para operações de logout.
  final AuthService _authService;

  /// Construtor do controlador.
  HomeController({
    required SessionManager sessionManager,
    required AuthService authService,
  })  : _sessionManager = sessionManager,
        _authService = authService;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Turno ativo atual (se houver).
  final Rxn<TurnoModel> turnoAtivo = Rxn<TurnoModel>();

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
  bool get hasTurnoAberto => turnoAtivo.value?.estaAberto ?? false;

  // ============================================================================
  // MÉTODOS DE INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController inicializado', tag: 'HomeController');
    _carregarTurnoAtivo();
  }

  /// Carrega turno ativo do usuário.
  ///
  /// Busca no banco local ou API se há um turno aberto
  /// para o usuário atual.
  Future<void> _carregarTurnoAtivo() async {
    try {
      isLoading.value = true;
      AppLogger.d('Carregando turno ativo...', tag: 'HomeController');

      // TODO: Buscar turno real do banco/API
      // Por enquanto, simula um turno ativo para demonstração
      await Future.delayed(const Duration(milliseconds: 500));

      // Simula turno aberto (remover quando integrar com API)
      turnoAtivo.value = TurnoModel(
        id: '1',
        prefixo: 'A-123',
        veiculo: 'Volkswagen Gol',
        placa: 'ABC-1234',
        horaInicio: DateTime.now().subtract(const Duration(hours: 2)),
        status: StatusTurno.aberto,
      );

      AppLogger.i(
          'Turno ativo carregado: ${turnoAtivo.value?.prefixo ?? "Nenhum"}',
          tag: 'HomeController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar turno ativo',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
      turnoAtivo.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // AÇÕES DE NAVEGAÇÃO
  // ============================================================================

  /// Navega para tela de gerenciamento de turno.
  void abrirTurno() {
    AppLogger.i('Navegando para tela de turno', tag: 'HomeController');
    // TODO: Implementar navegação
    Get.snackbar(
      'Turno',
      'Tela de turno em desenvolvimento',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navega para tela de APR (Análise Preliminar de Risco).
  void abrirAPR() {
    AppLogger.i('Navegando para tela de APR', tag: 'HomeController');
    // TODO: Implementar navegação
    Get.snackbar(
      'APR',
      'Tela de APR em desenvolvimento',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navega para tela de checklist.
  void abrirChecklist() {
    AppLogger.i('Navegando para tela de checklist', tag: 'HomeController');
    // TODO: Implementar navegação
    Get.snackbar(
      'Checklist',
      'Tela de checklist em desenvolvimento',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navega para tela de almoxarifado.
  void abrirAlmoxarifado() {
    AppLogger.i('Navegando para tela de almoxarifado', tag: 'HomeController');
    // TODO: Implementar navegação (desabilitado)
  }

  // ============================================================================
  // AÇÕES DO USUÁRIO
  // ============================================================================

  /// Executa logout do usuário.
  ///
  /// Limpa sessão e redireciona para tela de login.
  Future<void> logout() async {
    try {
      AppLogger.i('Iniciando logout', tag: 'HomeController');

      /// Mostra loading.
      isLoading.value = true;

      /// Executa logout via AuthService.
      await _authService.logout();

      /// Registra sucesso.
      AppLogger.i('Logout realizado com sucesso', tag: 'HomeController');

      /// Redireciona para login.
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
    await _carregarTurnoAtivo();
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
