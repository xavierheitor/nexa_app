import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_controller.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/shared/bindings/repository_builder.dart';

/// Binding responsável por injetar dependências do módulo de Checklist.
///
/// **Dependências Mistas:**
/// - Repositories específicos de checklist (ChecklistXxxRepo)
/// - Usa repositories globais já registrados (TurnoRepo, VeiculoRepo, EquipeRepo)
///
/// **Ciclo de vida:** Destruído ao sair das telas de checklist
class ChecklistBinding extends Bindings {
  @override
  void dependencies() {
    _registerRepositories();
    _registerServices();
    _registerControllers();
  }

  // ==========================================================================
  // REPOSITORIES - Específicos de checklist
  // ==========================================================================

  void _registerRepositories() {
    // Criar builder para repositories de checklist
    final builder = RepositoryBuilder(
      dio: Get.find<DioClient>(),
      db: Get.find<AppDatabase>(),
    );
    
    final db = Get.find<AppDatabase>();

    // Repositories de modelos e perguntas de checklist
    Get.lazyPut<ChecklistModeloRepo>(
      () => builder.createChecklistModeloRepo(),
      fenix: true,
    );

    Get.lazyPut<ChecklistPerguntaRepo>(
      () => builder.createChecklistPerguntaRepo(),
      fenix: true,
    );

    Get.lazyPut<ChecklistOpcaoRespostaRepo>(
      () => builder.createChecklistOpcaoRespostaRepo(),
      fenix: true,
    );

    // Repositories de preenchimento e respostas
    // NOTA: Estes usam DAO diretamente ao invés de Dio+DB
    Get.lazyPut<ChecklistPreenchidoRepo>(
      () => ChecklistPreenchidoRepo(db.checklistPreenchidoDao),
      fenix: true,
    );

    Get.lazyPut<ChecklistRespostaRepo>(
      () => ChecklistRespostaRepo(db.checklistRespostaDao),
      fenix: true,
    );

    // NOTA: Repositories auxiliares já estão registrados globalmente no InitialBinding:
    // - TurnoRepo (com fenix: true)
    // - VeiculoRepo (com fenix: true)
    // - EquipeRepo (com fenix: true)
    // O GetX encontrará automaticamente esses repositories.
  }

  // ==========================================================================
  // SERVICES - Lógica de negócio de checklist
  // ==========================================================================

  void _registerServices() {
    // ChecklistService - Orquestra lógica de checklists
    // Depende de: ChecklistRepos + TurnoRepo + VeiculoRepo + EquipeRepo
    Get.lazyPut<ChecklistService>(
      () => ChecklistService(
        checklistModeloRepo: Get.find<ChecklistModeloRepo>(),
        checklistPerguntaRepo: Get.find<ChecklistPerguntaRepo>(),
        checklistOpcaoRespostaRepo: Get.find<ChecklistOpcaoRespostaRepo>(),
        turnoRepo: Get.find<TurnoRepo>(),
        veiculoRepo: Get.find<VeiculoRepo>(),
        equipeRepo: Get.find<EquipeRepo>(),
        checklistPreenchidoRepo: Get.find<ChecklistPreenchidoRepo>(),
        checklistRespostaRepo: Get.find<ChecklistRespostaRepo>(),
      ),
      fenix: true,
    );
  }

  // ==========================================================================
  // CONTROLLERS - Controller da tela
  // ==========================================================================

  void _registerControllers() {
    // ChecklistController - Gerencia estado da UI de checklist
    // Depende de: ChecklistService
    Get.lazyPut<ChecklistController>(
      () => ChecklistController(),
    );
  }
}

