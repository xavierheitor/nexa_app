import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/equipe_dao.dart';
import 'package:nexa_app/data/models/equipe_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;

/// Repositório responsável pelo gerenciamento de dados de equipes.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a equipes, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de equipes
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID, nome e tipo
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
/// 7. **Sincronização**: Implementa SyncableRepository para sincronização
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em equipes
/// - **SyncableRepository**: Compatível com sistema de sincronização
///
/// ## Fluxo de Operações:
///
/// 1. Recebe DTOs da camada de domínio
/// 2. Converte para entidades do banco (se necessário)
/// 3. Executa operações via DAO
/// 4. Converte resultado de volta para DTO
/// 5. Retorna DTO para a camada de domínio
///
/// ## Uso:
///
/// ```dart
/// final equipeRepo = EquipeRepo(dio: dioClient, db: database);
///
/// // Listar todas as equipes
/// final equipes = await equipeRepo.listar();
///
/// // Buscar por ID
/// final equipe = await equipeRepo.buscarPorId('1');
///
/// // Criar nova equipe
/// final novaEquipe = EquipeTableDto(...);
/// await equipeRepo.criar(novaEquipe);
/// ```
class EquipeRepo
    with log_mixin.LoggingMixin
    implements SyncableRepository<EquipeTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final EquipeDao _dao;

  EquipeRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = _db.equipeDao;
  }

  @override
  String get repositoryName => 'EquipeRepository';

  @override
  String get nomeEntidade => 'equipe';

  Future<List<EquipeTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        final entidades = await _dao.listar();
        return entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();
      },
    );
  }

  Future<EquipeTableDto?> buscarPorId(String id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        final entidade = await _dao.buscarPorIdOuNull(int.parse(id));
        if (entidade == null) {
          AppLogger.d('Equipe não encontrada', tag: repositoryName);
          return null;
        }
        return EquipeTableDto.fromEntity(entidade);
      },
    );
  }

  Future<List<EquipeTableDto>> buscarPorNome(String nome) async {
    return await executeWithLogging(
      operationName: 'buscarPorNome',
      operation: () async {
        final entidades = await _dao.buscarPorNome(nome);
        return entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();
      },
    );
  }

  Future<List<EquipeTableDto>> buscarPorTipoEquipe(int tipoEquipeId) async {
    return await executeWithLogging(
      operationName: 'buscarPorTipoEquipe',
      operation: () async {
        final entidades = await _dao.buscarPorTipoEquipe(tipoEquipeId);
        return entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();
      },
    );
  }

  Future<List<EquipeTableDto>> listarComTipoEquipe() async {
    return await executeWithLogging(
      operationName: 'listarComTipoEquipe',
      operation: () async {
        final entidades = await _dao.listarComTipoEquipe();
        return entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();
      },
    );
  }

  Future<EquipeTableDto> criar(EquipeTableDto dto) async {
    return await executeWithLogging(
      operationName: 'criar',
      operation: () async {
        dto.validate();
        final companion = dto.toCompanion();
        final id = await _dao.inserirOuAtualizar(companion);
        return dto.copyWith(id: id.toString());
      },
    );
  }

  Future<EquipeTableDto> atualizar(EquipeTableDto dto) async {
    return await executeWithLogging(
      operationName: 'atualizar',
      operation: () async {
        dto.validate();
        final entidade = dto.toEntity();
        await _dao.atualizar(entidade);
        return dto;
      },
    );
  }

  Future<void> deletar(String id) async {
    return await executeVoidWithLogging(
      operationName: 'deletar',
      operation: () async {
        await _dao.deletar(int.parse(id));
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
  Future<bool> estaVazio(String entidade) async {
    return await executeWithLogging(
      operationName: 'estaVazio',
      operation: () async {
        final count = await _dao.contar();
        return count == 0;
      },
    );
  }

  @override
  Future<List<EquipeTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response = await _dio.get(ApiConstants.equipes);
        if (response.data == null) {
          AppLogger.w('Resposta da API vazia para equipes',
              tag: repositoryName);
          return <EquipeTableDto>[];
        }
        final List<dynamic> data =
            response.data is List ? response.data : [response.data];
        return data.map((json) => EquipeTableDto.fromJson(json)).toList();
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(List<EquipeTableDto> dtos) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        final companions = dtos.map((dto) => dto.toCompanion()).toList();
        await _dao.sincronizar(companions);
        AppLogger.i('Sincronizados ${dtos.length} equipes',
            tag: repositoryName);
      },
      logLevel: log_mixin.LogLevel.info,
    );
  }
}
