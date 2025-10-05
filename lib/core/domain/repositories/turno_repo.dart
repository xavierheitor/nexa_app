import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/turno_dao.dart';
import 'package:nexa_app/core/database/daos/turno_eletricistas_dao.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório unificado para gerenciar turnos e seus eletricistas.
///
/// Este repositório combina operações de turno e relacionamentos turno-eletricista
/// em uma única interface, já que eles sempre trabalham juntos no contexto
/// de abertura e fechamento de turnos.
class TurnoRepo {
  // ignore: unused_field
  final DioClient _dio; // TODO: Será usado para sincronização com API
  final AppDatabase _db;
  late final TurnoDao _turnoDao;
  late final TurnoEletricistasDao _turnoEletricistasDao;

  TurnoRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _turnoDao = TurnoDao(_db);
    _turnoEletricistasDao = TurnoEletricistasDao(_db);
  }

  // ============================================================================
  // OPERAÇÕES DE TURNO
  // ============================================================================

  /// Lista todos os turnos.
  Future<List<TurnoTableDto>> listarTurnos() async {
    try {
      AppLogger.d('Listando todos os turnos', tag: 'TurnoRepo');
      return await _turnoDao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar turnos', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID.
  Future<TurnoTableDto?> buscarTurnoPorId(int id) async {
    try {
      AppLogger.d('Buscando turno por ID: $id', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por ID', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID remoto.
  Future<TurnoTableDto?> buscarTurnoPorRemoteId(int remoteId) async {
    try {
      AppLogger.d('Buscando turno por remote ID: $remoteId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorRemoteId(remoteId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por remote ID', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno ativo (em abertura).
  Future<TurnoTableDto?> buscarTurnoAtivo() async {
    try {
      AppLogger.d('Buscando turno ativo', tag: 'TurnoRepo');
      return await _turnoDao.buscarTurnoAtivo();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno ativo', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por situação.
  Future<List<TurnoTableDto>> buscarTurnosPorSituacao(SituacaoTurno situacao) async {
    try {
      AppLogger.d('Buscando turnos por situação: ${situacao.name}', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorSituacao(situacao);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por situação', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por veículo.
  Future<List<TurnoTableDto>> buscarTurnosPorVeiculo(int veiculoId) async {
    try {
      AppLogger.d('Buscando turnos por veículo: $veiculoId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorVeiculo(veiculoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por veículo', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por equipe.
  Future<List<TurnoTableDto>> buscarTurnosPorEquipe(int equipeId) async {
    try {
      AppLogger.d('Buscando turnos por equipe: $equipeId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorEquipe(equipeId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por equipe', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Salva um turno (insere ou atualiza).
  Future<int> salvarTurno(TurnoTableDto turno) async {
    try {
      AppLogger.d('Salvando turno', tag: 'TurnoRepo');
      return await _turnoDao.inserirOuAtualizar(turno);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao salvar turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Atualiza um turno existente.
  Future<bool> atualizarTurno(TurnoTableDto turno) async {
    try {
      AppLogger.d('Atualizando turno: ${turno.id}', tag: 'TurnoRepo');
      return await _turnoDao.atualizar(turno);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta um turno.
  Future<bool> deletarTurno(int turnoId) async {
    try {
      AppLogger.d('Deletando turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoDao.deletar(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta total de turnos.
  Future<int> contarTurnos() async {
    try {
      AppLogger.d('Contando turnos', tag: 'TurnoRepo');
      return await _turnoDao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos por situação.
  Future<int> contarTurnosPorSituacao(SituacaoTurno situacao) async {
    try {
      AppLogger.d('Contando turnos por situação: ${situacao.name}', tag: 'TurnoRepo');
      return await _turnoDao.contarPorSituacao(situacao);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos por situação', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // OPERAÇÕES DE ELETRICISTAS DO TURNO
  // ============================================================================

  /// Busca eletricistas de um turno específico.
  Future<List<TurnoEletricistasTableDto>> buscarEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('Buscando eletricistas do turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.buscarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar eletricistas do turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos de um eletricista específico.
  Future<List<TurnoEletricistasTableDto>> buscarTurnosDoEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Buscando turnos do eletricista: $eletricistaId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.buscarPorEletricista(eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos do eletricista', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se um eletricista está em um turno específico.
  Future<bool> eletricistaEstaNoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Verificando se eletricista $eletricistaId está no turno $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.eletricistaEstaNoTurno(turnoId, eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar se eletricista está no turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Adiciona um eletricista a um turno.
  Future<int> adicionarEletricistaAoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Adicionando eletricista $eletricistaId ao turno $turnoId', tag: 'TurnoRepo');
      
      final relacionamento = TurnoEletricistasTableDto(
        id: 0, // Será gerado automaticamente
        turnoId: turnoId,
        eletricistaId: eletricistaId,
      );
      
      return await _turnoEletricistasDao.inserir(relacionamento);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar eletricista ao turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Adiciona múltiplos eletricistas a um turno.
  Future<void> adicionarEletricistasAoTurno(int turnoId, List<int> eletricistaIds) async {
    try {
      AppLogger.d('Adicionando ${eletricistaIds.length} eletricistas ao turno $turnoId', tag: 'TurnoRepo');
      
      final relacionamentos = eletricistaIds.map((eletricistaId) => TurnoEletricistasTableDto(
        id: 0, // Será gerado automaticamente
        turnoId: turnoId,
        eletricistaId: eletricistaId,
      )).toList();
      
      await _turnoEletricistasDao.inserirMultiplos(relacionamentos);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar eletricistas ao turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove um eletricista de um turno.
  Future<bool> removerEletricistaDoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Removendo eletricista $eletricistaId do turno $turnoId', tag: 'TurnoRepo');
      
      // Busca o relacionamento específico
      final relacionamentos = await _turnoEletricistasDao.buscarPorTurno(turnoId);
      final relacionamento = relacionamentos.firstWhere(
        (r) => r.eletricistaId == eletricistaId,
        orElse: () => throw Exception('Eletricista não encontrado no turno'),
      );
      
      return await _turnoEletricistasDao.deletar(relacionamento.id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover eletricista do turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove todos os eletricistas de um turno.
  Future<int> removerTodosEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('Removendo todos os eletricistas do turno $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.deletarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover todos os eletricistas do turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta eletricistas de um turno.
  Future<int> contarEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('Contando eletricistas do turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.contarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar eletricistas do turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos de um eletricista.
  Future<int> contarTurnosDoEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Contando turnos do eletricista: $eletricistaId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.contarPorEletricista(eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos do eletricista', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // OPERAÇÕES COMPOSTAS (TURNO + ELETRICISTAS)
  // ============================================================================

  /// Abre um novo turno com eletricistas.
  ///
  /// Cria um turno e adiciona os eletricistas especificados em uma transação.
  Future<int> abrirTurno({
    required int veiculoId,
    required int equipeId,
    required int kmInicial,
    required List<int> eletricistaIds,
    String? latitude,
    String? longitude,
  }) async {
    try {
      AppLogger.d('Abrindo novo turno com ${eletricistaIds.length} eletricistas', tag: 'TurnoRepo');
      
      // Cria o turno
      final turno = TurnoTableDto(
        id: 0, // Será gerado automaticamente
        veiculoId: veiculoId,
        equipeId: equipeId,
        kmInicial: kmInicial,
        horaInicio: DateTime.now(),
        situacaoTurno: SituacaoTurno.emAbertura,
        latitude: latitude,
        longitude: longitude,
      );
      
      final turnoId = await salvarTurno(turno);
      
      // Adiciona os eletricistas
      if (eletricistaIds.isNotEmpty) {
        await adicionarEletricistasAoTurno(turnoId, eletricistaIds);
      }
      
      AppLogger.d('Turno $turnoId aberto com sucesso', tag: 'TurnoRepo');
      return turnoId;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao abrir turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Fecha um turno existente.
  ///
  /// Atualiza a situação do turno para fechado e define hora de fim.
  Future<bool> fecharTurno(int turnoId, {int? kmFinal}) async {
    try {
      AppLogger.d('Fechando turno: $turnoId', tag: 'TurnoRepo');
      
      final turno = await buscarTurnoPorId(turnoId);
      if (turno == null) {
        throw Exception('Turno não encontrado');
      }
      
      final turnoAtualizado = turno.copyWith(
        situacaoTurno: SituacaoTurno.fechado,
        horaFim: DateTime.now(),
        kmFinal: kmFinal,
      );
      
      final sucesso = await atualizarTurno(turnoAtualizado);
      
      if (sucesso) {
        AppLogger.d('Turno $turnoId fechado com sucesso', tag: 'TurnoRepo');
      }
      
      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fechar turno', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno completo com seus eletricistas.
  ///
  /// Retorna o turno e a lista de IDs dos eletricistas associados.
  Future<Map<String, dynamic>?> buscarTurnoCompleto(int turnoId) async {
    try {
      AppLogger.d('Buscando turno completo: $turnoId', tag: 'TurnoRepo');
      
      final turno = await buscarTurnoPorId(turnoId);
      if (turno == null) return null;
      
      final eletricistas = await buscarEletricistasDoTurno(turnoId);
      final eletricistaIds = eletricistas.map((e) => e.eletricistaId).toList();
      
      return {
        'turno': turno,
        'eletricistaIds': eletricistaIds,
      };
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno completo', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se existe turno ativo.
  Future<bool> temTurnoAtivo() async {
    try {
      AppLogger.d('Verificando se existe turno ativo', tag: 'TurnoRepo');
      final turnoAtivo = await buscarTurnoAtivo();
      return turnoAtivo != null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar turno ativo', tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
