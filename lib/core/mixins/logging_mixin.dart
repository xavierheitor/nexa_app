import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart' hide LogLevel;

/// Mixin para adicionar logging automático e consistente em repositories.
///
/// Este mixin elimina a duplicação de código de try-catch, logging e tratamento
/// de erros que aparece repetidamente em todos os métodos dos repositories.
///
/// ## Problema Resolvido:
///
/// Antes (código duplicado em CADA método):
/// ```dart
/// Future<List<VeiculoDto>> buscarDaApi() async {
///   try {
///     final response = await dio.get(ApiConstants.veiculos);
///     return (response.data as List)
///         .map((json) => VeiculoDto.fromJson(json))
///         .toList();
///   } catch (e, s) {
///     final erro = ErrorHandler.tratar(e, s);
///     AppLogger.e(
///       '[veiculo_repository - buscarDaApi] ${erro.mensagem}',
///       tag: 'VeiculoRepository',
///       error: e,
///       stackTrace: s,
///     );
///     throw erro;
///   }
/// }
/// ```
///
/// Depois (com LoggingMixin):
/// ```dart
/// Future<List<VeiculoDto>> buscarDaApi() async {
///   return await executeWithLogging(
///     operationName: 'buscarDaApi',
///     operation: () async {
///       final response = await dio.get(ApiConstants.veiculos);
///       return (response.data as List)
///           .map((json) => VeiculoDto.fromJson(json))
///           .toList();
///     },
///   );
/// }
/// ```
///
/// ## Como Usar:
///
/// 1. **Adicione o mixin à classe do repository**:
/// ```dart
/// class VeiculoRepo with LoggingMixin implements SyncableRepository<VeiculoDto> {
///   // ...
/// }
/// ```
///
/// 2. **Implemente o getter `repositoryName`**:
/// ```dart
/// @override
/// String get repositoryName => 'VeiculoRepository';
/// ```
///
/// 3. **Use `executeWithLogging()` em todos os métodos**:
/// ```dart
/// Future<VeiculoDto> buscarPorId(String id) async {
///   return await executeWithLogging(
///     operationName: 'buscarPorId',
///     operation: () async {
///       final veiculo = await veiculoDao.buscarPorId(id);
///       return VeiculoDto.fromEntity(veiculo);
///     },
///   );
/// }
/// ```
///
/// ## Benefícios:
///
/// - **Logging Consistente**: Mesmo formato em todos os repositories
/// - **DRY**: Elimina ~3.000 linhas de código duplicado
/// - **Manutenibilidade**: Mudanças de logging em um único lugar
/// - **Stack Traces**: Sempre capturados automaticamente
/// - **Error Handling**: Tratamento padronizado via ErrorHandler
/// - **Performance**: Logs incluem tempo de execução (opcional)
/// - **Debugging**: Tags automáticas facilitam filtragem de logs
///
/// ## Funcionalidades:
///
/// - ✅ Try-catch automático
/// - ✅ Logging de início/fim da operação
/// - ✅ Captura de stack traces
/// - ✅ Tratamento de erros via ErrorHandler
/// - ✅ Tag baseada no repositoryName
/// - ✅ Mensagens formatadas consistentemente
/// - ✅ Re-throw de exceptions tratadas
///
mixin LoggingMixin {
  /// Nome do repository para identificação nos logs.
  ///
  /// Deve ser único e descritivo (ex: 'VeiculoRepository', 'UsuarioRepository').
  /// Usado como tag nos logs para facilitar filtragem.
  String get repositoryName;

  /// Executa uma operação com logging automático e tratamento de erros.
  ///
  /// Wrapper genérico que adiciona try-catch, logging e error handling
  /// consistente a qualquer operação assíncrona.
  ///
  /// ## Parâmetros:
  /// - `operationName`: Nome da operação (método) sendo executada
  /// - `operation`: Função async que executa a operação real
  /// - `logLevel`: Nível de log para início/sucesso (default: debug)
  ///
  /// ## Retorno:
  /// - `Future<T>`: Resultado da operação ou AppException em caso de erro
  ///
  /// ## Comportamento:
  /// 1. Loga início da operação (debug)
  /// 2. Executa a operação fornecida
  /// 3. Loga sucesso (debug)
  /// 4. Em caso de erro:
  ///    - Trata erro via ErrorHandler
  ///    - Loga erro detalhado (error level)
  ///    - Re-lança AppException tratada
  ///
  /// ## Exemplo:
  /// ```dart
  /// Future<VeiculoDto> buscarPorId(String id) async {
  ///   return await executeWithLogging(
  ///     operationName: 'buscarPorId',
  ///     operation: () async {
  ///       final veiculo = await veiculoDao.buscarPorId(id);
  ///       return VeiculoDto.fromEntity(veiculo);
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// ## Logs Gerados:
  /// ```
  /// [DEBUG] [VeiculoRepository] buscarPorId - Iniciando...
  /// [DEBUG] [VeiculoRepository] buscarPorId - ✅ Concluído
  /// ```
  ///
  /// Ou em caso de erro:
  /// ```
  /// [ERROR] [VeiculoRepository] buscarPorId - Erro ao buscar veículo
  /// [ERROR] [VeiculoRepository] Mensagem do erro...
  /// [STACK] [VeiculoRepository] #0 ... (stack trace completo)
  /// ```
  Future<T> executeWithLogging<T>({
    required String operationName,
    required Future<T> Function() operation,
    LogLevel logLevel = LogLevel.debug,
  }) async {
    try {
      // Log de início da operação
      _log('$operationName - Iniciando...', logLevel);

      // Executa a operação fornecida
      final result = await operation();

      // Log de sucesso
      _log('$operationName - ✅ Concluído', logLevel);

      return result;
    } catch (e, stackTrace) {
      // Trata o erro bruto e converte para AppException padronizada
      final erro = ErrorHandler.tratar(e, stackTrace);

      // Loga erro detalhado com stack trace
      AppLogger.e(
        '[$repositoryName - $operationName] ${erro.mensagem}',
        tag: repositoryName,
        error: e,
        stackTrace: stackTrace,
      );

      // Re-lança a exceção tratada
      throw erro;
    }
  }

  /// Executa uma operação void com logging automático.
  ///
  /// Variante de `executeWithLogging()` para métodos que não retornam valor.
  ///
  /// ## Exemplo:
  /// ```dart
  /// Future<void> deletar(String id) async {
  ///   return await executeVoidWithLogging(
  ///     operationName: 'deletar',
  ///     operation: () async {
  ///       await veiculoDao.deletar(id);
  ///     },
  ///   );
  /// }
  /// ```
  Future<void> executeVoidWithLogging({
    required String operationName,
    required Future<void> Function() operation,
    LogLevel logLevel = LogLevel.debug,
  }) async {
    try {
      _log('$operationName - Iniciando...', logLevel);
      await operation();
      _log('$operationName - ✅ Concluído', logLevel);
    } catch (e, stackTrace) {
      final erro = ErrorHandler.tratar(e, stackTrace);

      AppLogger.e(
        '[$repositoryName - $operationName] ${erro.mensagem}',
        tag: repositoryName,
        error: e,
        stackTrace: stackTrace,
      );

      throw erro;
    }
  }

  /// Helper interno para logging baseado no nível.
  void _log(String message, LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        AppLogger.v(message, tag: repositoryName);
        break;
      case LogLevel.debug:
        AppLogger.d(message, tag: repositoryName);
        break;
      case LogLevel.info:
        AppLogger.i(message, tag: repositoryName);
        break;
      case LogLevel.warning:
        AppLogger.w(message, tag: repositoryName);
        break;
      case LogLevel.error:
        AppLogger.e(message, tag: repositoryName);
        break;
    }
  }
}

/// Níveis de log disponíveis para operações.
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

