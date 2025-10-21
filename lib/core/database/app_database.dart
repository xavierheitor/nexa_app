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
import 'package:nexa_app/data/datasources/local/usuario_dao.dart';
import 'package:nexa_app/data/datasources/local/tipo_veiculo_dao.dart';
import 'package:nexa_app/data/datasources/local/veiculo_dao.dart';
import 'package:nexa_app/data/datasources/local/tipo_equipe_dao.dart';
import 'package:nexa_app/data/datasources/local/equipe_dao.dart';
import 'package:nexa_app/data/datasources/local/eletricista_dao.dart';
import 'package:nexa_app/data/datasources/local/turno_dao.dart';
import 'package:nexa_app/data/datasources/local/turno_eletricistas_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_modelo_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_pergunta_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_opcao_resposta_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_pergunta_relacao_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_opcao_resposta_relacao_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_tipo_equipe_relacao_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_tipo_veiculo_relacao_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_preenchido_dao.dart';
import 'package:nexa_app/data/datasources/local/checklist_resposta_dao.dart';
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
import 'package:nexa_app/core/database/models/checklist_preenchido_table.dart';
import 'package:nexa_app/core/database/models/checklist_resposta_table.dart';
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
    ChecklistPreenchidoTable,
    ChecklistRespostaTable,
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
    ChecklistPreenchidoDao,
    ChecklistRespostaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    AppLogger.d('🗃️ AppDatabase iniciado');
  }

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          AppLogger.i('📦 Criando banco de dados (schema v13)',
              tag: 'AppDatabase');
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          AppLogger.i('🔄 Migrando banco de dados de v$from para v$to',
              tag: 'AppDatabase');

          if (from == 5 && to == 6) {
            // Migration: adicionar tabelas de checklist
            await m.createAll();
          }
          if (from == 6 && to == 7) {
            // Migration: adicionar campo motorista em turno_eletricistas_table
            await m.addColumn(
                turnoEletricistasTable, turnoEletricistasTable.motorista);
          }
          if (from == 7 && to == 8) {
            // Migração: resetar banco para corrigir estrutura das tabelas
            await m.drop(veiculoTable);
            await m.drop(tipoVeiculoTable);
            await m.createTable(veiculoTable);
            await m.createTable(tipoVeiculoTable);
          }
          if (from == 8 && to == 9) {
            // Migração: resetar banco para corrigir tipos de remoteId
            await m.drop(veiculoTable);
            await m.drop(tipoVeiculoTable);
            await m.createTable(veiculoTable);
            await m.createTable(tipoVeiculoTable);
          }
          if (from == 9 && to == 10) {
            // Migração: forçar limpeza completa das tabelas problemáticas
            await m.drop(veiculoTable);
            await m.drop(tipoVeiculoTable);
            await m.createTable(veiculoTable);
            await m.createTable(tipoVeiculoTable);
          }
          if (from == 10 && to == 11) {
            // Migração: adicionar tabelas de checklist preenchido
            await m.createTable(checklistPreenchidoTable);
            await m.createTable(checklistRespostaTable);
          }
          if (from == 11 && to == 12) {
            // Migração: adicionar coluna eletricistaRemoteId em checklistPreenchidoTable
            await m.addColumn(checklistPreenchidoTable,
                checklistPreenchidoTable.eletricistaRemoteId);
          }
          if (from == 12 && to == 13) {
            // Migração v12 → v13: Adicionar Foreign Keys e Índices
            // 🎯 Objetivo: Integridade referencial + Performance
            await _migrateToV13(m);
          }
          // versões futuras aqui
        },
        beforeOpen: (details) async {
          // ✅ CRÍTICO: Habilitar foreign keys em TODA abertura do banco
          // SQLite desabilita FKs por padrão, precisamos habilitar sempre
          await customStatement('PRAGMA foreign_keys = ON');
          AppLogger.d('✅ Foreign keys habilitadas', tag: 'AppDatabase');

          if (details.wasCreated) {
            AppLogger.i('🆕 Banco de dados criado pela primeira vez',
                tag: 'AppDatabase');
          } else {
            AppLogger.d('📂 Banco de dados aberto (v${details.versionNow})',
                tag: 'AppDatabase');
          }
        },
      );

  /// Migração v12 → v13: Adicionar Foreign Keys e Índices
  ///
  /// SQLite não permite adicionar FKs em tabelas existentes via ALTER TABLE.
  /// Estratégia: Recriar tabelas com FKs preservando dados.
  Future<void> _migrateToV13(Migrator m) async {
    try {
      AppLogger.i('🔄 Iniciando migração v12 → v13 (FKs + Índices)',
          tag: 'AppDatabase');

      // ⚠️ IMPORTANTE: Desabilitar FKs temporariamente durante migração
      await customStatement('PRAGMA foreign_keys = OFF');

      // 🗂️ ORDEM DE RECRIAÇÃO (respeitar dependências)
      // 1. Tabelas sem dependências (tipos)
      // 2. Tabelas com FKs para tipos
      // 3. Tabelas com FKs para veículo/equipe
      // 4. Tabelas com FKs para turno

      // 1️⃣ Tipo Veículo (sem dependências)
      await _recreateTableIfExists(m, tipoVeiculoTable, 'tipo_veiculo_table');

      // 2️⃣ Tipo Equipe (sem dependências)
      await _recreateTableIfExists(m, tipoEquipeTable, 'tipo_equipe_table');

      // 3️⃣ Veículo (FK → tipo_veiculo)
      await _recreateTableIfExists(m, veiculoTable, 'veiculo_table');

      // 4️⃣ Equipe (FK → tipo_equipe)
      await _recreateTableIfExists(m, equipeTable, 'equipe_table');

      // 5️⃣ Turno (FK → veiculo, equipe)
      await _recreateTableIfExists(m, turnoTable, 'turno_table');

      // 6️⃣ Turno Eletricistas (FK → turno)
      await _recreateTableIfExists(
          m, turnoEletricistasTable, 'turno_eletricistas_table');

      // 7️⃣ Checklist Preenchido (FK → turno) - pode não existir em v12
      await _recreateTableIfExists(
          m, checklistPreenchidoTable, 'checklist_preenchido_table');

      // 8️⃣ Checklist Resposta (FK → checklist_preenchido) - pode não existir em v12
      await _recreateTableIfExists(
          m, checklistRespostaTable, 'checklist_resposta_table');

      // ✅ Reabilitar FKs
      await customStatement('PRAGMA foreign_keys = ON');

      // ✅ Validar integridade
      final fkCheckResult =
          await customSelect('PRAGMA foreign_key_check').get();
      if (fkCheckResult.isEmpty) {
        AppLogger.i('✅ Migração v12 → v13 concluída com sucesso',
            tag: 'AppDatabase');
        AppLogger.i('   • Foreign keys: ✅ Ativadas', tag: 'AppDatabase');
        AppLogger.i('   • Índices: ✅ Criados', tag: 'AppDatabase');
        AppLogger.i('   • Integridade: ✅ Validada', tag: 'AppDatabase');
      } else {
        AppLogger.e('❌ Violações de FK detectadas após migração',
            tag: 'AppDatabase');
        for (final row in fkCheckResult) {
          AppLogger.e('   • ${row.data}', tag: 'AppDatabase');
        }
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro na migração v12 → v13',
          error: e, stackTrace: stackTrace, tag: 'AppDatabase');
      // Reabilitar FKs mesmo em caso de erro
      await customStatement('PRAGMA foreign_keys = ON');
      rethrow;
    }
  }

  /// Verifica se tabela existe antes de recriar
  Future<void> _recreateTableIfExists(
    Migrator m,
    TableInfo table,
    String tableName,
  ) async {
    // Verificar se a tabela existe
    final result = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      variables: [Variable.withString(tableName)],
    ).get();

    if (result.isEmpty) {
      AppLogger.w('   ⚠️ Tabela $tableName não existe, criando...',
          tag: 'AppDatabase');
      await m.createTable(table);
      AppLogger.d('   ✅ Tabela $tableName criada', tag: 'AppDatabase');
      return;
    }

    AppLogger.d('   🔄 Recriando tabela: $tableName', tag: 'AppDatabase');

    try {
      // 1. Renomear tabela antiga
      await customStatement(
          'ALTER TABLE $tableName RENAME TO ${tableName}_old');

      // 2. Criar nova tabela com FKs e índices
      await m.createTable(table);

      // 3. Copiar dados (todas as colunas comuns)
      await customStatement('''
        INSERT INTO $tableName 
        SELECT * FROM ${tableName}_old
      ''');

      // 4. Dropar tabela antiga
      await customStatement('DROP TABLE ${tableName}_old');

      AppLogger.d('   ✅ Tabela $tableName recriada com sucesso',
          tag: 'AppDatabase');
    } catch (e) {
      AppLogger.e('   ❌ Erro ao recriar $tableName: $e', tag: 'AppDatabase');

      // Tentar restaurar se der erro
      try {
        await customStatement('DROP TABLE IF EXISTS $tableName');
        await customStatement(
            'ALTER TABLE ${tableName}_old RENAME TO $tableName');
        AppLogger.w('   ⚠️ Tabela $tableName restaurada ao estado anterior',
            tag: 'AppDatabase');
      } catch (restoreError) {
        AppLogger.e('   ❌ Falha ao restaurar $tableName: $restoreError',
            tag: 'AppDatabase');
      }

      rethrow;
    }
  }
}
