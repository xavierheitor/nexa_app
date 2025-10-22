import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_modelo_dao.dart';
import 'package:nexa_app/data/models/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;

/// Repositório para gerenciar operações com Modelos de Checklist.
class ChecklistModeloRepo
    with log_mixin.LoggingMixin
    implements SyncableRepository<ChecklistModeloTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistModeloDao _dao;

  ChecklistModeloRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistModeloDao(_db);
  }

  @override
  String get repositoryName => 'ChecklistModeloRepository';

  @override
  String get nomeEntidade => 'checklist-modelo';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  Future<List<ChecklistModeloTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        return await _dao.listarDto();
      },
    );
  }

  Future<ChecklistModeloTableDto?> buscarPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        return await _dao.buscarPorIdDto(id);
      },
    );
  }

  Future<ChecklistModeloTableDto?> buscarPorRemoteId(int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarPorRemoteId',
      operation: () async {
        return await _dao.buscarPorRemoteIdDto(remoteId);
      },
    );
  }

  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklist(
      int tipoChecklistId) async {
    return await executeWithLogging(
      operationName: 'buscarPorTipoChecklist',
      operation: () async {
        return await _dao.buscarPorTipoChecklist(tipoChecklistId);
      },
    );
  }

  Future<List<ChecklistModeloTableDto>> buscarPorTipoVeiculo(
      int tipoVeiculoId) async {
    return await executeWithLogging(
      operationName: 'buscarPorTipoVeiculo',
      operation: () async {
        return await _dao.buscarPorTipoVeiculo(tipoVeiculoId);
      },
    );
  }

  Future<List<ChecklistModeloTableDto>> buscarPorTipoEquipe(
      int tipoEquipeId) async {
    return await executeWithLogging(
      operationName: 'buscarPorTipoEquipe',
      operation: () async {
        return await _dao.buscarPorTipoEquipe(tipoEquipeId);
      },
    );
  }

  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklistETipoEquipe(
      int tipoChecklistId, int tipoEquipeId) async {
    return await executeWithLogging(
      operationName: 'buscarPorTipoChecklistETipoEquipe',
      operation: () async {
        return await _dao.buscarPorTipoChecklistETipoEquipe(
            tipoChecklistId, tipoEquipeId);
      },
    );
  }

  Future<List<ChecklistModeloTableDto>> buscarPorNome(String nome) async {
    return await executeWithLogging(
      operationName: 'buscarPorNome',
      operation: () async {
        return await _dao.buscarPorNome(nome);
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

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistModeloTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response = await _dio.get(ApiConstants.checklistModelo);

        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData == null) {
            AppLogger.w('⚠️ API retornou resposta vazia', tag: repositoryName);
            return <ChecklistModeloTableDto>[];
          }

          final List<dynamic> data = responseData is List
              ? responseData
              : (responseData['data'] ?? []);
          AppLogger.v('📦 API retornou ${data.length} modelos',
              tag: repositoryName);

          return data.map((item) {
            final now = DateTime.now();
            return ChecklistModeloTableDto(
              id: 0,
              remoteId: item['id'] as int,
              nome: item['nome'] as String,
              tipoChecklistId: item['tipoChecklistId'] as int,
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
              'Erro ao buscar modelos da API: ${response.statusCode}');
        }
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(List<ChecklistModeloTableDto> itens) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        await _dao.deletarTodos();
        for (final item in itens) {
          await _dao.inserirOuAtualizarDto(item);
        }
        AppLogger.i('✅ ${itens.length} modelos sincronizados com sucesso',
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

