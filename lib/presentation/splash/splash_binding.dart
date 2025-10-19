import 'package:get/get.dart';
import 'package:nexa_app/presentation/splash/splash_controller.dart';

/// Binding responsável pela injeção de dependências do módulo de splash.
///
/// Esta classe implementa o padrão de injeção de dependências do GetX,
/// configurando todas as dependências necessárias para o funcionamento
/// do SplashController e sua lógica de inicialização da aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Injeção de Dependências**: Configura dependências do SplashController
/// 2. **Inicialização Imediata**: Carrega controller imediatamente para execução
/// 3. **Gestão de Ciclo de Vida**: Controla criação e destruição de instâncias
/// 4. **Resolução de Dependências**: Resolve dependências de forma automática
///
/// ## Arquitetura:
///
/// - **GetX Bindings**: Implementa interface Bindings do GetX
/// - **Dependency Injection**: Injeta dependências via construtor
/// - **Immediate Loading**: Carregamento imediato para execução de inicialização
/// - **Singleton Management**: Gerencia instância única do controller
///
/// ## Fluxo de Inicialização:
///
/// 1. GetX chama método dependencies()
/// 2. Cria instância do SplashController imediatamente
/// 3. Controller executa lógica de inicialização automaticamente
/// 4. Disponibiliza controller para uso na página
///
/// ## Uso:
///
/// ```dart
/// // No app_pages.dart
/// GetPage(
///   name: Routes.splash,
///   page: () => const SplashPage(),
///   binding: SplashBinding(),
/// ),
///
/// // Ou manualmente
/// Get.put(SplashBinding()).dependencies();
/// ```
///
/// ## Dependências Resolvidas:
/// - `SplashController`: Controlador principal da tela de splash
/// - `SessionManager`: Resolvido automaticamente do container GetX
/// - `AppLogger`: Sistema de logging para monitoramento
class SplashBinding extends Bindings {
  
  /// Configura as dependências do módulo de splash.
  ///
  /// Este método é chamado automaticamente pelo GetX quando a rota
  /// de splash é navegada, configurando todas as dependências
  /// necessárias para o funcionamento do SplashController.
  ///
  /// ## Dependências Configuradas:
  /// - `SplashController`: Controlador principal com inicialização imediata
  ///
  /// ## Comportamento:
  /// - Utiliza put imediato para execução de inicialização
  /// - Cria instância única do controller
  /// - Disponibiliza controller para uso imediato
  /// - Inicia processo de verificação de autenticação automaticamente
  @override
  void dependencies() {
    
    /// Registra SplashController com criação imediata.
    /// Utiliza put em vez de lazyPut para garantir que o controller
    /// seja criado imediatamente e execute sua lógica de inicialização.
    Get.put(SplashController());
  }
}
