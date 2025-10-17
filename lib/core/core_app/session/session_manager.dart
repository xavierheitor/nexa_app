import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/domain/dto/usuario_table_dto.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Gerenciador centralizado de sessão do usuário.
///
/// Esta classe implementa o gerenciamento completo da sessão de usuário,
/// incluindo carregamento automático, validação de tokens, renovação
/// automática e limpeza de dados. Funciona como um serviço GetX que
/// permanece ativo durante todo o ciclo de vida da aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Inicialização Automática**: Carrega sessão ao iniciar aplicação
/// 2. **Validação de Sessão**: Verifica se usuário está logado e sessão válida
/// 3. **Renovação de Tokens**: Atualiza tokens automaticamente
/// 4. **Gerenciamento de Estado**: Controla estado de autenticação
/// 5. **Logout Seguro**: Limpa dados de sessão completamente
/// 6. **Integração DioClient**: Fornece tokens para requisições HTTP
///
/// ## Arquitetura:
///
/// - **GetX Service**: Serviço persistente durante ciclo de vida da app
/// - **Singleton Pattern**: Instância única gerenciada pelo GetX
/// - **State Management**: Controla estado de autenticação globalmente
/// - **Dependency Injection**: Recebe AuthService via construtor
///
/// ## Fluxo de Funcionamento:
///
/// 1. **Inicialização**: Carrega dados de usuário do banco local
/// 2. **Validação**: Verifica se sessão ainda é válida (24h)
/// 3. **Renovação**: Tenta renovar tokens se necessário
/// 4. **Estado**: Fornece estado de autenticação para toda aplicação
/// 5. **Logout**: Limpa dados quando sessão é encerrada
///
/// ## Uso:
///
/// ```dart
/// // Inicialização (geralmente no main.dart)
/// await Get.put(SessionManager(authService: authService)).init();
///
/// // Verificação de autenticação
/// if (Get.find<SessionManager>().estaLogado) {
///   // Usuário logado
/// }
///
/// // Acesso ao token para requisições
/// final token = Get.find<SessionManager>().tokenSync;
/// ```
///
/// ## Dependências:
/// - `AuthService`: Serviço de autenticação para operações
/// - `GetxService`: Base para serviços GetX
/// - `UsuarioTableDto`: DTO para dados de usuário
/// - `AppLogger`: Sistema de logging
class SessionManager extends GetxService {
  // ============================================================================
  // DEPENDÊNCIAS E CONFIGURAÇÃO
  // ============================================================================

  /// Serviço de autenticação para operações de login e tokens.
  ///
  /// Utilizado para todas as operações relacionadas à autenticação,
  /// incluindo login, logout, renovação de tokens e gerenciamento
  /// de dados de usuário.
  final AuthService authService;

  /// Construtor do gerenciador de sessão.
  ///
  /// Inicializa o gerenciador com as dependências necessárias
  /// para operações de autenticação e gerenciamento de sessão.
  ///
  /// ## Parâmetros:
  /// - `authService`: Serviço de autenticação (obrigatório)
  SessionManager({required this.authService});

  // ============================================================================
  // ESTADO INTERNO
  // ============================================================================

  /// Dados do usuário atualmente logado.
  ///
  /// Armazena informações completas do usuário autenticado,
  /// incluindo tokens de acesso e dados pessoais. Null quando
  /// nenhum usuário está logado.
  UsuarioTableDto? _usuario;

  /// Flag indicando se o gerenciador foi inicializado.
  ///
  /// Previne operações antes da inicialização completa e
  /// garante que dados foram carregados corretamente.
  bool _inicializado = false;

  /// Flag indicando se renovação de token está em andamento.
  ///
  /// Previne múltiplas tentativas simultâneas de renovação
  /// de token, evitando condições de corrida.
  bool _refreshing = false;

  // ============================================================================
  // GETTERS PÚBLICOS
  // ============================================================================

  /// Dados do usuário atualmente logado.
  ///
  /// Retorna os dados completos do usuário autenticado ou null
  /// se nenhum usuário estiver logado.
  ///
  /// ## Retorno:
  /// - `UsuarioTableDto?`: Dados do usuário ou null
  UsuarioTableDto? get usuario => _usuario;

