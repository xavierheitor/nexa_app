import 'package:package_info_plus/package_info_plus.dart';

/// Utilitário centralizado para gerenciamento de informações de versão da aplicação.
///
/// Esta classe fornece acesso unificado às informações de versão, build e metadados
/// do aplicativo, obtidas através do `package_info_plus`. Ela centraliza toda a
/// lógica relacionada à versão, facilitando o acesso e manutenção dessas informações
/// em toda a aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Inicialização de Metadados**: Carrega informações do package da plataforma
/// 2. **Acesso a Versões**: Fornece versão, build number e versão completa
/// 3. **Informações do App**: Disponibiliza nome e identificadores do aplicativo
/// 4. **Debug e Logging**: Fornece informações completas para debugging
/// 5. **Fallback Seguro**: Valores padrão para casos de falha na inicialização
///
/// ## Arquitetura:
///
/// - **Singleton Pattern**: Classe estática para acesso global
/// - **Lazy Loading**: Informações carregadas apenas quando necessário
/// - **Null Safety**: Tratamento seguro de valores nulos com fallbacks
/// - **Platform Agnostic**: Funciona em todas as plataformas suportadas
///
/// ## Fluxo de Inicialização:
///
/// 1. Chamada de `initialize()` no `main()` da aplicação
/// 2. Carregamento das informações do package via `PackageInfo.fromPlatform()`
/// 3. Armazenamento das informações em `_packageInfo`
/// 4. Disponibilização das informações através de getters estáticos
///
/// ## Uso:
///
/// ```dart
/// // Inicialização (no main.dart)
/// await AppVersion.initialize();
///
/// // Acesso às informações
/// String version = AppVersion.version;
/// String build = AppVersion.buildNumber;
/// Map<String, String> info = AppVersion.debugInfo;
/// ```
///
/// ## Casos de Uso:
///
/// - **Logging**: Identificação de versão em logs de erro
/// - **Debugging**: Informações de build para suporte técnico
/// - **Analytics**: Tracking de versões para análise de uso
/// - **Suporte**: Identificação de versão para atendimento ao cliente
/// - **CI/CD**: Validação de builds em pipelines de deploy
///
/// ## Dependências:
/// - `package_info_plus`: Plugin para obtenção de informações do package
class AppVersion {
  
  // ============================================================================
  // ARMAZENAMENTO DE INFORMAÇÕES DO PACKAGE
  // ============================================================================

  /// Instância privada do PackageInfo contendo todas as informações do aplicativo.
  ///
  /// Esta variável armazena as informações obtidas da plataforma após a inicialização.
  /// É inicializada como `null` e preenchida durante o processo de inicialização.
  /// O uso de `?` garante que os getters funcionem mesmo se a inicialização falhar.
  static PackageInfo? _packageInfo;

  // ============================================================================
  // INICIALIZAÇÃO E CONFIGURAÇÃO
  // ============================================================================

  /// Inicializa as informações do package obtidas da plataforma.
  ///
  /// Este método deve ser chamado obrigatoriamente no `main()` da aplicação,
  /// antes de qualquer tentativa de acesso às informações de versão. Ele
  /// carrega todas as informações disponíveis do package da plataforma atual.
  ///
  /// ## Importante:
  /// - Deve ser chamado no `main()` antes de `runApp()`
  /// - É uma operação assíncrona que pode falhar
  /// - Em caso de falha, os getters retornam valores padrão seguros
  ///
  /// ## Throws:
  /// - Pode lançar exceções se houver problemas na obtenção das informações
  static Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  // ============================================================================
  // ACESSO ÀS INFORMAÇÕES DE VERSÃO
  // ============================================================================

