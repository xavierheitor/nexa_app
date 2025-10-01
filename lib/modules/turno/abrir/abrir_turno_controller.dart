import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Controlador da tela de abrir turno.
///
/// Gerencia o formulário e o processo de abertura de um novo turno,
/// validando dados e integrando com o TurnoController global.
class AbrirTurnoController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Controlador global de turno.
  final TurnoController _turnoController = Get.find<TurnoController>();

  // ============================================================================
  // CONTROLADORES DE FORMULÁRIO
  // ============================================================================

  /// Controlador do campo de prefixo.
  final prefixoController = TextEditingController();

  /// Controlador do campo de veículo.
  final veiculoController = TextEditingController();

  /// Controlador do campo de placa.
  final placaController = TextEditingController();

  /// Chave do formulário para validação.
  final formKey = GlobalKey<FormState>();

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se está salvando.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // VALIDAÇÕES
  // ============================================================================

  /// Valida campo de prefixo.
  String? validatePrefixo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Prefixo é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Prefixo deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  /// Valida campo de veículo.
  String? validateVeiculo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veículo é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Veículo deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  /// Valida campo de placa.
  String? validatePlaca(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Placa é obrigatória';
    }
    
    // Remove caracteres especiais para validação
    final placaLimpa = value.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    
    if (placaLimpa.length != 7) {
      return 'Placa deve ter 7 caracteres';
    }
    
    return null;
  }

  // ============================================================================
  // AÇÕES
  // ============================================================================

  /// Abre um novo turno.
  Future<void> abrirTurno() async {
    // Valida formulário
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      AppLogger.i('Abrindo novo turno...', tag: 'AbrirTurnoController');

      final sucesso = await _turnoController.abrirTurno(
        prefixo: prefixoController.text.trim(),
        veiculo: veiculoController.text.trim(),
        placa: placaController.text.trim().toUpperCase(),
      );

      if (sucesso) {
        AppLogger.i('Turno aberto com sucesso', tag: 'AbrirTurnoController');
        
        Get.back(); // Volta para home
        
        Get.snackbar(
          'Sucesso',
          'Turno aberto com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
        );
      } else {
        Get.snackbar(
          'Erro',
          'Erro ao abrir turno. Tente novamente.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao abrir turno',
          tag: 'AbrirTurnoController', error: e, stackTrace: stackTrace);
      
      Get.snackbar(
        'Erro',
        'Erro inesperado ao abrir turno.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.d('AbrirTurnoController inicializado',
        tag: 'AbrirTurnoController');
  }

  @override
  void onClose() {
    prefixoController.dispose();
    veiculoController.dispose();
    placaController.dispose();
    AppLogger.d('AbrirTurnoController finalizado',
        tag: 'AbrirTurnoController');
    super.onClose();
  }
}