  /// Verifica se o usuário está logado e com sessão válida.
  ///
  /// Realiza validação completa do estado de autenticação,
  /// verificando inicialização, existência de usuário e
  /// validade da sessão (24 horas).
  ///
  /// ## Retorno:
  /// - `bool`: True se usuário está logado e sessão válida
  ///
  /// ## Validações:
  /// - Gerenciador deve estar inicializado
  /// - Usuário deve existir
  /// - Último login deve ser menor que 24 horas
  bool get estaLogado {
    /// Verifica se gerenciador foi inicializado.
    if (!_inicializado) return false;

    /// Verifica se usuário existe.
    if (_usuario == null) return false;

    /// Obtém data do último login.
    final login = _usuario?.ultimoLogin;
    if (login == null) return false;

    /// Verifica se sessão ainda é válida (menos de 24 horas).
    return DateTime.now().difference(login).inHours < 24;
  }

  /// Token de acesso síncrono para uso imediato.
  ///
  /// Fornece token de acesso de forma síncrona para uso em
  /// interceptors HTTP e outras operações que requerem
  /// acesso imediato ao token.
  ///
  /// ## Retorno:
  /// - `String?`: Token de acesso ou null se não logado
  String? get tokenSync => _usuario?.token;

  /// Token de acesso assíncrono para uso futuro.
  ///
  /// Fornece token de acesso de forma assíncrona, útil para
  /// operações que podem aguardar a obtenção do token.
  ///
  /// ## Retorno:
  /// - `Future<String?>`: Token de acesso ou null se não logado
  Future<String?> get token async => _usuario?.token;

  // ============================================================================
  // OPERAÇÕES DE GERENCIAMENTO DE SESSÃO
  // ============================================================================

