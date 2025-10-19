import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/veiculo_dao.dart';
import 'package:nexa_app/data/models/veiculo_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório responsável pelo gerenciamento de dados de veículos.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a veículos, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de veículos
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID, placa e tipo
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
/// 7. **Sincronização**: Implementa SyncableRepository para sincronização
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em veículos
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
/// final veiculoRepo = VeiculoRepo(dio: dioClient, db: database);
///
/// // Listar todos os veículos
/// final veiculos = await veiculoRepo.listar();
///
/// // Buscar veículo por placa
/// final veiculo = await veiculoRepo.buscarPorPlaca('ABC-1234');
///
/// // Inserir novo veículo
/// final novoVeiculo = await veiculoRepo.inserir(veiculoDto);
/// ```
///
/// ## Dependências:
/// - `DioClient`: Cliente HTTP para comunicação com APIs
/// - `AppDatabase`: Instância do banco de dados local
/// - `VeiculoDao`: Data Access Object para operações de veículo
/// - `VeiculoTableDto`: DTO para representação de dados de veículo
class VeiculoRepo implements SyncableRepository<VeiculoTableDto> {
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

  /// Data Access Object específico para operações de veículo.
  ///
  /// Encapsula todas as operações SQL relacionadas à tabela de veículos,
  /// incluindo CRUD básico e consultas personalizadas. Inicializado
  /// automaticamente a partir da instância do banco de dados.
  final VeiculoDao veiculoDao;

  /// Construtor do repositório de veículos.
  ///
  /// Inicializa o repositório com as dependências necessárias e
  /// configura o DAO de veículo a partir da instância do banco.
  ///
  /// ## Parâmetros:
  /// - `dio`: Cliente HTTP para comunicação com APIs (obrigatório)
  /// - `db`: Instância do banco de dados local (obrigatório)
  ///
  /// ## Inicialização:
  /// O `veiculoDao` é inicializado automaticamente através de `db.veiculoDao`,
  /// garantindo que todas as operações de banco sejam executadas corretamente.
  VeiculoRepo({required this.dio, required this.db})
      : veiculoDao = db.veiculoDao;

  // ============================================================================
  // IMPLEMENTAÇÃO DO SYNCABLE REPOSITORY
  // ============================================================================

  @override
  String get nomeEntidade => 'veiculo';

  @override
  Future<List<VeiculoTableDto>> buscarDaApi() async {
    try {
      /// Envia requisição GET para endpoint de veículos.
      final response = await dio.get(ApiConstants.veiculos);

      /// Converte resposta JSON para lista de DTOs tipados.
      return (response.data as List)
          .map((json) => VeiculoTableDto.fromJson(json))
          .toList();
    } catch (e, s) {
      /// Trata erro bruto e converte para AppException padronizada.
      final erro = ErrorHandler.tratar(e, s);

      /// Registra erro detalhado para debugging e monitoramento.
      AppLogger.e(
        '[veiculo_repository - buscarDaApi] ${erro.mensagem}',
        tag: 'VeiculoRepository',
        error: e,
        stackTrace: s,
      );

      /// Re-lança erro tratado para camada superior.
      throw erro;
    }
  }

