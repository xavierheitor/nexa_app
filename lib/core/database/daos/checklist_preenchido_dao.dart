import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_preenchido_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

part 'checklist_preenchido_dao.g.dart';

@DriftAccessor(tables: [ChecklistPreenchidoTable])
class ChecklistPreenchidoDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistPreenchidoDaoMixin {
  ChecklistPreenchidoDao(AppDatabase db) : super(db);

  /// Lista todos os checklists preenchidos
  Future<List<ChecklistPreenchidoTableDto>> listar() async {
    AppLogger.d('Listando todos os checklists preenchidos', tag: 'ChecklistPreenchidoDao');
    
    final results = await select(checklistPreenchidoTable).get();
    return results.map((row) => ChecklistPreenchidoTableDto.fromEntity(row)).toList();
  }

  /// Busca checklist preenchido por ID
  Future<ChecklistPreenchidoTableDto?> buscarPorId(int id) async {
    AppLogger.d('Buscando checklist preenchido por ID: $id', tag: 'ChecklistPreenchidoDao');
    
    try {
      final result = await (select(checklistPreenchidoTable)
            ..where((c) => c.id.equals(id)))
          .getSingleOrNull();
      
      if (result == null) {
        AppLogger.w('Checklist preenchido não encontrado para ID: $id', tag: 'ChecklistPreenchidoDao');
        return null;
      }
      
      return ChecklistPreenchidoTableDto.fromEntity(result);
    } catch (e) {
      AppLogger.e('Erro ao buscar checklist preenchido por ID: $e', tag: 'ChecklistPreenchidoDao');
      return null;
    }
  }

  /// Busca checklists preenchidos por turno
  Future<List<ChecklistPreenchidoTableDto>> buscarPorTurno(int turnoId) async {
    AppLogger.d('Buscando checklists preenchidos por turno: $turnoId', tag: 'ChecklistPreenchidoDao');
    
    final results = await (select(checklistPreenchidoTable)
          ..where((c) => c.turnoId.equals(turnoId))
          ..orderBy([(c) => OrderingTerm.desc(c.dataPreenchimento)]))
        .get();
    
    return results.map((row) => ChecklistPreenchidoTableDto.fromEntity(row)).toList();
  }

  /// Busca checklists preenchidos por modelo de checklist
  Future<List<ChecklistPreenchidoTableDto>> buscarPorModelo(int checklistModeloId) async {
    AppLogger.d('Buscando checklists preenchidos por modelo: $checklistModeloId', tag: 'ChecklistPreenchidoDao');
    
    final results = await (select(checklistPreenchidoTable)
          ..where((c) => c.checklistModeloId.equals(checklistModeloId))
          ..orderBy([(c) => OrderingTerm.desc(c.dataPreenchimento)]))
        .get();
    
    return results.map((row) => ChecklistPreenchidoTableDto.fromEntity(row)).toList();
  }

  /// Insere um novo checklist preenchido
  Future<int> inserir(ChecklistPreenchidoTableDto dto) async {
    AppLogger.d('Inserindo checklist preenchido para turno: ${dto.turnoId}', tag: 'ChecklistPreenchidoDao');
    
    try {
      final companion = dto.toCompanion();
      final id = await into(checklistPreenchidoTable).insert(companion);
      
      AppLogger.i('Checklist preenchido inserido com ID: $id', tag: 'ChecklistPreenchidoDao');
      return id;
    } catch (e) {
      AppLogger.e('Erro ao inserir checklist preenchido: $e', tag: 'ChecklistPreenchidoDao');
      rethrow;
    }
  }

  /// Atualiza um checklist preenchido
  Future<bool> atualizar(ChecklistPreenchidoTableDto dto) async {
    AppLogger.d('Atualizando checklist preenchido ID: ${dto.id}', tag: 'ChecklistPreenchidoDao');
    
    try {
      final companion = dto.toCompanion();
      final updated = await update(checklistPreenchidoTable).replace(companion);
      
      AppLogger.i('Checklist preenchido atualizado: $updated', tag: 'ChecklistPreenchidoDao');
      return updated;
    } catch (e) {
      AppLogger.e('Erro ao atualizar checklist preenchido: $e', tag: 'ChecklistPreenchidoDao');
      return false;
    }
  }

  /// Remove um checklist preenchido
  Future<bool> remover(int id) async {
    AppLogger.d('Removendo checklist preenchido ID: $id', tag: 'ChecklistPreenchidoDao');
    
    try {
      final deleted = await (delete(checklistPreenchidoTable)
            ..where((c) => c.id.equals(id)))
          .go();
      
      AppLogger.i('Checklist preenchido removido: $deleted', tag: 'ChecklistPreenchidoDao');
      return deleted > 0;
    } catch (e) {
      AppLogger.e('Erro ao remover checklist preenchido: $e', tag: 'ChecklistPreenchidoDao');
      return false;
    }
  }

  /// Conta checklists preenchidos por turno
  Future<int> contarPorTurno(int turnoId) async {
    AppLogger.d('Contando checklists preenchidos por turno: $turnoId', tag: 'ChecklistPreenchidoDao');
    
    final result = await (selectOnly(checklistPreenchidoTable)
          ..addColumns([checklistPreenchidoTable.id.count()])
          ..where(checklistPreenchidoTable.turnoId.equals(turnoId)))
        .getSingle();
    
    return result.read(checklistPreenchidoTable.id.count()) ?? 0;
  }

  /// Verifica se existe checklist preenchido para um turno
  Future<bool> existeParaTurno(int turnoId) async {
    AppLogger.d('Verificando se existe checklist preenchido para turno: $turnoId', tag: 'ChecklistPreenchidoDao');
    
    final count = await contarPorTurno(turnoId);
    return count > 0;
  }
}
