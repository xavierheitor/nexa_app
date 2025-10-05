import 'package:nexa_app/core/database/daos/checklist_resposta_dao.dart';
import 'package:nexa_app/core/domain/dto/checklist_resposta_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Repositório para ChecklistRespostaTable
class ChecklistRespostaRepo {
  final ChecklistRespostaDao _dao;

  ChecklistRespostaRepo(this._dao);

  /// Lista todas as respostas
  Future<List<ChecklistRespostaTableDto>> listar() async {
    AppLogger.d('Listando todas as respostas', tag: 'ChecklistRespostaRepo');
    return await _dao.listar();
  }

  /// Busca resposta por ID
  Future<ChecklistRespostaTableDto?> buscarPorId(int id) async {
    AppLogger.d('Buscando resposta por ID: $id', tag: 'ChecklistRespostaRepo');
    return await _dao.buscarPorId(id);
  }

  /// Busca respostas por checklist preenchido
  Future<List<ChecklistRespostaTableDto>> buscarPorChecklistPreenchido(int checklistPreenchidoId) async {
    AppLogger.d('Buscando respostas por checklist preenchido: $checklistPreenchidoId', tag: 'ChecklistRespostaRepo');
    return await _dao.buscarPorChecklistPreenchido(checklistPreenchidoId);
  }

  /// Busca resposta por pergunta
  Future<ChecklistRespostaTableDto?> buscarPorPergunta(int checklistPreenchidoId, int perguntaId) async {
    AppLogger.d('Buscando resposta por pergunta: $perguntaId', tag: 'ChecklistRespostaRepo');
    return await _dao.buscarPorPergunta(checklistPreenchidoId, perguntaId);
  }

  /// Insere uma nova resposta
  Future<int> inserir(ChecklistRespostaTableDto dto) async {
    AppLogger.d('Inserindo resposta para pergunta: ${dto.perguntaId}', tag: 'ChecklistRespostaRepo');
    return await _dao.inserir(dto);
  }

  /// Insere múltiplas respostas
  Future<List<int>> inserirMultiplos(List<ChecklistRespostaTableDto> dtos) async {
    AppLogger.d('Inserindo ${dtos.length} respostas', tag: 'ChecklistRespostaRepo');
    return await _dao.inserirMultiplos(dtos);
  }

  /// Atualiza uma resposta
  Future<bool> atualizar(ChecklistRespostaTableDto dto) async {
    AppLogger.d('Atualizando resposta ID: ${dto.id}', tag: 'ChecklistRespostaRepo');
    return await _dao.atualizar(dto);
  }

  /// Remove uma resposta
  Future<bool> remover(int id) async {
    AppLogger.d('Removendo resposta ID: $id', tag: 'ChecklistRespostaRepo');
    return await _dao.remover(id);
  }

  /// Remove todas as respostas de um checklist preenchido
  Future<bool> removerPorChecklistPreenchido(int checklistPreenchidoId) async {
    AppLogger.d('Removendo respostas do checklist preenchido: $checklistPreenchidoId', tag: 'ChecklistRespostaRepo');
    return await _dao.removerPorChecklistPreenchido(checklistPreenchidoId);
  }

  /// Conta respostas por checklist preenchido
  Future<int> contarPorChecklistPreenchido(int checklistPreenchidoId) async {
    AppLogger.d('Contando respostas por checklist preenchido: $checklistPreenchidoId', tag: 'ChecklistRespostaRepo');
    return await _dao.contarPorChecklistPreenchido(checklistPreenchidoId);
  }

  /// Verifica se existe resposta para uma pergunta
  Future<bool> existeRespostaParaPergunta(int checklistPreenchidoId, int perguntaId) async {
    AppLogger.d('Verificando se existe resposta para pergunta: $perguntaId', tag: 'ChecklistRespostaRepo');
    return await _dao.existeRespostaParaPergunta(checklistPreenchidoId, perguntaId);
  }

  /// Salva múltiplas respostas para um checklist preenchido
  Future<List<int>> salvarRespostas({
    required int checklistPreenchidoId,
    required List<Map<String, dynamic>> respostas,
  }) async {
    AppLogger.d('Salvando ${respostas.length} respostas para checklist: $checklistPreenchidoId', tag: 'ChecklistRespostaRepo');
    
    try {
      final dtos = respostas.map((resposta) {
        return ChecklistRespostaTableDto(
          id: '0', // Será autoincrementado
          checklistPreenchidoId: checklistPreenchidoId,
          perguntaId: resposta['perguntaId'] as int,
          opcaoRespostaId: resposta['opcaoRespostaId'] as int,
          dataResposta: DateTime.now(),
        );
      }).toList();

      final ids = await inserirMultiplos(dtos);
      
      AppLogger.i('${ids.length} respostas salvas com sucesso', tag: 'ChecklistRespostaRepo');
      
      return ids;
    } catch (e) {
      AppLogger.e('Erro ao salvar respostas: $e', tag: 'ChecklistRespostaRepo');
      rethrow;
    }
  }
}
