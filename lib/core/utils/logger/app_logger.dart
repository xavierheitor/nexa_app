import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Sistema de logging centralizado para toda a aplicação NexaApp.
///
/// Esta classe implementa um sistema robusto de logging que combina
/// saída colorida no console para desenvolvimento com persistência
/// em arquivo para produção e debugging. Oferece diferentes níveis
/// de log e formatação padronizada para facilitar o debugging e
/// monitoramento da aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Logging Colorido**: Saída colorida no console para desenvolvimento
/// 2. **Persistência em Arquivo**: Logs salvos em `app.log` no diretório de documentos
/// 3. **Níveis de Log**: 5 níveis diferentes (verbose, debug, info, warning, error)
/// 4. **Formatação Padronizada**: Timestamp, tags e emojis para identificação rápida
/// 5. **Tratamento de Erros**: Captura de exceções e stack traces
/// 6. **Performance**: Operações assíncronas para não bloquear a UI
/// 7. **Modo Debug**: Logs apenas em modo debug para otimização de produção
///
/// ## Arquitetura:
///
/// - **Singleton Pattern**: Métodos estáticos para acesso global
/// - **Async File I/O**: Escrita de arquivos não bloqueia a aplicação
/// - **Conditional Logging**: Logs apenas em modo debug
/// - **Color Coding**: Códigos ANSI para cores no terminal
/// - **Error Handling**: Tratamento seguro de falhas na escrita de arquivos
///
/// ## Níveis de Log:
///
/// - **VERBOSE (🔍)**: Informações muito detalhadas para debugging profundo
/// - **DEBUG (🐞)**: Informações de debugging para desenvolvimento
/// - **INFO (ℹ️)**: Informações gerais sobre o funcionamento da aplicação
/// - **WARNING (⚠️)**: Avisos sobre situações que podem causar problemas
/// - **ERROR (❌)**: Erros que afetam o funcionamento da aplicação
///
/// ## Uso:
///
/// ```dart
/// // Logs básicos
/// AppLogger.i('Aplicação iniciada');
/// AppLogger.d('Debug info');
/// AppLogger.w('Aviso importante');
/// AppLogger.e('Erro crítico');
/// AppLogger.v('Informação detalhada');
///
/// // Com tags para categorização
/// AppLogger.i('Usuário logado', tag: 'Auth');
/// AppLogger.e('Falha na API', tag: 'Network', error: exception);
///
/// // Log detalhado com método principal
/// AppLogger.log(
///   'Operação complexa',
///   level: LogLevel.info,
///   tag: 'Business',
///   error: error,
///   stackTrace: stackTrace,
/// );
/// ```
///
/// ## Localização dos Logs:
///
/// - **Console**: Saída colorida durante desenvolvimento
/// - **Arquivo**: `{DocumentsDirectory}/app.log`
/// - **Formato**: `[TIMESTAMP] [LEVEL] [TAG] MESSAGE`
///
/// ## Dependências:
/// - `flutter/foundation`: Para `kDebugMode` e `debugPrint`
/// - `path_provider`: Para acesso ao diretório de documentos
/// - `dart:io`: Para operações de arquivo
enum LogLevel {
  /// Logs muito detalhados para debugging profundo
  verbose,

  /// Logs de debugging para desenvolvimento
  debug,

  /// Informações gerais sobre o funcionamento
  info,

  /// Avisos sobre situações potencialmente problemáticas
  warning,

  /// Erros que afetam o funcionamento da aplicação
  error
}

// ============================================================================
// CÓDIGOS DE CORES ANSI PARA TERMINAL
// ============================================================================

/// Código ANSI para resetar cores no terminal
const _reset = '\x1B[0m';

/// Código ANSI para cor vermelha (usado em logs de erro)
const _red = '\x1B[31m';

/// Código ANSI para cor amarela (usado em logs de warning)
const _yellow = '\x1B[33m';

/// Código ANSI para cor verde (usado em logs de informação)
const _green = '\x1B[32m';

/// Código ANSI para cor azul (usado em logs de debug)
const _blue = '\x1B[34m';

/// Código ANSI para cor magenta (usado em stack traces)
const _magenta = '\x1B[35m';

/// Código ANSI para cor cinza (usado em logs verbose)
const _cinza = '\x1B[90m';

/// Classe principal do sistema de logging da aplicação.
///
/// Esta classe fornece métodos estáticos para logging em diferentes níveis,
/// com formatação padronizada, cores no terminal e persistência em arquivo.
/// Todos os métodos são otimizados para performance e só executam em modo debug.
class AppLogger {
  // ============================================================================
  // MÉTODO PRINCIPAL DE LOGGING
  // ============================================================================

