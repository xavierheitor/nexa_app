import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/turno_eletricistas_table.dart';
import 'package:nexa_app/data/models/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

part 'turno_eletricistas_dao.g.dart';

/// DAO para gerenciar operações da tabela TurnoEletricistasTable.
///
/// Fornece métodos para CRUD básico e operações específicas de relacionamento
/// entre turnos e eletricistas, incluindo busca por turno e eletricista.
@DriftAccessor(tables: [TurnoEletricistasTable])
class TurnoEletricistasDao extends DatabaseAccessor<AppDatabase> with _$TurnoEletricistasDaoMixin {
  TurnoEletricistasDao(super.db);

  /// Lista todos os relacionamentos turno-eletricista.
  Future<List<TurnoEletricistasTableDto>> listar() async {
    try {
      AppLogger.d('Listando todos os relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao');
      final relacionamentos = await select(db.turnoEletricistasTable).get();
      final dtos = relacionamentos.map((rel) => TurnoEletricistasTableDto.fromTable(rel)).toList();
      AppLogger.d('${dtos.length} relacionamentos encontrados', tag: 'TurnoEletricistasDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca relacionamento por ID.
  Future<TurnoEletricistasTableDto?> buscarPorId(int id) async {
    try {
      AppLogger.d('Buscando relacionamento por ID: $id', tag: 'TurnoEletricistasDao');
      final relacionamento = await (select(db.turnoEletricistasTable)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (relacionamento != null) {
        AppLogger.d('Relacionamento encontrado: ${relacionamento.id}', tag: 'TurnoEletricistasDao');
        return TurnoEletricistasTableDto.fromTable(relacionamento);
      }
      AppLogger.d('Relacionamento não encontrado', tag: 'TurnoEletricistasDao');
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar relacionamento por ID', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca eletricistas de um turno específico.
  Future<List<TurnoEletricistasTableDto>> buscarPorTurno(int turnoId) async {
    try {
      AppLogger.d('Buscando eletricistas do turno: $turnoId', tag: 'TurnoEletricistasDao');
      final relacionamentos = await (select(db.turnoEletricistasTable)..where((t) => t.turnoId.equals(turnoId))).get();
      final dtos = relacionamentos.map((rel) => TurnoEletricistasTableDto.fromTable(rel)).toList();
      AppLogger.d('${dtos.length} eletricistas encontrados para o turno $turnoId', tag: 'TurnoEletricistasDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar eletricistas do turno', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos de um eletricista específico.
  Future<List<TurnoEletricistasTableDto>> buscarPorEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Buscando turnos do eletricista: $eletricistaId', tag: 'TurnoEletricistasDao');
      final relacionamentos = await (select(db.turnoEletricistasTable)..where((t) => t.eletricistaId.equals(eletricistaId))).get();
      final dtos = relacionamentos.map((rel) => TurnoEletricistasTableDto.fromTable(rel)).toList();
      AppLogger.d('${dtos.length} turnos encontrados para o eletricista $eletricistaId', tag: 'TurnoEletricistasDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos do eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se um eletricista está em um turno específico.
  Future<bool> eletricistaEstaNoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Verificando se eletricista $eletricistaId está no turno $turnoId', tag: 'TurnoEletricistasDao');
      final relacionamento = await (select(db.turnoEletricistasTable)
        ..where((t) => t.turnoId.equals(turnoId) & t.eletricistaId.equals(eletricistaId))).getSingleOrNull();
      final existe = relacionamento != null;
      AppLogger.d('Eletricista ${existe ? 'está' : 'não está'} no turno', tag: 'TurnoEletricistasDao');
      return existe;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar se eletricista está no turno', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Insere um novo relacionamento turno-eletricista.
  Future<int> inserir(TurnoEletricistasTableDto dto) async {
    try {
      AppLogger.d('Inserindo relacionamento turno-eletricista', tag: 'TurnoEletricistasDao');
      
      final relacionamentoCompanion = TurnoEletricistasTableCompanion(
        id: dto.id > 0 ? Value(dto.id) : const Value.absent(),
        turnoId: Value(dto.turnoId),
        eletricistaId: Value(dto.eletricistaId),
        motorista: Value(dto.motorista),
      );

      final id = await into(db.turnoEletricistasTable).insert(relacionamentoCompanion);
      AppLogger.d('Relacionamento salvo com ID: $id', tag: 'TurnoEletricistasDao');
      return id;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao inserir relacionamento turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Insere múltiplos relacionamentos turno-eletricista.
  Future<List<int>> inserirMultiplos(List<TurnoEletricistasTableDto> dtos) async {
    try {
      AppLogger.d('Inserindo ${dtos.length} relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao');
      
      final relacionamentosCompanion = dtos.map((dto) => TurnoEletricistasTableCompanion(
        id: dto.id > 0 ? Value(dto.id) : const Value.absent(),
        turnoId: Value(dto.turnoId),
        eletricistaId: Value(dto.eletricistaId),
                motorista: Value(dto.motorista),
      )).toList();

      final ids = <int>[];
      await batch((batch) {
        for (final companion in relacionamentosCompanion) {
          batch.insert(db.turnoEletricistasTable, companion);
        }
      });
      
      AppLogger.d('${dtos.length} relacionamentos salvos', tag: 'TurnoEletricistasDao');
      return ids;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao inserir múltiplos relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Atualiza um relacionamento existente.
  Future<bool> atualizar(TurnoEletricistasTableDto dto) async {
    try {
      AppLogger.d('Atualizando relacionamento: ${dto.id}', tag: 'TurnoEletricistasDao');
      
      final relacionamentoCompanion = TurnoEletricistasTableCompanion(
        turnoId: Value(dto.turnoId),
        eletricistaId: Value(dto.eletricistaId),
      );

      final linhasAfetadas = await (update(db.turnoEletricistasTable)..where((t) => t.id.equals(dto.id))).write(relacionamentoCompanion);
      final sucesso = linhasAfetadas > 0;
      AppLogger.d('Relacionamento atualizado: $sucesso', tag: 'TurnoEletricistasDao');
      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar relacionamento turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta um relacionamento por ID.
  Future<bool> deletar(int id) async {
    try {
      AppLogger.d('Deletando relacionamento: $id', tag: 'TurnoEletricistasDao');
      final linhasAfetadas = await (delete(db.turnoEletricistasTable)..where((t) => t.id.equals(id))).go();
      final sucesso = linhasAfetadas > 0;
      AppLogger.d('Relacionamento deletado: $sucesso', tag: 'TurnoEletricistasDao');
      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar relacionamento turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta todos os relacionamentos de um turno.
  Future<int> deletarPorTurno(int turnoId) async {
    try {
      AppLogger.d('Deletando todos os relacionamentos do turno: $turnoId', tag: 'TurnoEletricistasDao');
      final linhasAfetadas = await (delete(db.turnoEletricistasTable)..where((t) => t.turnoId.equals(turnoId))).go();
      AppLogger.d('$linhasAfetadas relacionamentos deletados do turno $turnoId', tag: 'TurnoEletricistasDao');
      return linhasAfetadas;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar relacionamentos do turno', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta todos os relacionamentos de um eletricista.
  Future<int> deletarPorEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Deletando todos os relacionamentos do eletricista: $eletricistaId', tag: 'TurnoEletricistasDao');
      final linhasAfetadas = await (delete(db.turnoEletricistasTable)..where((t) => t.eletricistaId.equals(eletricistaId))).go();
      AppLogger.d('$linhasAfetadas relacionamentos deletados do eletricista $eletricistaId', tag: 'TurnoEletricistasDao');
      return linhasAfetadas;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar relacionamentos do eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta todos os relacionamentos.
  Future<int> deletarTodos() async {
    try {
      AppLogger.d('Deletando todos os relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao');
      final linhasAfetadas = await delete(db.turnoEletricistasTable).go();
      AppLogger.d('$linhasAfetadas relacionamentos deletados', tag: 'TurnoEletricistasDao');
      return linhasAfetadas;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar todos os relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta total de relacionamentos.
  Future<int> contar() async {
    try {
      AppLogger.d('Contando relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao');
      final query = selectOnly(db.turnoEletricistasTable)..addColumns([db.turnoEletricistasTable.id.count()]);
      final result = await query.map((row) => row.read(db.turnoEletricistasTable.id.count())).getSingle();
      AppLogger.d('Total de relacionamentos: $result', tag: 'TurnoEletricistasDao');
      return result ?? 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar relacionamentos turno-eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta eletricistas de um turno.
  Future<int> contarPorTurno(int turnoId) async {
    try {
      AppLogger.d('Contando eletricistas do turno: $turnoId', tag: 'TurnoEletricistasDao');
      final query = selectOnly(db.turnoEletricistasTable)
        ..where(db.turnoEletricistasTable.turnoId.equals(turnoId))
        ..addColumns([db.turnoEletricistasTable.id.count()]);
      final result = await query.map((row) => row.read(db.turnoEletricistasTable.id.count())).getSingle();
      AppLogger.d('Total de eletricistas no turno $turnoId: $result', tag: 'TurnoEletricistasDao');
      return result ?? 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar eletricistas do turno', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos de um eletricista.
  Future<int> contarPorEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Contando turnos do eletricista: $eletricistaId', tag: 'TurnoEletricistasDao');
      final query = selectOnly(db.turnoEletricistasTable)
        ..where(db.turnoEletricistasTable.eletricistaId.equals(eletricistaId))
        ..addColumns([db.turnoEletricistasTable.id.count()]);
      final result = await query.map((row) => row.read(db.turnoEletricistasTable.id.count())).getSingle();
      AppLogger.d('Total de turnos do eletricista $eletricistaId: $result', tag: 'TurnoEletricistasDao');
      return result ?? 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos do eletricista', tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS PARA MOTORISTA
  // ============================================================================

  /// Busca o motorista de um turno.
  Future<TurnoEletricistasTableData?> buscarMotoristaPorTurno(
      int turnoId) async {
    try {
      AppLogger.d('Buscando motorista do turno: $turnoId',
          tag: 'TurnoEletricistasDao');
      final query = select(db.turnoEletricistasTable)
        ..where((tbl) => tbl.turnoId.equals(turnoId))
        ..where((tbl) => tbl.motorista.equals(true));
      return await query.getSingleOrNull();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar motorista do turno',
          tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Define um eletricista como motorista de um turno.
  /// Remove a flag de motorista dos outros eletricistas do mesmo turno.
  Future<void> definirMotorista(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d(
          'Definindo eletricista $eletricistaId como motorista do turno $turnoId',
          tag: 'TurnoEletricistasDao');

      await transaction(() async {
        // Primeiro, remove a flag de motorista de todos os eletricistas do turno
        await (update(db.turnoEletricistasTable)
              ..where((tbl) => tbl.turnoId.equals(turnoId)))
            .write(
                const TurnoEletricistasTableCompanion(motorista: Value(false)));

        // Depois, marca o eletricista especificado como motorista
        await (update(db.turnoEletricistasTable)
              ..where((tbl) => tbl.turnoId.equals(turnoId))
              ..where((tbl) => tbl.eletricistaId.equals(eletricistaId)))
            .write(
                const TurnoEletricistasTableCompanion(motorista: Value(true)));
      });

      AppLogger.i('Motorista definido com sucesso',
          tag: 'TurnoEletricistasDao');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao definir motorista',
          tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove a flag de motorista de todos os eletricistas de um turno.
  Future<void> removerMotorista(int turnoId) async {
    try {
      AppLogger.d('Removendo motorista do turno: $turnoId',
          tag: 'TurnoEletricistasDao');
      await (update(db.turnoEletricistasTable)
            ..where((tbl) => tbl.turnoId.equals(turnoId)))
          .write(
              const TurnoEletricistasTableCompanion(motorista: Value(false)));
      AppLogger.i('Motorista removido com sucesso',
          tag: 'TurnoEletricistasDao');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover motorista',
          tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se um eletricista é o motorista de um turno.
  Future<bool> ehMotorista(int turnoId, int eletricistaId) async {
    try {
      final query = select(db.turnoEletricistasTable)
        ..where((tbl) => tbl.turnoId.equals(turnoId))
        ..where((tbl) => tbl.eletricistaId.equals(eletricistaId))
        ..where((tbl) => tbl.motorista.equals(true));
      final result = await query.getSingleOrNull();
      return result != null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar se é motorista',
          tag: 'TurnoEletricistasDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
