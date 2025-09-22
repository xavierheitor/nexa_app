import 'package:nexa_app/core/domain/dto/usuario_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/usuario_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável pelo gerenciamento de autenticação de usuários.
///
/// Esta classe implementa a camada de serviço para operações de autenticação,
/// fornecendo uma interface limpa entre os controladores e o repositório.
/// Centraliza toda a lógica de negócio relacionada a login, logout, renovação
/// de tokens e gerenciamento de sessão.
///
/// ## Funcionalidades Principais:
///
/// 1. **Autenticação**: Login com credenciais e validação
/// 2. **Renovação de Tokens**: Refresh automático de tokens de acesso
/// 3. **Logout**: Encerramento seguro de sessão
/// 4. **Gerenciamento de Usuários**: Acesso a dados de usuários
/// 5. **Persistência**: Salvamento de dados de autenticação
/// 6. **Logs**: Rastreamento de operações de autenticação
///
/// ## Arquitetura:
///
/// - **Service Layer**: Camada de serviço entre controllers e repository
/// - **Business Logic**: Contém regras de negócio de autenticação
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Error Handling**: Tratamento centralizado de erros
///
/// ## Fluxo de Operações:
///
/// 1. Recebe requisições de controllers
/// 2. Aplica regras de negócio específicas
/// 3. Delega operações ao repositório
/// 4. Processa e transforma dados retornados
/// 5. Registra logs de operações
/// 6. Retorna dados formatados para controllers
///
/// ## Uso:
///
/// ```dart
/// final authService = AuthService(usuarioRepo: usuarioRepo);
///
/// // Login de usuário
/// final usuario = await authService.login('12345', 'senha123');
///
/// // Logout
/// final sucesso = await authService.logout();
///
/// // Renovar token
/// final novoUsuario = await authService.refreshToken(refreshToken);
/// ```
///
/// ## Dependências:
/// - `UsuarioRepo`: Repositório para operações de dados
/// - `AppLogger`: Sistema de logging para rastreamento
/// - `LoginResponseDto`: DTO para respostas de API
/// - `UsuarioTableDto`: DTO para dados de usuário
class AuthService {
  // ============================================================================
  // DEPENDÊNCIAS E CONFIGURAÇÃO
  // ============================================================================

  /// Repositório de usuários para operações de dados.
  ///
  /// Utilizado para todas as operações de persistência e comunicação
  /// com APIs, incluindo login, logout e gerenciamento de usuários.
  final UsuarioRepo usuarioRepo;

  /// Construtor do serviço de autenticação.
  ///
  /// Inicializa o serviço com as dependências necessárias para
  /// operações de autenticação e gerenciamento de usuários.
  ///
  /// ## Parâmetros:
  /// - `usuarioRepo`: Repositório de usuários (obrigatório)
  AuthService({required this.usuarioRepo});

  // ============================================================================
  // OPERAÇÕES DE AUTENTICAÇÃO
  // ============================================================================

