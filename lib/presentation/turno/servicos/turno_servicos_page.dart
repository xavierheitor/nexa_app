import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nexa_app/presentation/turno/servicos/turno_servicos_controller.dart';

/// Página de serviços executados no turno.
///
/// Exibe lista de serviços e permite adicionar novos.
class TurnoServicosPage extends StatelessWidget {
  const TurnoServicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TurnoServicosController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Serviços do Turno'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Voltar para Home',
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: Column(
        children: [
          /// Card com informações do turno.
          _buildTurnoInfo(controller, theme, colorScheme),

          /// Lista de serviços.
          /// Otimizado: ListView constante, apenas itemCount reativo
          Expanded(
            child: Obx(() {
              final servicos = controller.turnoController.servicos;

              if (servicos.isEmpty) {
                return _buildEmptyState(colorScheme);
              }

              // ListView é constante, apenas a contagem de itens muda
              return RefreshIndicator(
                onRefresh: controller.turnoController.atualizar,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: servicos.length,
                  itemBuilder: (context, index) {
                    // Cada item observa apenas seu próprio índice
                    return Obx(() {
                      // Acessa apenas o item específico da lista
                      if (index >= controller.turnoController.servicos.length) {
                        return const SizedBox.shrink();
                      }
                      final servico =
                          controller.turnoController.servicos[index];
                      return _buildServicoCard(
                        controller,
                        servico,
                        theme,
                        colorScheme,
                      );
                    });
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.mostrarDialogAdicionarServico,
        icon: const Icon(Icons.add),
        label: const Text('Novo Serviço'),
      ),
    );
  }

  /// Constrói card com informações do turno.
  Widget _buildTurnoInfo(
    TurnoServicosController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final turno = controller.turnoController.turno;
    if (turno == null) return const SizedBox.shrink();

    final horaInicio = DateFormat('HH:mm').format(turno.horaInicio);
    final duracao = DateTime.now().difference(turno.horaInicio);
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.directions_car,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A-${turno.id} • Veículo ${turno.veiculoId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Início: $horaInicio • ${horas}h ${minutos}min',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói card de serviço.
  Widget _buildServicoCard(
    TurnoServicosController controller,
    dynamic servico,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final horario = DateFormat('HH:mm').format(servico.horario);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildTipoIcon(servico.tipo, colorScheme),
        title: Text(
          servico.descricao,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                horario,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getTipoColor(servico.tipo).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getTipoNome(servico.tipo),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getTipoColor(servico.tipo),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () => controller.removerServico(servico.id),
        ),
      ),
    );
  }

  /// Constrói ícone do tipo de serviço.
  Widget _buildTipoIcon(dynamic tipo, ColorScheme colorScheme) {
    final cor = _getTipoColor(tipo);
    final icone = _getTipoIcon(tipo);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icone,
        color: cor,
        size: 24,
      ),
    );
  }

  /// Obtém cor do tipo de serviço.
  Color _getTipoColor(dynamic tipo) {
    switch (tipo.toString()) {
      case 'TipoServico.coleta':
        return Colors.green;
      case 'TipoServico.limpeza':
        return Colors.blue;
      case 'TipoServico.manutencao':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Obtém ícone do tipo de serviço.
  IconData _getTipoIcon(dynamic tipo) {
    switch (tipo.toString()) {
      case 'TipoServico.coleta':
        return Icons.delete_outline;
      case 'TipoServico.limpeza':
        return Icons.cleaning_services;
      case 'TipoServico.manutencao':
        return Icons.build;
      default:
        return Icons.work_outline;
    }
  }

  /// Obtém nome legível do tipo de serviço.
  String _getTipoNome(dynamic tipo) {
    switch (tipo.toString()) {
      case 'TipoServico.coleta':
        return 'Coleta';
      case 'TipoServico.limpeza':
        return 'Limpeza';
      case 'TipoServico.manutencao':
        return 'Manutenção';
      case 'TipoServico.outro':
        return 'Outro';
      default:
        return 'Desconhecido';
    }
  }

  /// Constrói estado vazio.
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum serviço registrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque no botão abaixo para adicionar',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

