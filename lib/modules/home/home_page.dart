import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/home/home_controller.dart';
import 'package:nexa_app/routes/routes.dart';
import 'package:intl/intl.dart';

/// Página principal da aplicação (Home).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(controller, colorScheme),
      body: RefreshIndicator(
        onRefresh: controller.atualizar,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Card de informações do turno.
              Obx(() => _buildTurnoCard(controller, colorScheme)),

              const SizedBox(height: 24),

              /// Título da seção de funcionalidades.
              Text(
                'Funcionalidades',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 16),

              /// Grade de botões de funcionalidades.
              _buildFuncionalidadesGrid(controller, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói a AppBar com informações do usuário.
  PreferredSizeWidget _buildAppBar(
      HomeController controller, ColorScheme colorScheme) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${controller.nomeUsuario}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   'Matrícula: ${controller.matriculaUsuario}',
          //   style: TextStyle(
          //     fontSize: 12,
          //     color: colorScheme.onSurfaceVariant,
          //     fontWeight: FontWeight.normal,
          //   ),
          // ),
        ],
      ),
      actions: [
        /// Botão de logout.
        IconButton(
          icon: const Icon(Icons.logout_outlined),
          tooltip: 'Sair',
          onPressed: () => _showLogoutDialog(controller),
        ),
      ],
    );
  }

  /// Constrói o card com informações do turno.
  Widget _buildTurnoCard(HomeController controller, ColorScheme colorScheme) {
    final turno = controller.turnoController.turnoAtivo.value;

    if (turno == null || !turno.estaAberto) {
      return _buildSemTurnoCard(controller, colorScheme);
    }

    return _buildTurnoAtivoCard(controller, turno, colorScheme);
  }

  /// Constrói o card quando não há turno aberto.
  Widget _buildSemTurnoCard(
      HomeController controller, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showAbrirTurnoDialog(controller),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                colorScheme.surfaceContainerHighest,
                colorScheme.surfaceContainer,
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'Nenhum turno aberto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Toque aqui para abrir um turno',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o card com informações do turno ativo.
  Widget _buildTurnoAtivoCard(
      HomeController controller, dynamic turno, ColorScheme colorScheme) {
    final horaInicio = DateFormat('HH:mm').format(turno.horaInicio);
    final duracao = turno.duracao;
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showFecharTurnoDialog(controller),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer,
                colorScheme.primary.withOpacity(0.1),
              ],
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header do card.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Turno Aberto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Início: $horaInicio • ${horas}h ${minutos}min',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ativo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Divisor.
            Divider(color: colorScheme.outline.withOpacity(0.3)),

            const SizedBox(height: 16),

            /// Informações do veículo.
            _buildInfoRow(
              icon: Icons.directions_car_outlined,
              label: 'Prefixo',
              value: turno.prefixo,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Placa',
              value: turno.placa,
              colorScheme: colorScheme,
            ),
          ],
        ),
        ),
      ),
    );
  }

  /// Constrói uma linha de informação.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói a grade de funcionalidades.
  Widget _buildFuncionalidadesGrid(
      HomeController controller, ColorScheme colorScheme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildFuncionalidadeCard(
          icon: Icons.access_time,
          label: 'Turno',
          color: colorScheme.primary,
          enabled: true,
          onTap: controller.abrirTurno,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.assignment_outlined,
          label: 'APR',
          color: Colors.orange,
          enabled: true,
          onTap: controller.abrirAPR,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.checklist_outlined,
          label: 'Checklist',
          color: Colors.green,
          enabled: true,
          onTap: controller.abrirChecklist,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.inventory_2_outlined,
          label: 'Almoxarifado',
          color: Colors.purple,
          enabled: false,
          onTap: controller.abrirAlmoxarifado,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.build_outlined,
          label: 'Manutenção',
          color: Colors.blue,
          enabled: false,
          onTap: () {},
        ),
        _buildFuncionalidadeCard(
          icon: Icons.assessment_outlined,
          label: 'Relatórios',
          color: Colors.teal,
          enabled: false,
          onTap: () {},
        ),
      ],
    );
  }

  /// Constrói um card de funcionalidade.
  Widget _buildFuncionalidadeCard({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: enabled ? 2 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: enabled ? color.withOpacity(0.1) : Colors.grey.shade200,
            border: Border.all(
              color: enabled ? color.withOpacity(0.3) : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: enabled ? color : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: enabled
                      ? Color.alphaBlend(Colors.black.withOpacity(0.3), color)
                      : Colors.grey.shade600,
                ),
              ),
              if (!enabled) ...[
                const SizedBox(height: 4),
                Text(
                  'Em breve',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra diálogo para abrir turno.
  void _showAbrirTurnoDialog(HomeController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Abrir Turno'),
        content: const Text('Deseja abrir um novo turno?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              // Navega para tela de abrir turno
              Get.toNamed(Routes.turnoAbrir);
            },
            child: const Text('Abrir Turno'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para fechar turno.
  void _showFecharTurnoDialog(HomeController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Fechar Turno'),
        content: const Text(
            'Deseja fechar o turno atual?\nTodos os serviços serão finalizados.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Get.back();
              // Fecha o turno
              final sucesso = await controller.turnoController.fecharTurno();
              if (sucesso) {
                Get.snackbar(
                  'Sucesso',
                  'Turno fechado com sucesso!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Erro',
                  'Erro ao fechar turno. Tente novamente.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Fechar Turno'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo de confirmação de logout.
  void _showLogoutDialog(HomeController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('Deseja realmente sair da aplicação?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

