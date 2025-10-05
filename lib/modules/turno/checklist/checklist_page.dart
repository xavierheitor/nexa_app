import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/domain/models/checklist_model.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_controller.dart';

/// Página do checklist veicular.
class ChecklistPage extends GetView<ChecklistController> {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.checklist.value?.nome ?? 'Checklist',
              style: const TextStyle(fontSize: 18),
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.checklist.value == null ||
            controller.perguntas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum checklist encontrado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Não foi possível carregar o checklist para este veículo',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header com progresso
            _buildProgressHeader(),
            const Divider(height: 1),

            // Lista de perguntas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.perguntas.length,
                itemBuilder: (context, index) {
                  final pergunta = controller.perguntas[index];
                  return _buildPerguntaCard(pergunta, index);
                },
              ),
            ),

            // Botão de finalizar
            _buildFinalizarButton(),
          ],
        );
      }),
    );
  }

  /// Header com barra de progresso.
  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Obx(() => Text(
                    controller.progressoTexto,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => LinearProgressIndicator(
                value: controller.progresso,
                backgroundColor: Colors.blue.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              )),
        ],
      ),
    );
  }

  /// Card de uma pergunta com suas opções.
  Widget _buildPerguntaCard(ChecklistPerguntaModel pergunta, int index) {
    return Obx(() {
      // Pega a pergunta atualizada da lista reativa
      final perguntaAtual = controller.perguntas[index];

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: perguntaAtual.foiRespondida
              ? BorderSide(color: Colors.green.shade300, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número e título da pergunta
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: perguntaAtual.foiRespondida
                          ? Colors.green
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: perguntaAtual.foiRespondida
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 18)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      perguntaAtual.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Opções de resposta
              ...perguntaAtual.opcoes.map((opcao) {
                final isSelected =
                    perguntaAtual.respostaSelecionada == opcao.id;
                return _buildOpcaoResposta(
                  opcao: opcao,
                  isSelected: isSelected,
                  onTap: () => controller.selecionarResposta(
                      perguntaAtual.id, opcao.id),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  /// Opção de resposta (botão).
  Widget _buildOpcaoResposta({
    required ChecklistOpcaoRespostaModel opcao,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color getColor() {
      if (!isSelected) return Colors.grey.shade200;
      if (opcao.geraPendencia) return Colors.orange.shade100;
      return Colors.green.shade100;
    }

    Color getTextColor() {
      if (!isSelected) return Colors.black87;
      if (opcao.geraPendencia) return Colors.orange.shade900;
      return Colors.green.shade900;
    }

    IconData? getIcon() {
      if (!isSelected) return null;
      if (opcao.geraPendencia) return Icons.warning_amber_rounded;
      return Icons.check_circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: getColor(),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: opcao.geraPendencia
                          ? Colors.orange.shade700
                          : Colors.green.shade700,
                      width: 2,
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (getIcon() != null) ...[
                  Icon(
                    getIcon(),
                    color: getTextColor(),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    opcao.nome,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: getTextColor(),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.radio_button_checked,
                    color: getTextColor(),
                    size: 20,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Botão de finalizar checklist.
  Widget _buildFinalizarButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.finalizarChecklist,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Finalizar Checklist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

