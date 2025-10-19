import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/turno/checklist/epi/checklist_eletricistas_controller.dart';

class ChecklistEletricistasPage
    extends GetView<ChecklistEletricistasController> {
  const ChecklistEletricistasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist EPI - Eletricistas'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  /// Constrói o corpo da página com Obx otimizados.
  /// Separado em múltiplos Obx para reduzir reconstruções desnecessárias.
  Widget _buildBody() {
    // Observa apenas isLoading
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return _buildContent();
    });
  }

  /// Constrói o conteúdo principal (erro ou lista).
  Widget _buildContent() {
    // Observa apenas erro
    return Obx(() {
      final erro = controller.erro.value;
      if (erro != null) {
        return _ErroWidget(
          mensagem: erro,
          onRetry: controller.carregarEletricistas,
        );
      }
      return _buildListaOuVazio();
    });
  }

  /// Constrói a lista de eletricistas ou estado vazio.
  Widget _buildListaOuVazio() {
    // Observa apenas eletricistas
    return Obx(() {
      if (controller.eletricistas.isEmpty) {
        return const _ErroWidget(
          mensagem: 'Nenhum eletricista disponível para o checklist.',
          onRetry: null, // Não há retry para estado vazio
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.eletricistas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                // Cada item observa apenas seu índice específico
                return Obx(() {
                  if (index >= controller.eletricistas.length) {
                    return const SizedBox.shrink();
                  }
                  final item = controller.eletricistas[index];
                  return _EletricistaCard(
                    item: item,
                    onTap: () => controller.abrirChecklist(item),
                  );
                });
              },
            ),
          ),
          _buildBotaoAbrirTurno(),
        ],
      );
    });
  }

  /// Constrói o botão de abrir turno.
  /// Observa apenas todosConcluidos e isAbrindoTurno.
  Widget _buildBotaoAbrirTurno() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            final podeAbrir = controller.todosConcluidos;
            final carregando = controller.isAbrindoTurno.value;
            return ElevatedButton.icon(
              onPressed:
                  podeAbrir && !carregando ? controller.abrirTurno : null,
              icon: carregando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.lock_open),
              label: Text(carregando ? 'Validando...' : 'Abrir turno'),
            );
          }),
        ),
      ),
    );
  }
}

class _EletricistaCard extends StatelessWidget {
  final EletricistaChecklistStatus item;
  final VoidCallback onTap;

  const _EletricistaCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final concluido = item.concluido;
    final disabled = item.remoteId == null || concluido;

    final statusText = concluido ? 'Concluído' : 'Pendente';
    final statusColor = concluido ? Colors.green : Colors.orange;

    return Card(
      elevation: 2,
      color: concluido ? Colors.green.shade50 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          item.eletricista.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Matrícula: ${item.eletricista.matricula}'),
            if (item.motorista) ...[
              const SizedBox(height: 4),
              const Text('Motorista responsável',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              concluido ? Icons.check_circle : Icons.schedule,
              color: statusColor,
            ),
            const SizedBox(height: 4),
            Text(
              statusText,
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
          ],
        ),
        onTap: disabled ? null : onTap,
      ),
    );
  }
}

class _ErroWidget extends StatelessWidget {
  final String mensagem;
  final Future<void> Function()? onRetry;

  const _ErroWidget({required this.mensagem, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  onRetry?.call();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
