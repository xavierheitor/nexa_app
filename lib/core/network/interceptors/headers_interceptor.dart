import 'package:dio/dio.dart';
import 'package:nexa_app/core/utils/app_version.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Interceptor responsável por adicionar headers padrão em todas as requisições.
///
/// Este interceptor garante que todas as requisições incluam headers essenciais
/// para comunicação adequada com a API.
///
/// ## Headers Adicionados:
/// 1. **Content-Type**: application/json (padrão para APIs REST)
/// 2. **App-Version**: Versão completa do aplicativo (para analytics e compatibilidade)
/// 3. **Accept**: application/json (esperamos respostas em JSON)
///
/// ## Benefícios:
/// - Consistência em todas as requisições
/// - Facilita tracking de versões no backend
/// - Simplifica código dos repositories (não precisa definir headers sempre)
class HeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Define Content-Type padrão
    options.headers['Content-Type'] = 'application/json';

    // Define Accept padrão
    options.headers['Accept'] = 'application/json';

    // Adiciona versão do app
    options.headers['App-Version'] = AppVersion.fullVersion;

    AppLogger.d(
      '📱 Headers padrão adicionados (versão: ${AppVersion.fullVersion})',
      tag: 'HeadersInterceptor',
    );

    handler.next(options);
  }
}

