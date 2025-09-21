import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/app_version.dart';
import 'package:nexa_app/app.dart';

/// Ponto de entrada do aplicativo Flutter.
///
/// - Configura tratadores globais de erro (Flutter e PlatformDispatcher)
/// - Configura o logger do GetX para integrar ao `AppLogger`
/// - Garante inicialização dos bindings antes de `runApp`
void main() {
  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.e('[FlutterError]',
          tag: 'GlobalError',
          error: details.exception,
          stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.e('[PlatformError]',
          tag: 'GlobalError', error: error, stackTrace: stack);
      return true;
    };

    // Integra os logs do GetX ao nosso logger padronizado
    Get.config(
      enableLog: true,
      logWriterCallback: (text, {bool isError = false}) {
        if (isError) {
          AppLogger.e('[GETX] $text', tag: 'GetX');
        } else {
          AppLogger.d('[GETX] $text', tag: 'GetX');
        }
      },
    );

    // Garante que os bindings do Flutter estejam prontos (plugins, etc.)
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializa as informações de versão do app
    await AppVersion.initialize();
    AppLogger.i('📱 App inicializado - ${AppVersion.debugInfo}',
        tag: 'AppVersion');

    // Inicia o app principal (`GetMaterialApp` está em `SymplaApp`)
    runApp(const NexaApp());
  }, (error, stack) {
    AppLogger.e('[GlobalError]',
        tag: 'GlobalError', error: error, stackTrace: stack);
  });
}
