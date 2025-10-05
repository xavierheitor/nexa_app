import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_controller.dart';
import 'package:nexa_app/widgets/custom_searcheable_dropdown.dart';

/// Página para abertura de novo turno.
///
/// Fornece formulário para inserir dados do veículo e iniciar turno.
class AbrirTurnoPage extends StatelessWidget {
  const AbrirTurnoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbrirTurnoController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Abrir Turno'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Ícone ilustrativo.
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              /// Título.
              Text(
                'Informações do Turno',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              /// Subtítulo.
              Text(
                'Preencha os dados para iniciar o turno',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              /// Dropdown de Veículo.
              SearchableDropdown(
                controller: controller.veiculoDropdownController,
                labelText: 'Veículo (Placa)',
                hintText: 'Selecionar veículo...',
                leadingIcon: const Icon(Icons.directions_car),
                onChanged: (value) {
                  // Força revalidação quando o valor muda
                  controller.formKey.currentState?.validate();
                },
              ),

              const SizedBox(height: 16),

              /// Campo de KM Inicial.
              TextFormField(
                controller: controller.kmInicialController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'KM Inicial',
                  hintText: 'Ex: 15000',
                  prefixIcon: const Icon(Icons.speed),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: controller.validateKmInicial,
              ),

              const SizedBox(height: 16),

              /// Dropdown de Equipe.
              SearchableDropdown(
                controller: controller.equipeDropdownController,
                labelText: 'Equipe',
                hintText: 'Selecionar equipe...',
                leadingIcon: const Icon(Icons.group),
                onChanged: (value) {
                  // Força revalidação quando o valor muda
                  controller.formKey.currentState?.validate();
                },
              ),

              const SizedBox(height: 16),

              /// Dropdown de Eletricistas.
              SearchableDropdown(
                controller: controller.eletricistaDropdownController,
                labelText: 'Eletricistas',
                hintText: 'Selecionar eletricista...',
                leadingIcon: const Icon(Icons.person),
                onChanged: (value) {
                  if (value != null) {
                    controller.adicionarEletricista(value);
                    // Limpa a seleção do dropdown após adicionar
                    controller.eletricistaDropdownController.clearSelection();
                  }
                },
              ),

              const SizedBox(height: 16),

              /// Lista de Eletricistas Selecionados.
              Obx(() {
                if (controller.eletricistasSelecionados.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Card(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Eletricistas Selecionados (${controller.eletricistasSelecionados.length})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...controller.eletricistasSelecionados
                            .map((eletricistaSelecionado) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: eletricistaSelecionado.isMotorista
                                    ? colorScheme.primaryContainer
                                        .withOpacity(0.3)
                                    : colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: eletricistaSelecionado.isMotorista
                                      ? colorScheme.primary
                                      : colorScheme.outline.withOpacity(0.3),
                                  width: eletricistaSelecionado.isMotorista
                                      ? 2
                                      : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${eletricistaSelecionado.eletricista.matricula} - ${eletricistaSelecionado.eletricista.nome}',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (eletricistaSelecionado.isMotorista)
                                          Text(
                                            'Motorista',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Toggle para motorista
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.drive_eta,
                                            color: eletricistaSelecionado
                                                    .isMotorista
                                                ? colorScheme.primary
                                                : colorScheme.onSurface
                                                    .withOpacity(0.6),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Switch(
                                            value: eletricistaSelecionado
                                                .isMotorista,
                                            onChanged: (value) {
                                              controller.alternarMotorista(
                                                eletricistaSelecionado
                                                    .eletricista.id,
                                              );
                                            },
                                            activeColor: colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      // Botão de remover
                                      IconButton(
                                        onPressed: () {
                                          controller.removerEletricista(
                                            eletricistaSelecionado
                                                .eletricista.id,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: colorScheme.error,
                                        ),
                                        tooltip: 'Remover eletricista',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (controller.eletricistasSelecionados.length < 2)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Mínimo de 2 eletricistas necessários',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                        // Aviso sobre motorista obrigatório
                        if (controller.eletricistasSelecionados.length >= 2 &&
                            !controller.eletricistasSelecionados
                                .any((e) => e.isMotorista))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.errorContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colorScheme.error,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'É obrigatório marcar um motorista para abrir o turno',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              /// Card com informações selecionadas.
              Obx(() {
                final veiculoSelecionado =
                    controller.veiculoDropdownController.selected.value;

                final equipeSelecionada =
                    controller.equipeDropdownController.selected.value;
                final kmInicial = controller.kmInicialController.text.trim();

                if (veiculoSelecionado == null ||
                    equipeSelecionada == null ||
                    kmInicial.isEmpty ||
                    controller.eletricistasSelecionados.length < 2) {
                  return const SizedBox.shrink();
                }

                return Card(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Informações do Turno',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                            'Veículo',
                            'Veículo ${veiculoSelecionado.placa}',
                            Icons.directions_car),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            'Placa', veiculoSelecionado.placa, Icons.badge),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            'Equipe', equipeSelecionada.nome, Icons.group),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            'KM Inicial', '$kmInicial km', Icons.speed),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Eletricistas',
                          '${controller.eletricistasSelecionados.length} selecionados',
                          Icons.people,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Motorista',
                          controller.eletricistasSelecionados
                                  .where((e) => e.isMotorista)
                                  .isNotEmpty
                              ? controller.eletricistasSelecionados
                                  .firstWhere((e) => e.isMotorista)
                                  .eletricista
                                  .nome
                              : 'Não definido',
                          Icons.drive_eta,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 32),

              /// Botão de Abrir Turno.
              Obx(() => SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.abrirTurno,
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.play_arrow),
                      label: Text(
                        controller.isLoading.value
                            ? 'Abrindo...'
                            : 'Iniciar Turno',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 16),

              /// Card informativo.
              Card(
                color: colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ao iniciar o turno, você poderá registrar os serviços executados.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói uma linha de informação no card.
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
