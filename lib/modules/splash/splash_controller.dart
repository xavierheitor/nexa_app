import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controlador responsável pelo gerenciamento da tela de splash.
///
/// Este controlador implementa a lógica de inicialização da aplicação,
/// incluindo verificação de sessão, carregamento de dependências e
/// redirecionamento para a tela apropriada baseada no estado de autenticação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Inicialização da Sessão**: Carrega e inicializa o SessionManager
/// 2. **Verificação de Autenticação**: Verifica se usuário está logado
/// 3. **Redirecionamento Inteligente**: Navega para tela apropriada
/// 4. **Logging**: Rastreamento de operações de inicialização
/// 5. **Tratamento de Erros**: Gerenciamento de falhas durante inicialização
///
/// ## Arquitetura:
///
/// - **GetX Controller**: Gerenciamento de estado reativo
/// - **Dependency Injection**: Recebe SessionManager via GetX
/// - **Navigation**: Integração com sistema de rotas
/// - **Error Handling**: Tratamento de erros de inicialização
///
/// ## Fluxo de Funcionamento:
///
/// 1. Inicialização do controlador
/// 2. Carregamento do SessionManager
/// 3. Verificação de estado de autenticação
/// 4. Redirecionamento para tela apropriada
/// 5. Logging de operações
///
/// ## Casos de Redirecionamento:
///
/// - **Usuário Logado**: Redireciona para `/home`
/// - **Usuário Não Logado**: Redireciona para `/login`
/// - **Erro na Inicialização**: Redireciona para `/login` (fallback)
///
/// ## Uso:
///
/// ```dart
/// // O controlador é inicializado automaticamente pelo SplashBinding
/// // quando a rota /splash é navegada
/// ```
///
/// ## Dependências:
/// - `SessionManager`: Para verificação de autenticação
/// - `AppLogger`: Para logging de operações
/// - `Routes`: Para navegação entre telas
class SplashController extends GetxController {
  /// Inicialização do controlador de splash.
  ///
  /// Executado quando o controlador é criado, implementando toda a lógica
  /// de inicialização da aplicação e redirecionamento para a tela apropriada.
  ///
  /// ## Comportamento:
  /// 1. Registra início da inicialização
  /// 2. Carrega e inicializa SessionManager
  /// 3. Verifica estado de autenticação
  /// 4. Redireciona para tela apropriada
  /// 5. Registra resultado da operação
  ///
  /// ## Tratamento de Erros:
  /// - Falhas na inicialização do SessionManager
  /// - Problemas de navegação
  /// - Timeouts de inicialização
  ///
  /// ## Redirecionamentos:
  /// - Usuário logado → `/home`
  /// - Usuário não logado → `/login`
  /// - Erro → `/login` (fallback)
  @override
  void onInit() {
    super.onInit();

    /// Registra início da inicialização do splash.
    AppLogger.i('🌀 Splash: Iniciando processo de inicialização',
        tag: 'SplashController');

    /// Executa processo de inicialização de forma assíncrona.
    _initializeApp();
  }

  /// Inicializa a aplicação de forma assíncrona.
  ///
  /// Carrega dependências, verifica autenticação e redireciona
  /// para a tela apropriada baseada no estado do usuário.
  Future<void> _initializeApp() async {
    try {
      /// Obtém instância do SessionManager.
      final session = Get.find<SessionManager>();

      /// Registra início da inicialização da sessão.
      AppLogger.d('🌀 Inicializando SessionManager...',
          tag: 'SplashController');

      /// Inicializa o SessionManager (carrega dados do usuário).
      await session.init();

      /// Registra estado da sessão após inicialização.
      AppLogger.d(
          '🌀 SessionManager inicializado. Usuário: ${session.usuario?.nome ?? 'Nenhum'}',
          tag: 'SplashController');

      /// Verifica se usuário está autenticado.
      if (session.estaLogado) {
        /// Usuário está logado, redireciona para home.
        AppLogger.i('✅ Usuário autenticado. Redirecionando para home.',
            tag: 'SplashController');
        await Get.offAllNamed(Routes.home);
      } else {
        /// Usuário não está logado, redireciona para login.
        AppLogger.w('🔐 Usuário não autenticado. Redirecionando para login.',
            tag: 'SplashController');
        await Get.offAllNamed(Routes.login);
      }
    } catch (e, stack) {
      /// Trata erro durante inicialização.
      AppLogger.e('❌ Erro durante inicialização do splash',
          tag: 'SplashController', error: e, stackTrace: stack);

      /// Em caso de erro, redireciona para login como fallback.
      AppLogger.w('🔄 Redirecionando para login devido a erro.',
          tag: 'SplashController');
      await Get.offAllNamed(Routes.login);
    }
  }
}