  /// Realiza login de usuário com credenciais fornecidas.
  ///
  /// Autentica um usuário através de matrícula e senha, obtendo
  /// tokens de acesso e dados do usuário da API. Salva os dados
  /// de autenticação no banco local para persistência de sessão.
  ///
  /// ## Parâmetros:
  /// - `matricula`: Matrícula do usuário (String)
  /// - `senha`: Senha do usuário (String)
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados do usuário autenticado
  ///
  /// ## Comportamento:
  /// 1. Autentica via API usando repositório
  /// 2. Converte dados de resposta para entidade de usuário
  /// 3. Salva dados de autenticação no banco local
  /// 4. Registra log de sucesso
  /// 5. Retorna dados do usuário para uso na aplicação
  ///
  /// ## Casos de Uso:
  /// - Login inicial do usuário
  /// - Autenticação após logout
  /// - Validação de credenciais
  /// - Estabelecimento de sessão
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuario = await authService.login('12345', 'senha123');
  /// print('Usuário logado: ${usuario.nome}');
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Repassa erros do repositório (credenciais inválidas, rede, etc.)
  /// - Registra logs detalhados de falhas
  /// - Mantém transparência de erros para camada superior
  Future<UsuarioTableDto> login(String matricula, String senha) async {
    /// Registra início da operação de login.
    AppLogger.i('Iniciando login para matrícula: $matricula',
        tag: 'AuthService');

    try {
      /// Autentica usuário via API e obtém dados completos de autenticação.
      final loginResponse = await usuarioRepo.login(matricula, senha);

      /// Converte dados de resposta da API para entidade de usuário local.
      final usuario = UsuarioTableDto(
        id: loginResponse.id,
        remoteId: loginResponse.uuid,
        nome: loginResponse.nome,
        matricula: loginResponse.matricula,
        token: loginResponse.token,
        refreshToken: loginResponse.refreshToken,
        ultimoLogin: DateTime.now(),
        createdAt: loginResponse.createdAt,
      );

      /// Salva dados do usuário no banco local para persistência de sessão.
      await usuarioRepo.inserir(usuario);

      /// Registra sucesso da operação de login.
      AppLogger.i('Login realizado com sucesso para: ${usuario.nome}',
          tag: 'AuthService');

      /// Retorna dados do usuário para uso na aplicação.
      return usuario;
    } catch (e) {
      /// Registra falha na operação de login.
      AppLogger.e('Falha no login para matrícula: $matricula',
          tag: 'AuthService', error: e);

      /// Re-lança erro para tratamento na camada superior.
      rethrow;
    }
  }

  /// Encerra a sessão atual do usuário.
  ///
  /// Remove dados de autenticação do banco local, efetivamente
  /// encerrando a sessão do usuário e limpando tokens armazenados.
  /// Não realiza logout no servidor (tokens continuam válidos até expirarem).
  ///
  /// ## Retorno:
  /// - `Future<bool>`: True se logout foi realizado com sucesso
  ///
  /// ## Comportamento:
  /// 1. Remove todos os usuários do banco local
  /// 2. Limpa dados de sessão persistidos
  /// 3. Registra log da operação
  /// 4. Retorna status de sucesso
  ///
  /// ## Casos de Uso:
  /// - Logout manual do usuário
  /// - Encerramento de sessão por segurança
  /// - Limpeza de dados antes de novo login
  /// - Reset de sessão em caso de problemas
  ///
  /// ## Exemplo:
  /// ```dart
  /// final sucesso = await authService.logout();
  /// if (sucesso) {
  ///   print('Logout realizado com sucesso');
  /// }
  /// ```
  ///
  /// ## Nota de Segurança:
  /// Este método apenas limpa dados locais. Tokens no servidor
  /// continuam válidos até expirarem naturalmente.
  Future<bool> logout() async {
    /// Registra início da operação de logout.
    AppLogger.i('Iniciando logout do usuário', tag: 'AuthService');

    try {
      /// Obtém lista de usuários para remoção.
      final usuarios = await usuarioRepo.listar();

      /// Remove todos os usuários do banco local.
      for (final usuario in usuarios) {
        await usuarioRepo.deletar(int.parse(usuario.id));
      }

      /// Registra sucesso da operação de logout.
      AppLogger.i('Logout realizado com sucesso', tag: 'AuthService');

      /// Retorna sucesso da operação.
      return true;
    } catch (e) {
      /// Registra falha na operação de logout.
      AppLogger.e('Falha no logout', tag: 'AuthService', error: e);

      /// Retorna falha da operação.
      return false;
    }
  }

