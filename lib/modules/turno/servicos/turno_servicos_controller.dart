import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Controlador da tela de serviços do turno.
///
/// Gerencia a lista de serviços executados e adição de novos serviços.
class TurnoServicosController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Controlador global de turno.
  final TurnoController turnoController = Get.find<TurnoController>();

  // ============================================================================
  // CONTROLADORES DE FORMULÁRIO
  // ============================================================================

  /// Controlador do campo de descrição.
  final descricaoController = TextEditingController();

  /// Chave do formulário para validação.
  final formKey = GlobalKey<FormState>();

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Tipo de serviço selecionado.
  final Rx<TipoServico> tipoSelecionado = TipoServico.coleta.obs;

  /// Flag indicando se está salvando.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // VALIDAÇÕES
  // ============================================================================

  /// Valida campo de descrição.
  String? validateDescricao(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }
    if (value.trim().length < 5) {
      return 'Descrição deve ter pelo menos 5 caracteres';
    }
    return null;
  }

  // ============================================================================
  // AÇÕES
  // ============================================================================

  /// Mostra dialog para adicionar novo serviço.
  void mostrarDialogAdicionarServico() {
    // Limpa campos
    descricaoController.clear();
    tipoSelecionado.value = TipoServico.coleta;

    Get.dialog(
      AlertDialog(
        title: const Text('Adicionar Serviço'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Campo de descrição.
                TextFormField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Coleta de lixo - Rua Principal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateDescricao,
                ),

                const SizedBox(height: 16),

                /// Dropdown de tipo.
                Obx(() => DropdownButtonFormField<TipoServico>(
                      value: tipoSelecionado.value,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Serviço',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: TipoServico.values.map((tipo) {
                        return DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo.nome),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          tipoSelecionado.value = valor;
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: adicionarServico,
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  /// Adiciona um novo serviço.
  Future<void> adicionarServico() async {
    // Valida formulário
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      AppLogger.i('Adicionando serviço...', tag: 'TurnoServicosController');

      final sucesso = await turnoController.adicionarServico(
        descricao: descricaoController.text.trim(),
        tipo: tipoSelecionado.value,
      );

      if (sucesso) {
        AppLogger.i('Serviço adicionado', tag: 'TurnoServicosController');
        
        Get.back(); // Fecha dialog
        
        Get.snackbar(
          'Sucesso',
          'Serviço adicionado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
        );
      } else {
        Get.snackbar(
          'Erro',
          'Erro ao adicionar serviço. Tente novamente.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar serviço',
          tag: 'TurnoServicosController', error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove um serviço.
  Future<void> removerServico(String servicoId) async {
    final confirmou = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente remover este serviço?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      isLoading.value = true;
      AppLogger.i('Removendo serviço...', tag: 'TurnoServicosController');

      final sucesso = await turnoController.removerServico(servicoId);

      if (sucesso) {
        Get.snackbar(
          'Sucesso',
          'Serviço removido com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover serviço',
          tag: 'TurnoServicosController', error: e, stackTrace: stackTrace);
      
      Get.snackbar(
        'Erro',
        'Erro ao remover serviço.',
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
    AppLogger.d('TurnoServicosController inicializado',
        tag: 'TurnoServicosController');
  }

  @override
  void onClose() {
    descricaoController.dispose();
    AppLogger.d('TurnoServicosController finalizado',
        tag: 'TurnoServicosController');
    super.onClose();
  }
}

