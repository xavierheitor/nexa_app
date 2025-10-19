import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/equipe_dao.dart';
import 'package:nexa_app/data/models/equipe_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

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
class EquipeRepo implements SyncableRepository<EquipeTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final EquipeDao _dao;

  EquipeRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = _db.equipeDao;
  }

  @override
  String get nomeEntidade => 'equipe';

  /// Lista todas as equipes do banco local
  Future<List<EquipeTableDto>> listar() async {
    try {
      AppLogger.d('Listando equipes', tag: 'EquipeRepository');

      final entidades = await _dao.listar();
      final dtos = entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} equipes encontradas',
          tag: 'EquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao listar equipes: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Busca uma equipe por ID
  Future<EquipeTableDto?> buscarPorId(String id) async {
    try {
      AppLogger.d('Buscando equipe por ID: $id', tag: 'EquipeRepository');

      final entidade = await _dao.buscarPorIdOuNull(int.parse(id));
      if (entidade == null) {
        AppLogger.d('Equipe não encontrada', tag: 'EquipeRepository');
        return null;
      }

      final dto = EquipeTableDto.fromEntity(entidade);
      AppLogger.d('Equipe encontrada: ${dto.nome}', tag: 'EquipeRepository');
      return dto;
    } catch (e) {
      AppLogger.e('Erro ao buscar equipe por ID: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Busca equipes por nome
  Future<List<EquipeTableDto>> buscarPorNome(String nome) async {
    try {
      AppLogger.d('Buscando equipes por nome: $nome', tag: 'EquipeRepository');

      final entidades = await _dao.buscarPorNome(nome);
      final dtos = entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} equipes encontradas',
          tag: 'EquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar equipes por nome: $e',
          tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Busca equipes por tipo de equipe
  Future<List<EquipeTableDto>> buscarPorTipoEquipe(int tipoEquipeId) async {
    try {
      AppLogger.d('Buscando equipes por tipo: $tipoEquipeId',
          tag: 'EquipeRepository');

      final entidades = await _dao.buscarPorTipoEquipe(tipoEquipeId);
      final dtos = entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} equipes encontradas',
          tag: 'EquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar equipes por tipo: $e',
          tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Lista equipes com informações do tipo de equipe
  Future<List<EquipeTableDto>> listarComTipoEquipe() async {
    try {
      AppLogger.d('Listando equipes com tipo de equipe',
          tag: 'EquipeRepository');

      final entidades = await _dao.listarComTipoEquipe();
      final dtos = entidades.map((e) => EquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} equipes encontradas',
          tag: 'EquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao listar equipes com tipo: $e',
          tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Cria uma nova equipe
  Future<EquipeTableDto> criar(EquipeTableDto dto) async {
    try {
      AppLogger.d('Criando equipe: ${dto.nome}', tag: 'EquipeRepository');

      dto.validate();

      final companion = dto.toCompanion();
      final id = await _dao.inserirOuAtualizar(companion);

      final novoDto = dto.copyWith(id: id.toString());
      AppLogger.d('Equipe criada com ID: $id', tag: 'EquipeRepository');
      return novoDto;
    } catch (e) {
      AppLogger.e('Erro ao criar equipe: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Atualiza uma equipe existente
  Future<EquipeTableDto> atualizar(EquipeTableDto dto) async {
    try {
      AppLogger.d('Atualizando equipe: ${dto.nome}', tag: 'EquipeRepository');

      dto.validate();

      final entidade = dto.toEntity();
      await _dao.atualizar(entidade);

      AppLogger.d('Equipe atualizada com sucesso', tag: 'EquipeRepository');
      return dto;
    } catch (e) {
      AppLogger.e('Erro ao atualizar equipe: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Deleta uma equipe
  Future<void> deletar(String id) async {
    try {
      AppLogger.d('Deletando equipe: $id', tag: 'EquipeRepository');

      await _dao.deletar(int.parse(id));

      AppLogger.d('Equipe deletada com sucesso', tag: 'EquipeRepository');
    } catch (e) {
      AppLogger.e('Erro ao deletar equipe: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Conta o número de equipes
  Future<int> contar() async {
    try {
      AppLogger.d('Contando equipes', tag: 'EquipeRepository');

      final count = await _dao.contar();

      AppLogger.d('Total de equipes: $count', tag: 'EquipeRepository');
      return count;
    } catch (e) {
      AppLogger.e('Erro ao contar equipes: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    try {
      final count = await _dao.contar();
      return count == 0;
    } catch (e) {
      AppLogger.e('Erro ao verificar se equipes estão vazias: $e',
          tag: 'EquipeRepository');
      return true; // Em caso de erro, considera vazio para forçar sincronização
    }
  }

  @override
  Future<List<EquipeTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('Buscando equipes da API', tag: 'EquipeRepository');

      final response = await _dio.get(ApiConstants.equipes);

      if (response.data == null) {
        AppLogger.w('Resposta da API vazia para equipes',
            tag: 'EquipeRepository');
        return [];
      }

      final List<dynamic> data =
          response.data is List ? response.data : [response.data];
      final dtos = data.map((json) => EquipeTableDto.fromJson(json)).toList();

      AppLogger.d('${dtos.length} equipes recebidas da API',
          tag: 'EquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar equipes da API: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  @override
  Future<void> sincronizarComBanco(List<EquipeTableDto> dtos) async {
    try {
      AppLogger.d('Sincronizando ${dtos.length} equipes com o banco',
          tag: 'EquipeRepository');

      final companions = dtos.map((dto) => dto.toCompanion()).toList();
      await _dao.sincronizar(companions);

      AppLogger.d('Sincronização de equipes concluída',
          tag: 'EquipeRepository');
    } catch (e) {
      AppLogger.e('Erro ao sincronizar equipes: $e', tag: 'EquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }
}
