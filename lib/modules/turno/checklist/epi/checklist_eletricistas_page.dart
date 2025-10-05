import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/checklist/epi/checklist_eletricistas_controller.dart';

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final erro = controller.erro.value;
        if (erro != null) {
          return _ErroWidget(
            mensagem: erro,
            onRetry: controller.carregarEletricistas,
          );
        }

        if (controller.eletricistas.isEmpty) {
          return _ErroWidget(
            mensagem: 'Nenhum eletricista disponível para o checklist.',
            onRetry: controller.carregarEletricistas,
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
                  final item = controller.eletricistas[index];
                  return _EletricistaCard(
                    item: item,
                    onTap: () => controller.abrirChecklist(item),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.lock_open),
                      label: Text(carregando ? 'Validando...' : 'Abrir turno'),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
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

    final statusText = disabled
        ? 'Dados incompletos'
        : concluido
            ? 'Concluído'
            : 'Pendente';

    final statusColor = disabled
        ? Colors.grey
        : concluido
            ? Colors.green
            : Colors.orange;

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
  final Future<void> Function() onRetry;

  const _ErroWidget({required this.mensagem, required this.onRetry});

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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
