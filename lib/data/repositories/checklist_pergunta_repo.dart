import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_pergunta_dao.dart';
import 'package:nexa_app/data/models/checklist_pergunta_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório para gerenciar operações com Perguntas de Checklist.
class ChecklistPerguntaRepo implements SyncableRepository<ChecklistPerguntaTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistPerguntaDao _dao;

  ChecklistPerguntaRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistPerguntaDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-pergunta';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  /// Lista todas as perguntas de checklist.
  Future<List<ChecklistPerguntaTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar perguntas de checklist',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca uma pergunta por ID local.
  Future<ChecklistPerguntaTableDto?> buscarPorId(int id) async {
    try {
      return await _dao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar pergunta por ID',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca uma pergunta por remote ID.
  Future<ChecklistPerguntaTableDto?> buscarPorRemoteId(int remoteId) async {
    try {
      return await _dao.buscarPorRemoteId(remoteId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar pergunta por remote ID',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca perguntas de um modelo de checklist.
  Future<List<ChecklistPerguntaTableDto>> buscarPorModelo(
      int checklistModeloId) async {
    try {
      return await _dao.buscarPorModelo(checklistModeloId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar perguntas por modelo',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca perguntas por nome (busca parcial).
  Future<List<ChecklistPerguntaTableDto>> buscarPorNome(String nome) async {
    try {
      return await _dao.buscarPorNome(nome);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar perguntas por nome',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta o total de perguntas.
  Future<int> contar() async {
    try {
      return await _dao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar perguntas',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistPerguntaTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando perguntas de checklist da API',
          tag: 'ChecklistPerguntaRepo');

      final response = await _dio.get(ApiConstants.checklistPergunta);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistPerguntaRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} perguntas',
            tag: 'ChecklistPerguntaRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistPerguntaTableDto(
            id: 0,
            remoteId: item['id'] as int,
            nome: item['nome'] as String,
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
            'Erro ao buscar perguntas da API: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar perguntas de checklist da API',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(List<ChecklistPerguntaTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} perguntas com o banco',
          tag: 'ChecklistPerguntaRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} perguntas sincronizadas com sucesso',
          tag: 'ChecklistPerguntaRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar perguntas com banco',
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
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
          tag: 'ChecklistPerguntaRepo', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

