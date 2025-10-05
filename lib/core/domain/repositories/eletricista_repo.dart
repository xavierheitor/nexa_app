import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/eletricista_dao.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

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
class EletricistaRepo implements SyncableRepository<EletricistaTableDto> {
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
  // IMPLEMENTAÇÃO DO SYNCABLE REPOSITORY
  // ============================================================================

  @override
  String get nomeEntidade => 'eletricista';

  @override
  Future<List<EletricistaTableDto>> buscarDaApi() async {
    try {
      /// Envia requisição GET para endpoint de eletricistas.
      final response = await dio.get(ApiConstants.eletricistas);

      /// Converte resposta JSON para lista de DTOs tipados.
      return (response.data as List)
          .map((json) => EletricistaTableDto.fromJson(json))
          .toList();
    } catch (e, s) {
      /// Trata erro bruto e converte para AppException padronizada.
      final erro = ErrorHandler.tratar(e, s);

      /// Registra erro detalhado para debugging e monitoramento.
      AppLogger.e(
        '[eletricista_repository - buscarDaApi] ${erro.mensagem}',
        tag: 'EletricistaRepository',
        error: e,
        stackTrace: s,
      );

      /// Re-lança erro tratado para camada superior.
      throw erro;
    }
  }

  @override
  Future<void> sincronizarComBanco(List<EletricistaTableDto> itens) async {
    try {
      /// Executa sincronização em transação para garantir atomicidade.
      await db.transaction(() async {
        /// Limpa todos os registros existentes.
        await eletricistaDao.deletarTodos();

        /// Insere todos os novos itens.
        for (final eletricista in itens) {
          await eletricistaDao.inserirOuAtualizar(eletricista.toCompanion());
        }
      });

      AppLogger.i(
        '[eletricista_repository - sincronizarComBanco] Sincronizados ${itens.length} eletricistas',
        tag: 'EletricistaRepository',
      );
    } catch (e, s) {
      /// Trata erro bruto e converte para AppException padronizada.
      final erro = ErrorHandler.tratar(e, s);

      /// Registra erro detalhado para debugging e monitoramento.
      AppLogger.e(
        '[eletricista_repository - sincronizarComBanco] ${erro.mensagem}',
        tag: 'EletricistaRepository',
        error: e,
        stackTrace: s,
      );

      /// Re-lança erro tratado para camada superior.
      throw erro;
    }
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    try {
      /// Verifica se a tabela de eletricistas está vazia.
      final count = await eletricistaDao.contar();
      return count == 0;
    } catch (e, s) {
      /// Em caso de erro, assume que não está vazio para evitar perda de dados.
      AppLogger.e(
        '[eletricista_repository - estaVazio] Erro ao verificar se tabela está vazia: $e',
        tag: 'EletricistaRepository',
        error: e,
        stackTrace: s,
      );
      return false;
    }
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
    /// Executa consulta no banco para obter todas as entidades de eletricista.
    final eletricistas = await eletricistaDao.listar();

    /// Converte cada entidade para DTO padronizado e retorna como lista.
    return eletricistas
        .map((eletricista) => EletricistaTableDto.fromEntity(eletricista))
        .toList();
  }

  /// Busca um eletricista específico pelo seu identificador único.
  ///
  /// Localiza um eletricista no banco de dados através do ID primário
  /// e retorna os dados completos em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do eletricista (int)
  ///
  /// ## Retorno:
  /// - `Future<EletricistaTableDto>`: Dados completos do eletricista encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por ID
  /// - Converte entidade para DTO
  /// - Lança exceção se eletricista não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Visualização de detalhes do eletricista
  /// - Edição de dados específicos
  /// - Validação de existência de eletricista
  ///
  /// ## Exemplo:
  /// ```dart
  /// final eletricista = await eletricistaRepo.buscarPorId(123);
  /// print('Eletricista: ${eletricista.nome}');
  /// ```
  Future<EletricistaTableDto> buscarPorId(int id) async {
    /// Busca entidade específica no banco através do DAO.
    final eletricista = await eletricistaDao.buscarPorId(id);

    /// Converte entidade para DTO e retorna dados padronizados.
    return EletricistaTableDto.fromEntity(eletricista);
  }

  /// Busca um eletricista pelo identificador remoto.
  Future<EletricistaTableDto?> buscarPorRemoteIdOuNull(int remoteId) async {
    final entidade = await eletricistaDao.buscarPorRemoteIdOuNull(remoteId);
    return entidade != null ? EletricistaTableDto.fromEntity(entidade) : null;
  }

  /// Busca um eletricista pelo identificador remoto (lançando se não encontrar).
  Future<EletricistaTableDto> buscarPorRemoteId(int remoteId) async {
    final entidade = await eletricistaDao.buscarPorRemoteId(remoteId);
    return EletricistaTableDto.fromEntity(entidade);
  }

