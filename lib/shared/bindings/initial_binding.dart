import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/services/error_message_service.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/usuario_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/shared/bindings/repository_builder.dart';

/// Binding inicial responsável por registrar dependências globais da aplicação.
///
/// Este binding é executado no início do app e registra apenas dependências
/// que precisam estar disponíveis durante TODO o ciclo de vida da aplicação
/// ou que são usadas em múltiplos módulos.
///
/// **Princípios:**
/// - `permanent: true` → Nunca é destruído (infraestrutura, estado global)
/// - `fenix: true` → Pode ser recriado se deletado (services, repos globais)
/// - `lazyPut` simples → Para bindings locais de features específicas
///
/// **Dependências Locais:**
/// Repositories usados em apenas UM módulo devem ser registrados
/// no binding específico daquele módulo para melhor gestão de memória.
///
/// Exemplos:
/// - VeiculoRepo, EquipeRepo → AbrirTurnoBinding
/// - ChecklistXxxRepo → ChecklistBinding
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _registerCore();
    _registerRepositories();
    _registerServices();
    _registerGlobalControllers();
  }

  // ==========================================================================
  // CORE - Infraestrutura Base (permanent: true)
  // ==========================================================================
  //
  // Dependências fundamentais que NUNCA devem ser destruídas e são
  // usadas por toda a aplicação.
  //
  // Ciclo de vida: Toda a vida do app
  // ==========================================================================

  void _registerCore() {
    // Database local (Drift/SQLite)
    Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );

    // Cliente HTTP (Dio)
    Get.put<DioClient>(
      DioClient(),
      permanent: true,
    );
  }

  // ==========================================================================
  // REPOSITORIES - Acesso a Dados (fenix: true)
  // ==========================================================================
  //
  // Repositories GLOBAIS que são usados em múltiplos módulos.
  // São recreáveis (fenix) para permitir refresh de dados se necessário.
  //
  // IMPORTANTE: Repositories usados em apenas 1 módulo devem ser
  // registrados no binding local daquele módulo!
  //
  // Ciclo de vida: Recreável automaticamente se deletado
  // ==========================================================================

  void _registerRepositories() {
    // Criar builder com dependências core
    // ✨ Builder elimina necessidade de Get.find() repetido!
    final builder = RepositoryBuilder(
      dio: Get.find<DioClient>(),
      db: Get.find<AppDatabase>(),
    );

    // UsuarioRepo - Usado em: AuthService, SessionManager, Login
    // Ciclo de vida: fenix (recreável)
    Get.lazyPut<UsuarioRepo>(
      () => builder.createUsuarioRepo(),
      fenix: true,
    );

    // TurnoRepo - Usado em: TurnoController (global), múltiplos módulos
    // Ciclo de vida: fenix (recreável)
    Get.lazyPut<TurnoRepo>(
      () => builder.createTurnoRepo(),
      fenix: true,
    );

    // EquipeRepo - Usado em: HomeController, AbrirTurnoBinding
    // Ciclo de vida: fenix (recreável)
    Get.lazyPut<EquipeRepo>(
      () => builder.createEquipeRepo(),
      fenix: true,
    );

    // VeiculoRepo - Usado em: HomeController, AbrirTurnoBinding
    // Ciclo de vida: fenix (recreável)
    Get.lazyPut<VeiculoRepo>(
      () => builder.createVeiculoRepo(),
      fenix: true,
    );

    // NOTA: Outros repositories (ChecklistRepos, etc) são registrados nos
    // bindings específicos dos módulos que os usam.
    // Isso melhora gestão de memória e organização.
  }

  // ==========================================================================
  // SERVICES - Lógica de Negócio Global (fenix: true / permanent: true)
  // ==========================================================================
  //
  // Services que implementam lógica de negócio usada em múltiplos módulos.
  //
  // fenix: true → Service pode ser recriado (AuthService, SyncService)
  // permanent: true → Service mantém estado crítico (ErrorMessageService)
  //
  // Ciclo de vida: Depende do tipo de service
  // ==========================================================================

  void _registerServices() {
    // AuthService - Autenticação global
    // Depende de: UsuarioRepo
    Get.lazyPut<AuthService>(
      () => AuthService(usuarioRepo: Get.find<UsuarioRepo>()),
      fenix: true,
    );

    // SyncService - Sincronização de dados
    // Sem dependências externas
    Get.lazyPut<SyncService>(
      () => SyncService(),
      fenix: true,
    );

    // ErrorMessageService - Gerenciamento global de erros
    // Mantém estado de erro atual (permanent)
    Get.put<ErrorMessageService>(
      ErrorMessageService(),
      permanent: true,
    );
  }

  // ==========================================================================
  // GLOBAL CONTROLLERS - Estado Global (permanent: true)
  // ==========================================================================
  //
  // Controllers que mantêm estado global compartilhado entre múltiplos módulos.
  // NUNCA são destruídos pois o estado precisa persistir durante toda a sessão.
  //
  // Exemplos:
  // - SessionManager: Estado de autenticação
  // - TurnoController: Estado do turno ativo
  //
  // Ciclo de vida: Toda a vida do app
  // ==========================================================================

  void _registerGlobalControllers() {
    // SessionManager - Gerenciamento de sessão e autenticação
    // Depende de: AuthService
    Get.put<SessionManager>(
      SessionManager(authService: Get.find<AuthService>()),
      permanent: true,
    );

    // TurnoController - Estado global do turno ativo
    // Usado em: Home, Turno (todos sub-módulos), Serviços
    // Sem dependências diretas (usa repos via Get.find quando necessário)
    Get.put<TurnoController>(
      TurnoController(),
      permanent: true,
    );
  }
}
