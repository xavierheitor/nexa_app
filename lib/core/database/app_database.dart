/// Banco de dados local (SQLite) usando Drift.
///
/// - Define as tabelas em `tables/schema.dart`
/// - Usa `LoggingExecutor` para logar statements (configurável)
/// - `schemaVersion` controla migrações futuras

/// ao criar uma nova tabela, é necessário rodar o comando:
/// flutter pub run build_runner build
/// para gerar o arquivo de migração
/// flutter pub run build_runner build --delete-conflicting-outputs
/// para deletar o arquivo de migração
/// flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/database/daos/usuario_dao.dart';
import 'package:nexa_app/core/database/daos/tipo_veiculo_dao.dart';
import 'package:nexa_app/core/database/daos/veiculo_dao.dart';
import 'package:nexa_app/core/database/daos/tipo_equipe_dao.dart';
import 'package:nexa_app/core/database/daos/equipe_dao.dart';
import 'package:nexa_app/core/database/daos/eletricista_dao.dart';
import 'package:nexa_app/core/database/daos/turno_dao.dart';
import 'package:nexa_app/core/database/daos/turno_eletricistas_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_modelo_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_pergunta_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_opcao_resposta_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_pergunta_relacao_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_opcao_resposta_relacao_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_tipo_equipe_relacao_dao.dart';
import 'package:nexa_app/core/database/daos/checklist_tipo_veiculo_relacao_dao.dart';
import 'package:nexa_app/core/database/logging_executor.dart';
import 'package:nexa_app/core/database/models/eletricista_table.dart';
import 'package:nexa_app/core/database/models/equipe_table.dart';
import 'package:nexa_app/core/database/models/tipo_equipe_table.dart';
import 'package:nexa_app/core/database/models/turno_eletricistas_table.dart';
import 'package:nexa_app/core/database/models/turno_table.dart';
import 'package:nexa_app/core/database/models/usuario_table.dart';
import 'package:nexa_app/core/database/models/tipo_veiculo_table.dart';
import 'package:nexa_app/core/database/models/veiculo_table.dart';
import 'package:nexa_app/core/database/models/checklist_modelo_table.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_table.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_table.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_relacao_table.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_relacao_table.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_equipe_relacao_table.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_veiculo_relacao_table.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// ignore: uri_does_not_exist
part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nexa2.sqlite'));

    final nativeDb = NativeDatabase(
      file,
      // logStatements: true,
    );
    return LoggingExecutor(nativeDb);
  });
}

@DriftDatabase(
  tables: [
    UsuarioTable,
    TipoVeiculoTable,
    VeiculoTable,
    TipoEquipeTable,
    EquipeTable,
    EletricistaTable,
    TurnoTable,
    TurnoEletricistasTable,
    ChecklistModeloTable,
    ChecklistPerguntaTable,
    ChecklistOpcaoRespostaTable,
    ChecklistOpcaoRespostaRelacaoTable,
    ChecklistPerguntaRelacaoTable,
    ChecklistTipoEquipeRelacaoTable,
    ChecklistTipoVeiculoRelacaoTable,
  ],
  daos: [
    UsuarioDao,
    TipoVeiculoDao,
    VeiculoDao,
    TipoEquipeDao,
    EquipeDao,
    EletricistaDao,
    TurnoDao,
    TurnoEletricistasDao,
    ChecklistModeloDao,
    ChecklistPerguntaDao,
    ChecklistOpcaoRespostaDao,
    ChecklistPerguntaRelacaoDao,
    ChecklistOpcaoRespostaRelacaoDao,
    ChecklistTipoEquipeRelacaoDao,
    ChecklistTipoVeiculoRelacaoDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    AppLogger.d('🗃️ AppDatabase iniciado');
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from == 5 && to == 6) {
            // Migration: adicionar tabelas de checklist
            await m.createAll();
          }
          // versões futuras aqui
        },
        beforeOpen: (details) async {
          // Você pode fazer verificação, popular tabelas, logs, etc.
          if (details.wasCreated) {
            // Seed inicial se necessário
          }
        },
      );
}
