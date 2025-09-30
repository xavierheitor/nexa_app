import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controlador responsável pelo gerenciamento da tela de login.
///
/// Este controlador implementa toda a lógica de negócio da tela de login,
/// incluindo validação de formulário, autenticação de usuário, gerenciamento
/// de estado da interface e navegação após login bem-sucedido.
///
/// ## Funcionalidades Principais:
///
/// 1. **Validação de Formulário**: Validação de campos obrigatórios
/// 2. **Autenticação**: Login via AuthService com tratamento de erros
/// 3. **Gerenciamento de Estado**: Loading, erros e sucesso
/// 4. **Navegação**: Redirecionamento após login bem-sucedido
/// 5. **UX/UI**: Feedback visual para o usuário
/// 6. **Logging**: Rastreamento de operações de login
///
/// ## Arquitetura:
///
/// - **GetX Controller**: Gerenciamento de estado reativo
/// - **Dependency Injection**: Recebe AuthService e SessionManager
/// - **Error Handling**: Tratamento centralizado de erros
/// - **Navigation**: Integração com sistema de rotas
///
/// ## Fluxo de Funcionamento:
///
/// 1. Usuário preenche formulário
/// 2. Validação de campos obrigatórios
/// 3. Chamada para AuthService.login()
/// 4. Tratamento de resposta (sucesso/erro)
/// 5. Navegação para tela apropriada
/// 6. Limpeza de estado
///
/// ## Uso:
///
/// ```dart
/// // No binding
/// Get.lazyPut(() => LoginController(
///   authService: Get.find<AuthService>(),
///   sessionManager: Get.find<SessionManager>(),
/// ));
///
/// // Na página
/// final controller = Get.find<LoginController>();
/// ```
///
/// ## Dependências:
/// - `AuthService`: Para operações de autenticação
/// - `SessionManager`: Para gerenciamento de sessão
/// - `ErrorHandler`: Para tratamento de erros
/// - `AppLogger`: Para logging de operações
class LoginController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Serviço de autenticação para operações de login.
  ///
  /// Utilizado para realizar autenticação do usuário através
  /// de matrícula e senha, obtendo tokens e dados do usuário.
  final AuthService _authService;

  /// Gerenciador de sessão para controle de estado de autenticação.
  ///
  /// Utilizado para verificar se usuário já está logado e
  /// para atualizar estado de sessão após login bem-sucedido.
  final SessionManager _sessionManager;

  /// Construtor do controlador de login.
  ///
  /// Inicializa o controlador com as dependências necessárias
  /// para operações de autenticação e gerenciamento de sessão.
  ///
  /// ## Parâmetros:
  /// - `authService`: Serviço de autenticação (obrigatório)
  /// - `sessionManager`: Gerenciador de sessão (obrigatório)
  LoginController({
    required AuthService authService,
    required SessionManager sessionManager,
  })  : _authService = authService,
        _sessionManager = sessionManager;

  // ============================================================================
  // CONTROLADORES DE FORMULÁRIO
  // ============================================================================

  /// Valor da matrícula como variável observável.
  ///
  /// Gerencia o estado e valor do campo de entrada de matrícula
  /// usando GetX observables para evitar problemas de lifecycle.
  final RxString matricula = ''.obs;

  /// Valor da senha como variável observável.
  ///
  /// Gerencia o estado e valor do campo de entrada de senha
  /// usando GetX observables para evitar problemas de lifecycle.
  final RxString senha = ''.obs;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se login está em andamento.
  ///
  /// Controla o estado de loading durante operação de login,
  /// desabilitando botões e mostrando indicadores visuais.
  final RxBool _isLoading = false.obs;

  /// Flag indicando se senha está visível.
  ///
  /// Controla a visibilidade da senha no campo de entrada,
  /// permitindo ao usuário alternar entre texto oculto e visível.
  final RxBool _isPasswordVisible = false.obs;

  /// Mensagem de erro atual.
  ///
  /// Armazena mensagem de erro a ser exibida ao usuário,
  /// sendo atualizada conforme ocorrem erros durante login.
  final RxString _errorMessage = ''.obs;

  // ============================================================================
  // GETTERS PÚBLICOS
  // ============================================================================

  /// Indica se login está em andamento.
  ///
  /// Retorna true se operação de login está sendo executada,
  /// false caso contrário. Usado para controlar estado de UI.
  bool get isLoading => _isLoading.value;

  /// Indica se senha está visível.
  ///
  /// Retorna true se senha está sendo exibida em texto claro,
  /// false se está oculta. Usado para controlar ícone de visibilidade.
  bool get isPasswordVisible => _isPasswordVisible.value;

  /// Retorna mensagem de erro atual.
  ///
  /// Retorna string com mensagem de erro a ser exibida,
  /// string vazia se não há erro. Usado para exibir feedback ao usuário.
  String get errorMessage => _errorMessage.value;

  // ============================================================================
  // MÉTODOS DE CONTROLE DE INTERFACE
  // ============================================================================

  /// Alterna visibilidade da senha.
  ///
  /// Inverte o estado atual da visibilidade da senha,
  /// permitindo ao usuário visualizar ou ocultar a senha digitada.
  ///
  /// ## Comportamento:
  /// - Se senha está oculta, torna visível
  /// - Se senha está visível, torna oculta
  /// - Atualiza estado reativo automaticamente
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// Limpa mensagem de erro.
  ///
  /// Remove mensagem de erro atual, limpando feedback
  /// visual de erro para o usuário.
  void clearError() {
    _errorMessage.value = '';
  }

  // ============================================================================
  // MÉTODOS DE VALIDAÇÃO
  // ============================================================================

  /// Valida campo de matrícula.
  ///
  /// Verifica se matrícula foi preenchida e possui formato válido,
  /// retornando mensagem de erro se inválida, null se válida.
  ///
  /// ## Parâmetros:
  /// - `value`: Valor da matrícula a ser validado
  ///
  /// ## Retorno:
  /// - `String?`: Mensagem de erro ou null se válida
  ///
  /// ## Validações:
  /// - Campo não pode estar vazio
  /// - Deve ter pelo menos 3 caracteres
  /// - Deve conter apenas números e letras
  String? validateMatricula(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Matrícula é obrigatória';
    }

    if (value.trim().length < 3) {
      return 'Matrícula deve ter pelo menos 3 caracteres';
    }

    return null;
  }

  /// Valida campo de senha.
  ///
  /// Verifica se senha foi preenchida e possui formato válido,
  /// retornando mensagem de erro se inválida, null se válida.
  ///
  /// ## Parâmetros:
  /// - `value`: Valor da senha a ser validado
  ///
  /// ## Retorno:
  /// - `String?`: Mensagem de erro ou null se válida
  ///
  /// ## Validações:
  /// - Campo não pode estar vazio
  /// - Deve ter pelo menos 4 caracteres
  String? validateSenha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 4) {
      return 'Senha deve ter pelo menos 4 caracteres';
    }

    return null;
  }

  // ============================================================================
  // MÉTODOS DE AUTENTICAÇÃO
  // ============================================================================

  /// Executa processo de login do usuário.
  ///
  /// Autentica usuário via AuthService e navega para tela apropriada
  /// baseada no resultado da operação.
  ///
  /// ## Comportamento:
  /// 1. Limpa erros anteriores
  /// 2. Define estado de loading
  /// 3. Executa autenticação via AuthService
  /// 4. Trata resultado (sucesso/erro)
  /// 5. Navega para tela apropriada
  /// 6. Limpa estado de loading
  ///
  /// ## Casos de Uso:
  /// - Login inicial do usuário
  /// - Reautenticação após logout
  /// - Validação de credenciais
  ///
  /// ## Tratamento de Erros:
  /// - Credenciais inválidas
  /// - Falhas de rede
  /// - Erros de validação
  /// - Erros de servidor
  ///
  /// ## Navegação:
  /// - Sucesso: Redireciona para tela principal
  /// - Erro: Mantém na tela de login com feedback
  Future<void> login() async {
    /// Limpa mensagens de erro anteriores.
    clearError();

    /// Define estado de loading.
    _isLoading.value = true;

    try {
      /// Registra início da tentativa de login.
      AppLogger.i('Tentativa de login para matrícula: ${matricula.value}',
          tag: 'LoginController');

      /// Executa autenticação via AuthService.
      final usuario =
          await _authService.login(matricula.value.trim(), senha.value);

      /// Registra sucesso do login.
      AppLogger.i('Login realizado com sucesso para: ${usuario.nome}',
          tag: 'LoginController');

      /// Navega para tela principal e limpa o controller.
      Get.offAllNamed(Routes.home);

      /// Limpa o controller após login bem-sucedido.
      _cleanup();
    } catch (e) {
      /// Trata erro e converte para mensagem amigável.
      final erro = ErrorHandler.tratar(e, StackTrace.current);
      final mensagemErro = ErrorHandler.mensagemUsuario(erro);

      /// Define mensagem de erro para exibição.
      _errorMessage.value = mensagemErro.descricao;

      /// Registra erro de login.
      AppLogger.e('Falha no login para matrícula: ${matricula.value}',
          tag: 'LoginController', error: e);
    } finally {
      /// Sempre limpa estado de loading.
      _isLoading.value = false;
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Limpa o controlador e libera recursos.
  ///
  /// Método privado para limpeza manual do controlador,
  /// usado apenas quando login é bem-sucedido.
  void _cleanup() {
    /// Limpa os valores dos campos.
    matricula.value = '';
    senha.value = '';

    /// Registra finalização do controlador.
    AppLogger.d('LoginController finalizado após login bem-sucedido',
        tag: 'LoginController');

    /// Remove o controller do GetX.
    Get.delete<LoginController>();
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Inicialização do controlador.
  ///
  /// Executado quando controlador é criado, configurando
  /// estado inicial e verificando se usuário já está logado.
  @override
  void onInit() {
    super.onInit();

    /// Registra inicialização do controlador.
    AppLogger.d('LoginController inicializado', tag: 'LoginController');

    /// Verifica se usuário já está logado.
    if (_sessionManager.estaLogado) {
      AppLogger.i('Usuário já está logado, redirecionando...',
          tag: 'LoginController');
      Get.offAllNamed(Routes.home);
    }
  }

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária.
  ///
  /// NOTA: Este método não deve ser chamado durante logout automático,
  /// apenas quando o controller é realmente removido do GetX.
  @override
  void onClose() {
    /// Limpa os valores dos campos.
    matricula.value = '';
    senha.value = '';

    /// Registra finalização do controlador.
    AppLogger.d('LoginController finalizado', tag: 'LoginController');

    super.onClose();
  }
}