  /// Inicializa a sessão a partir do storage local.
  ///
  /// Carrega dados de usuário do banco local, valida se a sessão
  /// ainda é válida e tenta renovar tokens se necessário. Este
  /// método deve ser chamado durante a inicialização da aplicação.
  ///
  /// ## Comportamento:
  /// 1. Carrega usuários do banco local
  /// 2. Verifica se há usuário válido
  /// 3. Valida se sessão não expirou (24h)
  /// 4. Tenta renovar tokens se disponível
  /// 5. Marca gerenciador como inicializado
  ///
  /// ## Casos de Uso:
  /// - Inicialização da aplicação
  /// - Recuperação de sessão após restart
  /// - Validação de autenticação persistente
  ///
  /// ## Exemplo:
  /// ```dart
  /// await sessionManager.init();
  /// if (sessionManager.estaLogado) {
  ///   // Usuário tem sessão válida
  /// }
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Registra erros detalhados
  /// - Permite funcionamento offline se renovação falhar
  /// - Sempre marca como inicializado
  Future<void> init() async {
    /// Registra início da inicialização.
    AppLogger.d('[SessionManager] Inicializando sessão...');

    try {
      /// Carrega usuários do banco local.
      final usuarios = await authService.getUsuarios();
      if (usuarios.isEmpty) {
        /// Nenhum usuário encontrado, sessão não inicializada.
        return;
      }

      /// Define primeiro usuário como usuário ativo.
      _usuario = usuarios.first;
      AppLogger.i('Usuário local encontrado: ${_usuario?.nome}', tag: 'Sessão');

      /// Valida se usuário tem data de último login.
      final ultimoLogin = _usuario?.ultimoLogin;
      if (ultimoLogin == null) {
        AppLogger.w('Usuário sem data de último login. Limpando sessão.', tag: 'Sessão');
        await logout();
        return;
      }

      /// Calcula tempo desde último login.
      final diff = DateTime.now().difference(ultimoLogin).inHours;
      AppLogger.d('Último login há $diff horas', tag: 'Sessão');

      /// Verifica se sessão expirou (24 horas).
      if (diff >= 24) {
        AppLogger.i('Sessão expirada ($diff horas). Fazendo logout.', tag: 'Sessão');
        await logout();
        return;
      }

      /// Tenta renovar token se refresh token disponível.
      final refreshToken = _usuario?.refreshToken;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          await renovarToken();
        } catch (_) {
          /// Falha na renovação não impede funcionamento offline.
          AppLogger.w('Falha ao renovar token. Sessão offline permitida.',
              tag: 'Sessão');
        }
      }
    } catch (e, s) {
      /// Trata erro e registra detalhes.
      final erro = ErrorHandler.tratar(e, s);
      AppLogger.e('Erro ao inicializar sessão',
          tag: 'SessionManager', error: erro.mensagem, stackTrace: s);

      /// Re-lança erro para tratamento superior.
      rethrow;
    } finally {
      /// Sempre marca como inicializado, mesmo em caso de erro.
      _inicializado = true;
    }
  }

  /// Renova tokens de autenticação usando refresh token persistido.
  ///
  /// Solicita novos tokens de acesso ao servidor usando o refresh token
  /// armazenado localmente. Previne múltiplas tentativas simultâneas
  /// e atualiza dados de usuário com novos tokens.
  ///
  /// ## Comportamento:
  /// 1. Verifica se renovação já está em andamento
  /// 2. Valida existência de refresh token
  /// 3. Solicita novos tokens via API
  /// 4. Atualiza dados do usuário
  /// 5. Registra resultado da operação
  ///
  /// ## Casos de Uso:
  /// - Renovação automática durante inicialização
  /// - Atualização de tokens antes de expiração
  /// - Recuperação de sessão após falha de rede
  ///
  /// ## Exemplo:
  /// ```dart
  /// try {
  ///   await sessionManager.renovarToken();
  ///   print('Token renovado com sucesso');
  /// } catch (e) {
  ///   print('Falha na renovação: $e');
  /// }
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Previne múltiplas tentativas simultâneas
  /// - Valida existência de refresh token
  /// - Registra erros detalhados
  /// - Re-lança erros para tratamento superior
  ///
  /// ## ⚠️ Importante:
  /// Se este método falhar, o usuário precisará fazer novo login.
  Future<void> renovarToken() async {
    /// Previne múltiplas tentativas simultâneas.
    if (_refreshing) return;

    /// Valida existência de refresh token.
    final token = _usuario?.refreshToken;
    if (token == null || token.isEmpty) {
      throw Exception('Refresh token ausente');
    }

    /// Marca como renovando para evitar concorrência.
    _refreshing = true;

    try {
      /// Solicita novos tokens via API.
      await authService.refreshToken(token);

      /// Atualiza dados do usuário com novos tokens.
      _usuario = (await authService.getUsuarios()).first;

      /// Registra sucesso da renovação.
      AppLogger.i('Token renovado com sucesso', tag: 'Sessão');
    } catch (e, s) {
      /// Trata erro e registra detalhes.
      final erro = ErrorHandler.tratar(e, s);
      AppLogger.e('Erro ao renovar token',
          tag: 'SessionManager', error: erro.mensagem, stackTrace: s);

      /// Re-lança erro para tratamento superior.
      rethrow;
    } finally {
      /// Sempre libera flag de renovação.
      _refreshing = false;
    }
  }

  /// Finaliza a sessão atual e limpa dados do usuário.
  ///
  /// Executa logout completo, removendo dados de autenticação
  /// do banco local e limpando estado interno do gerenciador.
  /// Não realiza logout no servidor (tokens continuam válidos).
  ///
  /// ## Comportamento:
  /// 1. Solicita logout via AuthService
  /// 2. Remove dados do banco local
  /// 3. Limpa estado interno
  /// 4. Registra resultado da operação
  ///
  /// ## Casos de Uso:
  /// - Logout manual do usuário
  /// - Limpeza de sessão expirada
  /// - Reset de autenticação
  /// - Encerramento seguro da aplicação
  ///
  /// ## Exemplo:
  /// ```dart
  /// final sucesso = await sessionManager.logout();
  /// if (sucesso) {
  ///   // Redirecionar para tela de login
  /// }
  /// ```
  ///
  /// ## Retorno:
  /// - `Future<bool>`: True se logout foi realizado com sucesso
  ///
  /// ## Tratamento de Erros:
  /// - Registra erros detalhados
  /// - Retorna false em caso de falha
  /// - Não impede limpeza de estado local
  ///
  /// ## Nota de Segurança:
  /// Este método apenas limpa dados locais. Tokens no servidor
  /// continuam válidos até expirarem naturalmente.
  Future<bool> logout() async {
    try {
      /// Solicita logout via AuthService.
      final result = await authService.logout();

      if (result) {
        /// Limpa dados do usuário em memória.
        _usuario = null;

        /// Registra sucesso do logout.
        AppLogger.i('Sessão encerrada com sucesso', tag: 'Sessão');

        /// Retorna sucesso.
        return true;
      }

      /// Retorna falha se AuthService falhou.
      return false;
    } catch (e, s) {
      /// Trata erro e registra detalhes.
      final erro = ErrorHandler.tratar(e, s);
      AppLogger.e('Erro ao encerrar sessão',
          tag: 'SessionManager', error: erro.mensagem, stackTrace: s);

      /// Retorna falha mesmo em caso de erro.
      return false;
    }
  }
}
