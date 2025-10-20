import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_tipo_equipe_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_tipo_veiculo_relacao_repo.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/tipo_equipe_repo.dart';
import 'package:nexa_app/data/repositories/tipo_veiculo_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/usuario_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';

/// Factory para criação de repositories com dependências injetadas.
///
/// **Objetivo:**
/// Centralizar a criação de repositories eliminando a necessidade de
/// `Get.find()` repetido nos bindings. Todas as dependências (dio, db)
/// são injetadas uma única vez no construtor do builder.
///
/// **Benefícios:**
/// - ✅ ZERO `Get.find()` na criação de repositories
/// - ✅ Dependências explícitas e visíveis
/// - ✅ Fácil de testar (pode criar builder mock)
/// - ✅ Código mais limpo e organizado
/// - ✅ Reduz repetição (DRY principle)
///
/// **Uso:**
/// ```dart
/// // No binding:
/// final builder = RepositoryBuilder(
///   dio: Get.find<DioClient>(),
///   db: Get.find<AppDatabase>(),
/// );
///
/// Get.lazyPut<UsuarioRepo>(() => builder.createUsuarioRepo());
/// ```
class RepositoryBuilder {
  // ==========================================================================
  // DEPENDÊNCIAS CORE
  // ==========================================================================

  final DioClient dio;
  final AppDatabase db;

  // ==========================================================================
  // CONSTRUTOR
  // ==========================================================================

  const RepositoryBuilder({
    required this.dio,
    required this.db,
  });

  // ==========================================================================
  // REPOSITORIES PRINCIPAIS
  // ==========================================================================

  /// Cria UsuarioRepo com dependências injetadas.
  UsuarioRepo createUsuarioRepo() => UsuarioRepo(dio: dio, db: db);

  /// Cria TurnoRepo com dependências injetadas.
  TurnoRepo createTurnoRepo() => TurnoRepo(dio: dio, db: db);

  /// Cria VeiculoRepo com dependências injetadas.
  VeiculoRepo createVeiculoRepo() => VeiculoRepo(dio: dio, db: db);

  /// Cria EquipeRepo com dependências injetadas.
  EquipeRepo createEquipeRepo() => EquipeRepo(dio: dio, db: db);

  /// Cria EletricistaRepo com dependências injetadas.
  EletricistaRepo createEletricistaRepo() => EletricistaRepo(dio: dio, db: db);

  // ==========================================================================
  // REPOSITORIES DE TIPO
  // ==========================================================================

  /// Cria TipoVeiculoRepo com dependências injetadas.
  TipoVeiculoRepo createTipoVeiculoRepo() => TipoVeiculoRepo(dio: dio, db: db);

  /// Cria TipoEquipeRepo com dependências injetadas.
  TipoEquipeRepo createTipoEquipeRepo() => TipoEquipeRepo(dio: dio, db: db);

  // ==========================================================================
  // REPOSITORIES DE CHECKLIST
  // ==========================================================================

  /// Cria ChecklistModeloRepo com dependências injetadas.
  ChecklistModeloRepo createChecklistModeloRepo() =>
      ChecklistModeloRepo(dio: dio, db: db);

  /// Cria ChecklistPerguntaRepo com dependências injetadas.
  ChecklistPerguntaRepo createChecklistPerguntaRepo() =>
      ChecklistPerguntaRepo(dio: dio, db: db);

  /// Cria ChecklistOpcaoRespostaRepo com dependências injetadas.
  ChecklistOpcaoRespostaRepo createChecklistOpcaoRespostaRepo() =>
      ChecklistOpcaoRespostaRepo(dio: dio, db: db);

  /// Cria ChecklistPreenchidoRepo com dependências injetadas.
  /// NOTA: Este repo recebe apenas o DAO diretamente
  ChecklistPreenchidoRepo createChecklistPreenchidoRepo() =>
      ChecklistPreenchidoRepo(db.checklistPreenchidoDao);

  /// Cria ChecklistRespostaRepo com dependências injetadas.
  /// NOTA: Este repo recebe apenas o DAO diretamente
  ChecklistRespostaRepo createChecklistRespostaRepo() =>
      ChecklistRespostaRepo(db.checklistRespostaDao);

  // ==========================================================================
  // REPOSITORIES DE RELAÇÃO (CHECKLIST)
  // ==========================================================================

  /// Cria ChecklistPerguntaRelacaoRepo com dependências injetadas.
  ChecklistPerguntaRelacaoRepo createChecklistPerguntaRelacaoRepo() =>
      ChecklistPerguntaRelacaoRepo(dio: dio, db: db);

  /// Cria ChecklistOpcaoRespostaRelacaoRepo com dependências injetadas.
  ChecklistOpcaoRespostaRelacaoRepo createChecklistOpcaoRespostaRelacaoRepo() =>
      ChecklistOpcaoRespostaRelacaoRepo(dio: dio, db: db);

  /// Cria ChecklistTipoVeiculoRelacaoRepo com dependências injetadas.
  ChecklistTipoVeiculoRelacaoRepo createChecklistTipoVeiculoRelacaoRepo() =>
      ChecklistTipoVeiculoRelacaoRepo(dio: dio, db: db);

  /// Cria ChecklistTipoEquipeRelacaoRepo com dependências injetadas.
  ChecklistTipoEquipeRelacaoRepo createChecklistTipoEquipeRelacaoRepo() =>
      ChecklistTipoEquipeRelacaoRepo(dio: dio, db: db);
}

