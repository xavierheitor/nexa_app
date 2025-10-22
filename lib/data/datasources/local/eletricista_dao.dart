import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/eletricista_table.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'eletricista_dao.g.dart';

/// DAO para gerenciar operações da tabela EletricistaTable.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Mantém apenas métodos específicos de negócio relacionados a eletricistas.
@DriftAccessor(tables: [EletricistaTable])
class EletricistaDao extends SyncableDao<EletricistaTable, EletricistaTableData>
    with _$EletricistaDaoMixin {
  EletricistaDao(super.db);

  @override
  TableInfo<EletricistaTable, EletricistaTableData> get table =>
      db.eletricistaTable;

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE ELETRICISTA
  // ============================================================================

  /// Busca um eletricista por matrícula.
  Future<EletricistaTableData> buscarPorMatricula(String matricula) async {
    return await (select(db.eletricistaTable)
          ..where((e) => e.matricula.equals(matricula)))
        .getSingle();
  }

  /// Busca um eletricista por matrícula (retorna null se não encontrar).
  Future<EletricistaTableData?> buscarPorMatriculaOuNull(
      String matricula) async {
    try {
      return await (select(db.eletricistaTable)
            ..where((e) => e.matricula.equals(matricula)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca eletricistas por nome (busca parcial).
  Future<List<EletricistaTableData>> buscarPorNome(String nome) async {
    return await (select(db.eletricistaTable)
          ..where((e) => e.nome.contains(nome)))
        .get();
  }

  // ============================================================================
  // MÉTODOS DE COMPATIBILIDADE
  // ============================================================================

  /// Alias para [buscarPorId] para manter compatibilidade.
  Future<EletricistaTableData?> buscarPorIdOuNull(int id) async {
    return await buscarPorId(id);
  }

  // buscarPorRemoteId() e buscarPorRemoteIdOuNull() são herdados de SyncableDao

  /// Lista todos os eletricistas (alias para listar).
  Future<List<EletricistaTableData>> listarTodos() async {
    return await listar();
  }
}
