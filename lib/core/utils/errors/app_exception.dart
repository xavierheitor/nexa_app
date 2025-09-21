import 'package:nexa_app/core/utils/errors/tipo_erro.dart';

/// Classe base para todas as exceções da aplicação NexaApp.
///
/// Esta classe abstrata define a estrutura comum para todas as exceções
/// customizadas da aplicação, fornecendo informações padronizadas sobre
/// o tipo de erro, mensagem descritiva e stack trace para debugging.
///
/// ## Funcionalidades Principais:
///
/// 1. **Hierarquia de Exceções**: Base para todas as exceções customizadas
/// 2. **Categorização**: Tipo de erro para tratamento específico
/// 3. **Mensagens Descritivas**: Informações claras sobre o problema
/// 4. **Stack Trace**: Informações de debugging para desenvolvedores
/// 5. **Sealed Class**: Garante que todas as subclasses sejam conhecidas
/// 6. **Type Safety**: Implementa Exception para compatibilidade
///
/// ## Arquitetura:
///
/// - **Sealed Class**: Impede herança fora do arquivo
/// - **Exception Interface**: Compatível com sistema de exceções do Dart
/// - **Immutable**: Campos finais para thread safety
/// - **Extensible**: Permite criação de tipos específicos de erro
///
/// ## Uso:
///
/// ```dart
/// // Não instanciar diretamente - usar subclasses específicas
/// throw ApiException('Falha na requisição', statusCode: 500);
/// throw AuthException('Credenciais inválidas');
/// throw NetworkException('Timeout de conexão', uri: Uri.parse('/api/users'));
/// ```
///
/// ## Dependências:
/// - `TipoErro`: Enum para categorização de erros
sealed class AppException implements Exception {
  // ============================================================================
  // PROPRIEDADES DA EXCEÇÃO
  // ============================================================================

  /// Mensagem descritiva do erro para logging e debugging.
  ///
  /// Esta mensagem deve ser clara e específica sobre o que ocorreu,
  /// facilitando a identificação e resolução do problema.
  final String mensagem;

  /// Tipo de erro para categorização e tratamento específico.
  ///
  /// Utiliza o enum `TipoErro` para classificar o erro e permitir
  /// tratamento diferenciado baseado na categoria.
  final TipoErro tipo;

  /// Stack trace opcional para debugging detalhado.
  ///
  /// Contém informações sobre a pilha de chamadas no momento do erro,
  /// essencial para debugging e identificação da origem do problema.
  final StackTrace? stack;

  /// Construtor da classe base para exceções da aplicação.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro
  /// - `tipo`: Categoria do erro (padrão: TipoErro.desconhecido)
  /// - `stack`: Stack trace opcional para debugging
  AppException(this.mensagem, {this.tipo = TipoErro.desconhecido, this.stack});
}

// ============================================================================
// EXCEÇÕES ESPECÍFICAS DA APLICAÇÃO
// ============================================================================

/// Exceção para erros relacionados a APIs externas.
///
/// Representa falhas em comunicações com serviços externos, incluindo
/// erros HTTP, problemas de serialização e falhas de conectividade.
///
/// ## Características:
/// - **Status Code**: Código HTTP da resposta de erro
/// - **Tipo Fixo**: Sempre categorizada como TipoErro.api
/// - **Debugging**: Inclui informações de status para troubleshooting
///
/// ## Casos de Uso:
/// - Requisições HTTP falhadas
/// - Erros de serialização de dados
/// - Timeouts de API
/// - Respostas de erro do servidor
///
/// ## Exemplo:
/// ```dart
/// throw ApiException('Falha na requisição de usuários', statusCode: 500);
/// ```
class ApiException extends AppException {
  /// Código de status HTTP da resposta de erro.
  ///
  /// Contém o status code retornado pela API, útil para identificar
  /// o tipo específico de erro (400, 401, 404, 500, etc.).
  final int? statusCode;

  /// Construtor para exceções de API.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro de API
  /// - `statusCode`: Código HTTP opcional
  /// - `stack`: Stack trace opcional para debugging
  ApiException(super.mensagem, {this.statusCode, super.stack})
      : super(tipo: TipoErro.api);
}

/// Exceção para erros de conectividade e comunicação de rede.
///
/// Representa falhas específicas de rede, incluindo timeouts, problemas
/// de conectividade e erros de comunicação com serviços externos.
///
/// ## Características:
/// - **URI**: URL que estava sendo acessada
/// - **Status Code**: Código HTTP se disponível
/// - **Response**: Dados da resposta de erro
/// - **ToString Customizado**: Formatação detalhada para debugging
///
/// ## Casos de Uso:
/// - Timeouts de conexão
/// - Falhas de conectividade
/// - Erros de DNS
/// - Problemas de SSL/TLS
///
/// ## Exemplo:
/// ```dart
/// throw NetworkException(
///   'Timeout de conexão',
///   uri: Uri.parse('https://api.example.com/users'),
///   statusCode: 408,
/// );
/// ```
class NetworkException extends AppException {
  /// URI que estava sendo acessada quando o erro ocorreu.
  ///
  /// Contém a URL completa da requisição que falhou, útil para
  /// identificar qual endpoint estava sendo acessado.
  final Uri? uri;

