import 'package:nexa_app/core/database/daos/checklist_preenchido_dao.dart';
import 'package:nexa_app/core/domain/dto/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Repositório para ChecklistPreenchidoTable
class ChecklistPreenchidoRepo {
  final ChecklistPreenchidoDao _dao;

  ChecklistPreenchidoRepo(this._dao);

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

  /// Salva um checklist preenchido com respostas
  Future<int> salvarChecklistCompleto({
    required int turnoId,
    required int checklistModeloId,
    required List<Map<String, dynamic>> respostas,
    double? latitude,
    double? longitude,
    int? eletricistaRemoteId,
  }) async {
    AppLogger.d('Salvando checklist completo para turno: $turnoId', tag: 'ChecklistPreenchidoRepo');
    
    try {
      // 1. Criar o checklist preenchido
      final checklistDto = ChecklistPreenchidoTableDto(
        id: '0', // Será autoincrementado
        turnoId: turnoId,
        checklistModeloId: checklistModeloId,
        eletricistaRemoteId: eletricistaRemoteId,
        latitude: latitude,
        longitude: longitude,
        dataPreenchimento: DateTime.now(),
      );

      // 2. Inserir o checklist preenchido
      final checklistId = await inserir(checklistDto);
      
      AppLogger.i('Checklist preenchido criado com ID: $checklistId', tag: 'ChecklistPreenchidoRepo');
      
      return checklistId;
    } catch (e) {
      AppLogger.e('Erro ao salvar checklist completo: $e', tag: 'ChecklistPreenchidoRepo');
      rethrow;
    }
  }
}