  /// Busca um eletricista por matrícula.
  ///
  /// Localiza um eletricista no banco de dados através da matrícula
  /// e retorna os dados completos em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `matricula`: Matrícula do eletricista (String)
  ///
  /// ## Retorno:
  /// - `Future<EletricistaTableDto>`: Dados completos do eletricista encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por matrícula
  /// - Converte entidade para DTO
  /// - Lança exceção se eletricista não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Login por matrícula
  /// - Validação de matrícula existente
  /// - Busca rápida de eletricista
  ///
  /// ## Exemplo:
  /// ```dart
  /// final eletricista = await eletricistaRepo.buscarPorMatricula('12345');
  /// print('Eletricista: ${eletricista.nome}');
  /// ```
  Future<EletricistaTableDto> buscarPorMatricula(String matricula) async {
    /// Busca entidade específica no banco através do DAO.
    final eletricista = await eletricistaDao.buscarPorMatricula(matricula);

    /// Converte entidade para DTO e retorna dados padronizados.
    return EletricistaTableDto.fromEntity(eletricista);
  }

  /// Busca eletricistas por nome (busca parcial).
  ///
  /// Localiza eletricistas no banco de dados que contenham o nome
  /// especificado e retorna uma lista de DTOs padronizados.
  ///
  /// ## Parâmetros:
  /// - `nome`: Nome ou parte do nome do eletricista (String)
  ///
  /// ## Retorno:
  /// - `Future<List<EletricistaTableDto>>`: Lista de eletricistas encontrados
  ///
  /// ## Comportamento:
  /// - Busca registros que contenham o nome especificado
  /// - Converte cada entidade para DTO
  /// - Retorna lista vazia se nenhum eletricista for encontrado
  ///
  /// ## Casos de Uso:
  /// - Busca por nome parcial
  /// - Filtros de interface
  /// - Autocomplete de nomes
  ///
  /// ## Exemplo:
  /// ```dart
  /// final eletricistas = await eletricistaRepo.buscarPorNome('João');
  /// print('Encontrados ${eletricistas.length} eletricistas');
  /// ```
  Future<List<EletricistaTableDto>> buscarPorNome(String nome) async {
    /// Executa consulta no banco para obter eletricistas com nome similar.
    final eletricistas = await eletricistaDao.buscarPorNome(nome);

    /// Converte cada entidade para DTO padronizado e retorna como lista.
    return eletricistas
        .map((eletricista) => EletricistaTableDto.fromEntity(eletricista))
        .toList();
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
    /// Converte DTO para Companion (formato de inserção do Drift).
    /// O ID é omitido para permitir geração automática pelo banco.
    final id =
        await eletricistaDao.inserirOuAtualizar(eletricista.toCompanion());

    /// Busca o registro recém-inserido para obter dados completos
    /// incluindo o ID gerado automaticamente.
    final eletricistaInserido = await eletricistaDao.buscarPorId(id);

    /// Converte a entidade para DTO e retorna dados completos.
    return EletricistaTableDto.fromEntity(eletricistaInserido);
  }

  /// Atualiza os dados de um eletricista existente.
  ///
  /// Modifica os dados de um eletricista já cadastrado no banco de dados,
  /// mantendo o ID original e retornando os dados atualizados.
  ///
  /// ## Parâmetros:
  /// - `eletricista`: DTO com dados atualizados do eletricista (deve conter ID válido)
  ///
  /// ## Retorno:
  /// - `Future<EletricistaTableDto>`: Dados completos do eletricista atualizado
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Atualiza registro existente por ID
  /// - Busca registro atualizado para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Edição de dados do eletricista
  /// - Atualização de informações
  /// - Sincronização de mudanças
  ///
  /// ## Exemplo:
  /// ```dart
  /// final eletricistaAtualizado = EletricistaTableDto(
  ///   id: '123',
  ///   remoteId: '123',
  ///   nome: 'João Silva Santos',
  ///   matricula: '12345',
  /// );
  /// final resultado = await eletricistaRepo.atualizar(eletricistaAtualizado);
  /// print('Eletricista atualizado: ${resultado.nome}');
  /// ```
  Future<EletricistaTableDto> atualizar(EletricistaTableDto eletricista) async {
    /// Converte DTO para entidade e executa atualização no banco.
    await eletricistaDao.atualizar(eletricista.toEntity());

    /// Busca o registro atualizado para garantir dados consistentes
    /// e obter qualquer valor calculado ou modificado pelo banco.
    final eletricistaAtualizado =
        await eletricistaDao.buscarPorId(int.parse(eletricista.id));

    /// Converte a entidade atualizada para DTO e retorna.
    return EletricistaTableDto.fromEntity(eletricistaAtualizado);
  }

  /// Remove um eletricista do banco de dados.
  ///
  /// Exclui permanentemente um registro de eletricista do banco de dados
  /// local através do seu identificador único. Esta operação é
  /// irreversível e deve ser usada com cuidado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do eletricista a ser removido
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
  /// - Exclusão de eletricista
  /// - Limpeza de dados obsoletos
  /// - Remoção de registros duplicados
  ///
  /// ## Exemplo:
  /// ```dart
  /// await eletricistaRepo.deletar(123);
  /// print('Eletricista removido com sucesso');
  /// ```
  ///
  /// ## ⚠️ Atenção:
  /// Esta operação é **irreversível**. Certifique-se de que o eletricista
  /// realmente deve ser removido antes de executar esta operação.
  Future<void> deletar(int id) async {
    /// Executa exclusão do registro específico por ID.
    /// A operação é atômica e falhará completamente se houver problemas.
    await eletricistaDao.deletar(id);
  }
}
