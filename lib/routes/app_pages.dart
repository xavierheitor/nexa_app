import 'package:get/get.dart';
import 'package:nexa_app/core/middlewares/auth_middleware.dart';
import 'package:nexa_app/modules/home/home_binding.dart';
import 'package:nexa_app/modules/home/home_page.dart';
import 'package:nexa_app/modules/login/login_binding.dart';
import 'package:nexa_app/modules/login/login_page.dart';
import 'package:nexa_app/modules/splash/splash_binding.dart';
import 'package:nexa_app/modules/splash/splash_page.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_binding.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_page.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_binding.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_page.dart';
import 'package:nexa_app/modules/turno/servicos/turno_servicos_binding.dart';
import 'package:nexa_app/modules/turno/servicos/turno_servicos_page.dart';
import 'package:nexa_app/routes/routes.dart';

/// Classe responsável pela configuração e gerenciamento das páginas da aplicação.
///
/// Esta classe centraliza toda a configuração de rotas, bindings e middlewares
/// do sistema de navegação GetX. Ela define como cada rota será construída,
/// quais dependências serão injetadas e quais middlewares serão executados.
///
/// ## Responsabilidades Principais:
///
/// 1. **Definição de Rotas**: Mapeia nomes de rotas para páginas específicas
/// 2. **Injeção de Dependências**: Configura bindings para cada página
/// 3. **Middleware de Segurança**: Aplica middlewares de autenticação quando necessário
/// 4. **Rota Inicial**: Define qual página será carregada ao iniciar o app
/// 5. **Lazy Loading**: Permite carregamento sob demanda das páginas
///
/// ## Arquitetura:
///
/// - **GetPage**: Estrutura individual de cada rota com página, binding e middlewares
/// - **Bindings**: Responsáveis pela injeção de dependências específicas de cada página
/// - **Middlewares**: Interceptam navegação para validações (ex: autenticação)
/// - **Lazy Loading**: Páginas são construídas apenas quando acessadas
///
/// ## Fluxo de Navegação:
///
/// 1. Usuário solicita navegação para uma rota
/// 2. Middlewares são executados (se configurados)
/// 3. Binding correspondente injeta dependências
/// 4. Página é construída e exibida
/// 5. Controller é inicializado com dependências
///
/// ## Dependências:
/// - `Routes`: Definições de nomes de rotas
/// - `AuthMiddleware`: Middleware de autenticação
/// - Módulos: Home, Login, Splash com suas respectivas páginas e bindings
class AppPages {
  // ============================================================================
  // CONFIGURAÇÃO DA ROTA INICIAL
  // ============================================================================

  /// Define a rota inicial que será carregada quando o aplicativo iniciar.
  ///
  /// Esta rota é a primeira página exibida após a inicialização completa
  /// do aplicativo. Geralmente é a página principal (home) após o usuário
  /// estar autenticado, ou a página de splash durante o carregamento inicial.
  ///
  /// **Nota**: Atualmente configurada para `/home`, mas pode ser alterada
  /// para `/splash` se necessário carregar configurações iniciais primeiro.
  static const String initial = Routes.splash;

  // ============================================================================
  // CONFIGURAÇÃO DAS ROTAS DA APLICAÇÃO
  // ============================================================================

  /// Lista de todas as rotas configuradas na aplicação.
  ///
  /// Cada `GetPage` define:
  /// - **name**: Nome da rota (definido em `Routes`)
  /// - **page**: Função que constrói o widget da página
  /// - **binding**: Injeção de dependências específicas da página
  /// - **middlewares**: Lista de middlewares aplicados à rota (opcional)
  ///
  /// As rotas são processadas em ordem, e a primeira correspondência é usada.
  static final routes = [
    // ========================================================================
    // ROTA DA PÁGINA PRINCIPAL
    // ========================================================================

    /// Configuração da página principal da aplicação.
    ///
    /// Esta rota representa a interface principal do aplicativo, contendo
    /// as funcionalidades principais disponíveis para o usuário autenticado.
    ///
    /// **Características:**
    /// - Protegida por `AuthMiddleware` para garantir autenticação
    /// - Utiliza `HomeBinding` para injeção de dependências específicas
    /// - Carregada sob demanda (lazy loading) para otimização de performance
    GetPage(
        name: Routes.home,
        page: () => const HomePage(),
        binding: HomeBinding(),
        middlewares: [
          AuthMiddleware()
        ]), // Middleware de autenticação obrigatório

    // ========================================================================
    // ROTA DA TELA DE SPLASH
    // ========================================================================

    /// Configuração da tela de inicialização/splash.
    ///
    /// Esta rota é exibida durante o carregamento inicial do aplicativo,
    /// permitindo inicialização de serviços, verificação de autenticação
    /// e apresentação da marca da aplicação.
    ///
    /// **Características:**
    /// - Primeira tela exibida (se configurada como rota inicial)
    /// - Utiliza `SplashBinding` para dependências de inicialização
    /// - Sem middlewares - carregamento direto
    /// - Pode redirecionar automaticamente para home ou login
    GetPage(
        name: Routes.splash,
        page: () => const SplashPage(),
        binding: SplashBinding()), // Sem middlewares - carregamento inicial

    // ========================================================================
    // ROTA DA PÁGINA DE LOGIN
    // ========================================================================

    /// Configuração da página de autenticação do usuário.
    ///
    /// Esta rota é responsável pela interface de login, incluindo campos
    /// de credenciais e opções de autenticação (email/senha, biometria, etc.).
    ///
    /// **Características:**
    /// - Acesso público (sem middleware de autenticação)
    /// - Utiliza `LoginBinding` para dependências do módulo de login
    /// - Interface responsiva para diferentes tamanhos de tela
    GetPage(
        name: Routes.login,
        page: () => const LoginPage(),
        binding: LoginBinding()), // Sem middlewares - acesso público

    // ========================================================================
    // ROTAS DE TURNO
    // ========================================================================

    /// Configuração da página de abrir turno.
    ///
    /// Tela para iniciar um novo turno, preenchendo dados do veículo.
    ///
    /// **Características:**
    /// - Protegida por `AuthMiddleware`
    /// - Formulário de entrada de dados
    /// - Validações de campos obrigatórios
    GetPage(
      name: Routes.turnoAbrir,
      page: () => const AbrirTurnoPage(),
      binding: AbrirTurnoBinding(),
      middlewares: [AuthMiddleware()],
    ),

    /// Configuração da página de checklist veicular.
    ///
    /// Tela para realizar o checklist do veículo antes de iniciar o turno.
    ///
    /// **Características:**
    /// - Protegida por `AuthMiddleware`
    /// - Perguntas baseadas no tipo de veículo
    /// - Opções de resposta com indicação de pendências
    GetPage(
      name: Routes.turnoChecklist,
      page: () => const ChecklistPage(),
      binding: ChecklistBinding(),
      middlewares: [AuthMiddleware()],
    ),

    /// Configuração da página de serviços do turno.
    ///
    /// Tela que lista serviços executados e permite adicionar novos.
    ///
    /// **Características:**
    /// - Protegida por `AuthMiddleware`
    /// - Lista de serviços com detalhes
    /// - FAB para adicionar novo serviço
    GetPage(
      name: Routes.turnoServicos,
      page: () => const TurnoServicosPage(),
      binding: TurnoServicosBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
