// lib/app.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/bindings/initial_binding.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/app_pages.dart';

/// The main entry point for the application.
///

class NexaApp extends StatelessWidget {
  const NexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nexa',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      navigatorObservers: [
        GetObserver(
          (route) {
            if (route?.current is Error) {
              AppLogger.e('[NavigatorObserver] ${route?.current}',
                  tag: 'SymplaApp');
            }
          },
        ),
      ],
    );
  }
}
