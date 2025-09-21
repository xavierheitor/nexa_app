import 'package:dio/dio.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';
import 'package:nexa_app/core/utils/errors/mensagem_erro.dart';
import 'package:nexa_app/core/utils/errors/tipo_erro.dart';

/// Sistema centralizado de tratamento e conversão de erros da aplicação.
///
/// Esta classe fornece funcionalidades para converter erros de baixo nível
/// (como DioException) em exceções padronizadas da camada de domínio
/// (`AppException`) e gerar mensagens amigáveis para o usuário através
/// do sistema `MensagemErro`.
///
/// ## Funcionalidades Principais:
///
/// 1. **Conversão de Erros**: Transforma erros técnicos em exceções padronizadas
/// 2. **Categorização**: Classifica erros por tipo para tratamento específico
/// 3. **Mensagens Amigáveis**: Gera mensagens compreensíveis para usuários
/// 4. **Tratamento de Rede**: Especializado em erros de comunicação
/// 5. **Fallback Seguro**: Tratamento para erros não mapeados
/// 6. **Debugging**: Preserva stack traces para análise técnica
///
/// ## Arquitetura:
///
/// - **Static Methods**: Acesso global sem necessidade de instanciação
/// - **Error Mapping**: Mapeamento de erros específicos para tipos padronizados
/// - **User Experience**: Foco em mensagens amigáveis para usuários
/// - **Developer Experience**: Preservação de informações técnicas para debugging
///
/// ## Fluxo de Tratamento:
///
/// 1. Recebe erro de baixo nível (DioException, etc.)
/// 2. Identifica o tipo específico de erro
/// 3. Converte para AppException correspondente
/// 4. Gera mensagem amigável para o usuário
/// 5. Preserva informações técnicas para debugging
///
/// ## Uso:
///
/// ```dart
/// try {
///   await apiService.getData();
/// } catch (error, stackTrace) {
///   final appException = ErrorHandler.tratar(error, stackTrace);
///   final userMessage = ErrorHandler.mensagemUsuario(appException);
///   // Exibir userMessage para o usuário
/// }
/// ```
///
/// ## Dependências:
/// - `DioException`: Erros de rede do framework Dio
/// - `AppException`: Sistema de exceções da aplicação
/// - `MensagemErro`: Mensagens amigáveis para usuários
/// - `TipoErro`: Categorização de tipos de erro
class ErrorHandler {
  // ============================================================================
  // CONVERSÃO DE ERROS TÉCNICOS PARA EXCEÇÕES PADRONIZADAS
  // ============================================================================

  /// Converte erros de baixo nível em exceções padronizadas da aplicação.
  ///
  /// Este método analisa o tipo de erro recebido e o converte para uma
  /// `AppException` apropriada, preservando informações relevantes como
  /// stack trace, status codes e dados de resposta para debugging.
  ///
  /// ## Parâmetros:
  /// - `error`: Erro original a ser convertido (DioException, Exception, etc.)
  /// - `stack`: Stack trace opcional para debugging
  ///
  /// ## Retorno:
  /// - `AppException`: Exceção padronizada da aplicação
  ///
  /// ## Tipos de Erro Suportados:
  /// - **AppException**: Retorna o erro original se já for padronizado
  /// - **DioException**: Converte para ApiException ou NetworkException
  /// - **Outros**: Converte para LocalException como fallback
  ///
  /// ## Exemplo:
  /// ```dart
  /// final exception = ErrorHandler.tratar(dioError, stackTrace);
  /// ```
  static AppException tratar(dynamic error, [StackTrace? stack]) {
    /// Se o erro já é uma AppException, retorna diretamente.
    /// Isso evita reconversões desnecessárias e preserva o tipo original.
    if (error is AppException) return error;

    /// Trata erros específicos do framework Dio para comunicação HTTP.
    if (error is DioException) {
      /// Verifica se é um erro de conectividade (timeout, conexão perdida, etc.).
      /// Estes erros são tratados como NetworkException com informações de rede.
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.unknown) {
        return NetworkException(
          _mensagemParaCodigo(error.response?.statusCode),
          uri: error.requestOptions.uri,
          statusCode: error.response?.statusCode,
          response: error.response?.data,
          stack: stack,
        );
      }

      /// Para outros erros Dio, extrai informações da resposta HTTP.
      /// Cria ApiException com status code e mensagem do servidor.
      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['message'] ?? 'Erro desconhecido';

      return ApiException(message, statusCode: statusCode, stack: stack);
    }

