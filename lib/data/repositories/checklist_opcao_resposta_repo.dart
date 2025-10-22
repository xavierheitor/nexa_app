import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_opcao_resposta_dao.dart';
import 'package:nexa_app/data/models/checklist_opcao_resposta_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;
import 'package:nexa_app/core/cache/cache_mixin.dart';

/// Repositório para gerenciar operações com Opções de Resposta de Checklist.
class ChecklistOpcaoRespostaRepo
    with log_mixin.LoggingMixin, CacheMixin
    implements SyncableRepository<ChecklistOpcaoRespostaTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistOpcaoRespostaDao _dao;

  ChecklistOpcaoRespostaRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistOpcaoRespostaDao(_db);
  }

  @override
  String get repositoryName => 'ChecklistOpcaoRespostaRepository';

  @override
  String get nomeEntidade => 'checklist-opcao-resposta';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  Future<List<ChecklistOpcaoRespostaTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        return await listarComCache(
          'checklist_opcao_resposta',
          () async {
            return await _dao.listarDto();
          },
        );
      },
    );
  }

  Future<ChecklistOpcaoRespostaTableDto?> buscarPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        return await _dao.buscarPorIdDto(id);
      },
    );
  }

  Future<ChecklistOpcaoRespostaTableDto?> buscarPorRemoteId(
      int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarPorRemoteId',
      operation: () async {
        return await _dao.buscarPorRemoteIdDto(remoteId);
      },
    );
  }

  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorModelo(
      int checklistModeloId) async {
    return await executeWithLogging(
      operationName: 'buscarPorModelo',
      operation: () async {
        return await _dao.buscarPorModelo(checklistModeloId);
      },
    );
  }

  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorNome(
      String nome) async {
    return await executeWithLogging(
      operationName: 'buscarPorNome',
      operation: () async {
        return await _dao.buscarPorNome(nome);
      },
    );
  }

  Future<List<ChecklistOpcaoRespostaTableDto>> buscarQueGeramPendencia() async {
    return await executeWithLogging(
      operationName: 'buscarQueGeramPendencia',
      operation: () async {
        return await _dao.buscarQueGeramPendencia();
      },
    );
  }

  Future<int> contar() async {
    return await executeWithLogging(
      operationName: 'contar',
      operation: () async {
        return await _dao.contar();
      },
    );
  }

  Future<int> contarQueGeramPendencia() async {
    return await executeWithLogging(
      operationName: 'contarQueGeramPendencia',
      operation: () async {
        return await _dao.contarQueGeramPendencia();
      },
    );
  }

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response = await _dio.get(ApiConstants.checklistOpcaoResposta);

        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData == null) {
            AppLogger.w('⚠️ API retornou resposta vazia', tag: repositoryName);
            return <ChecklistOpcaoRespostaTableDto>[];
          }

          final List<dynamic> data = responseData is List
              ? responseData
              : (responseData['data'] ?? []);
          AppLogger.v('📦 API retornou ${data.length} opções',
              tag: repositoryName);

          return data.map((item) {
            final now = DateTime.now();
            return ChecklistOpcaoRespostaTableDto(
              id: 0,
              remoteId: item['id'] as int,
              nome: item['nome'] as String,
              geraPendencia: item['geraPendencia'] as bool? ?? false,
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
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(List<ChecklistOpcaoRespostaTableDto> itens) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        await _dao.deletarTodos();
        for (final item in itens) {
          await _dao.inserirOuAtualizarDto(item);
        }
        AppLogger.i('✅ ${itens.length} opções sincronizadas com sucesso',
            tag: repositoryName);
      },
      logLevel: log_mixin.LogLevel.info,
    );
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    return await executeWithLogging(
      operationName: 'estaVazio',
      operation: () async {
        final count = await _dao.contar();
        return count == 0;
      },
    );
  }
}

