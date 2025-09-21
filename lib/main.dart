import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/app_version.dart';
import 'package:nexa_app/app.dart';

/// Ponto de entrada principal do aplicativo Flutter NexaApp.
///
/// Esta função é responsável por configurar e inicializar todos os componentes
/// essenciais antes da execução do aplicativo. Ela implementa uma estratégia
/// robusta de tratamento de erros e configuração de logging centralizado.
///
/// ## Funcionalidades Principais:
///
/// 1. **Tratamento Global de Erros**: Configura captura de erros tanto do Flutter
///    quanto do PlatformDispatcher para garantir que nenhum erro crítico passe
///    despercebido.
///
/// 2. **Sistema de Logging Integrado**: Unifica todos os logs do aplicativo através
///    do `AppLogger`, incluindo logs do GetX framework.
///
/// 3. **Inicialização Segura**: Garante que todos os bindings e dependências estejam
///    prontos antes da execução do aplicativo principal.
///
/// 4. **Informações de Versão**: Inicializa e registra informações detalhadas sobre
///    a versão do aplicativo para debugging e monitoramento.
///
/// ## Fluxo de Execução:
///
/// 1. Configuração de tratadores de erro globais
/// 2. Integração do sistema de logging do GetX
/// 3. Inicialização dos bindings do Flutter
/// 4. Carregamento das informações de versão
/// 5. Execução do aplicativo principal
///
/// ## Tratamento de Exceções:
///
/// Utiliza `runZonedGuarded` para capturar qualquer exceção não tratada durante
/// a inicialização, garantindo que o aplicativo não trave silenciosamente.
///
/// ## Dependências:
/// - `AppLogger`: Sistema centralizado de logging
/// - `AppVersion`: Gerenciamento de informações de versão
/// - `NexaApp`: Widget principal do aplicativo
void main() {
  // Zona isolada para captura de exceções durante a inicialização
  // Isso garante que qualquer erro crítico seja logado adequadamente
  runZonedGuarded(() async {
    // ============================================================================
    // CONFIGURAÇÃO DE TRATADORES DE ERRO GLOBAIS
    // ============================================================================

    /// Tratador de erros específicos do framework Flutter
    /// Captura exceções que ocorrem durante o ciclo de vida dos widgets
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.e('[FlutterError]',
          tag: 'GlobalError',
          error: details.exception,
          stackTrace: details.stack);
    };

    /// Tratador de erros da plataforma (iOS/Android/Web/Desktop)
    /// Captura exceções que ocorrem no nível do sistema operacional
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.e('[PlatformError]',
          tag: 'GlobalError', error: error, stackTrace: stack);
      return true; // Indica que o erro foi tratado
    };

    // ============================================================================
    // CONFIGURAÇÃO DO SISTEMA DE LOGGING
    // ============================================================================

    /// Integra os logs do GetX ao sistema de logging centralizado (AppLogger)
    /// Isso permite que todos os logs do framework sejam capturados e formatados
    /// de forma consistente com o resto da aplicação
    Get.config(
      enableLog: true, // Habilita logs do GetX (apenas em debug)
      logWriterCallback: (text, {bool isError = false}) {
        // Redireciona logs do GetX para o AppLogger
        if (isError) {
          AppLogger.e('[GETX] $text', tag: 'GetX');
        } else {
          AppLogger.d('[GETX] $text', tag: 'GetX');
        }
      },
    );

    // ============================================================================
    // INICIALIZAÇÃO DOS BINDINGS DO FLUTTER
    // ============================================================================

    /// Garante que todos os bindings necessários estejam inicializados
    /// Isso inclui plugins nativos, canais de comunicação e outros recursos
    /// que dependem da plataforma específica (iOS/Android/Web/Desktop)
    WidgetsFlutterBinding.ensureInitialized();

    // ============================================================================
    // INICIALIZAÇÃO DAS INFORMAÇÕES DE VERSÃO
    // ============================================================================

    /// Carrega e inicializa informações detalhadas sobre a versão do aplicativo
    /// Isso inclui versão do build, número da versão, informações da plataforma
    /// e outros metadados úteis para debugging e suporte técnico
    await AppVersion.initialize();

    /// Registra informações de inicialização para monitoramento e debugging
    AppLogger.i('📱 App inicializado - ${AppVersion.debugInfo}',
        tag: 'AppVersion');

    // ============================================================================
    // EXECUÇÃO DO APLICATIVO PRINCIPAL
    // ============================================================================

    /// Inicia o aplicativo principal após todas as configurações estarem prontas
    /// O NexaApp contém toda a estrutura do aplicativo, incluindo rotas,
    /// tema, configurações do GetX e outras dependências
    runApp(const NexaApp());
  }, (error, stack) {
    // ============================================================================
    // TRATADOR DE EXCEÇÕES GLOBAIS
    // ============================================================================

    /// Captura qualquer exceção não tratada durante todo o processo de inicialização
    /// Isso inclui erros de configuração, falhas na inicialização de plugins,
    /// problemas de rede durante o carregamento de recursos, etc.
    AppLogger.e('[GlobalError]',
        tag: 'GlobalError', error: error, stackTrace: stack);
  });
}