  /// Retorna a versão semântica do aplicativo.
  ///
  /// A versão segue o padrão semântico (ex: "1.2.3") e é obtida diretamente
  /// do arquivo de configuração da plataforma (pubspec.yaml, build.gradle, etc.).
  ///
  /// ## Formato:
  /// - Versão semântica: "MAJOR.MINOR.PATCH"
  /// - Exemplo: "1.0.0", "2.1.3", "0.9.5"
  ///
  /// ## Fallback:
  /// - Retorna "0.0.0" se não inicializado ou em caso de erro
  static String get version {
    return _packageInfo?.version ?? '0.0.0';
  }

  /// Retorna o número de build do aplicativo.
  ///
  /// O build number é um identificador único para cada build específico,
  /// usado principalmente para distinguir diferentes compilações da mesma versão.
  /// É especialmente útil para tracking de builds em CI/CD e debugging.
  ///
  /// ## Formato:
  /// - Número inteiro como string: "1", "42", "100"
  /// - Incrementa a cada build, mesmo com mesma versão
  ///
  /// ## Fallback:
  /// - Retorna "0" se não inicializado ou em caso de erro
  static String get buildNumber {
    return _packageInfo?.buildNumber ?? '0';
  }

  /// Retorna a versão completa combinando versão e build number.
  ///
  /// Esta propriedade combina a versão semântica com o número de build,
  /// fornecendo uma identificação única e completa da versão do aplicativo.
  /// É útil para logging, analytics e identificação precisa de builds.
  ///
  /// ## Formato:
  /// - Combinação: "VERSÃO+BUILD"
  /// - Exemplo: "1.2.3+42", "0.9.5+1"
  ///
  /// ## Uso:
  /// - Identificação única de builds
  /// - Logging de versões específicas
  /// - Suporte técnico e debugging
  static String get fullVersion {
    return '$version+$buildNumber';
  }

  // ============================================================================
  // INFORMAÇÕES DO APLICATIVO
  // ============================================================================

  /// Retorna o nome do aplicativo conforme configurado na plataforma.
  ///
  /// O nome do app é obtido das configurações específicas de cada plataforma
  /// e pode diferir entre Android, iOS, Web, etc. É usado para exibição
  /// em interfaces e identificação do aplicativo.
  ///
  /// ## Fonte:
  /// - Android: android/app/src/main/AndroidManifest.xml
  /// - iOS: ios/Runner/Info.plist
  /// - Web: web/index.html
  ///
  /// ## Fallback:
  /// - Retorna "Nexa App" se não inicializado ou em caso de erro
  static String get appName {
    return _packageInfo?.appName ?? 'Nexa App';
  }

  // ============================================================================
  // INFORMAÇÕES PARA DEBUG E LOGGING
  // ============================================================================

  /// Retorna um mapa com todas as informações disponíveis para debugging.
  ///
  /// Esta propriedade fornece acesso centralizado a todas as informações
  /// de versão e metadados do aplicativo em um formato estruturado.
  /// É especialmente útil para logging, debugging e suporte técnico.
  ///
  /// ## Conteúdo:
  /// - `appName`: Nome do aplicativo
  /// - `version`: Versão semântica
  /// - `buildNumber`: Número do build
  /// - `fullVersion`: Versão completa (versão+build)
  /// - `packageName`: Identificador único do package
  ///
  /// ## Uso:
  /// - Logging de informações completas
  /// - Debugging de problemas específicos de versão
  /// - Suporte técnico com informações detalhadas
  /// - Analytics e tracking de versões
  ///
  /// ## Exemplo de Saída:
  /// ```dart
  /// {
  ///   'appName': 'Nexa App',
  ///   'version': '1.0.0',
  ///   'buildNumber': '42',
  ///   'fullVersion': '1.0.0+42',
  ///   'packageName': 'com.nexa.app'
  /// }
  /// ```
  static Map<String, String> get debugInfo {
    return {
      'appName': appName,
      'version': version,
      'buildNumber': buildNumber,
      'fullVersion': fullVersion,
      'packageName': _packageInfo?.packageName ?? 'unknown',
    };
  }
}
