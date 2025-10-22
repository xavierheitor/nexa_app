import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_opcao_resposta_relacao_dao.dart';
import 'package:nexa_app/data/models/checklist_opcao_resposta_relacao_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;

/// Repositório para gerenciar relacionamentos entre Opções de Resposta e Modelos de Checklist.
class ChecklistOpcaoRespostaRelacaoRepo
    with log_mixin.LoggingMixin
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
  String get repositoryName => 'ChecklistOpcaoRespostaRelacaoRepository';

  @override
  String get nomeEntidade => 'checklist-opcao-resposta-relacao';

  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        return await _dao.listarDto();
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

  @override
  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response =
            await _dio.get(ApiConstants.checklistOpcaoRespostaRelacao);

        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData == null) {
            AppLogger.w('⚠️ API retornou resposta vazia', tag: repositoryName);
            return <ChecklistOpcaoRespostaRelacaoTableDto>[];
          }

          final List<dynamic> data = responseData is List
              ? responseData
              : (responseData['data'] ?? []);
          AppLogger.v('📦 API retornou ${data.length} relações',
              tag: repositoryName);

          return data.map((item) {
            final now = DateTime.now();
            return ChecklistOpcaoRespostaRelacaoTableDto(
              id: 0,
              remoteId: item['id'] as int?,
              checklistOpcaoRespostaId: item['checklistOpcaoRespostaId'] as int,
              checklistModeloId: item['checklistId'] as int,
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
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(
      List<ChecklistOpcaoRespostaRelacaoTableDto> itens) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        await _dao.deletarTodos();
        for (final item in itens) {
          await _dao.inserirOuAtualizarDto(item);
        }
        AppLogger.i('✅ ${itens.length} relações sincronizadas com sucesso',
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

