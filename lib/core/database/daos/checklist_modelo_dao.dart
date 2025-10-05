import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_modelo_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

part 'checklist_modelo_dao.g.dart';

/// DAO para operações com a tabela ChecklistModelo.
@DriftAccessor(tables: [ChecklistModeloTable])
class ChecklistModeloDao extends DatabaseAccessor<AppDatabase> with _$ChecklistModeloDaoMixin {
  ChecklistModeloDao(super.db);

  /// Lista todos os modelos de checklist.
  Future<List<ChecklistModeloTableDto>> listar() async {
    return await (select(db.checklistModeloTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .get();
  }

  /// Busca um modelo por ID.
  Future<ChecklistModeloTableDto?> buscarPorId(int id) async {
    final result = await (select(db.checklistModeloTable)
          ..where((t) => t.id.equals(id)))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca um modelo por remote ID.
  Future<ChecklistModeloTableDto?> buscarPorRemoteId(int remoteId) async {
    final result = await (select(db.checklistModeloTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca modelos por tipo de checklist.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklist(int tipoChecklistId) async {
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
  Future<List<ChecklistModeloTableDto>> buscarPorTipoVeiculo(int tipoVeiculoId) async {
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
    final query = select(db.checklistModeloTable)
        .join([
          leftOuterJoin(
            db.checklistTipoVeiculoRelacaoTable,
        db.checklistTipoVeiculoRelacaoTable.checklistModeloId
            .equalsExp(db.checklistModeloTable.remoteId),
          )
        ])
        ..where(db.checklistTipoVeiculoRelacaoTable.tipoVeiculoId.equals(tipoVeiculoId))
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


  /// Busca modelos por nome (busca parcial).
  Future<List<ChecklistModeloTableDto>> buscarPorNome(String nome) async {
    return await (select(db.checklistModeloTable)
          ..where((t) => t.nome.like('%$nome%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistModeloTableDto.fromTable(row))
        .get();
  }

  /// Insere ou atualiza um modelo.
  Future<int> inserirOuAtualizar(ChecklistModeloTableDto modelo) async {
    return await into(db.checklistModeloTable).insertOnConflictUpdate(
      modelo.toCompanion(),
    );
  }

  /// Atualiza um modelo existente.
  Future<bool> atualizar(ChecklistModeloTableDto modelo) async {
    final result = await (update(db.checklistModeloTable)
          ..where((t) => t.id.equals(modelo.id)))
        .write(modelo.toCompanion());
    return result > 0;
  }

  /// Deleta um modelo.
  Future<bool> deletar(int id) async {
    final result = await (delete(db.checklistModeloTable)
          ..where((t) => t.id.equals(id)))
        .go();
    return result > 0;
  }

  /// Deleta todos os modelos.
  Future<int> deletarTodos() async {
    return await delete(db.checklistModeloTable).go();
  }

  /// Conta o total de modelos.
  Future<int> contar() async {
    final lista = await listar();
    return lista.length;
  }

  /// Conta modelos por tipo de checklist.
  Future<int> contarPorTipoChecklist(int tipoChecklistId) async {
    final lista = await buscarPorTipoChecklist(tipoChecklistId);
    return lista.length;
  }
}
