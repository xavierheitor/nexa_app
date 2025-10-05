import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_controller.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_service.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.currentRoute == '/turno/checklist/epc'
            ? 'Checklist EPC'
            : 'Checklist Veicular'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<ChecklistController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.checklistAtual == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum checklist encontrado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Verifique se há um turno ativo e se o veículo possui checklist cadastrado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.recarregar(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return _buildChecklistContent(controller);
        },
      ),
    );
  }

  Widget _buildChecklistContent(ChecklistController controller) {
    final checklist = controller.checklistAtual!;
    final perguntaAtual = controller.perguntaAtualModel;

    return Column(
      children: [
        // Header com informações do checklist
        _buildHeader(controller, checklist),
        
        // Progresso
        _buildProgress(controller),

        // Conteúdo da pergunta atual
        Expanded(
          child: perguntaAtual != null
              ? _buildPerguntaCard(controller, perguntaAtual)
              : const Center(
                  child: Text('Nenhuma pergunta encontrada'),
                ),
        ),
        
        // Navegação
        _buildNavigation(controller),
      ],
    );
  }

  Widget _buildHeader(
      ChecklistController controller, ChecklistCompletoModel checklist) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            checklist.modelo.nome,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pergunta ${controller.perguntaAtualIndex + 1} de ${controller.totalPerguntas}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ChecklistController controller) {
    final progress = controller.totalPerguntas > 0
        ? (controller.perguntaAtualIndex + 1) / controller.totalPerguntas
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildPerguntaCard(
      ChecklistController controller, ChecklistPerguntaModel pergunta) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pergunta
              Text(
                pergunta.nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // Opções de resposta
              _buildOpcoesResposta(controller, pergunta),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpcoesResposta(
      ChecklistController controller, ChecklistPerguntaModel pergunta) {
    if (pergunta.opcoes.length <= 2) {
      // Para 2 ou menos opções, usa Row com Expanded
      return Row(
        children: pergunta.opcoes.map((opcao) {
          final isSelected = pergunta.respostaSelecionada == opcao.id;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildOpcaoResposta(
                opcao: opcao,
                isSelected: isSelected,
                onTap: () =>
                    controller.selecionarResposta(pergunta.id, opcao.id),
              ),
            ),
          );
        }).toList(),
      );
    } else if (pergunta.opcoes.length <= 4) {
      // Para 3-4 opções, usa Wrap com flexibilidade
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: pergunta.opcoes.map((opcao) {
          final isSelected = pergunta.respostaSelecionada == opcao.id;
          return SizedBox(
            width: (Get.width - 64) / 2 - 4, // Metade da largura menos padding
            child: _buildOpcaoResposta(
              opcao: opcao,
              isSelected: isSelected,
              onTap: () => controller.selecionarResposta(pergunta.id, opcao.id),
            ),
          );
        }).toList(),
      );
    } else {
      // Para mais de 4 opções, usa layout vertical
      return Column(
        children: pergunta.opcoes.map((opcao) {
          final isSelected = pergunta.respostaSelecionada == opcao.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildOpcaoResposta(
              opcao: opcao,
              isSelected: isSelected,
              onTap: () => controller.selecionarResposta(pergunta.id, opcao.id),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildOpcaoResposta({
    required ChecklistOpcaoRespostaModel opcao,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color getColor() {
      if (isSelected) {
        return opcao.geraPendencia
            ? Colors.orange.shade100
            : Colors.green.shade100;
      }
      return Colors.grey.shade100;
    }

    Color getTextColor() {
      if (isSelected) {
        return opcao.geraPendencia
            ? Colors.orange.shade800
            : Colors.green.shade800;
      }
      return Colors.grey.shade700;
    }

    IconData? getIcon() {
      if (isSelected) {
        return opcao.geraPendencia ? Icons.warning : Icons.check_circle;
      }
      return null;
    }

    return Material(
      color: getColor(),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (getIcon() != null) ...[
                Icon(
                  getIcon(),
                  color: getTextColor(),
                  size: 18,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  opcao.nome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: getTextColor(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? getTextColor() : Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(ChecklistController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Botão anterior
          if (controller.temPerguntaAnterior)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.perguntaAnterior,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Anterior'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

          if (controller.temPerguntaAnterior) const SizedBox(width: 16),

          // Botão próximo/salvar
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.isSaving.value) {
                return const SizedBox(
                  height: 56,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.isUltimaPergunta &&
                  controller.checklistCompleto.value) {
                return ElevatedButton.icon(
                  onPressed: () => controller.salvarChecklist(),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Checklist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              } else if (controller.temProximaPergunta) {
                return ElevatedButton.icon(
                  onPressed: controller.proximaPergunta,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Próxima'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              } else {
                return ElevatedButton.icon(
                  onPressed: controller.checklistCompleto.value
                      ? () => controller.salvarChecklist()
                      : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Checklist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
