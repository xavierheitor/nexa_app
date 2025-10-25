import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/checklist/visualizacao/checklist_visualizacao_controller.dart';
import 'package:nexa_app/core/enums/checklist_tipo.dart';

/// Tela de visualização detalhada de um checklist.
///
/// Esta tela exibe as respostas detalhadas de um checklist específico,
/// incluindo perguntas e respostas selecionadas.
///
/// ## Funcionalidades:
///
/// - Exibe informações do checklist
/// - Lista perguntas e respostas
/// - Mostra informações do eletricista (se aplicável)
/// - Interface de leitura apenas
/// - Loading e tratamento de erros
///
/// ## Estrutura:
///
/// - **AppBar**: Título e botão de voltar
/// - **Body**: Lista de perguntas e respostas
/// - **Loading**: Indicador de carregamento
/// - **Error State**: Tratamento de erros
class ChecklistVisualizacaoPage extends StatelessWidget {
  const ChecklistVisualizacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChecklistVisualizacaoController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(controller, colorScheme),
      body: _buildBody(controller, colorScheme),
    );
  }

  /// Constrói a AppBar da tela.
  PreferredSizeWidget _buildAppBar(
      ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.checklistNome),
          if (controller.checklistSubtitulo.isNotEmpty)
            Text(
              controller.checklistSubtitulo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: controller.voltar,
        tooltip: 'Voltar',
      ),
    );
  }

  /// Constrói o corpo da tela.
  Widget _buildBody(ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.temErro.value) {
        return _buildErrorState(controller, colorScheme);
      }

      return _buildChecklistContent(controller, colorScheme);
    });
  }

  /// Constrói o estado de carregamento.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando checklist...'),
        ],
      ),
    );
  }

  /// Constrói o estado de erro.
  Widget _buildErrorState(ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao Carregar Checklist',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.mensagemErro.value,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.voltar(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o conteúdo do checklist.
  Widget _buildChecklistContent(ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChecklistInfo(controller, colorScheme),
          const SizedBox(height: 24),
          _buildPerguntasList(controller, colorScheme),
        ],
      ),
    );
  }

  /// Constrói as informações do checklist.
  Widget _buildChecklistInfo(ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações do Checklist',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Data de Preenchimento', controller.dataPreenchimento, colorScheme),
            Obx(() {
              final eletricista = controller.eletricista.value;
              if (eletricista != null) {
                return _buildInfoRow('Eletricista', eletricista.nome, colorScheme);
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              final modelo = controller.checklistModelo.value;
              if (modelo != null) {
                return _buildInfoRow('Tipo', ChecklistTipoExtension.fromId(modelo.tipoChecklistId).name, colorScheme);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  /// Constrói uma linha de informação.
  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a lista de perguntas.
  Widget _buildPerguntasList(ChecklistVisualizacaoController controller, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Obx(() {
      if (controller.itensFormatados.isEmpty) {
        return _buildEmptyPerguntas(colorScheme);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perguntas e Respostas',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...controller.itensFormatados.map((item) => _buildPerguntaCard(item, colorScheme)),
        ],
      );
    });
  }

  /// Constrói o estado vazio (sem perguntas).
  Widget _buildEmptyPerguntas(ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma Pergunta Encontrada',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há perguntas associadas a este checklist.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói um card de pergunta e resposta.
  Widget _buildPerguntaCard(ChecklistVisualizacaoItem item, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '1', // TODO: Implementar ordem quando campo estiver disponível
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:                     Text(
                      item.pergunta.nome,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRespostaColor(item.respostaTexto, colorScheme).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getRespostaColor(item.respostaTexto, colorScheme).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getRespostaIcon(item.respostaTexto),
                    color: _getRespostaColor(item.respostaTexto, colorScheme),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.respostaTexto,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getRespostaColor(item.respostaTexto, colorScheme),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna a cor baseada na resposta.
  Color _getRespostaColor(String resposta, ColorScheme colorScheme) {
    if (resposta.toLowerCase().contains('sim') || resposta.toLowerCase().contains('conforme')) {
      return Colors.green;
    } else if (resposta.toLowerCase().contains('não') || resposta.toLowerCase().contains('não conforme')) {
      return Colors.red;
    } else if (resposta.toLowerCase().contains('não respondida')) {
      return Colors.grey;
    }
    return colorScheme.primary;
  }

  /// Retorna o ícone baseado na resposta.
  IconData _getRespostaIcon(String resposta) {
    if (resposta.toLowerCase().contains('sim') || resposta.toLowerCase().contains('conforme')) {
      return Icons.check_circle;
    } else if (resposta.toLowerCase().contains('não') || resposta.toLowerCase().contains('não conforme')) {
      return Icons.cancel;
    } else if (resposta.toLowerCase().contains('não respondida')) {
      return Icons.help_outline;
    }
    return Icons.info_outline;
  }
}
