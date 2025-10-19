import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/checklist_tipo_veiculo_relacao_dao.dart';
import 'package:nexa_app/data/models/checklist_tipo_veiculo_relacao_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório para gerenciar relacionamentos entre Tipos de Veículo e Modelos de Checklist.
class ChecklistTipoVeiculoRelacaoRepo
    implements SyncableRepository<ChecklistTipoVeiculoRelacaoTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistTipoVeiculoRelacaoDao _dao;

  ChecklistTipoVeiculoRelacaoRepo(
      {required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistTipoVeiculoRelacaoDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-tipo-veiculo-relacao';

  Future<List<ChecklistTipoVeiculoRelacaoTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar relações tipo-veiculo-modelo',
          tag: 'ChecklistTipoVeiculoRelacaoRepo',
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
          tag: 'ChecklistTipoVeiculoRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<ChecklistTipoVeiculoRelacaoTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando relações tipo-veiculo-modelo da API',
          tag: 'ChecklistTipoVeiculoRelacaoRepo');

      final response =
          await _dio.get(ApiConstants.checklistTipoVeiculoRelacao);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistTipoVeiculoRelacaoRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} relações',
            tag: 'ChecklistTipoVeiculoRelacaoRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistTipoVeiculoRelacaoTableDto(
            id: 0,
            remoteId: item['id'] as int?,
            checklistModeloId: item['checklistId'] as int, // API usa 'checklistId'
            tipoVeiculoId: item['tipoVeiculoId'] as int,
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
      AppLogger.e('❌ Erro ao buscar relações tipo-veiculo-modelo da API',
          tag: 'ChecklistTipoVeiculoRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(
      List<ChecklistTipoVeiculoRelacaoTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} relações com o banco',
          tag: 'ChecklistTipoVeiculoRelacaoRepo');

      await _dao.deletarTodos();

      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} relações sincronizadas com sucesso',
          tag: 'ChecklistTipoVeiculoRelacaoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar relações com banco',
          tag: 'ChecklistTipoVeiculoRelacaoRepo',
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
          tag: 'ChecklistTipoVeiculoRelacaoRepo',
          error: e,
          stackTrace: stackTrace);
      return false;
    }
  }
}

