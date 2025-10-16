import 'package:get/get.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controller para a tela de abertura de turno.
class AbrindoTurnoController extends GetxController {
  final TurnoRepo _turnoRepo = Get.find<TurnoRepo>();

  final RxString statusMensagem = 'Preparando dados...'.obs;
  final RxnString erro = RxnString();

  @override
  void onInit() {
    super.onInit();
    _iniciarAberturaTurno();
  }

  Future<void> _iniciarAberturaTurno() async {
    try {
      AppLogger.d('🚀 [ABERTURA TURNO] Iniciando processo de abertura remota',
          tag: 'AbrindoTurnoController');

      // 1. Preparar dados
      statusMensagem.value = 'Preparando dados do turno...';
      await Future.delayed(const Duration(milliseconds: 500));

      // 2. Validar com API
      statusMensagem.value = 'Validando com servidor...';
      await Future.delayed(const Duration(milliseconds: 500));

      final sucesso = await _turnoRepo.abrirTurnoRemoto();

      if (!sucesso) {
        throw Exception('Falha ao abrir turno remotamente');
      }

      // 3. Sucesso
      statusMensagem.value = 'Turno aberto com sucesso!';
      AppLogger.i('✅ [ABERTURA TURNO] Turno aberto remotamente com sucesso',
          tag: 'AbrindoTurnoController');

      await Future.delayed(const Duration(milliseconds: 800));

      // 4. Redirecionar para home
      Get.offAllNamed(Routes.home);

      Get.snackbar(
        'Turno aberto',
        'Turno aberto com sucesso! Bom trabalho!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ABERTURA TURNO] Erro ao abrir turno remotamente',
          tag: 'AbrindoTurnoController', error: e, stackTrace: stackTrace);

      erro.value = 'Não foi possível abrir o turno.\n${e.toString()}';
      statusMensagem.value = 'Erro ao abrir turno';

      // Aguardar 3 segundos e voltar automaticamente
      await Future.delayed(const Duration(seconds: 3));
      voltar();
    }
  }

  void voltar() {
    Get.offAllNamed(Routes.home);
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - Estados reativos (statusMensagem, erro)
  @override
  void onClose() {
    /// Limpa estados reativos.
    statusMensagem.value = '';
    erro.value = null;

    /// Registra finalização do controlador.
    AppLogger.d('AbrindoTurnoController finalizado e recursos liberados',
        tag: 'AbrindoTurnoController');

    super.onClose();
  }
}
