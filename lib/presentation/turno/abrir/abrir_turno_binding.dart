import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/tipo_equipe_repo.dart';
import 'package:nexa_app/data/repositories/tipo_veiculo_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/presentation/turno/abrir/abrir_turno_controller.dart';
import 'package:nexa_app/presentation/turno/abrir/abrir_turno_service.dart';
import 'package:nexa_app/shared/bindings/repository_builder.dart';

/// Binding responsável por injetar dependências da feature "Abrir Turno".
///
/// **Dependências Locais:**
/// Este binding registra repositories e services usados APENAS na
/// funcionalidade de abertura de turno. Quando o usuário sair desta tela,
/// essas dependências serão automaticamente destruídas pelo GetX.
///
/// **Ciclo de vida:** Destruído ao sair da tela
///
/// **Repositories registrados:**
/// - EletricistaRepo, TipoVeiculoRepo, TipoEquipeRepo
///
/// **Repositories globais usados (do InitialBinding):**
/// - VeiculoRepo, EquipeRepo (com fenix: true)
///
/// **Benefício:** Melhor gestão de memória - só carrega quando necessário
class AbrirTurnoBinding extends Bindings {
  @override
  void dependencies() {
    _registerRepositories();
    _registerServices();
    _registerControllers();
  }

  // ==========================================================================
  // REPOSITORIES - Específicos desta feature
  // ==========================================================================
  //
  // Repositories usados APENAS para abrir turno.
  // SEM fenix → Destruídos ao sair da tela (libera memória)
  // ==========================================================================

  void _registerRepositories() {
    // Criar builder com dependências core
    // ✨ Builder elimina Get.find() repetido na criação de repositories!
    final builder = RepositoryBuilder(
      dio: Get.find<DioClient>(),
      db: Get.find<AppDatabase>(),
    );

    // NOTA: VeiculoRepo e EquipeRepo agora estão registrados globalmente
    // no InitialBinding (com fenix: true), pois são usados em múltiplos módulos
    // (HomeController e AbrirTurnoBinding). O GetX encontrará automaticamente.

    // EletricistaRepo - Listagem de eletricistas disponíveis
    Get.lazyPut<EletricistaRepo>(
      () => builder.createEletricistaRepo(),
    );

    // TipoVeiculoRepo - Tipos de veículos para validação
    Get.lazyPut<TipoVeiculoRepo>(
      () => builder.createTipoVeiculoRepo(),
    );

    // TipoEquipeRepo - Tipos de equipes para validação
    Get.lazyPut<TipoEquipeRepo>(
      () => builder.createTipoEquipeRepo(),
    );
  }

  // ==========================================================================
  // SERVICES - Lógica de negócio específica
  // ==========================================================================

  void _registerServices() {
    // AbrirTurnoService - Orquestra lógica de abertura de turno
    // Depende de: VeiculoRepo, EletricistaRepo, EquipeRepo
    Get.lazyPut<AbrirTurnoService>(
      () => AbrirTurnoService(
        veiculoRepo: Get.find<VeiculoRepo>(),
        eletricistaRepo: Get.find<EletricistaRepo>(),
        equipeRepo: Get.find<EquipeRepo>(),
      ),
    );
  }

  // ==========================================================================
  // CONTROLLERS - Controller da tela
  // ==========================================================================

  void _registerControllers() {
    // AbrirTurnoController - Gerencia estado da UI de abertura de turno
    // Depende de: AbrirTurnoService
    Get.lazyPut<AbrirTurnoController>(
      () => AbrirTurnoController(),
    );
  }
}


