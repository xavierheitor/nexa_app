import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_modelo_table.dart';
import 'package:nexa_app/data/models/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_modelo_dao.g.dart';

/// DAO para operações com a tabela ChecklistModelo.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Mantém métodos específicos de busca por relacionamentos (tipo equipe, tipo veículo, etc).
@DriftAccessor(tables: [ChecklistModeloTable])
class ChecklistModeloDao
    extends SyncableDao<ChecklistModeloTable, ChecklistModeloTableData>
    with _$ChecklistModeloDaoMixin {
  ChecklistModeloDao(super.db);

  @override
  TableInfo<ChecklistModeloTable, ChecklistModeloTableData> get table =>
      db.checklistModeloTable;

  // ============================================================================
  // WRAPPERS PARA DTO (Mantém compatibilidade com código existente)
  // ============================================================================

  /// Lista todos os modelos ordenados por nome (retorna DTOs).
  Future<List<ChecklistModeloTableDto>> listarDto() async {
    final results = await (select(db.checklistModeloTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return results
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .toList();
  }

  /// Busca um modelo por ID (retorna DTO).
  Future<ChecklistModeloTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null ? ChecklistModeloTableDto.fromTable(result) : null;
  }

  /// Busca um modelo por remote ID (retorna DTO ou null).
  Future<ChecklistModeloTableDto?> buscarPorRemoteIdDto(int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    return result != null ? ChecklistModeloTableDto.fromTable(result) : null;
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE CHECKLIST MODELO
  // ============================================================================

  /// Busca modelos por tipo de checklist.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklist(
      int tipoChecklistId) async {
    return await (select(db.checklistModeloTable)
          ..where((t) => t.tipoChecklistId.equals(tipoChecklistId))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .get();
  }

  /// Busca modelos por tipo de equipe.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoEquipe(
      int tipoEquipeId) async {
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Buscando checklist para tipoEquipeId: $tipoEquipeId',
        tag: 'ChecklistModeloDao');

    // Verificar se existem dados nas tabelas
    final todasRelacoes = await db.checklistTipoEquipeRelacaoDao.listar();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Total de relações tipo-equipe: ${todasRelacoes.length}',
        tag: 'ChecklistModeloDao');

    // Implementação com JOIN manual - CORREÇÃO: buscar pelo remoteId
    final query = select(db.checklistModeloTable).join([
      leftOuterJoin(
        db.checklistTipoEquipeRelacaoTable,
        db.checklistTipoEquipeRelacaoTable.checklistModeloId
            .equalsExp(db.checklistModeloTable.remoteId),
      )
    ])
      ..where(
          db.checklistTipoEquipeRelacaoTable.tipoEquipeId.equals(tipoEquipeId))
      ..orderBy([OrderingTerm.asc(db.checklistModeloTable.nome)]);

    AppLogger.d('🔍 [DIAGNÓSTICO DAO] Executando query com JOIN...',
        tag: 'ChecklistModeloDao');

    final results = await query.get();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Query executada. ${results.length} resultados encontrados',
        tag: 'ChecklistModeloDao');

    final dtos = results
        .map((row) => ChecklistModeloTableDto.fromTable(
            row.readTable(db.checklistModeloTable)))
        .toList();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Convertidos para DTOs: ${dtos.length} modelos',
        tag: 'ChecklistModeloDao');

    return dtos;
  }

  /// Busca modelos por tipo de veículo.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoVeiculo(
      int tipoVeiculoId) async {
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Buscando checklist para tipoVeiculoId: $tipoVeiculoId',
        tag: 'ChecklistModeloDao');

    // Primeiro, vamos verificar se existem dados nas tabelas
    final todosModelos = await listar();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Total de modelos de checklist: ${todosModelos.length}',
        tag: 'ChecklistModeloDao');

    final todasRelacoes = await db.checklistTipoVeiculoRelacaoDao.listar();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Total de relações tipo-veículo: ${todasRelacoes.length}',
        tag: 'ChecklistModeloDao');

    if (todasRelacoes.isNotEmpty) {
      for (int i = 0; i < todasRelacoes.length; i++) {
        final relacao = todasRelacoes[i];
        AppLogger.d(
            '🔍 [DIAGNÓSTICO DAO] Relação $i: checklistModeloId=${relacao.checklistModeloId}, tipoVeiculoId=${relacao.tipoVeiculoId}',
            tag: 'ChecklistModeloDao');
      }
    }

    // Log dos modelos para comparar
    AppLogger.d('🔍 [DIAGNÓSTICO DAO] Modelos disponíveis:',
        tag: 'ChecklistModeloDao');
    for (int i = 0; i < todosModelos.length; i++) {
      final modelo = todosModelos[i];
      AppLogger.d(
          '🔍 [DIAGNÓSTICO DAO] Modelo $i: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
          tag: 'ChecklistModeloDao');
    }

    // Implementação com JOIN manual - CORREÇÃO: buscar pelo remoteId
    final query = select(db.checklistModeloTable).join([
      leftOuterJoin(
        db.checklistTipoVeiculoRelacaoTable,
        db.checklistTipoVeiculoRelacaoTable.checklistModeloId
            .equalsExp(db.checklistModeloTable.remoteId),
      )
    ])
      ..where(db.checklistTipoVeiculoRelacaoTable.tipoVeiculoId
          .equals(tipoVeiculoId))
      ..orderBy([OrderingTerm.asc(db.checklistModeloTable.nome)]);

    AppLogger.d('🔍 [DIAGNÓSTICO DAO] Executando query com JOIN...',
        tag: 'ChecklistModeloDao');

    final results = await query.get();

    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Query executada. ${results.length} resultados brutos encontrados',
        tag: 'ChecklistModeloDao');

    if (results.isNotEmpty) {
      for (int i = 0; i < results.length; i++) {
        final row = results[i];
        final modelo = row.readTable(db.checklistModeloTable);
        final relacao =
            row.readTableOrNull(db.checklistTipoVeiculoRelacaoTable);
        AppLogger.d(
            '🔍 [DIAGNÓSTICO DAO] Resultado $i: modeloId=${modelo.id}, relacaoTipoVeiculoId=${relacao?.tipoVeiculoId}',
            tag: 'ChecklistModeloDao');
      }
    }

    final dtos = results
        .map((row) => ChecklistModeloTableDto.fromTable(
            row.readTable(db.checklistModeloTable)))
        .toList();

    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Convertidos para DTOs: ${dtos.length} modelos',
        tag: 'ChecklistModeloDao');

    return dtos;
  }

  /// Busca modelos por tipo de checklist e tipo de equipe.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklistETipoEquipe(
      int tipoChecklistId, int tipoEquipeId) async {
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Buscando checklist para tipoChecklistId: $tipoChecklistId e tipoEquipeId: $tipoEquipeId',
        tag: 'ChecklistModeloDao');

    // JOIN entre modelos de checklist e relações tipo de equipe
    final query = select(db.checklistModeloTable).join([
      leftOuterJoin(
        db.checklistTipoEquipeRelacaoTable,
        db.checklistTipoEquipeRelacaoTable.checklistModeloId
            .equalsExp(db.checklistModeloTable.remoteId),
      )
    ])
      ..where(db.checklistModeloTable.tipoChecklistId.equals(tipoChecklistId) &
          db.checklistTipoEquipeRelacaoTable.tipoEquipeId.equals(tipoEquipeId))
      ..orderBy([OrderingTerm.asc(db.checklistModeloTable.nome)]);

    AppLogger.d('🔍 [DIAGNÓSTICO DAO] Executando query com JOIN...',
        tag: 'ChecklistModeloDao');

    final results = await query.get();
    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Query executada. ${results.length} resultados encontrados',
        tag: 'ChecklistModeloDao');

    final dtos = results
        .map((row) => ChecklistModeloTableDto.fromTable(
            row.readTable(db.checklistModeloTable)))
        .toList();

    AppLogger.d(
        '🔍 [DIAGNÓSTICO DAO] Convertidos para DTOs: ${dtos.length} modelos',
        tag: 'ChecklistModeloDao');

    return dtos;
  }

  /// Busca modelos por nome (busca parcial).
  Future<List<ChecklistModeloTableDto>> buscarPorNome(String nome) async {
    return await (select(db.checklistModeloTable)
          ..where((t) => t.nome.like('%$nome%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .get();
  }

  // ============================================================================
  // MÉTODOS CUSTOMIZADOS DE UPSERT/UPDATE (para compatibilidade com DTOs)
  // ============================================================================

  /// Insere ou atualiza um modelo usando DTO.
  Future<int> inserirOuAtualizarDto(ChecklistModeloTableDto modelo) async {
    return await inserirOuAtualizar(modelo.toCompanion());
  }

  /// Atualiza um modelo existente usando DTO.
  Future<bool> atualizarDto(ChecklistModeloTableDto modelo) async {
    final result = await (update(db.checklistModeloTable)
          ..where((t) => t.id.equals(modelo.id)))
        .write(modelo.toCompanion());
    return result > 0;
  }

  /// Conta modelos por tipo de checklist.
  Future<int> contarPorTipoChecklist(int tipoChecklistId) async {
    final lista = await buscarPorTipoChecklist(tipoChecklistId);
    return lista.length;
  }
}
