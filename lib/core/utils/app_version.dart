import 'package:package_info_plus/package_info_plus.dart';

/// Utilitário para obter informações de versão do aplicativo
class AppVersion {
  static PackageInfo? _packageInfo;

  /// Inicializa as informações do package (deve ser chamado no main())
  static Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// Retorna a versão do app (ex: "0.1.0")
  static String get version {
    return _packageInfo?.version ?? '0.0.0';
  }

  /// Retorna o build number (ex: "1")
  static String get buildNumber {
    return _packageInfo?.buildNumber ?? '0';
  }

  /// Retorna a versão completa (versão + build)
  static String get fullVersion {
    return '$version+$buildNumber';
  }

  /// Retorna o nome do app
  static String get appName {
    return _packageInfo?.appName ?? 'Sympla App';
  }

  /// Retorna informações completas para debug
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
