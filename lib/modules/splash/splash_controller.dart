import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
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
/// 3. **Sincronização de Dados**: Sincroniza dados quando usuário está logado
/// 4. **Redirecionamento Inteligente**: Navega para tela apropriada
/// 5. **Feedback Visual**: Mostra progresso de sincronização
/// 6. **Logging**: Rastreamento de operações de inicialização
/// 7. **Tratamento de Erros**: Gerenciamento de falhas durante inicialização
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
/// 4. Se autenticado: Sincronização de dados do servidor
/// 5. Redirecionamento para tela apropriada
/// 6. Logging de operações
///
/// ## Casos de Redirecionamento:
///
/// - **Usuário Logado**: Sincroniza dados → Redireciona para `/home`
/// - **Usuário Não Logado**: Redireciona para `/login`
/// - **Após Login**: Sincroniza dados → Redireciona para `/home`
/// - **Erro na Inicialização**: Redireciona para `/login` (fallback)
///
/// ## Fluxo Completo da Aplicação:
///
/// ```
/// [APP START] → Splash
///     ↓
///   Tem login?
///     ├─ Sim → Sincroniza → Home
///     └─ Não → Login
///                 ↓
///            Login OK? → Splash → Sincroniza → Home
/// ```
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
/// - `SyncService`: Para sincronização de dados
class SplashController extends GetxController {
  /// Serviço de sincronização de dados.
  late final SyncService _syncService;

  /// Mensagem de status atual da splash.
  final RxString statusMessage = 'Carregando...'.obs;

  /// Indica se está sincronizando.
  final RxBool isSyncing = false.obs;

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

    /// Obtém instância do SyncService via GetX.
    _syncService = Get.find<SyncService>();

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
        /// Usuário está logado, executa sincronização antes de ir para home.
        AppLogger.i('✅ Usuário autenticado. Iniciando sincronização...',
            tag: 'SplashController');

        /// Atualiza mensagem de status.
        statusMessage.value = 'Sincronizando dados...';
        isSyncing.value = true;

        /// Executa sincronização de dados.
        final sincronizadoComSucesso = await _syncService.sincronizar();

        isSyncing.value = false;

        if (sincronizadoComSucesso) {
          AppLogger.i('✅ Sincronização concluída. Redirecionando para home.',
              tag: 'SplashController');
          statusMessage.value = 'Sincronização concluída!';
        } else {
          AppLogger.w('⚠️ Sincronização falhou. Continuando para home.',
              tag: 'SplashController');
          statusMessage.value = 'Continuando...';
        }

        /// Pequeno delay para mostrar mensagem de conclusão.
        await Future.delayed(const Duration(milliseconds: 500));

        await Get.offAllNamed(Routes.home);
      } else {
        /// Usuário não está logado, redireciona para login.
        AppLogger.w('🔐 Usuário não autenticado. Redirecionando para login.',
            tag: 'SplashController');
        statusMessage.value = 'Redirecionando...';
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
