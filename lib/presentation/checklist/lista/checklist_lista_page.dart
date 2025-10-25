import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/checklist/lista/checklist_lista_controller.dart';
import 'package:nexa_app/core/enums/checklist_tipo.dart';

/// Tela de listagem de checklists preenchidos do turno.
///
/// Esta tela exibe todos os checklists preenchidos durante o turno ativo,
/// permitindo ao usuário visualizar as respostas de cada checklist.
///
/// ## Funcionalidades:
///
/// - Lista checklists por tipo (Veicular, EPC, EPI)
/// - Mostra informações do eletricista para checklists EPI
/// - Permite navegar para visualização detalhada
/// - Pull-to-refresh para atualizar dados
/// - Loading e tratamento de erros
///
/// ## Estrutura:
///
/// - **AppBar**: Título e botão de voltar
/// - **Body**: Lista de checklists com pull-to-refresh
/// - **Loading**: Indicador de carregamento
/// - **Empty State**: Mensagem quando não há checklists
/// - **Error State**: Tratamento de erros
class ChecklistListaPage extends StatelessWidget {
  const ChecklistListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChecklistListaController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(controller, colorScheme),
      body: _buildBody(controller, colorScheme),
    );
  }

  /// Constrói a AppBar da tela.
  PreferredSizeWidget _buildAppBar(
      ChecklistListaController controller, ColorScheme colorScheme) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Checklists Preenchidos'),
          Obx(() => Text(
                controller.prefixoTurno,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              )),
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
  Widget _buildBody(ChecklistListaController controller, ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.temErro.value) {
        return _buildErrorState(controller, colorScheme);
      }

      if (!controller.temChecklists) {
        return _buildEmptyState(colorScheme);
      }

      return _buildChecklistsList(controller, colorScheme);
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
          Text('Carregando checklists...'),
        ],
      ),
    );
  }

  /// Constrói o estado de erro.
  Widget _buildErrorState(ChecklistListaController controller, ColorScheme colorScheme) {
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
              'Erro ao Carregar Checklists',
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
              onPressed: controller.recarregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o estado vazio (sem checklists).
  Widget _buildEmptyState(ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum Checklist Preenchido',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há checklists preenchidos para este turno ainda.',
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

  /// Constrói a lista de checklists.
  Widget _buildChecklistsList(ChecklistListaController controller, ColorScheme colorScheme) {
    return RefreshIndicator(
      onRefresh: controller.recarregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.checklistsFormatados.length,
        itemBuilder: (context, index) {
          final item = controller.checklistsFormatados[index];
          return _buildChecklistCard(item, controller, colorScheme);
        },
      ),
    );
  }

  /// Constrói um card de checklist.
  Widget _buildChecklistCard(
      ChecklistItem item, ChecklistListaController controller, ColorScheme colorScheme) {
    final theme = Theme.of(Get.context!);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.visualizarChecklist(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildChecklistIcon(item.tipo, colorScheme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (item.subtitulo.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitulo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatarData(item.checklist.dataPreenchimento),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o ícone do checklist baseado no tipo.
  Widget _buildChecklistIcon(ChecklistTipo tipo, ColorScheme colorScheme) {
    IconData icon;
    Color color;

    switch (tipo) {
      case ChecklistTipo.veicular:
        icon = Icons.directions_car;
        color = Colors.blue;
        break;
      case ChecklistTipo.epc:
        icon = Icons.shield;
        color = Colors.green;
        break;
      case ChecklistTipo.epi:
        icon = Icons.person;
        color = Colors.orange;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  /// Formata a data para exibição.
  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }
}
