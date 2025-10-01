import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_controller.dart';

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
                'Informações do Veículo',
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

              /// Campo de Prefixo.
              TextFormField(
                controller: controller.prefixoController,
                decoration: InputDecoration(
                  labelText: 'Prefixo',
                  hintText: 'Ex: A-123',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: controller.validatePrefixo,
              ),

              const SizedBox(height: 16),

              /// Campo de Veículo.
              TextFormField(
                controller: controller.veiculoController,
                decoration: InputDecoration(
                  labelText: 'Veículo',
                  hintText: 'Ex: Volkswagen Gol',
                  prefixIcon: const Icon(Icons.local_shipping),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: controller.validateVeiculo,
              ),

              const SizedBox(height: 16),

              /// Campo de Placa.
              TextFormField(
                controller: controller.placaController,
                decoration: InputDecoration(
                  labelText: 'Placa',
                  hintText: 'Ex: ABC-1234',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9-]')),
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: controller.validatePlaca,
              ),

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
}