    /// Fallback para erros não mapeados - converte para LocalException.
    /// Garante que sempre retornamos uma AppException padronizada.
    return LocalException('Erro inesperado', stack: stack);
  }

  // ============================================================================
  // GERAÇÃO DE MENSAGENS AMIGÁVEIS PARA USUÁRIOS
  // ============================================================================

  /// Gera mensagens amigáveis e compreensíveis para exibição ao usuário.
  ///
  /// Este método converte exceções técnicas em mensagens de erro que podem
  /// ser exibidas diretamente ao usuário, fornecendo informações úteis sem
  /// expor detalhes técnicos ou stack traces que possam confundir.
  ///
  /// ## Parâmetros:
  /// - `error`: Erro a ser convertido em mensagem amigável
  ///
  /// ## Retorno:
  /// - `MensagemErro`: Objeto contendo título e descrição amigáveis
  ///
  /// ## Tipos de Erro Mapeados:
  /// - **API**: Erros de conexão com servidores externos
  /// - **Dados**: Problemas de processamento de informações
  /// - **Credenciais**: Erros de autenticação e autorização
  /// - **Validação**: Problemas de validação de dados de entrada
  /// - **Banco**: Falhas de acesso a dados locais
  /// - **Desconhecido**: Fallback para erros não mapeados
  ///
  /// ## Exemplo:
  /// ```dart
  /// final userMessage = ErrorHandler.mensagemUsuario(appException);
  /// showDialog(
  ///   title: userMessage.titulo,
  ///   content: userMessage.descricao,
  /// );
  /// ```
  static MensagemErro mensagemUsuario(Object error) {
    /// Verifica se o erro é uma AppException para tratamento específico.
    if (error is AppException) {
      /// Mapeia cada tipo de erro para uma mensagem amigável específica.
      /// Cada caso fornece título e descrição apropriados para o usuário.
      switch (error.tipo) {
        /// Erros de API e comunicação com servidores externos.
        /// Foca em problemas de conectividade e disponibilidade.
        case TipoErro.api:
          return MensagemErro(
            titulo: 'Erro de conexão',
            descricao:
                'Não foi possível acessar os servidores. Tente novamente mais tarde.',
          );

        /// Problemas de processamento e manipulação de dados.
        /// Relacionado a parsing, serialização e transformação de dados.
        case TipoErro.dados:
          return MensagemErro(
            titulo: 'Erro nos dados',
            descricao: 'Ocorreu um problema ao processar as informações.',
          );

        /// Erros de autenticação e credenciais inválidas.
        /// Específico para problemas de login e autorização.
        case TipoErro.credenciais:
          return MensagemErro(
            titulo: 'Credenciais inválidas',
            descricao: 'Matricula ou senha incorretos.',
          );

        /// Erros de validação de dados de entrada.
        /// Utiliza método específico para mensagens detalhadas de validação.
        case TipoErro.validacao:
          return MensagemErro(
            titulo: 'Erro de validação',
            descricao: _getValidationMessage(error),
          );

        /// Problemas de acesso a banco de dados local.
        /// Relacionado a SQLite, cache e armazenamento local.
        case TipoErro.banco:
          return MensagemErro(
            titulo: 'Erro no banco de dados',
            descricao: 'Ocorreu um problema ao acessar os dados locais.',
          );

        /// Fallback para erros não mapeados ou desconhecidos.
        /// Mensagem genérica para casos não previstos.
        default:
          return MensagemErro(
            titulo: 'Erro inesperado',
            descricao: 'Algo deu errado. Tente novamente.',
          );
      }
    }

    /// Fallback para erros que não são AppException.
    /// Garante que sempre retornamos uma mensagem amigável.
    return MensagemErro(
      titulo: 'Erro desconhecido',
      descricao: 'Ocorreu um erro inesperado.',
    );
  }

  // ============================================================================
  // MÉTODOS PRIVADOS DE UTILIDADE
  // ============================================================================

  /// Gera mensagens amigáveis específicas para erros de validação de DTOs.
  ///
  /// Este método privado analisa o tipo específico de erro de validação
  /// e retorna uma mensagem amigável personalizada baseada no tipo de
  /// problema encontrado (campo obrigatório, formato inválido, etc.).
  ///
  /// ## Parâmetros:
  /// - `error`: AppException de validação a ser analisada
  ///
  /// ## Retorno:
  /// - `String`: Mensagem amigável específica para o tipo de erro
  ///
  /// ## Tipos de Erro de Validação:
  /// - **RequiredFieldError**: Campos obrigatórios ausentes
  /// - **InvalidDateFormatError**: Formatos de data inválidos
  /// - **TypeConversionError**: Problemas de conversão de tipo
  /// - **InvalidJsonError**: JSON malformado
  /// - **DtoError**: Erros genéricos de DTO
  ///
  /// ## Exemplo:
  /// ```dart
  /// final message = _getValidationMessage(requiredFieldError);
  /// // Retorna: 'O campo "email" é obrigatório.'
  /// ```
  static String _getValidationMessage(AppException error) {
    /// Erro de campo obrigatório não informado.
    /// Retorna mensagem específica com nome do campo.
    if (error is RequiredFieldError) {
      return 'O campo "${error.field}" é obrigatório.';
    }

    /// Erro de formato de data inválido.
    /// Retorna mensagem específica com nome do campo de data.
    if (error is InvalidDateFormatError) {
      return 'O campo "${error.field}" possui um formato de data inválido.';
    }

    /// Erro de conversão de tipo.
    /// Retorna mensagem genérica sobre formato inválido.
    if (error is TypeConversionError) {
      return 'O campo "${error.field}" possui um formato inválido.';
    }

    /// Erro de JSON malformado.
    /// Retorna mensagem genérica sobre formato de dados.
    if (error is InvalidJsonError) {
      return 'Dados recebidos em formato inválido.';
    }

    /// Erro genérico de DTO.
    /// Retorna a mensagem original do erro.
    if (error is DtoError) {
      return error.mensagem;
    }

    /// Fallback para outros erros de validação.
    /// Retorna mensagem genérica de validação.
    return 'Erro de validação nos dados.';
  }

  /// Converte códigos de status HTTP em mensagens descritivas.
  ///
  /// Este método privado mapeia códigos de status HTTP específicos
  /// para mensagens descritivas em português, facilitando a
  /// identificação de problemas de comunicação.
  ///
  /// ## Parâmetros:
  /// - `statusCode`: Código de status HTTP (400, 401, 404, 500, etc.)
  ///
  /// ## Retorno:
  /// - `String`: Mensagem descritiva do erro HTTP
  ///
  /// ## Códigos Mapeados:
  /// - **400**: Requisição inválida
  /// - **401**: Não autorizado
  /// - **404**: Recurso não encontrado
  /// - **500**: Erro interno no servidor
  /// - **Outros**: Erro de conexão (fallback)
  ///
  /// ## Exemplo:
  /// ```dart
  /// final message = _mensagemParaCodigo(404);
  /// // Retorna: 'Recurso não encontrado'
  /// ```
  static String _mensagemParaCodigo(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autorizado';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro interno no servidor';
      default:
        return 'Erro de conexão';
    }
  }
}
