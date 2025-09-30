
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/modules/login/login_controller.dart';

/// Binding responsável pela injeção de dependências do módulo de login.
///
/// Esta classe implementa o padrão de injeção de dependências do GetX,
/// configurando todas as dependências necessárias para o funcionamento
/// do LoginController e suas operações de autenticação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Injeção de Dependências**: Configura dependências do LoginController
/// 2. **Lazy Loading**: Carrega dependências apenas quando necessário
/// 3. **Gestão de Ciclo de Vida**: Controla criação e destruição de instâncias
/// 4. **Resolução de Dependências**: Resolve dependências de forma automática
///
/// ## Arquitetura:
///
/// - **GetX Bindings**: Implementa interface Bindings do GetX
/// - **Dependency Injection**: Injeta dependências via construtor
/// - **Lazy Loading**: Carregamento sob demanda para performance
/// - **Singleton Management**: Gerencia instâncias únicas de serviços
///
/// ## Fluxo de Inicialização:
///
/// 1. GetX chama método dependencies()
/// 2. Resolve dependências do LoginController
/// 3. Cria instância do controller com dependências
/// 4. Disponibiliza controller para uso na página
///
/// ## Uso:
///
/// ```dart
/// // No app_pages.dart
/// GetPage(
///   name: Routes.login,
///   page: () => const LoginPage(),
///   binding: LoginBinding(),
/// ),
///
/// // Ou manualmente
/// Get.put(LoginBinding()).dependencies();
/// ```
///
/// ## Dependências Resolvidas:
/// - `AuthService`: Para operações de autenticação
/// - `SessionManager`: Para gerenciamento de sessão
/// - `LoginController`: Controlador principal da tela
class LoginBinding extends Bindings {
  
  /// Configura as dependências do módulo de login.
  ///
  /// Este método é chamado automaticamente pelo GetX quando a rota
  /// de login é navegada, configurando todas as dependências
  /// necessárias para o funcionamento do LoginController.
  ///
  /// ## Dependências Configuradas:
  /// - `LoginController`: Controlador principal com dependências injetadas
  /// - `AuthService`: Resolvido automaticamente do container GetX
  /// - `SessionManager`: Resolvido automaticamente do container GetX
  ///
  /// ## Comportamento:
  /// - Utiliza lazy loading para performance
  /// - `fenix: true` permite recriar o controller após ser deletado
  /// - Resolve dependências de forma automática
  /// - Disponibiliza controller para uso imediato
  @override
  void dependencies() {
    
    /// Registra LoginController com fenix: true para recriação automática.
    /// Isso resolve problemas de hot reload e lifecycle do controller.
    Get.lazyPut(() => LoginController(
          authService: Get.find<AuthService>(),
          sessionManager: Get.find<SessionManager>(),
            ),
        fenix: true);
  }
}