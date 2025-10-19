import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_opcao_resposta_dao.dart';
import 'package:nexa_app/data/models/checklist_opcao_resposta_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório para gerenciar operações com Opções de Resposta de Checklist.
class ChecklistOpcaoRespostaRepo implements SyncableRepository<ChecklistOpcaoRespostaTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistOpcaoRespostaDao _dao;

  ChecklistOpcaoRespostaRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistOpcaoRespostaDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-opcao-resposta';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  /// Lista todas as opções de resposta.
  Future<List<ChecklistOpcaoRespostaTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar opções de resposta',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca uma opção por ID local.
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorId(int id) async {
    try {
      return await _dao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar opção por ID',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca uma opção por remote ID.
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorRemoteId(
      int remoteId) async {
    try {
      return await _dao.buscarPorRemoteId(remoteId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar opção por remote ID',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca opções de resposta de um modelo de checklist.
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorModelo(
      int checklistModeloId) async {
    try {
      return await _dao.buscarPorModelo(checklistModeloId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar opções por modelo',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca opções por nome (busca parcial).
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorNome(
      String nome) async {
    try {
      return await _dao.buscarPorNome(nome);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar opções por nome',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca opções que geram pendência.
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarQueGeramPendencia() async {
    try {
      return await _dao.buscarQueGeramPendencia();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar opções que geram pendência',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta o total de opções.
  Future<int> contar() async {
    try {
      return await _dao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar opções',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta opções que geram pendência.
  Future<int> contarQueGeramPendencia() async {
    try {
      return await _dao.contarQueGeramPendencia();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar opções que geram pendência',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando opções de resposta da API',
          tag: 'ChecklistOpcaoRespostaRepo');

      final response = await _dio.get(ApiConstants.checklistOpcaoResposta);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistOpcaoRespostaRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} opções',
            tag: 'ChecklistOpcaoRespostaRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistOpcaoRespostaTableDto(
            id: 0,
            remoteId: item['id'] as int,
            nome: item['nome'] as String,
            geraPendencia: item['geraPendencia'] as bool? ?? false,
            // Se não vier da API, usa data atual
            createdAt: item['createdAt'] != null
                ? DateTime.parse(item['createdAt'])
                : (item['created_at'] != null
                    ? DateTime.parse(item['created_at'])
                    : now),
            updatedAt: item['updatedAt'] != null
                ? DateTime.parse(item['updatedAt'])
                : (item['updated_at'] != null
                    ? DateTime.parse(item['updated_at'])
                    : now),
          );
        }).toList();
      } else {
        throw Exception(
            'Erro ao buscar opções da API: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar opções de resposta da API',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(List<ChecklistOpcaoRespostaTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} opções com o banco',
          tag: 'ChecklistOpcaoRespostaRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} opções sincronizadas com sucesso',
          tag: 'ChecklistOpcaoRespostaRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar opções com banco',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    try {
      final count = await _dao.contar();
      return count == 0;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar se tabela está vazia',
          tag: 'ChecklistOpcaoRespostaRepo', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