  /// Código de status HTTP se disponível.
  ///
  /// Pode ser null em casos de falhas de conectividade onde
  /// nenhuma resposta HTTP foi recebida.
  final int? statusCode;

  /// Dados da resposta de erro se disponíveis.
  ///
  /// Contém o corpo da resposta de erro para análise detalhada
  /// do problema específico.
  final dynamic response;

  /// Construtor para exceções de rede.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro de rede
  /// - `uri`: URI que estava sendo acessada
  /// - `statusCode`: Código HTTP opcional
  /// - `response`: Dados da resposta opcionais
  /// - `stack`: Stack trace opcional para debugging
  NetworkException(
    super.mensagem, {
    this.uri,
    this.statusCode,
    this.response,
    super.stack,
  }) : super(tipo: TipoErro.api);

  /// Retorna representação detalhada da exceção para debugging.
  ///
  /// Inclui mensagem, URI, status code e resposta para facilitar
  /// a identificação e resolução de problemas de rede.
  @override
  String toString() {
    return 'NetworkException: $mensagem\n→ URL: $uri\n→ Status: $statusCode\n→ Response: $response';
  }
}

/// Exceção para erros de autenticação e autorização.
///
/// Representa falhas relacionadas a credenciais inválidas, tokens
/// expirados e problemas de autorização de acesso.
///
/// ## Características:
/// - **Tipo Fixo**: Sempre categorizada como TipoErro.credenciais
/// - **Foco em Segurança**: Específica para problemas de autenticação
/// - **Logging Sensível**: Não inclui informações sensíveis
///
/// ## Casos de Uso:
/// - Credenciais inválidas
/// - Tokens expirados
/// - Falhas de autorização
/// - Sessões inválidas
///
/// ## Exemplo:
/// ```dart
/// throw AuthException('Token de acesso expirado');
/// ```
class AuthException extends AppException {
  /// Construtor para exceções de autenticação.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro de autenticação
  /// - `stack`: Stack trace opcional para debugging
  AuthException(super.mensagem, {super.stack})
      : super(tipo: TipoErro.credenciais);
}

/// Exceção para erros de banco de dados e armazenamento local.
///
/// Representa falhas relacionadas ao acesso e manipulação de dados
/// locais, incluindo problemas de SQLite, cache e armazenamento.
///
/// ## Características:
/// - **Tipo Fixo**: Sempre categorizada como TipoErro.banco
/// - **Dados Locais**: Específica para problemas de armazenamento local
/// - **Performance**: Relacionada a operações de I/O local
///
/// ## Casos de Uso:
/// - Falhas de SQLite
/// - Problemas de cache
/// - Erros de serialização local
/// - Falhas de armazenamento
///
/// ## Exemplo:
/// ```dart
/// throw LocalException('Falha ao salvar dados no banco local');
/// ```
class LocalException extends AppException {
  /// Construtor para exceções de banco de dados local.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro de banco de dados
  /// - `stack`: Stack trace opcional para debugging
  LocalException(super.mensagem, {super.stack}) : super(tipo: TipoErro.banco);
}

// ============================================================================
// EXCEÇÕES ESPECÍFICAS PARA VALIDAÇÃO DE DTOs
// ============================================================================

/// Exceção base para erros de validação de DTOs e dados.
///
/// Representa falhas na validação, conversão ou processamento de dados
/// transfer objects (DTOs), incluindo campos obrigatórios ausentes,
/// formatos inválidos e problemas de serialização.
///
/// ## Características:
/// - **Campo Específico**: Identifica qual campo causou o erro
/// - **Valor Problemático**: Contém o valor que causou a falha
/// - **Contexto Adicional**: Informações extras sobre o erro
/// - **ToString Detalhado**: Formatação específica para debugging
///
/// ## Casos de Uso:
/// - Validação de campos obrigatórios
/// - Conversão de tipos de dados
/// - Validação de formatos
/// - Problemas de serialização JSON
///
/// ## Exemplo:
/// ```dart
/// throw DtoError('Formato inválido', field: 'email', value: 'invalid-email');
/// ```
class DtoError extends AppException {
  /// Nome do campo que causou o erro de validação.
  ///
  /// Identifica especificamente qual propriedade do DTO
  /// está relacionada ao problema, facilitando debugging.
  final String? field;

  /// Valor que causou o erro de validação.
  ///
  /// Contém o valor problemático que não passou na validação,
  /// útil para análise e correção do problema.
  final dynamic value;

  /// Contexto adicional sobre o erro.
  ///
  /// Pode conter informações extras como nome da operação,
  /// etapa do processamento ou outros detalhes relevantes.
  final String? context;

  /// Construtor para erros de validação de DTO.
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do erro de validação
  /// - `field`: Nome do campo problemático
  /// - `value`: Valor que causou o erro
  /// - `context`: Contexto adicional opcional
  DtoError(super.mensagem, {this.field, this.value, this.context})
      : super(tipo: TipoErro.validacao);

