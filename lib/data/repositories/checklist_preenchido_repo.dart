import 'package:nexa_app/data/datasources/local/checklist_preenchido_dao.dart';
import 'package:nexa_app/data/models/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;

/// Repositório para ChecklistPreenchidoTable
class ChecklistPreenchidoRepo with log_mixin.LoggingMixin {
  final ChecklistPreenchidoDao _dao;

  ChecklistPreenchidoRepo(this._dao);

  @override
  String get repositoryName => 'ChecklistPreenchidoRepository';

  /// Lista todos os checklists preenchidos
  Future<List<ChecklistPreenchidoTableDto>> listar() async {
    AppLogger.d('Listando todos os checklists preenchidos', tag: 'ChecklistPreenchidoRepo');
    return await _dao.listar();
  }

  /// Busca checklist preenchido por ID
  Future<ChecklistPreenchidoTableDto?> buscarPorId(int id) async {
    AppLogger.d('Buscando checklist preenchido por ID: $id', tag: 'ChecklistPreenchidoRepo');
    return await _dao.buscarPorId(id);
  }

  /// Busca checklists preenchidos por turno
  Future<List<ChecklistPreenchidoTableDto>> buscarPorTurno(int turnoId) async {
    AppLogger.d('Buscando checklists preenchidos por turno: $turnoId', tag: 'ChecklistPreenchidoRepo');
    return await _dao.buscarPorTurno(turnoId);
  }

  /// Busca checklists preenchidos por modelo de checklist
  Future<List<ChecklistPreenchidoTableDto>> buscarPorModelo(int checklistModeloId) async {
    AppLogger.d('Buscando checklists preenchidos por modelo: $checklistModeloId', tag: 'ChecklistPreenchidoRepo');
    return await _dao.buscarPorModelo(checklistModeloId);
  }

  /// Busca checklists preenchidos por eletricista (remoteId)
  Future<List<ChecklistPreenchidoTableDto>> buscarPorEletricistaRemoteId(
      int eletricistaRemoteId) async {
    AppLogger.d(
        'Buscando checklists preenchidos por eletricistaRemoteId: $eletricistaRemoteId',
        tag: 'ChecklistPreenchidoRepo');
    return await _dao.buscarPorEletricistaRemoteId(eletricistaRemoteId);
  }

  /// Insere um novo checklist preenchido
  Future<int> inserir(ChecklistPreenchidoTableDto dto) async {
    AppLogger.d('Inserindo checklist preenchido para turno: ${dto.turnoId}', tag: 'ChecklistPreenchidoRepo');
    return await _dao.inserir(dto);
  }

  /// Atualiza um checklist preenchido
  Future<bool> atualizar(ChecklistPreenchidoTableDto dto) async {
    AppLogger.d('Atualizando checklist preenchido ID: ${dto.id}', tag: 'ChecklistPreenchidoRepo');
    return await _dao.atualizar(dto);
  }

  /// Remove um checklist preenchido
  Future<bool> remover(int id) async {
    AppLogger.d('Removendo checklist preenchido ID: $id', tag: 'ChecklistPreenchidoRepo');
    return await _dao.remover(id);
  }

  /// Remove todos os checklists preenchidos de um turno
  Future<int> removerPorTurno(int turnoId) async {
    AppLogger.d('Removendo todos os checklists preenchidos do turno: $turnoId',
        tag: 'ChecklistPreenchidoRepo');
    final checklists = await buscarPorTurno(turnoId);
    int removidos = 0;
    for (final checklist in checklists) {
      final sucesso = await remover(int.parse(checklist.id));
      if (sucesso) removidos++;
    }
    AppLogger.i('$removidos checklists preenchidos removidos do turno $turnoId',
        tag: 'ChecklistPreenchidoRepo');
    return removidos;
  }

  /// Conta checklists preenchidos por turno
  Future<int> contarPorTurno(int turnoId) async {
    AppLogger.d('Contando checklists preenchidos por turno: $turnoId', tag: 'ChecklistPreenchidoRepo');
    return await _dao.contarPorTurno(turnoId);
  }

  /// Verifica se existe checklist preenchido para um turno
  Future<bool> existeParaTurno(int turnoId) async {
    AppLogger.d('Verificando se existe checklist preenchido para turno: $turnoId', tag: 'ChecklistPreenchidoRepo');
    return await _dao.existeParaTurno(turnoId);
  }

  Future<int> salvarChecklistCompleto({
    required int turnoId,
    required int checklistModeloId,
    required List<Map<String, dynamic>> respostas,
    double? latitude,
    double? longitude,
    int? eletricistaRemoteId,
  }) async {
    return await executeWithLogging(
      operationName: 'salvarChecklistCompleto',
      operation: () async {
        final existente = await _dao.buscarPorChave(
          turnoId: turnoId,
          checklistModeloId: checklistModeloId,
          eletricistaRemoteId: eletricistaRemoteId,
        );

        if (existente != null) {
          AppLogger.d(
              'Checklist existente encontrado (ID ${existente.id}). Atualizando.',
              tag: repositoryName);

          final dtoAtualizado = ChecklistPreenchidoTableDto(
            id: existente.id.toString(),
            turnoId: turnoId,
            checklistModeloId: checklistModeloId,
            eletricistaRemoteId: eletricistaRemoteId,
            latitude: latitude,
            longitude: longitude,
            dataPreenchimento: DateTime.now(),
          );

          await _dao.atualizar(dtoAtualizado);
          return int.parse(existente.id);
        }

        final checklistDto = ChecklistPreenchidoTableDto(
          id: '0',
          turnoId: turnoId,
          checklistModeloId: checklistModeloId,
          eletricistaRemoteId: eletricistaRemoteId,
          latitude: latitude,
          longitude: longitude,
          dataPreenchimento: DateTime.now(),
        );

        final checklistId = await inserir(checklistDto);
        AppLogger.i('Checklist preenchido criado com ID: $checklistId',
            tag: repositoryName);
        return checklistId;
      },
    );
  }
}