  /// Renova tokens de autenticação usando refresh token.
  ///
  /// Solicita novos tokens de acesso ao servidor usando o refresh token
  /// válido, atualiza dados de autenticação no banco local e mantém
  /// a sessão do usuário ativa.
  ///
  /// ## Parâmetros:
  /// - `refreshToken`: Token de renovação válido (String)
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados atualizados do usuário
  ///
  /// ## Comportamento:
  /// 1. Solicita novos tokens via API
  /// 2. Atualiza dados de autenticação no banco
  /// 3. Mantém dados de usuário existentes
  /// 4. Registra log da operação
  /// 5. Retorna dados atualizados
  ///
  /// ## Casos de Uso:
  /// - Renovação automática de tokens
  /// - Manutenção de sessão ativa
  /// - Recuperação após expiração
  /// - Sincronização de tokens
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuarioAtualizado = await authService.refreshToken(refreshToken);
  /// print('Tokens renovados para: ${usuarioAtualizado.nome}');
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Repassa erros do repositório (token expirado, rede, etc.)
  /// - Registra logs detalhados de falhas
  /// - Mantém transparência de erros para camada superior
  ///
  /// ## ⚠️ Importante:
  /// Se este método falhar, o usuário precisará fazer novo login.
  Future<UsuarioTableDto> refreshToken(String refreshToken) async {
    /// Registra início da operação de renovação de token.
    AppLogger.i('Iniciando renovação de token', tag: 'AuthService');

    try {
      /// Solicita novos tokens via API usando refresh token.
      final loginResponse = await usuarioRepo.refreshToken(refreshToken);

      /// Obtém usuário atual do banco local.
      final usuarios = await usuarioRepo.listar();
      if (usuarios.isEmpty) {
        throw Exception('Nenhum usuário encontrado para atualizar tokens');
      }

      final usuarioAtual = usuarios.first;

      /// Atualiza dados de autenticação mantendo outros dados do usuário.
      final usuarioAtualizado = UsuarioTableDto(
        id: usuarioAtual.id,
        remoteId: usuarioAtual.remoteId,
        nome: usuarioAtual.nome,
        matricula: usuarioAtual.matricula,
        token: loginResponse.token,
        refreshToken: loginResponse.refreshToken,
        ultimoLogin: usuarioAtual.ultimoLogin,
        createdAt: usuarioAtual.createdAt,
      );

      /// Salva dados atualizados no banco local.
      await usuarioRepo.atualizar(usuarioAtualizado);

      /// Registra sucesso da operação de renovação.
      AppLogger.i('Token renovado com sucesso para: ${usuarioAtualizado.nome}',
          tag: 'AuthService');

      /// Retorna dados atualizados do usuário.
      return usuarioAtualizado;
    } catch (e) {
      /// Registra falha na operação de renovação de token.
      AppLogger.e('Falha na renovação de token', tag: 'AuthService', error: e);

      /// Re-lança erro para tratamento na camada superior.
      rethrow;
    }
  }

  // ============================================================================
  // OPERAÇÕES DE CONSULTA
  // ============================================================================

  /// Obtém lista de usuários cadastrados no banco local.
  ///
  /// Recupera todos os usuários armazenados localmente, incluindo
  /// dados de autenticação e informações pessoais. Utilizado
  /// principalmente para verificação de sessão ativa.
  ///
  /// ## Retorno:
  /// - `Future<List<UsuarioTableDto>>`: Lista de usuários cadastrados
  ///
  /// ## Comportamento:
  /// 1. Consulta banco local via repositório
  /// 2. Retorna lista de usuários encontrados
  /// 3. Lista vazia se nenhum usuário cadastrado
  ///
  /// ## Casos de Uso:
  /// - Verificação de sessão ativa
  /// - Carregamento de dados de usuário
  /// - Validação de autenticação
  /// - Gerenciamento de múltiplos usuários
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuarios = await authService.getUsuarios();
  /// if (usuarios.isNotEmpty) {
  ///   print('Usuário logado: ${usuarios.first.nome}');
  /// }
  /// ```
  Future<List<UsuarioTableDto>> getUsuarios() async {
    /// Consulta lista de usuários no banco local.
    final usuarios = await usuarioRepo.listar();

    /// Registra resultado da consulta.
    AppLogger.d('${usuarios.length} usuário(s) encontrado(s) no banco local',
        tag: 'AuthService');

    /// Retorna lista de usuários.
    return usuarios;
  }
}
