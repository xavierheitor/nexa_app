import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/checklist_tipo_equipe_relacao_dao.dart';
import 'package:nexa_app/core/domain/dto/checklist_tipo_equipe_relacao_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório para gerenciar relacionamentos entre Tipos de Equipe e Modelos de Checklist.
class ChecklistTipoEquipeRelacaoRepo
    implements SyncableRepository<ChecklistTipoEquipeRelacaoTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistTipoEquipeRelacaoDao _dao;

  ChecklistTipoEquipeRelacaoRepo(
      {required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistTipoEquipeRelacaoDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-tipo-equipe-relacao';

  Future<List<ChecklistTipoEquipeRelacaoTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar relações tipo-equipe-modelo',
          tag: 'ChecklistTipoEquipeRelacaoRepo',
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
          tag: 'ChecklistTipoEquipeRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<ChecklistTipoEquipeRelacaoTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando relações tipo-equipe-modelo da API',
          tag: 'ChecklistTipoEquipeRelacaoRepo');

      final response =
          await _dio.get(ApiConstants.checklistTipoEquipeRelacao);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistTipoEquipeRelacaoRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} relações',
            tag: 'ChecklistTipoEquipeRelacaoRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistTipoEquipeRelacaoTableDto(
            id: 0,
            remoteId: item['id'] as int?,
            checklistModeloId: item['checklistId'] as int, // API usa 'checklistId'
            tipoEquipeId: item['tipoEquipeId'] as int,
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
      AppLogger.e('❌ Erro ao buscar relações tipo-equipe-modelo da API',
          tag: 'ChecklistTipoEquipeRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(
      List<ChecklistTipoEquipeRelacaoTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} relações com o banco',
          tag: 'ChecklistTipoEquipeRelacaoRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} relações sincronizadas com sucesso',
          tag: 'ChecklistTipoEquipeRelacaoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar relações com banco',
          tag: 'ChecklistTipoEquipeRelacaoRepo',
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
          tag: 'ChecklistTipoEquipeRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      return false;
    }
  }
}

