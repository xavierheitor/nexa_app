import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/checklist_opcao_resposta_relacao_dao.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_relacao_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório para gerenciar relacionamentos entre Opções de Resposta e Modelos de Checklist.
class ChecklistOpcaoRespostaRelacaoRepo
    implements SyncableRepository<ChecklistOpcaoRespostaRelacaoTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistOpcaoRespostaRelacaoDao _dao;

  ChecklistOpcaoRespostaRelacaoRepo(
      {required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistOpcaoRespostaRelacaoDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-opcao-resposta-relacao';

  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar relações opcao-resposta-modelo',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo',
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
          tag: 'ChecklistOpcaoRespostaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando relações opcao-resposta-modelo da API',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo');

      final response =
          await _dio.get(ApiConstants.checklistOpcaoRespostaRelacao);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistOpcaoRespostaRelacaoRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} relações',
            tag: 'ChecklistOpcaoRespostaRelacaoRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistOpcaoRespostaRelacaoTableDto(
            id: 0,
            remoteId: item['id'] as int?,
            checklistOpcaoRespostaId:
                item['checklistOpcaoRespostaId'] as int,
            checklistModeloId: item['checklistId'] as int, // API usa 'checklistId'
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
      AppLogger.e('❌ Erro ao buscar relações opcao-resposta-modelo da API',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(
      List<ChecklistOpcaoRespostaRelacaoTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} relações com o banco',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} relações sincronizadas com sucesso',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar relações com banco',
          tag: 'ChecklistOpcaoRespostaRelacaoRepo',
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
          tag: 'ChecklistOpcaoRespostaRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      return false;
    }
  }
}