  /// Retorna representação detalhada do erro para debugging.
  ///
  /// Inclui mensagem, campo, valor e contexto para facilitar
  /// a identificação e correção de problemas de validação.
  @override
  String toString() {
    final buffer = StringBuffer('DtoError: $mensagem');

    if (field != null) {
      buffer.write(' (campo: $field');
      if (value != null) {
        buffer.write(', valor: $value');
      }
      buffer.write(')');
    }

    if (context != null) {
      buffer.write(' [contexto: $context]');
    }

    return buffer.toString();
  }
}

/// Exceção para campos obrigatórios não informados.
///
/// Representa falhas quando campos obrigatórios não são fornecidos
/// ou são nulos/vazios durante a validação de DTOs.
///
/// ## Características:
/// - **Mensagem Padrão**: "Campo obrigatório não informado"
/// - **Tipo Específico**: Herda de DtoError para validação
/// - **Foco em Obrigatoriedade**: Específica para campos required
///
/// ## Casos de Uso:
/// - Campos required ausentes em formulários
/// - Propriedades obrigatórias não fornecidas
/// - Validação de dados de entrada
///
/// ## Exemplo:
/// ```dart
/// throw RequiredFieldError('email');
/// throw RequiredFieldError('password', null);
/// ```
class RequiredFieldError extends DtoError {
  /// Construtor para erros de campo obrigatório.
  ///
  /// ## Parâmetros:
  /// - `field`: Nome do campo obrigatório
  /// - `value`: Valor fornecido (pode ser null/vazio)
  RequiredFieldError(String field, [dynamic value])
      : super('Campo obrigatório não informado', field: field, value: value);
}

/// Exceção para formatos de data inválidos.
///
/// Representa falhas quando valores de data não estão no formato
/// esperado ou são inválidos durante a conversão ou validação.
///
/// ## Características:
/// - **Mensagem Padrão**: "Formato de data inválido"
/// - **Foco em Datas**: Específica para problemas de data
/// - **Valor Problemático**: Inclui o valor que falhou na conversão
///
/// ## Casos de Uso:
/// - Conversão de strings para DateTime
/// - Validação de formatos de data
/// - Parsing de datas de API
///
/// ## Exemplo:
/// ```dart
/// throw InvalidDateFormatError('birthDate', '32/13/2023');
/// ```
class InvalidDateFormatError extends DtoError {
  /// Construtor para erros de formato de data.
  ///
  /// ## Parâmetros:
  /// - `field`: Nome do campo de data
  /// - `value`: Valor inválido fornecido
  InvalidDateFormatError(String field, dynamic value)
      : super('Formato de data inválido', field: field, value: value);
}

/// Exceção para erros de conversão de tipos.
///
/// Representa falhas quando valores não podem ser convertidos
/// para o tipo esperado durante o processamento de dados.
///
/// ## Características:
/// - **Tipo Esperado**: Informa qual tipo era esperado
/// - **Conversão Falhada**: Específica para problemas de cast
/// - **Debugging Detalhado**: Inclui informações sobre o tipo esperado
///
/// ## Casos de Uso:
/// - Conversão de String para int/double
/// - Cast de tipos dinâmicos
/// - Parsing de valores numéricos
///
/// ## Exemplo:
/// ```dart
/// throw TypeConversionError('age', 'not-a-number', 'int');
/// ```
class TypeConversionError extends DtoError {
  /// Construtor para erros de conversão de tipo.
  ///
  /// ## Parâmetros:
  /// - `field`: Nome do campo problemático
  /// - `value`: Valor que falhou na conversão
  /// - `expectedType`: Tipo esperado para a conversão
  TypeConversionError(String field, dynamic value, String expectedType)
      : super('Erro na conversão de tipo: esperado $expectedType',
            field: field, value: value);
}

/// Exceção para JSON malformado ou inválido.
///
/// Representa falhas quando dados JSON não estão no formato
/// esperado, são malformados ou contêm estruturas inválidas.
///
/// ## Características:
/// - **Mensagem Customizada**: Inclui detalhes sobre o problema JSON
/// - **Contexto Opcional**: Pode incluir contexto da operação
/// - **Foco em JSON**: Específica para problemas de serialização
///
/// ## Casos de Uso:
/// - Parsing de JSON inválido
/// - Estruturas JSON malformadas
/// - Campos JSON ausentes
/// - Tipos incorretos em JSON
///
/// ## Exemplo:
/// ```dart
/// throw InvalidJsonError('Campo "id" é obrigatório', 'User.fromJson');
/// ```
class InvalidJsonError extends DtoError {
  /// Construtor para erros de JSON inválido.
  ///
  /// ## Parâmetros:
  /// - `message`: Mensagem detalhada sobre o problema JSON
  /// - `context`: Contexto opcional da operação
  InvalidJsonError(String message, [String? context])
      : super('JSON inválido: $message', context: context);
}
