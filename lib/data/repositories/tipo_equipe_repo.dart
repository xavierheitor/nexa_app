import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/tipo_equipe_dao.dart';
import 'package:nexa_app/data/models/tipo_equipe_table_dto.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';

/// Repositório responsável pelo gerenciamento de dados de tipos de equipe.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a tipos de equipe, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de tipos de equipe
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID e nome
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
/// 7. **Sincronização**: Implementa SyncableRepository para sincronização
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em tipos de equipe
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
/// final tipoEquipeRepo = TipoEquipeRepo(dio: dioClient, db: database);
///
/// // Listar todos os tipos de equipe
/// final tiposEquipe = await tipoEquipeRepo.listar();
///
/// // Buscar por ID
/// final tipoEquipe = await tipoEquipeRepo.buscarPorId('1');
///
/// // Criar novo tipo de equipe
/// final novoTipoEquipe = TipoEquipeTableDto(...);
/// await tipoEquipeRepo.criar(novoTipoEquipe);
/// ```
class TipoEquipeRepo implements SyncableRepository<TipoEquipeTableDto> {
  final DioClient _dio;
  final AppDatabase _db;
  late final TipoEquipeDao _dao;

  TipoEquipeRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _dao = _db.tipoEquipeDao;
  }

  @override
  String get nomeEntidade => 'tipo_equipe';

  /// Lista todos os tipos de equipe do banco local
  Future<List<TipoEquipeTableDto>> listar() async {
    try {
      AppLogger.d('Listando tipos de equipe', tag: 'TipoEquipeRepository');

      final entidades = await _dao.listar();
      final dtos =
          entidades.map((e) => TipoEquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} tipos de equipe encontrados',
          tag: 'TipoEquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao listar tipos de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Busca um tipo de equipe por ID
  Future<TipoEquipeTableDto?> buscarPorId(String id) async {
    try {
      AppLogger.d('Buscando tipo de equipe por ID: $id',
          tag: 'TipoEquipeRepository');

      final entidade = await _dao.buscarPorIdOuNull(int.parse(id));
      if (entidade == null) {
        AppLogger.d('Tipo de equipe não encontrado',
            tag: 'TipoEquipeRepository');
        return null;
      }

      final dto = TipoEquipeTableDto.fromEntity(entidade);
      AppLogger.d('Tipo de equipe encontrado: ${dto.nome}',
          tag: 'TipoEquipeRepository');
      return dto;
    } catch (e) {
      AppLogger.e('Erro ao buscar tipo de equipe por ID: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Busca tipos de equipe por nome
  Future<List<TipoEquipeTableDto>> buscarPorNome(String nome) async {
    try {
      AppLogger.d('Buscando tipos de equipe por nome: $nome',
          tag: 'TipoEquipeRepository');

      final entidades = await _dao.buscarPorNome(nome);
      final dtos =
          entidades.map((e) => TipoEquipeTableDto.fromEntity(e)).toList();

      AppLogger.d('${dtos.length} tipos de equipe encontrados',
          tag: 'TipoEquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar tipos de equipe por nome: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Cria um novo tipo de equipe
  Future<TipoEquipeTableDto> criar(TipoEquipeTableDto dto) async {
    try {
      AppLogger.d('Criando tipo de equipe: ${dto.nome}',
          tag: 'TipoEquipeRepository');

      dto.validate();

      final companion = dto.toCompanion();
      final id = await _dao.inserirOuAtualizar(companion);

      final novoDto = dto.copyWith(id: id.toString());
      AppLogger.d('Tipo de equipe criado com ID: $id',
          tag: 'TipoEquipeRepository');
      return novoDto;
    } catch (e) {
      AppLogger.e('Erro ao criar tipo de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Atualiza um tipo de equipe existente
  Future<TipoEquipeTableDto> atualizar(TipoEquipeTableDto dto) async {
    try {
      AppLogger.d('Atualizando tipo de equipe: ${dto.nome}',
          tag: 'TipoEquipeRepository');

      dto.validate();

      final entidade = dto.toEntity();
      await _dao.atualizar(entidade);

      AppLogger.d('Tipo de equipe atualizado com sucesso',
          tag: 'TipoEquipeRepository');
      return dto;
    } catch (e) {
      AppLogger.e('Erro ao atualizar tipo de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Deleta um tipo de equipe
  Future<void> deletar(String id) async {
    try {
      AppLogger.d('Deletando tipo de equipe: $id', tag: 'TipoEquipeRepository');

      await _dao.deletar(int.parse(id));

      AppLogger.d('Tipo de equipe deletado com sucesso',
          tag: 'TipoEquipeRepository');
    } catch (e) {
      AppLogger.e('Erro ao deletar tipo de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  /// Conta o número de tipos de equipe
  Future<int> contar() async {
    try {
      AppLogger.d('Contando tipos de equipe', tag: 'TipoEquipeRepository');

      final count = await _dao.contar();

      AppLogger.d('Total de tipos de equipe: $count',
          tag: 'TipoEquipeRepository');
      return count;
    } catch (e) {
      AppLogger.e('Erro ao contar tipos de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    try {
      final count = await _dao.contar();
      return count == 0;
    } catch (e) {
      AppLogger.e('Erro ao verificar se tipos de equipe estão vazios: $e',
          tag: 'TipoEquipeRepository');
      return true; // Em caso de erro, considera vazio para forçar sincronização
    }
  }

  @override
  Future<List<TipoEquipeTableDto>> buscarDaApi() async {
    try {
      AppLogger.d('Buscando tipos de equipe da API',
          tag: 'TipoEquipeRepository');

      final response = await _dio.get(ApiConstants.tiposEquipe);

      if (response.data == null) {
        AppLogger.w('Resposta da API vazia para tipos de equipe',
            tag: 'TipoEquipeRepository');
        return [];
      }

      final List<dynamic> data =
          response.data is List ? response.data : [response.data];
      final dtos =
          data.map((json) => TipoEquipeTableDto.fromJson(json)).toList();

      AppLogger.d('${dtos.length} tipos de equipe recebidos da API',
          tag: 'TipoEquipeRepository');
      return dtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar tipos de equipe da API: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }

  @override
  Future<void> sincronizarComBanco(List<TipoEquipeTableDto> dtos) async {
    try {
      AppLogger.d('Sincronizando ${dtos.length} tipos de equipe com o banco',
          tag: 'TipoEquipeRepository');

      final companions = dtos.map((dto) => dto.toCompanion()).toList();
      await _dao.sincronizar(companions);

      AppLogger.d('Sincronização de tipos de equipe concluída',
          tag: 'TipoEquipeRepository');
    } catch (e) {
      AppLogger.e('Erro ao sincronizar tipos de equipe: $e',
          tag: 'TipoEquipeRepository');
      throw ErrorHandler.tratar(e);
    }
  }
}