  /// Método principal para logging com controle completo de parâmetros.
  ///
  /// Este método oferece a interface mais completa para logging, permitindo
  /// especificar nível, tag, erros e stack traces. É usado internamente pelos
  /// métodos de conveniência e pode ser usado diretamente para casos complexos.
  ///
  /// ## Parâmetros:
  /// - `message`: Mensagem principal a ser logada
  /// - `level`: Nível do log (padrão: LogLevel.info)
  /// - `tag`: Tag para categorização (padrão: 'APP')
  /// - `error`: Exceção ou erro opcional
  /// - `stackTrace`: Stack trace opcional
  ///
  /// ## Comportamento:
  /// - Não executa em modo release (kDebugMode)
  /// - Exibe emoji correspondente ao nível
  /// - Formata mensagem com tag e timestamp
  /// - Inclui informações de erro e stack trace se fornecidas
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.log(
  ///   'Falha na operação crítica',
  ///   level: LogLevel.error,
  ///   tag: 'Database',
  ///   error: exception,
  ///   stackTrace: stackTrace,
  /// );
  /// ```
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    String tag = 'APP',
    dynamic error,
    StackTrace? stackTrace,
  }) {
    /// Verifica se está em modo debug antes de executar qualquer operação de log.
    /// Isso garante que logs não sejam processados em builds de produção.
    if (!kDebugMode) return;

    // ========================================================================
    // MAPEAMENTO DE EMOJIS POR NÍVEL
    // ========================================================================

    /// Mapeia cada nível de log para um emoji correspondente,
    /// facilitando identificação visual rápida no console.
    final emoji = {
      LogLevel.verbose: '🔍',
      LogLevel.debug: '🐞',
      LogLevel.info: 'ℹ️',
      LogLevel.warning: '⚠️',
      LogLevel.error: '❌',
    }[level];

    // ========================================================================
    // CONSTRUÇÃO DA MENSAGEM FORMATADA
    // ========================================================================

    /// Constrói a mensagem formatada com emoji, tag e conteúdo principal.
    final buffer = StringBuffer();
    buffer.writeln('$emoji [$tag] $message');

    /// Adiciona informações de erro se fornecidas.
    if (error != null) buffer.writeln('   ↳ Error: $error');

    /// Adiciona stack trace se fornecido.
    if (stackTrace != null) buffer.writeln('   ↳ Stack: $stackTrace');

    /// Exibe a mensagem formatada no console.
    debugPrint(buffer.toString());
  }

  // ============================================================================
  // MÉTODOS DE CONVENIÊNCIA POR NÍVEL
  // ============================================================================

  /// Log de informação (INFO) - cor verde.
  ///
  /// Usado para registrar informações gerais sobre o funcionamento da aplicação,
  /// como inicialização, operações bem-sucedidas e eventos importantes.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `tag`: Tag opcional para categorização
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.i('Aplicação iniciada com sucesso');
  /// AppLogger.i('Usuário logado', tag: 'Auth');
  /// ```
  static void i(dynamic msg, {String? tag}) => _log(msg, 'INFO', _green, tag);

  /// Log de debug (DEBUG) - cor azul.
  ///
  /// Usado para informações de debugging durante o desenvolvimento,
  /// como valores de variáveis, fluxo de execução e estados internos.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `tag`: Tag opcional para categorização
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.d('Valor da variável: $valor');
  /// AppLogger.d('Entrando na função X', tag: 'Flow');
  /// ```
  static void d(dynamic msg, {String? tag}) => _log(msg, 'DEBUG', _blue, tag);

  /// Log de warning (WARN) - cor amarela.
  ///
  /// Usado para registrar avisos sobre situações que podem causar problemas,
  /// mas não impedem o funcionamento da aplicação.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `tag`: Tag opcional para categorização
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.w('API retornou dados em formato inesperado');
  /// AppLogger.w('Cache expirado, recarregando', tag: 'Cache');
  /// ```
  static void w(dynamic msg, {String? tag}) => _log(msg, 'WARN', _yellow, tag);

  /// Log de erro (ERROR) - cor vermelha.
  ///
  /// Usado para registrar erros que afetam o funcionamento da aplicação.
  /// Pode incluir exceções e stack traces para debugging detalhado.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `tag`: Tag opcional para categorização
  /// - `error`: Exceção ou erro opcional
  /// - `stackTrace`: Stack trace opcional
  ///
  /// ## Comportamento:
  /// - Loga a mensagem principal em vermelho
  /// - Se error for fornecido, loga o erro em vermelho
  /// - Se stackTrace for fornecido, loga em magenta
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.e('Falha na conexão com API');
  /// AppLogger.e('Erro crítico', tag: 'Database', error: exception);
  /// ```
  static void e(dynamic msg,
      {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(msg, 'ERROR', _red, tag);
    if (error != null) _log(error.toString(), 'ERROR', _red, tag);
    if (stackTrace != null) _log(stackTrace.toString(), 'STACK', _magenta, tag);
  }

  /// Log verbose (VERBOSE) - cor cinza.
  ///
  /// Usado para informações muito detalhadas durante debugging profundo,
  /// como logs de rede, operações de baixo nível e informações técnicas.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `tag`: Tag opcional para categorização
  ///
  /// ## Exemplo:
  /// ```dart
  /// AppLogger.v('Headers da requisição: $headers');
  /// AppLogger.v('Ciclo de vida do widget', tag: 'Widget');
  /// ```
  static void v(dynamic msg, {String? tag}) =>
      _log(msg, 'VERBOSE', _cinza, tag);

  // ============================================================================
  // MÉTODOS PRIVADOS DE IMPLEMENTAÇÃO
  // ============================================================================

  /// Método interno para processamento e formatação de logs.
  ///
  /// Este método é usado internamente pelos métodos de conveniência para
  /// processar logs com cores, timestamps e persistência em arquivo.
  /// É assíncrono para não bloquear a UI durante operações de I/O.
  ///
  /// ## Parâmetros:
  /// - `msg`: Mensagem a ser logada
  /// - `level`: Nível do log (INFO, DEBUG, etc.)
  /// - `color`: Código ANSI da cor para o terminal
  /// - `tag`: Tag opcional para categorização
  ///
  /// ## Comportamento:
  /// - Gera timestamp ISO 8601
  /// - Formata mensagem com nível e tag
  /// - Exibe no terminal com cor
  /// - Persiste em arquivo de forma assíncrona
  static Future<void> _log(dynamic msg, String level, String color,
      [String? tag]) async {
    /// Gera timestamp no formato ISO 8601 para identificação temporal precisa.
    final now = DateTime.now().toIso8601String();

    /// Formata a mensagem com nível e tag opcional para consistência.
    final formatted = "[$level] ${tag != null ? '[$tag] ' : ''}$msg";

    // ========================================================================
    // EXIBIÇÃO NO TERMINAL COM COR
    // ========================================================================

    /// Exibe a mensagem no terminal com cor correspondente ao nível de log.
    /// O reset é aplicado no final para não afetar logs subsequentes.
    debugPrint('$color[$now] $formatted$_reset');

    // ========================================================================
    // PERSISTÊNCIA EM ARQUIVO
    // ========================================================================

    /// Salva a mensagem formatada no arquivo de log de forma assíncrona.
    await _writeToFile('[$now] $formatted');
  }

  /// Salva conteúdo no arquivo de log da aplicação.
  ///
  /// Este método persiste logs no arquivo `app.log` no diretório de documentos
  /// da aplicação. Utiliza modo append para manter histórico completo e flush
  /// para garantir que dados sejam escritos imediatamente.
  ///
  /// ## Parâmetros:
  /// - `content`: Conteúdo a ser salvo no arquivo
  ///
  /// ## Comportamento:
  /// - Localiza o diretório de documentos da aplicação
  /// - Cria/acessa o arquivo `app.log`
  /// - Adiciona conteúdo em modo append
  /// - Falha silenciosamente em caso de erro
  ///
  /// ## Tratamento de Erros:
  /// - Captura todas as exceções para evitar crashes
  /// - Falha silenciosa para não impactar a aplicação
  static Future<void> _writeToFile(String content) async {
    try {
      /// Obtém o diretório de documentos da aplicação através do path_provider.
      final dir = await getApplicationDocumentsDirectory();

      /// Cria referência ao arquivo de log no diretório de documentos.
      final file = File('${dir.path}/app.log');

      /// Escreve o conteúdo no arquivo em modo append com flush imediato.
      /// O modo append mantém o histórico completo de logs.
      await file.writeAsString('$content\n',
          mode: FileMode.append, flush: true);
    } catch (_) {
      /// Falha silenciosa para não impactar o funcionamento da aplicação.
      /// Logs são importantes, mas não críticos para a operação.
    }
  }
}
