import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/turno_table.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

part 'turno_dao.g.dart';

/// DAO para gerenciar operações da tabela TurnoTable.
///
/// Fornece métodos para CRUD básico e operações específicas de turno,
/// incluindo busca por situações, turnos ativos, e relacionamentos.
@DriftAccessor(tables: [TurnoTable])
class TurnoDao extends DatabaseAccessor<AppDatabase> with _$TurnoDaoMixin {
  TurnoDao(super.db);

  /// Lista todos os turnos.
  Future<List<TurnoTableDto>> listar() async {
    try {
      AppLogger.d('Listando todos os turnos', tag: 'TurnoDao');
      final turnos = await select(db.turnoTable).get();
      final dtos =
          turnos.map((turno) => TurnoTableDto.fromTable(turno)).toList();
      AppLogger.d('${dtos.length} turnos encontrados', tag: 'TurnoDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar turnos',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID local.
  Future<TurnoTableDto?> buscarPorId(int id) async {
    try {
      AppLogger.d('Buscando turno por ID: $id', tag: 'TurnoDao');
      final turno = await (select(db.turnoTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (turno != null) {
        AppLogger.d('Turno encontrado: ${turno.id}', tag: 'TurnoDao');
        return TurnoTableDto.fromTable(turno);
      }
      AppLogger.d('Turno não encontrado', tag: 'TurnoDao');
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por ID',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID remoto.
  Future<TurnoTableDto?> buscarPorRemoteId(int remoteId) async {
    try {
      AppLogger.d('Buscando turno por remote ID: $remoteId', tag: 'TurnoDao');
      final turno = await (select(db.turnoTable)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();
      if (turno != null) {
        AppLogger.d('Turno encontrado por remote ID: ${turno.id}',
            tag: 'TurnoDao');
        return TurnoTableDto.fromTable(turno);
      }
      AppLogger.d('Turno não encontrado por remote ID', tag: 'TurnoDao');
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por remote ID',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por situação.
  Future<List<TurnoTableDto>> buscarPorSituacao(SituacaoTurno situacao) async {
    try {
      AppLogger.d('Buscando turnos por situação: ${situacao.name}',
          tag: 'TurnoDao');
      final turnos = await (select(db.turnoTable)
            ..where((t) => t.situacaoTurno.equals(situacao.name)))
          .get();
      final dtos =
          turnos.map((turno) => TurnoTableDto.fromTable(turno)).toList();
      AppLogger.d(
          '${dtos.length} turnos encontrados para situação ${situacao.name}',
          tag: 'TurnoDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por situação',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno ativo (em abertura ou aberto).
  Future<TurnoTableDto?> buscarTurnoAtivo() async {
    try {
      AppLogger.d('Buscando turno ativo (emAbertura ou aberto)',
          tag: 'TurnoDao');

      // Primeiro tenta buscar turno em abertura
      var turno = await (select(db.turnoTable)
            ..where(
                (t) => t.situacaoTurno.equals(SituacaoTurno.emAbertura.name))
            ..orderBy([(t) => OrderingTerm.desc(t.id)]))
          .getSingleOrNull();

      // Se não encontrar, busca turno aberto
      turno ??= await (select(db.turnoTable)
            ..where((t) => t.situacaoTurno.equals(SituacaoTurno.aberto.name))
            ..orderBy([(t) => OrderingTerm.desc(t.id)]))
          .getSingleOrNull();

      if (turno != null) {
        AppLogger.d(
            'Turno ativo encontrado: ${turno.id} (${turno.situacaoTurno})',
            tag: 'TurnoDao');
        return TurnoTableDto.fromTable(turno);
      }

      AppLogger.d('Nenhum turno ativo encontrado', tag: 'TurnoDao');
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno ativo',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por veículo.
  Future<List<TurnoTableDto>> buscarPorVeiculo(int veiculoId) async {
    try {
      AppLogger.d('Buscando turnos por veículo: $veiculoId', tag: 'TurnoDao');
      final turnos = await (select(db.turnoTable)
            ..where((t) => t.veiculoId.equals(veiculoId)))
          .get();
      final dtos =
          turnos.map((turno) => TurnoTableDto.fromTable(turno)).toList();
      AppLogger.d('${dtos.length} turnos encontrados para veículo $veiculoId',
          tag: 'TurnoDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por veículo',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por equipe.
  Future<List<TurnoTableDto>> buscarPorEquipe(int equipeId) async {
    try {
      AppLogger.d('Buscando turnos por equipe: $equipeId', tag: 'TurnoDao');
      final turnos = await (select(db.turnoTable)
            ..where((t) => t.equipeId.equals(equipeId)))
          .get();
      final dtos =
          turnos.map((turno) => TurnoTableDto.fromTable(turno)).toList();
      AppLogger.d('${dtos.length} turnos encontrados para equipe $equipeId',
          tag: 'TurnoDao');
      return dtos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por equipe',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Insere ou atualiza um turno.
  Future<int> inserirOuAtualizar(TurnoTableDto dto) async {
    try {
      AppLogger.d('Inserindo ou atualizando turno', tag: 'TurnoDao');

      final turnoCompanion = TurnoTableCompanion(
        id: dto.id > 0 ? Value(dto.id) : const Value.absent(),
        remoteId: Value(dto.remoteId),
        veiculoId: Value(dto.veiculoId),
        equipeId: Value(dto.equipeId),
        kmInicial: Value(dto.kmInicial),
        kmFinal: Value(dto.kmFinal),
        horaInicio: Value(dto.horaInicio),
        horaFim: Value(dto.horaFim),
        latitude: Value(dto.latitude),
        longitude: Value(dto.longitude),
        situacaoTurno: Value(dto.situacaoTurno),
      );

      final id =
          await into(db.turnoTable).insertOnConflictUpdate(turnoCompanion);
      AppLogger.d('Turno salvo com ID: $id', tag: 'TurnoDao');
      return id;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao inserir ou atualizar turno',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Atualiza um turno existente.
  Future<bool> atualizar(TurnoTableDto dto) async {
    try {
      AppLogger.d('Atualizando turno: ${dto.id}', tag: 'TurnoDao');

      final turnoCompanion = TurnoTableCompanion(
        remoteId: Value(dto.remoteId),
        veiculoId: Value(dto.veiculoId),
        equipeId: Value(dto.equipeId),
        kmInicial: Value(dto.kmInicial),
        kmFinal: Value(dto.kmFinal),
        horaInicio: Value(dto.horaInicio),
        horaFim: Value(dto.horaFim),
        latitude: Value(dto.latitude),
        longitude: Value(dto.longitude),
        situacaoTurno: Value(dto.situacaoTurno),
      );

      final linhasAfetadas = await (update(db.turnoTable)
            ..where((t) => t.id.equals(dto.id)))
          .write(turnoCompanion);
      final sucesso = linhasAfetadas > 0;
      AppLogger.d('Turno atualizado: $sucesso', tag: 'TurnoDao');
      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar turno',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta um turno por ID.
  Future<bool> deletar(int id) async {
    try {
      AppLogger.d('Deletando turno: $id', tag: 'TurnoDao');
      final linhasAfetadas =
          await (delete(db.turnoTable)..where((t) => t.id.equals(id))).go();
      final sucesso = linhasAfetadas > 0;
      AppLogger.d('Turno deletado: $sucesso', tag: 'TurnoDao');
      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar turno',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta todos os turnos.
  Future<int> deletarTodos() async {
    try {
      AppLogger.d('Deletando todos os turnos', tag: 'TurnoDao');
      final linhasAfetadas = await delete(db.turnoTable).go();
      AppLogger.d('$linhasAfetadas turnos deletados', tag: 'TurnoDao');
      return linhasAfetadas;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar todos os turnos',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta total de turnos.
  Future<int> contar() async {
    try {
      AppLogger.d('Contando turnos', tag: 'TurnoDao');
      final query = selectOnly(db.turnoTable)
        ..addColumns([db.turnoTable.id.count()]);
      final result = await query
          .map((row) => row.read(db.turnoTable.id.count()))
          .getSingle();
      AppLogger.d('Total de turnos: $result', tag: 'TurnoDao');
      return result ?? 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos por situação.
  Future<int> contarPorSituacao(SituacaoTurno situacao) async {
    try {
      AppLogger.d('Contando turnos por situação: ${situacao.name}',
          tag: 'TurnoDao');
      final query = selectOnly(db.turnoTable)
        ..where(db.turnoTable.situacaoTurno.equals(situacao.name))
        ..addColumns([db.turnoTable.id.count()]);
      final result = await query
          .map((row) => row.read(db.turnoTable.id.count()))
          .getSingle();
      AppLogger.d('Total de turnos para situação ${situacao.name}: $result',
          tag: 'TurnoDao');
      return result ?? 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos por situação',
          tag: 'TurnoDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
