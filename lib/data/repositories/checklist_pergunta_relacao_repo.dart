import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_pergunta_relacao_dao.dart';
import 'package:nexa_app/data/models/checklist_pergunta_relacao_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório para gerenciar relacionamentos entre Perguntas e Modelos de Checklist.
class ChecklistPerguntaRelacaoRepo
    implements SyncableRepository<ChecklistPerguntaRelacaoTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistPerguntaRelacaoDao _dao;

  ChecklistPerguntaRelacaoRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistPerguntaRelacaoDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-pergunta-relacao';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  Future<List<ChecklistPerguntaRelacaoTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar relações pergunta-modelo',
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<ChecklistPerguntaRelacaoTableDto?> buscarPorId(int id) async {
    try {
      return await _dao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar relação por ID',
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<int> contar() async {
    try {
      return await _dao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar relações',
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistPerguntaRelacaoTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando relações pergunta-modelo da API',
          tag: 'ChecklistPerguntaRelacaoRepo');

      final response = await _dio.get(ApiConstants.checklistPerguntaRelacao);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistPerguntaRelacaoRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} relações',
            tag: 'ChecklistPerguntaRelacaoRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistPerguntaRelacaoTableDto(
            id: 0,
            remoteId: item['id'] as int?,
            checklistModeloId: item['checklistId'] as int, // API usa 'checklistId'
            checklistPerguntaId: item['checklistPerguntaId'] as int,
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
            'Erro ao buscar relações da API: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar relações pergunta-modelo da API',
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(
      List<ChecklistPerguntaRelacaoTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} relações com o banco',
          tag: 'ChecklistPerguntaRelacaoRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} relações sincronizadas com sucesso',
          tag: 'ChecklistPerguntaRelacaoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar relações com banco',
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
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
          tag: 'ChecklistPerguntaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      return false;
    }
  }
}

