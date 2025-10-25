import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/home/home_controller.dart';
import 'package:nexa_app/app/routes/routes.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/presentation/shared/widgets/connectivity_indicator.dart';
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
              /// Otimizado: Obx acessa apenas turnoAtivo, reduzindo reconstruções
              Obx(() {
                final turno = controller.turnoController.turnoAtivo.value;
                return _buildTurnoCardOptimized(turno, controller, colorScheme);
              }),

              /// Card de erro unificado (se houver)
              Obx(() => controller.temErro
                  ? _buildErroCardUnificado(controller, colorScheme)
                  : const SizedBox.shrink()),

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
        /// Indicador de conectividade.
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ConnectivityIndicator(),
        ),
        /// Botão de logout (só aparece quando não há turno aberto).
        Obx(() {
          if (!controller.logoutVisivel) {
            return const SizedBox.shrink();
          }
          return IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sair',
            onPressed: () => _showLogoutDialog(controller),
          );
        }),
      ],
    );
  }

  /// Constrói o card com informações do turno (versão otimizada).
  /// Recebe o turno diretamente, evitando acessar observables desnecessários.
  Widget _buildTurnoCardOptimized(
      dynamic turno, HomeController controller, ColorScheme colorScheme) {
    if (turno == null) {
      return _buildSemTurnoCard(controller, colorScheme);
    }

    // Se turno está em abertura, mostra card especial
    if (turno.situacaoTurno == SituacaoTurno.emAbertura) {
      return _buildTurnoEmAberturaCard(controller, turno, colorScheme);
    }

    // Se turno está aberto, mostra card normal
    if (turno.situacaoTurno == SituacaoTurno.aberto) {
      return _buildTurnoAtivoCard(controller, turno, colorScheme);
    }

    // Se turno está fechado, mostra card para abrir novo
    return _buildSemTurnoCard(controller, colorScheme);
  }

  /// Constrói o card quando turno está em abertura.
  Widget _buildTurnoEmAberturaCard(
      HomeController controller, dynamic turno, ColorScheme colorScheme) {
    final horaInicio = DateFormat('HH:mm').format(turno.horaInicio);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => controller.abrirTurno(), // Usa navegação inteligente
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade100,
                Colors.amber.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 32,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Turno em Abertura',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        Text(
                          'Aguardando checklists',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'EM ABERTURA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Iniciado às $horaInicio',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: controller.buscarPlacaVeiculo(turno.veiculoId),
                builder: (context, snapshot) {
                  final placaVeiculo = snapshot.data ?? 'Carregando...';
                  return Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 16,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        placaVeiculo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Toque para continuar com os checklists',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o card quando não há turno aberto.
  Widget _buildSemTurnoCard(
      HomeController controller, ColorScheme colorScheme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showAbrirTurnoDialog(controller),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withOpacity(0.3),
                colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone grande e destacado
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Título
              Text(
                'Nenhum turno aberto',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtítulo
              Text(
                'Inicie um novo turno para começar\na registrar serviços',
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Botão de call-to-action
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Abrir Novo Turno',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
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
    
    // Calcula a duração do turno
    final agora = DateTime.now();
    final horaFim = turno.horaFim ?? agora;
    final duracao = horaFim.difference(turno.horaInicio);
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => controller
            .abrirTurno(), // Navega para tela de serviços quando turno aberto
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

              /// Informações da equipe e veículo - Com busca real.
              FutureBuilder<String>(
                future: controller.buscarNomeEquipe(turno.equipeId),
                builder: (context, snapshot) {
                  final nomeEquipe = snapshot.data ?? 'Carregando...';
                  return _buildInfoRow(
                    icon: Icons.group_outlined,
                    label: 'Equipe',
                    value: nomeEquipe,
                    colorScheme: colorScheme,
                  );
                },
            ),
            const SizedBox(height: 12),
              FutureBuilder<String>(
                future: controller.buscarPlacaVeiculo(turno.veiculoId),
                builder: (context, snapshot) {
                  final placaVeiculo = snapshot.data ?? 'Carregando...';
                  return _buildInfoRow(
                    icon: Icons.directions_car_outlined,
                    label: 'Placa',
                    value: placaVeiculo,
                    colorScheme: colorScheme,
                  );
                },
            ),

              const SizedBox(height: 20),

              /// Botão de fechar turno
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showFecharTurnoDialog(controller, turno),
                  icon: const Icon(Icons.close, size: 20),
                  label: const Text('Fechar Turno'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
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
          enabled: controller.aprHabilitado,
          onTap: controller.abrirAPR,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.checklist_outlined,
          label: 'Checklist',
          color: Colors.green,
          enabled: controller.checklistHabilitado,
          onTap: controller.abrirChecklist,
        ),
        _buildFuncionalidadeCard(
          icon: Icons.inventory_2_outlined,
          label: 'Almoxarifado',
          color: Colors.purple,
          enabled: controller.almoxarifadoHabilitado,
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
                  label == 'APR' || label == 'Checklist'
                      ? 'Turno fechado'
                      : 'Em breve',
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
              // Fecha o dialog primeiro
              Get.back();
              // Navega para tela de abrir turno
              Get.toNamed(Routes.turnoAbrir);
            },
            child: const Text('Abrir Turno'),
          ),
        ],
      ),
      barrierDismissible: true, // Permite fechar tocando fora
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

  /// Constrói o card de erro unificado.
  Widget _buildErroCardUnificado(
      HomeController controller, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.errorContainer.withOpacity(0.3),
              colorScheme.errorContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.mensagemErro ?? 'Erro desconhecido',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.limparErro,
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onErrorContainer,
                  ),
                  tooltip: 'Fechar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra dialog de confirmação para fechar turno
  void _showFecharTurnoDialog(HomeController controller, dynamic turno) {
    controller.fecharTurno();
  }

}

