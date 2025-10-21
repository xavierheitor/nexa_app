import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável pelo armazenamento seguro de tokens de autenticação.
///
/// Este serviço utiliza FlutterSecureStorage para armazenar tokens de forma
/// criptografada no dispositivo, garantindo que credenciais sensíveis não
/// fiquem expostas em texto plano.
///
/// ## Funcionalidades:
/// 1. **Armazenamento Criptografado**: Tokens salvos com criptografia nativa
/// 2. **Acesso Rápido**: Leitura/escrita otimizada
/// 3. **Limpeza Segura**: Remoção completa de tokens no logout
/// 4. **Logging Seguro**: Logs sem expor tokens
///
/// ## Segurança:
/// - **Android**: Usa EncryptedSharedPreferences (AES-256)
/// - **iOS**: Usa Keychain (criptografia de sistema)
/// - **Tokens nunca em texto plano**: Mesmo em arquivos de backup
///
/// ## Uso:
/// ```dart
/// final storage = TokenStorageService();
///
/// // Salvar tokens
/// await storage.saveAccessToken('token123');
/// await storage.saveRefreshToken('refresh456');
///
/// // Ler tokens
/// final token = await storage.getAccessToken();
///
/// // Limpar tudo
/// await storage.clearAll();
/// ```
class TokenStorageService {
  // ==========================================================================
  // CONSTANTES
  // ==========================================================================

  /// Chave para armazenar o access token.
  static const String _keyAccessToken = 'secure_access_token';

  /// Chave para armazenar o refresh token.
  static const String _keyRefreshToken = 'secure_refresh_token';

  /// Chave para armazenar o ID do usuário.
  static const String _keyUserId = 'secure_user_id';

  /// Chave para armazenar a matrícula do usuário.
  static const String _keyUserMatricula = 'secure_user_matricula';

  // ==========================================================================
  // DEPENDÊNCIAS
  // ==========================================================================

  /// Instância do Flutter Secure Storage.
  final FlutterSecureStorage _storage;

  /// Construtor com configuração otimizada.
  TokenStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  // ==========================================================================
  // MÉTODOS DE ESCRITA
  // ==========================================================================

  /// Salva o access token de forma segura.
  ///
  /// ## Parâmetros:
  /// - `token`: Access token a ser salvo (criptografado automaticamente)
  ///
  /// ## Exemplo:
  /// ```dart
  /// await storage.saveAccessToken('eyJhbGciOiJIUzI1NiIs...');
  /// ```
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccessToken, value: token);
      AppLogger.d('🔐 Access token salvo com segurança', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao salvar access token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Salva o refresh token de forma segura.
  ///
  /// ## Parâmetros:
  /// - `token`: Refresh token a ser salvo (criptografado automaticamente)
  ///
  /// ## Exemplo:
  /// ```dart
  /// await storage.saveRefreshToken('refresh_token_123');
  /// ```
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
      AppLogger.d('🔐 Refresh token salvo com segurança', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao salvar refresh token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Salva o ID do usuário.
  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _keyUserId, value: userId);
      AppLogger.d('🔐 User ID salvo com segurança', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao salvar user ID',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Salva a matrícula do usuário.
  Future<void> saveUserMatricula(String matricula) async {
    try {
      await _storage.write(key: _keyUserMatricula, value: matricula);
      AppLogger.d('🔐 Matrícula salva com segurança', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao salvar matrícula',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ==========================================================================
  // MÉTODOS DE LEITURA
  // ==========================================================================

  /// Recupera o access token armazenado.
  ///
  /// ## Retorno:
  /// - `String?`: Access token descriptografado ou null se não existir
  ///
  /// ## Exemplo:
  /// ```dart
  /// final token = await storage.getAccessToken();
  /// if (token != null) {
  ///   // Usar token
  /// }
  /// ```
  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _keyAccessToken);
      if (token != null) {
        AppLogger.d('🔐 Access token recuperado', tag: 'TokenStorage');
      }
      return token;
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao ler access token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Recupera o refresh token armazenado.
  ///
  /// ## Retorno:
  /// - `String?`: Refresh token descriptografado ou null se não existir
  ///
  /// ## Exemplo:
  /// ```dart
  /// final refreshToken = await storage.getRefreshToken();
  /// ```
  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: _keyRefreshToken);
      if (token != null) {
        AppLogger.d('🔐 Refresh token recuperado', tag: 'TokenStorage');
      }
      return token;
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao ler refresh token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Recupera o ID do usuário.
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _keyUserId);
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao ler user ID',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Recupera a matrícula do usuário.
  Future<String?> getUserMatricula() async {
    try {
      return await _storage.read(key: _keyUserMatricula);
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao ler matrícula',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ==========================================================================
  // MÉTODOS DE LIMPEZA
  // ==========================================================================

  /// Remove o access token armazenado.
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: _keyAccessToken);
      AppLogger.d('🗑️ Access token removido', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao deletar access token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remove o refresh token armazenado.
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _keyRefreshToken);
      AppLogger.d('🗑️ Refresh token removido', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao deletar refresh token',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remove TODOS os dados armazenados de forma segura.
  ///
  /// Este método deve ser chamado no logout para garantir que
  /// nenhuma credencial permaneça no dispositivo.
  ///
  /// ## Exemplo:
  /// ```dart
  /// await storage.clearAll(); // Logout seguro
  /// ```
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.i('🗑️ Todos os tokens removidos com segurança', tag: 'TokenStorage');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Erro ao limpar todos os tokens',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================================================
  // MÉTODOS AUXILIARES
  // ==========================================================================

  /// Verifica se há access token armazenado.
  ///
  /// ## Retorno:
  /// - `true` se existe access token
  /// - `false` caso contrário
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Verifica se há refresh token armazenado.
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  /// Retorna todas as chaves armazenadas (para debug).
  ///
  /// **ATENÇÃO**: Use apenas para debugging. Não exiba os valores!
  Future<Set<String>> getAllKeys() async {
    try {
      final all = await _storage.readAll();
      return all.keys.toSet();
    } catch (e) {
      AppLogger.e('❌ Erro ao ler chaves', tag: 'TokenStorage', error: e);
      return {};
    }
  }
}

