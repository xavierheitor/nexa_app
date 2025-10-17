import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/checklist_modelo_dao.dart';
import 'package:nexa_app/core/domain/dto/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório para gerenciar operações com Modelos de Checklist.
class ChecklistModeloRepo implements SyncableRepository<ChecklistModeloTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final ChecklistModeloDao _dao;

  ChecklistModeloRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = ChecklistModeloDao(_db);
  }

  @override
  String get nomeEntidade => 'checklist-modelo';

  // ============================================================================
  // CRUD LOCAL
  // ============================================================================

  /// Lista todos os modelos de checklist.
  Future<List<ChecklistModeloTableDto>> listar() async {
    try {
      return await _dao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar modelos de checklist',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca um modelo por ID local.
  Future<ChecklistModeloTableDto?> buscarPorId(int id) async {
    try {
      return await _dao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelo por ID',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca um modelo por remote ID.
  Future<ChecklistModeloTableDto?> buscarPorRemoteId(int remoteId) async {
    try {
      return await _dao.buscarPorRemoteId(remoteId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelo por remote ID',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca modelos por tipo de checklist.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklist(
      int tipoChecklistId) async {
    try {
      return await _dao.buscarPorTipoChecklist(tipoChecklistId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelos por tipo de checklist',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca modelos por tipo de veículo.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoVeiculo(
      int tipoVeiculoId) async {
    try {
      return await _dao.buscarPorTipoVeiculo(tipoVeiculoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelos por tipo de veículo',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca modelos por tipo de equipe.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoEquipe(
      int tipoEquipeId) async {
    try {
      return await _dao.buscarPorTipoEquipe(tipoEquipeId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelos por tipo de equipe',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca modelos por tipo de checklist e tipo de equipe.
  Future<List<ChecklistModeloTableDto>> buscarPorTipoChecklistETipoEquipe(
      int tipoChecklistId, int tipoEquipeId) async {
    try {
      return await _dao.buscarPorTipoChecklistETipoEquipe(
          tipoChecklistId, tipoEquipeId);
    } catch (e, stackTrace) {
      AppLogger.e(
          'Erro ao buscar modelos por tipo de checklist e tipo de equipe',
          tag: 'ChecklistModeloRepo',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca modelos por nome (busca parcial).
  Future<List<ChecklistModeloTableDto>> buscarPorNome(String nome) async {
    try {
      return await _dao.buscarPorNome(nome);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar modelos por nome',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta o total de modelos.
  Future<int> contar() async {
    try {
      return await _dao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar modelos',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO
  // ============================================================================

  @override
  Future<List<ChecklistModeloTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('🔄 Buscando modelos de checklist da API',
          tag: 'ChecklistModeloRepo');

      final response = await _dio.get(ApiConstants.checklistModelo);

      if (response.statusCode == 200) {
        // Valida se response.data existe
        final responseData = response.data;
        if (responseData == null) {
          AppLogger.w('⚠️ API retornou resposta vazia',
              tag: 'ChecklistModeloRepo');
          return [];
        }

        // API retorna array diretamente, não dentro de 'data'
        final List<dynamic> data =
            responseData is List ? responseData : (responseData['data'] ?? []);
        AppLogger.v('📦 API retornou ${data.length} modelos',
            tag: 'ChecklistModeloRepo');

        return data.map((item) {
          final now = DateTime.now();
          return ChecklistModeloTableDto(
            id: 0, // Será auto incrementado
            remoteId: item['id'] as int,
            nome: item['nome'] as String,
            tipoChecklistId: item['tipoChecklistId'] as int,
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
            'Erro ao buscar modelos da API: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar modelos de checklist da API',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sincronizarComBanco(List<ChecklistModeloTableDto> itens) async {
    try {
      AppLogger.d('💾 Sincronizando ${itens.length} modelos com o banco',
          tag: 'ChecklistModeloRepo');

      // Limpa dados antigos
      await _dao.deletarTodos();

      // Insere novos dados
      for (final item in itens) {
        await _dao.inserirOuAtualizar(item);
      }

      AppLogger.i('✅ ${itens.length} modelos sincronizados com sucesso',
          tag: 'ChecklistModeloRepo');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar modelos com banco',
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
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
          tag: 'ChecklistModeloRepo', error: e, stackTrace: stackTrace);
      return false; // Assume que não está vazio em caso de erro
    }
  }
}