  @override
  Future<void> sincronizarComBanco(List<VeiculoTableDto> itens) async {
    try {
      /// Executa sincronização em transação para garantir atomicidade.
      await db.transaction(() async {
        /// Limpa todos os registros existentes.
        await veiculoDao.deletarTodos();

        /// Insere todos os novos itens.
        for (final veiculo in itens) {
          await veiculoDao.inserirOuAtualizar(veiculo.toCompanion());
        }
      });

      AppLogger.i(
        '[veiculo_repository - sincronizarComBanco] Sincronizados ${itens.length} veículos',
        tag: 'VeiculoRepository',
      );
    } catch (e, s) {
      /// Trata erro bruto e converte para AppException padronizada.
      final erro = ErrorHandler.tratar(e, s);

      /// Registra erro detalhado para debugging e monitoramento.
      AppLogger.e(
        '[veiculo_repository - sincronizarComBanco] ${erro.mensagem}',
        tag: 'VeiculoRepository',
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
      /// Verifica se a tabela de veículos está vazia.
      final count = await veiculoDao.contarVeiculosAtivos();
      return count == 0;
    } catch (e, s) {
      /// Em caso de erro, assume que não está vazio para evitar perda de dados.
      AppLogger.e(
        '[veiculo_repository - estaVazio] Erro ao verificar se tabela está vazia: $e',
        tag: 'VeiculoRepository',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  // ============================================================================
  // OPERAÇÕES DE LEITURA (READ)
  // ============================================================================

  /// Lista todos os veículos cadastrados no banco de dados local.
  ///
  /// Recupera todos os registros da tabela de veículos e os converte
  /// para DTOs padronizados, fornecendo uma lista completa de veículos
  /// disponíveis no sistema.
  ///
  /// ## Retorno:
  /// - `Future<List<VeiculoTableDto>>`: Lista de todos os veículos
  ///
  /// ## Comportamento:
  /// - Busca todos os registros da tabela veículos
  /// - Converte cada entidade para DTO correspondente
  /// - Retorna lista vazia se não houver veículos cadastrados
  ///
  /// ## Casos de Uso:
  /// - Carregamento inicial da lista de veículos
  /// - Atualização de interface após sincronização
  /// - Relatórios e consultas gerais
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculos = await veiculoRepo.listar();
  /// veiculos.forEach((veiculo) => print('${veiculo.modelo} - ${veiculo.placa}'));
  /// ```
  Future<List<VeiculoTableDto>> listar() async {
    /// Executa consulta no banco para obter todas as entidades de veículo.
    final veiculos = await veiculoDao.listar();

    /// Converte cada entidade para DTO padronizado e retorna como lista.
    return veiculos
        .map((veiculo) => VeiculoTableDto.fromEntity(veiculo))
        .toList();
  }

  /// Busca um veículo específico pelo seu identificador único.
  ///
  /// Localiza um veículo no banco de dados através do ID primário
  /// e retorna os dados completos em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do veículo (int)
  ///
  /// ## Retorno:
  /// - `Future<VeiculoTableDto>`: Dados completos do veículo encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por ID
  /// - Converte entidade para DTO
  /// - Lança exceção se veículo não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Visualização de detalhes do veículo
  /// - Edição de dados específicos
  /// - Validação de existência de veículo
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoRepo.buscarPorId(123);
  /// print('Veículo: ${veiculo.modelo}');
  /// ```
  Future<VeiculoTableDto> buscarPorId(int id) async {
    /// Executa consulta específica por ID no banco de dados.
    final veiculo = await veiculoDao.buscarPorId(id);

    /// Converte a entidade encontrada para DTO padronizado.
    return VeiculoTableDto.fromEntity(veiculo);
  }

  /// Busca um veículo específico pela sua placa.
  ///
  /// Localiza um veículo no banco de dados através da placa
  /// (identificador único de negócio) e retorna os dados completos
  /// em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `placa`: Placa do veículo (String)
  ///
  /// ## Retorno:
  /// - `Future<VeiculoTableDto>`: Dados completos do veículo encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por placa
  /// - Converte entidade para DTO
  /// - Lança exceção se veículo não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Busca por identificador de negócio
  /// - Validação de placa existente
  /// - Consulta rápida por placa
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoRepo.buscarPorPlaca('ABC-1234');
  /// print('Veículo encontrado: ${veiculo.modelo}');
  /// ```
  Future<VeiculoTableDto> buscarPorPlaca(String placa) async {
    /// Executa consulta específica por placa no banco de dados.
    final veiculo = await veiculoDao.buscarPorPlaca(placa);

    /// Converte a entidade encontrada para DTO padronizado.
    return VeiculoTableDto.fromEntity(veiculo);
  }

  /// Busca veículos por tipo de veículo.
  ///
  /// Localiza todos os veículos de um tipo específico no banco de dados
  /// e retorna uma lista de DTOs padronizados.
  ///
  /// ## Parâmetros:
  /// - `tipoVeiculoId`: ID do tipo de veículo (int)
  ///
  /// ## Retorno:
  /// - `Future<List<VeiculoTableDto>>`: Lista de veículos do tipo especificado
  ///
  /// ## Comportamento:
  /// - Busca registros por tipo de veículo
  /// - Converte entidades para DTOs
  /// - Retorna lista vazia se não houver veículos do tipo
  ///
  /// ## Casos de Uso:
  /// - Filtro por categoria de veículo
  /// - Relatórios por tipo
  /// - Consultas específicas
  ///
  /// ## Exemplo:
  /// ```dart
  /// final carros = await veiculoRepo.buscarPorTipoVeiculo(1);
  /// print('Encontrados ${carros.length} carros');
  /// ```
  Future<List<VeiculoTableDto>> buscarPorTipoVeiculo(int tipoVeiculoId) async {
    /// Executa consulta por tipo de veículo no banco de dados.
    final veiculos = await veiculoDao.buscarPorTipoVeiculo(tipoVeiculoId);

    /// Converte cada entidade para DTO padronizado e retorna como lista.
    return veiculos
        .map((veiculo) => VeiculoTableDto.fromEntity(veiculo))
        .toList();
  }

  // ============================================================================
  // OPERAÇÕES DE ESCRITA (CREATE, UPDATE, DELETE)
  // ============================================================================

  /// Insere um novo veículo no banco de dados.
  ///
  /// Adiciona um novo registro de veículo ao banco de dados local,
  /// gerando automaticamente um ID único e retornando os dados
  /// completos do veículo inserido.
  ///
  /// ## Parâmetros:
  /// - `veiculo`: DTO com dados do veículo a ser inserido
  ///
  /// ## Retorno:
  /// - `Future<VeiculoTableDto>`: Dados completos do veículo inserido
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Insere registro e recebe ID gerado
  /// - Busca registro inserido para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Cadastro de novos veículos
  /// - Importação de dados externos
  /// - Sincronização de dados
  ///
  /// ## Exemplo:
  /// ```dart
  /// final novoVeiculo = VeiculoTableDto(
  ///   placa: 'ABC-1234',
  ///   modelo: 'Civic',
  ///   ano: 2020,
  ///   tipoVeiculoId: 1,
  /// );
  /// final veiculoInserido = await veiculoRepo.inserir(novoVeiculo);
  /// print('ID gerado: ${veiculoInserido.id}');
  /// ```
  Future<VeiculoTableDto> inserir(VeiculoTableDto veiculo) async {
    /// Converte DTO para Companion (formato de inserção do Drift).
    /// O ID é omitido para permitir geração automática pelo banco.
    final id = await veiculoDao.inserirOuAtualizar(veiculo.toCompanion());

    /// Busca o registro recém-inserido para obter dados completos
    /// incluindo o ID gerado automaticamente.
    final veiculoInserido = await veiculoDao.buscarPorId(id);

    /// Converte a entidade para DTO e retorna dados completos.
    return VeiculoTableDto.fromEntity(veiculoInserido);
  }

  /// Atualiza os dados de um veículo existente.
  ///
  /// Modifica os dados de um veículo já cadastrado no banco de dados,
  /// mantendo o ID original e retornando os dados atualizados.
  ///
  /// ## Parâmetros:
  /// - `veiculo`: DTO com dados atualizados do veículo (deve conter ID válido)
  ///
  /// ## Retorno:
  /// - `Future<VeiculoTableDto>`: Dados completos do veículo atualizado
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Atualiza registro existente por ID
  /// - Busca registro atualizado para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Edição de dados do veículo
  /// - Atualização de informações
  /// - Sincronização de mudanças
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculoAtualizado = VeiculoTableDto(
  ///   id: '123',
  ///   placa: 'ABC-1234',
  ///   modelo: 'Civic 2021',
  ///   ano: 2021,
  ///   tipoVeiculoId: 1,
  /// );
  /// final resultado = await veiculoRepo.atualizar(veiculoAtualizado);
  /// print('Veículo atualizado: ${resultado.modelo}');
  /// ```
  Future<VeiculoTableDto> atualizar(VeiculoTableDto veiculo) async {
    /// Converte DTO para entidade e executa atualização no banco.
    await veiculoDao.atualizar(veiculo.toEntity());

    /// Busca o registro atualizado para garantir dados consistentes
    /// e obter qualquer valor calculado ou modificado pelo banco.
    final veiculoAtualizado =
        await veiculoDao.buscarPorId(int.parse(veiculo.id));

    /// Converte a entidade atualizada para DTO e retorna.
    return VeiculoTableDto.fromEntity(veiculoAtualizado);
  }

  /// Remove um veículo do banco de dados.
  ///
  /// Exclui permanentemente um registro de veículo do banco de dados
  /// local através do seu identificador único. Esta operação é
  /// irreversível e deve ser usada com cuidado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do veículo a ser removido
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
  /// - Exclusão de veículo
  /// - Limpeza de dados obsoletos
  /// - Remoção de registros duplicados
  ///
  /// ## Exemplo:
  /// ```dart
  /// await veiculoRepo.deletar(123);
  /// print('Veículo removido com sucesso');
  /// ```
  ///
  /// ## ⚠️ Atenção:
  /// Esta operação é **irreversível**. Certifique-se de que o veículo
  /// realmente deve ser removido antes de executar esta operação.
  Future<void> deletar(int id) async {
    /// Executa exclusão do registro específico por ID.
    /// A operação é atômica e falhará completamente se houver problemas.
    await veiculoDao.deletar(id);
  }

}
