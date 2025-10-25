/// Classe abstrata que define todas as rotas da aplicação NexaApp.
///
/// Esta classe centraliza a definição de todas as rotas disponíveis no aplicativo,
/// garantindo consistência e facilitando a manutenção do sistema de navegação.
/// Todas as rotas são definidas como constantes estáticas para evitar erros de
/// digitação e facilitar refatorações futuras.
///
/// ## Propósito:
///
/// - **Centralização de Rotas**: Mantém todas as definições de rotas em um local único
/// - **Consistência**: Garante que os mesmos nomes de rota sejam usados em toda a aplicação
/// - **Manutenibilidade**: Facilita alterações de rotas sem impactar múltiplos arquivos
/// - **Type Safety**: Utiliza constantes para evitar erros de digitação
///
/// ## Convenções de Nomenclatura:
///
/// - Todas as rotas começam com '/' seguindo o padrão de URLs
/// - Nomes descritivos e em inglês para consistência
/// - Uso de snake_case para manter padronização
///
/// ## Estrutura das Rotas:
///
/// - **home**: Página principal da aplicação (rota inicial)
/// - **login**: Página de autenticação do usuário
/// - **splash**: Tela de carregamento inicial
///
/// ## Uso:
///
/// ```dart
/// // Navegação para uma rota específica
/// Get.toNamed(Routes.home);
///
/// // Definição de rota no AppPages
/// GetPage(name: Routes.login, page: () => LoginPage())
/// ```
///
/// ## Manutenção:
///
/// Ao adicionar novas rotas:
/// 1. Adicione a constante estática nesta classe
/// 2. Implemente a rota correspondente em `AppPages`
/// 3. Crie o módulo (page, controller, binding) se necessário
/// 4. Atualize a documentação
abstract class Routes {
  // ============================================================================
  // ROTAS PRINCIPAIS DA APLICAÇÃO
  // ============================================================================

  /// Rota da página principal da aplicação.
  ///
  /// Esta é a rota inicial do aplicativo após o usuário estar autenticado.
  /// Contém a interface principal com funcionalidades principais do app.
  /// Geralmente protegida por middleware de autenticação.
  static const String home = '/home';

  /// Rota da página de login/autenticação.
  ///
  /// Página responsável pela autenticação do usuário no sistema.
  /// Inclui campos de email/senha e opções de recuperação de senha.
  /// Pode incluir integração com redes sociais ou biometria.
  static const String login = '/login';

  /// Rota da tela de splash/boas-vindas.
  ///
  /// Tela exibida durante a inicialização do aplicativo.
  /// Usada para carregar configurações iniciais, verificar autenticação
  /// e apresentar a logo/marca da aplicação.
  static const String splash = '/splash';

  /// Rota da tela de serviços do turno.
  ///
  /// Tela que exibe a lista de serviços executados no turno ativo
  /// e permite adicionar novos serviços.
  static const String turnoServicos = '/turno/servicos';

  /// Rota da tela de abrir turno.
  ///
  /// Tela para iniciar um novo turno, selecionando veículo e outros dados.
  static const String turnoAbrir = '/turno/abrir';

  /// Rota da tela de checklist veicular.
  ///
  /// Tela para realizar o checklist do veículo antes de iniciar o turno.
  /// Exibe perguntas e opções de resposta baseadas no tipo de veículo.
  static const String turnoChecklist = '/turno/checklist';

  /// Rota da tela de checklist EPC.
  ///
  /// Tela para realizar o checklist de EPC (Equipamento de Proteção Coletiva).
  /// Exibe perguntas e opções de resposta baseadas no tipo de equipe.
  static const String turnoChecklistEPC = '/turno/checklist/epc';

  /// Rota da lista de eletricistas para checklist de EPI.
  static const String turnoChecklistEletricistas =
      '/turno/checklist/eletricistas';

  /// Rota da tela de checklist EPI (por eletricista).
  static const String turnoChecklistEPI = '/turno/checklist/epi';

  /// Rota da tela de abertura de turno (splash de processamento).
  static const String turnoAbrindo = '/turno/abrindo';

  /// Rota da tela de loading/decisão de navegação do turno.
  ///
  /// Tela intermediária que analisa o estado do turno e decide
  /// automaticamente para qual tela navegar (checklist, serviços, etc).
  static const String turnoNavigationLoading = '/turno/navigation/loading';

  /// Rota da tela de listagem de checklists preenchidos.
  ///
  /// Tela que exibe todos os checklists preenchidos do turno ativo,
  /// permitindo visualizar as respostas de cada checklist.
  static const String checklistLista = '/checklist/lista';

  /// Rota da tela de visualização de checklist.
  ///
  /// Tela que exibe as respostas detalhadas de um checklist específico,
  /// incluindo perguntas e respostas selecionadas.
  static const String checklistVisualizacao = '/checklist/visualizacao';
}
