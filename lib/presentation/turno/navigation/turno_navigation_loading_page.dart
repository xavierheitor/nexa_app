import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/turno/navigation/turno_navigation_loading_controller.dart';

/// Tela intermediária que mostra loading enquanto determina a rota correta.
///
/// Esta tela é responsável por:
/// - Mostrar indicador de loading durante verificações
/// - Exibir mensagens de progresso
/// - Navegar automaticamente para a rota correta
/// - Tratar erros de navegação
class TurnoNavigationLoadingPage extends GetView<TurnoNavigationLoadingController> {
  const TurnoNavigationLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // Loading state - Obx isolado
                Obx(() {
                  if (!controller.hasError.value) {
                    return Expanded(child: _buildLoadingState(context));
                  }
                  return const SizedBox.shrink();
                }),
                // Error state - Obx isolado
                Obx(() {
                  if (controller.hasError.value) {
                    return Expanded(child: _buildErrorState(context));
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ícone animado
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Loading indicator
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Mensagem de status - Obx isolado
        Obx(() => Text(
              controller.statusMessage.value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            )),

        const SizedBox(height: 8),

        // Mensagem secundária
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Analisando o estado do turno...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone de erro
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
          ),

          const SizedBox(height: 24),

          // Título do erro
          Text(
            'Erro ao verificar turno',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Mensagem de erro - Obx isolado
          Obx(() => Text(
                controller.errorMessage.value,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              )),

          const SizedBox(height: 32),

          // Botão de retry
          FilledButton.icon(
            onPressed: controller.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar Novamente'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Botão de voltar
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}

