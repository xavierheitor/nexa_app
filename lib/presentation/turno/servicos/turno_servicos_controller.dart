import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/snackbar_utils.dart';
import 'package:nexa_app/domain/entities/servico_model.dart';

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

  /// Lista de serviços executados no turno.
  final RxList<ServicoModel> servicos = <ServicoModel>[].obs;

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
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      AppLogger.i('Adicionando serviço...', tag: 'TurnoServicosController');

      // Verifica se há turno aberto
      if (!turnoController.hasTurnoAberto) {
        SnackbarUtils.validacao(
          'É necessário ter um turno aberto para adicionar serviços.',
        );
        return;
      }

      // TODO: Integrar com API/Banco quando disponível
      // Por enquanto, apenas adiciona na lista local
      final novoServico = ServicoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descricao: descricaoController.text.trim(),
        horario: DateTime.now(),
        tipo: tipoSelecionado.value,
      );

      servicos.add(novoServico);

      AppLogger.i('Serviço adicionado', tag: 'TurnoServicosController');

      // Sucesso: apenas fecha o dialog sem mostrar snackbar
      Get.back();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar serviço',
          tag: 'TurnoServicosController', error: e, stackTrace: stackTrace);

      SnackbarUtils.erro(
        titulo: 'Erro ao Adicionar Serviço',
        mensagem: 'Não foi possível adicionar o serviço. Tente novamente.',
      );
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

      // TODO: Integrar com API/Banco quando disponível
      // Por enquanto, apenas remove da lista local
      servicos.removeWhere((s) => s.id == servicoId);

      AppLogger.i('Serviço removido', tag: 'TurnoServicosController');
      // Sucesso: apenas remove sem mostrar snackbar
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover serviço',
          tag: 'TurnoServicosController', error: e, stackTrace: stackTrace);

      SnackbarUtils.erro(
        titulo: 'Erro ao Remover',
        mensagem: 'Não foi possível remover o serviço. Tente novamente.',
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
    
    // Carrega serviços mockados (TODO: substituir por API/Banco)
    _carregarServicosMock();
  }

  /// Carrega serviços mockados para demonstração.
  /// TODO: Substituir por busca real do banco/API quando implementado.
  void _carregarServicosMock() {
    servicos.value = [
      ServicoModel(
        id: '1',
        descricao: 'Coleta de lixo - Rua Principal',
        horario: DateTime.now().subtract(const Duration(hours: 1)),
        tipo: TipoServico.coleta,
      ),
      ServicoModel(
        id: '2',
        descricao: 'Limpeza de calçada - Praça Central',
        horario: DateTime.now().subtract(const Duration(minutes: 30)),
        tipo: TipoServico.limpeza,
      ),
    ];
  }

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - TextEditingController (descricao)
  /// - Estados reativos (tipoSelecionado, isLoading)
  @override
  void onClose() {
    /// Dispose de TextEditingController.
    descricaoController.dispose();

    /// Limpa listas observáveis.
    servicos.clear();

    /// Reseta estados reativos.
    isLoading.value = false;
    tipoSelecionado.value = TipoServico.coleta;

    /// Registra finalização do controlador.
    AppLogger.d('TurnoServicosController finalizado e recursos liberados',
        tag: 'TurnoServicosController');

    super.onClose();
  }
}
