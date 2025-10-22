import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/eletricista_dao.dart';
import 'package:nexa_app/data/models/eletricista_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;
import 'package:nexa_app/core/cache/cache_mixin.dart';

/// Repositório responsável pelo gerenciamento de dados de eletricistas.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a eletricistas, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de eletricistas
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID, matrícula e nome
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
/// 7. **Sincronização**: Implementa SyncableRepository para sincronização
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em eletricistas
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
/// final eletricistaRepo = EletricistaRepo(dio: dioClient, db: database);
///
/// // Listar todos os eletricistas
/// final eletricistas = await eletricistaRepo.listar();
///
/// // Buscar eletricista por matrícula
/// final eletricista = await eletricistaRepo.buscarPorMatricula('12345');
///
/// // Inserir novo eletricista
/// final novoEletricista = await eletricistaRepo.inserir(eletricistaDto);
/// ```
///
/// ## Dependências:
/// - `DioClient`: Cliente HTTP para comunicação com APIs
/// - `AppDatabase`: Instância do banco de dados local
/// - `EletricistaDao`: Data Access Object para operações de eletricista
/// - `EletricistaTableDto`: DTO para representação de dados de eletricista
class EletricistaRepo
    with log_mixin.LoggingMixin, CacheMixin
    implements SyncableRepository<EletricistaTableDto> {
  // ============================================================================
  // DEPENDÊNCIAS E CONFIGURAÇÃO
  // ============================================================================

  /// Cliente HTTP para comunicação com APIs externas.
  ///
  /// Utilizado para sincronização de dados e operações que requerem
  /// comunicação com servidores remotos. Configurado com interceptors
  /// de autenticação e tratamento de erros.
  final DioClient dio;

  /// Instância do banco de dados local (SQLite via Drift).
  ///
  /// Fornece acesso a todas as tabelas e operações de persistência
  /// local, incluindo transações, migrações e consultas complexas.
  final AppDatabase db;

  /// Data Access Object específico para operações de eletricista.
  ///
  /// Encapsula todas as operações SQL relacionadas à tabela de eletricistas,
  /// incluindo CRUD básico e consultas personalizadas. Inicializado
  /// automaticamente a partir da instância do banco de dados.
  final EletricistaDao eletricistaDao;

  /// Construtor do repositório de eletricistas.
  ///
  /// Inicializa o repositório com as dependências necessárias e
  /// configura o DAO de eletricista a partir da instância do banco.
  ///
  /// ## Parâmetros:
  /// - `dio`: Cliente HTTP para comunicação com APIs (obrigatório)
  /// - `db`: Instância do banco de dados local (obrigatório)
  ///
  /// ## Inicialização:
  /// O `eletricistaDao` é inicializado automaticamente através de `db.eletricistaDao`,
  /// garantindo que todas as operações de banco sejam executadas corretamente.
  EletricistaRepo({required this.dio, required this.db})
      : eletricistaDao = db.eletricistaDao;

  // ============================================================================
  // IMPLEMENTAÇÃO DO LOGGING MIXIN
  // ============================================================================

  @override
  String get repositoryName => 'EletricistaRepository';

  // ============================================================================
  // IMPLEMENTAÇÃO DO SYNCABLE REPOSITORY
  // ============================================================================

  @override
  String get nomeEntidade => 'eletricista';

  @override
  Future<List<EletricistaTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response = await dio.get(ApiConstants.eletricistas);
        return (response.data as List)
            .map((json) => EletricistaTableDto.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(List<EletricistaTableDto> itens) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        await db.transaction(() async {
          await eletricistaDao.deletarTodos();
          for (final eletricista in itens) {
            await eletricistaDao.inserirOuAtualizar(eletricista.toCompanion());
          }
        });
        
        // Invalida cache após sincronização
        await invalidarCacheAposSincronizacao('eletricistas');
        
        AppLogger.i('Sincronizados ${itens.length} eletricistas',
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
        final count = await eletricistaDao.contar();
        return count == 0;
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES DE LEITURA (READ)
  // ============================================================================

  /// Lista todos os eletricistas cadastrados no banco de dados local.
  ///
  /// Recupera todos os registros da tabela de eletricistas e os converte
  /// para DTOs padronizados, fornecendo uma lista completa de eletricistas
  /// disponíveis no sistema.
  ///
  /// ## Retorno:
  /// - `Future<List<EletricistaTableDto>>`: Lista de todos os eletricistas
  ///
  /// ## Comportamento:
  /// - Busca todos os registros da tabela eletricistas
  /// - Converte cada entidade para DTO correspondente
  /// - Retorna lista vazia se não houver eletricistas cadastrados
  ///
  /// ## Casos de Uso:
  /// - Carregamento inicial da lista de eletricistas
  /// - Atualização de interface após sincronização
  /// - Relatórios e consultas gerais
  ///
  /// ## Exemplo:
  /// ```dart
  /// final eletricistas = await eletricistaRepo.listar();
  /// eletricistas.forEach((eletricista) => print('${eletricista.nome} - ${eletricista.matricula}'));
  /// ```
  Future<List<EletricistaTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        return await listarComCache(
          'eletricistas',
          () async {
            final eletricistas = await eletricistaDao.listar();
            return eletricistas
                .map((eletricista) =>
                    EletricistaTableDto.fromEntity(eletricista))
                .toList();
          },
        );
      },
    );
  }

  Future<EletricistaTableDto> buscarPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        return await buscarPorIdComCache(
              'eletricistas',
              id,
              () async {
                final eletricista = await eletricistaDao.buscarPorIdOuFalha(id);
                return EletricistaTableDto.fromEntity(eletricista);
              },
            ) ??
            (throw Exception('Eletricista não encontrado'));
      },
    );
  }

  Future<EletricistaTableDto?> buscarPorRemoteIdOuNull(int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarPorRemoteIdOuNull',
      operation: () async {
        final entidade = await eletricistaDao.buscarPorRemoteIdOuNull(remoteId);
        return entidade != null
            ? EletricistaTableDto.fromEntity(entidade)
            : null;
      },
    );
  }

  Future<EletricistaTableDto> buscarPorRemoteId(int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarPorRemoteId',
      operation: () async {
        final entidade =
            await eletricistaDao.buscarPorRemoteIdOuFalha(remoteId);
        return EletricistaTableDto.fromEntity(entidade);
      },
    );
  }

  Future<EletricistaTableDto> buscarPorMatricula(String matricula) async {
    return await executeWithLogging(
      operationName: 'buscarPorMatricula',
      operation: () async {
        final eletricista = await eletricistaDao.buscarPorMatricula(matricula);
        return EletricistaTableDto.fromEntity(eletricista);
      },
    );
  }

  Future<List<EletricistaTableDto>> buscarPorNome(String nome) async {
    return await executeWithLogging(
      operationName: 'buscarPorNome',
      operation: () async {
        final eletricistas = await eletricistaDao.buscarPorNome(nome);
        return eletricistas
            .map((eletricista) => EletricistaTableDto.fromEntity(eletricista))
            .toList();
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES DE ESCRITA (CREATE, UPDATE, DELETE)
  // ============================================================================

  /// Insere um novo eletricista no banco de dados.
  ///
  /// Adiciona um novo registro de eletricista ao banco de dados local
  /// e retorna os dados completos incluindo o ID gerado automaticamente.
  ///
  /// ## Parâmetros:
  /// - `eletricista`: DTO com dados do novo eletricista
  ///
  /// ## Retorno:
  /// - `Future<EletricistaTableDto>`: Dados completos do eletricista inserido
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Insere novo registro (ID é gerado automaticamente)
  /// - Busca registro recém-inserido para obter dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Cadastro de novo eletricista
  /// - Importação de dados
  /// - Criação de registros de teste
  ///
  /// ## Exemplo:
  /// ```dart
  /// final novoEletricista = EletricistaTableDto(
  ///   id: '0', // Será ignorado
  ///   remoteId: '123',
  ///   nome: 'João Silva',
  ///   matricula: '12345',
  /// );
  /// final eletricistaInserido = await eletricistaRepo.inserir(novoEletricista);
  /// print('ID gerado: ${eletricistaInserido.id}');
  /// ```
  Future<EletricistaTableDto> inserir(EletricistaTableDto eletricista) async {
    return await executeWithLogging(
      operationName: 'inserir',
      operation: () async {
        final id =
            await eletricistaDao.inserirOuAtualizar(eletricista.toCompanion());
        final eletricistaInserido = await eletricistaDao.buscarPorIdOuFalha(id);
        return EletricistaTableDto.fromEntity(eletricistaInserido);
      },
    );
  }

  Future<EletricistaTableDto> atualizar(EletricistaTableDto eletricista) async {
    return await executeWithLogging(
      operationName: 'atualizar',
      operation: () async {
        await eletricistaDao.atualizar(eletricista.toEntity());
        final eletricistaAtualizado =
            await eletricistaDao.buscarPorIdOuFalha(int.parse(eletricista.id));
        return EletricistaTableDto.fromEntity(eletricistaAtualizado);
      },
    );
  }

  Future<void> deletar(int id) async {
    return await executeVoidWithLogging(
      operationName: 'deletar',
      operation: () async {
        await eletricistaDao.deletar(id);
      },
    );
  }
}
