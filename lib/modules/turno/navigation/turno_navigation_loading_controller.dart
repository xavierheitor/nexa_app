import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_orchestrator.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_state.dart';

/// Controller da tela de loading de navegação do turno.
///
/// Orquestra a verificação de estado e navegação automática.
class TurnoNavigationLoadingController extends GetxController {
  final TurnoNavigationOrchestrator _orchestrator;

  TurnoNavigationLoadingController({
    required TurnoNavigationOrchestrator orchestrator,
  }) : _orchestrator = orchestrator;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Mensagem de status atual.
  final RxString statusMessage = 'Verificando turno...'.obs;

  /// Indica se houve erro.
  final RxBool hasError = false.obs;

  /// Mensagem de erro (se houver).
  final RxString errorMessage = ''.obs;

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _determinarENavegar();
  }

  // ============================================================================
  // MÉTODOS PRINCIPAIS
  // ============================================================================

  /// Determina a próxima rota e navega automaticamente.
  Future<void> _determinarENavegar() async {
    try {
      hasError.value = false;
      statusMessage.value = 'Verificando turno...';

      AppLogger.d('🧭 [NAV LOADING] Iniciando determinação de rota',
          tag: 'TurnoNavigationLoadingController');

      // Aguarda um mínimo de tempo para evitar flash de tela
      await Future.wait([
        _orchestrator.determinarProximaRota(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]).then((results) {
        final result = results[0] as TurnoNavigationResult;
        return result;
      }).then((result) async {
        AppLogger.d('🧭 [NAV LOADING] Resultado: ${result.toString()}',
            tag: 'TurnoNavigationLoadingController');

        // Verificar se houve erro
        if (result.state == TurnoNavigationState.erro) {
          _mostrarErro(result.message);
          return;
        }

        // Mostrar snackbar se necessário
        if (result.showSnackbar) {
          Get.snackbar(
            'Atenção',
            result.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        // Navegar para a rota correta
        if (result.route != null) {
          statusMessage.value = 'Navegando...';
          await Future.delayed(const Duration(milliseconds: 300));

          AppLogger.d('🧭 [NAV LOADING] Navegando para: ${result.route}',
              tag: 'TurnoNavigationLoadingController');

          // Remove a tela de loading e navega
          Get.offNamed(result.route!, arguments: result.arguments);
        } else {
          // Sem rota definida - voltar
          AppLogger.w('⚠️ [NAV LOADING] Nenhuma rota definida, voltando',
              tag: 'TurnoNavigationLoadingController');
          Get.back();
        }
      });
    } catch (e, stackTrace) {
      AppLogger.e('❌ [NAV LOADING] Erro ao determinar rota',
          tag: 'TurnoNavigationLoadingController',
          error: e,
          stackTrace: stackTrace);
      _mostrarErro('Erro inesperado: ${e.toString()}');
    }
  }

  /// Mostra erro na tela.
  void _mostrarErro(String mensagem) {
    hasError.value = true;
    errorMessage.value = mensagem;
  }

  /// Tenta novamente após erro.
  Future<void> retry() async {
    hasError.value = false;
    errorMessage.value = '';
    await _determinarENavegar();
  }

  // ============================================================================
  // LIMPEZA
  // ============================================================================

  @override
  void onClose() {
    statusMessage.value = '';
    errorMessage.value = '';
    hasError.value = false;

    AppLogger.d(
        'TurnoNavigationLoadingController finalizado e recursos liberados',
        tag: 'TurnoNavigationLoadingController');

    super.onClose();
  }
}

