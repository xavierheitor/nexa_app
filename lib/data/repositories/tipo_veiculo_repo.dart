import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/tipo_veiculo_dao.dart';
import 'package:nexa_app/data/models/tipo_veiculo_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;

/// Repositório responsável pelo gerenciamento de dados de tipos de veículo.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a tipos de veículo, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de tipos de veículo
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID, nome e remote ID
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
/// 7. **Sincronização**: Implementa SyncableRepository para sincronização
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em tipos de veículo
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
/// final tipoVeiculoRepo = TipoVeiculoRepo(dio: dioClient, db: database);
///
/// // Listar todos os tipos de veículo
/// final tipos = await tipoVeiculoRepo.listar();
///
/// // Buscar tipo por nome
/// final tipo = await tipoVeiculoRepo.buscarPorNome('Carro');
///
/// // Inserir novo tipo
/// final novoTipo = await tipoVeiculoRepo.inserir(tipoDto);
/// ```
///
/// ## Dependências:
/// - `DioClient`: Cliente HTTP para comunicação com APIs
/// - `AppDatabase`: Instância do banco de dados local
/// - `TipoVeiculoDao`: Data Access Object para operações de tipo de veículo
/// - `TipoVeiculoTableDto`: DTO para representação de dados de tipo de veículo
class TipoVeiculoRepo
    with log_mixin.LoggingMixin
    implements SyncableRepository<TipoVeiculoTableDto> {
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

  /// Data Access Object específico para operações de tipo de veículo.
  ///
  /// Encapsula todas as operações SQL relacionadas à tabela de tipos de veículo,
  /// incluindo CRUD básico e consultas personalizadas. Inicializado
  /// automaticamente a partir da instância do banco de dados.
  final TipoVeiculoDao tipoVeiculoDao;

  /// Construtor do repositório de tipos de veículo.
  ///
  /// Inicializa o repositório com as dependências necessárias e
  /// configura o DAO de tipo de veículo a partir da instância do banco.
  ///
  /// ## Parâmetros:
  /// - `dio`: Cliente HTTP para comunicação com APIs (obrigatório)
  /// - `db`: Instância do banco de dados local (obrigatório)
  ///
  /// ## Inicialização:
  /// O `tipoVeiculoDao` é inicializado automaticamente através de `db.tipoVeiculoDao`,
  /// garantindo que todas as operações de banco sejam executadas corretamente.
  TipoVeiculoRepo({required this.dio, required this.db})
      : tipoVeiculoDao = db.tipoVeiculoDao;

  // ============================================================================
  // IMPLEMENTAÇÃO DO SYNCABLE REPOSITORY
  // ============================================================================

  @override
  String get repositoryName => 'TipoVeiculoRepository';

  @override
  String get nomeEntidade => 'tipo_veiculo';

  @override
  Future<List<TipoVeiculoTableDto>> buscarDaApi() async {
    return await executeWithLogging(
      operationName: 'buscarDaApi',
      operation: () async {
        final response = await dio.get(ApiConstants.tiposVeiculo);
        return (response.data as List)
            .map((json) => TipoVeiculoTableDto.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<void> sincronizarComBanco(List<TipoVeiculoTableDto> itens) async {
    return await executeVoidWithLogging(
      operationName: 'sincronizarComBanco',
      operation: () async {
        await db.transaction(() async {
          // ⚠️ NÃO deleta tudo porque veiculo_table tem FK para tipo_veiculo_table
          // Usa apenas UPSERT para sincronizar
          for (final tipoVeiculo in itens) {
            await tipoVeiculoDao.inserirOuAtualizar(tipoVeiculo.toCompanion());
          }
        });
        AppLogger.i('Sincronizados ${itens.length} tipos de veículo',
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
        final tipos = await tipoVeiculoDao.listar();
        return tipos.isEmpty;
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES DE LEITURA (READ)
  // ============================================================================

  /// Lista todos os tipos de veículo cadastrados no banco de dados local.
  ///
  /// Recupera todos os registros da tabela de tipos de veículo e os converte
  /// para DTOs padronizados, fornecendo uma lista completa de tipos
  /// disponíveis no sistema.
  ///
  /// ## Retorno:
  /// - `Future<List<TipoVeiculoTableDto>>`: Lista de todos os tipos de veículo
  ///
  /// ## Comportamento:
  /// - Busca todos os registros da tabela tipos de veículo
  /// - Converte cada entidade para DTO correspondente
  /// - Retorna lista vazia se não houver tipos cadastrados
  ///
  /// ## Casos de Uso:
  /// - Carregamento inicial da lista de tipos
  /// - Atualização de interface após sincronização
  /// - Relatórios e consultas gerais
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipos = await tipoVeiculoRepo.listar();
  /// tipos.forEach((tipo) => print('${tipo.nome} - ${tipo.descricao}'));
  /// ```
  Future<List<TipoVeiculoTableDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        final tipos = await tipoVeiculoDao.listar();
        return tipos
            .map((tipo) => TipoVeiculoTableDto.fromEntity(tipo))
            .toList();
      },
    );
  }

  /// Busca um tipo de veículo específico pelo seu identificador único.
  ///
  /// Localiza um tipo de veículo no banco de dados através do ID primário
  /// e retorna os dados completos em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do tipo de veículo (int)
  ///
  /// ## Retorno:
  /// - `Future<TipoVeiculoTableDto>`: Dados completos do tipo encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por ID
  /// - Converte entidade para DTO
  /// - Lança exceção se tipo não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Visualização de detalhes do tipo
  /// - Edição de dados específicos
  /// - Validação de existência de tipo
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipo = await tipoVeiculoRepo.buscarPorId(123);
  /// print('Tipo: ${tipo.nome}');
  /// ```
  Future<TipoVeiculoTableDto> buscarPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        final tipo = await tipoVeiculoDao.buscarPorIdOuFalha(id);
        return TipoVeiculoTableDto.fromEntity(tipo);
      },
    );
  }

  /// Busca um tipo de veículo específico pelo seu remote ID.
  ///
  /// Localiza um tipo de veículo no banco de dados através do remote ID
  /// (identificador único de negócio) e retorna os dados completos
  /// em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `remoteId`: Remote ID do tipo de veículo (String)
  ///
  /// ## Retorno:
  /// - `Future<TipoVeiculoTableDto>`: Dados completos do tipo encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por remote ID
  /// - Converte entidade para DTO
  /// - Lança exceção se tipo não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Busca por identificador de negócio
  /// - Validação de remote ID existente
  /// - Consulta rápida por remote ID
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipo = await tipoVeiculoRepo.buscarPorRemoteId('tipo-123');
  /// print('Tipo encontrado: ${tipo.nome}');
  /// ```
  Future<TipoVeiculoTableDto> buscarPorRemoteId(int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarPorRemoteId',
      operation: () async {
        final tipo = await tipoVeiculoDao.buscarPorRemoteIdOuFalha(remoteId);
        return TipoVeiculoTableDto.fromEntity(tipo);
      },
    );
  }

  /// Busca tipos de veículo por nome.
  ///
  /// Localiza todos os tipos de veículo que contenham o nome especificado
  /// no banco de dados e retorna uma lista de DTOs padronizados.
  ///
  /// ## Parâmetros:
  /// - `nome`: Nome ou parte do nome do tipo de veículo (String)
  ///
  /// ## Retorno:
  /// - `Future<List<TipoVeiculoTableDto>>`: Lista de tipos encontrados
  ///
  /// ## Comportamento:
  /// - Busca registros que contenham o nome especificado
  /// - Converte entidades para DTOs
  /// - Retorna lista vazia se não houver tipos com o nome
  ///
  /// ## Casos de Uso:
  /// - Busca por nome parcial
  /// - Filtro por nome
  /// - Consultas de pesquisa
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipos = await tipoVeiculoRepo.buscarPorNome('Carro');
  /// print('Encontrados ${tipos.length} tipos com "Carro"');
  /// ```
  Future<List<TipoVeiculoTableDto>> buscarPorNome(String nome) async {
    return await executeWithLogging(
      operationName: 'buscarPorNome',
      operation: () async {
        final tipos = await tipoVeiculoDao.buscarPorNome(nome);
        return tipos
            .map((tipo) => TipoVeiculoTableDto.fromEntity(tipo))
            .toList();
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES DE ESCRITA (CREATE, UPDATE, DELETE)
  // ============================================================================

  /// Insere um novo tipo de veículo no banco de dados.
  ///
  /// Adiciona um novo registro de tipo de veículo ao banco de dados local,
  /// gerando automaticamente um ID único e retornando os dados
  /// completos do tipo inserido.
  ///
  /// ## Parâmetros:
  /// - `tipoVeiculo`: DTO com dados do tipo de veículo a ser inserido
  ///
  /// ## Retorno:
  /// - `Future<TipoVeiculoTableDto>`: Dados completos do tipo inserido
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Insere registro e recebe ID gerado
  /// - Busca registro inserido para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Cadastro de novos tipos de veículo
  /// - Importação de dados externos
  /// - Sincronização de dados
  ///
  /// ## Exemplo:
  /// ```dart
  /// final novoTipo = TipoVeiculoTableDto(
  ///   remoteId: 'tipo-123',
  ///   nome: 'Carro',
  ///   descricao: 'Veículo de passeio',
  /// );
  /// final tipoInserido = await tipoVeiculoRepo.inserir(novoTipo);
  /// print('ID gerado: ${tipoInserido.id}');
  /// ```
  Future<TipoVeiculoTableDto> inserir(TipoVeiculoTableDto tipoVeiculo) async {
    return await executeWithLogging(
      operationName: 'inserir',
      operation: () async {
        final id =
            await tipoVeiculoDao.inserirOuAtualizar(tipoVeiculo.toCompanion());
        final tipoInserido = await tipoVeiculoDao.buscarPorIdOuFalha(id);
        return TipoVeiculoTableDto.fromEntity(tipoInserido);
      },
    );
  }

  /// Atualiza os dados de um tipo de veículo existente.
  ///
  /// Modifica os dados de um tipo de veículo já cadastrado no banco de dados,
  /// mantendo o ID original e retornando os dados atualizados.
  ///
  /// ## Parâmetros:
  /// - `tipoVeiculo`: DTO com dados atualizados do tipo (deve conter ID válido)
  ///
  /// ## Retorno:
  /// - `Future<TipoVeiculoTableDto>`: Dados completos do tipo atualizado
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Atualiza registro existente por ID
  /// - Busca registro atualizado para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Edição de dados do tipo
  /// - Atualização de informações
  /// - Sincronização de mudanças
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipoAtualizado = TipoVeiculoTableDto(
  ///   id: '123',
  ///   remoteId: 'tipo-123',
  ///   nome: 'Automóvel',
  ///   descricao: 'Veículo de passeio com 4 rodas',
  /// );
  /// final resultado = await tipoVeiculoRepo.atualizar(tipoAtualizado);
  /// print('Tipo atualizado: ${resultado.nome}');
  /// ```
  Future<TipoVeiculoTableDto> atualizar(TipoVeiculoTableDto tipoVeiculo) async {
    return await executeWithLogging(
      operationName: 'atualizar',
      operation: () async {
        await tipoVeiculoDao.atualizar(tipoVeiculo.toEntity());
        final tipoAtualizado =
            await tipoVeiculoDao.buscarPorIdOuFalha(int.parse(tipoVeiculo.id));
        return TipoVeiculoTableDto.fromEntity(tipoAtualizado);
      },
    );
  }

  /// Remove um tipo de veículo do banco de dados.
  ///
  /// Exclui permanentemente um registro de tipo de veículo do banco de dados
  /// local através do seu identificador único. Esta operação é
  /// irreversível e deve ser usada com cuidado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do tipo a ser removido
  ///
  /// ## Retorno:
  /// - `Future<void>`: Completa quando a exclusão é finalizada
  ///
  /// ## Comportamento:
  /// - Remove registro específico por ID
  /// - Operação atômica (sucesso ou falha completa)
  /// - Não retorna dados (operação de exclusão)
  ///
  /// ## Casos de Uso:
  /// - Exclusão de tipo de veículo
  /// - Limpeza de dados obsoletos
  /// - Remoção de registros duplicados
  ///
  /// ## Exemplo:
  /// ```dart
  /// await tipoVeiculoRepo.deletar(123);
  /// print('Tipo removido com sucesso');
  /// ```
  ///
  /// ## ⚠️ Atenção:
  /// Esta operação é **irreversível**. Certifique-se de que o tipo
  /// realmente deve ser removido antes de executar esta operação.
  Future<void> deletar(int id) async {
    return await executeVoidWithLogging(
      operationName: 'deletar',
      operation: () async {
        await tipoVeiculoDao.deletar(id);
      },
    );
  }
}
