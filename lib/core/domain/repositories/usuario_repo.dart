import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/usuario_dao.dart';
import 'package:nexa_app/core/domain/dto/login_response_dto.dart';
import 'package:nexa_app/core/domain/dto/usuario_table_dto.dart';
import 'package:nexa_app/core/utils/errors/error_handler.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório responsável pelo gerenciamento de dados de usuários.
///
/// Esta classe implementa o padrão Repository, fornecendo uma abstração
/// entre a camada de domínio e as fontes de dados (banco local e APIs).
/// Centraliza todas as operações CRUD relacionadas a usuários, oferecendo
/// uma interface limpa e consistente para o gerenciamento de dados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Operações CRUD**: Create, Read, Update, Delete de usuários
/// 2. **Abstração de Dados**: Encapsula acesso ao banco e APIs
/// 3. **Conversão de DTOs**: Transforma entidades em DTOs padronizados
/// 4. **Busca Específica**: Métodos para busca por ID e matrícula
/// 5. **Transações Seguras**: Operações atômicas no banco de dados
/// 6. **Integração Completa**: Combina banco local e comunicação de rede
///
/// ## Arquitetura:
///
/// - **Repository Pattern**: Abstração entre domínio e persistência
/// - **Dependency Injection**: Recebe dependências via construtor
/// - **Data Mapping**: Conversão entre entidades e DTOs
/// - **Single Responsibility**: Focado exclusivamente em usuários
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
/// final usuarioRepo = UsuarioRepo(dio: dioClient, db: database);
///
/// // Listar todos os usuários
/// final usuarios = await usuarioRepo.listar();
///
/// // Buscar usuário por matrícula
/// final usuario = await usuarioRepo.buscarPorMatricula('12345');
///
/// // Inserir novo usuário
/// final novoUsuario = await usuarioRepo.inserir(usuarioDto);
/// ```
///
/// ## Dependências:
/// - `DioClient`: Cliente HTTP para comunicação com APIs
/// - `AppDatabase`: Instância do banco de dados local
/// - `UsuarioDao`: Data Access Object para operações de usuário
/// - `UsuarioTableDto`: DTO para representação de dados de usuário
class UsuarioRepo {
  // ============================================================================
  // DEPENDÊNCIAS E CONFIGURAÇÃO
  // ============================================================================

  /// Cliente HTTP para comunicação com APIs externas.
  ///
  /// Utilizado para sincronização de dados, autenticação e
  /// operações que requerem comunicação com servidores remotos.
  /// Configurado com interceptors de autenticação e tratamento de erros.
  final DioClient dio;

  /// Instância do banco de dados local (SQLite via Drift).
  ///
  /// Fornece acesso a todas as tabelas e operações de persistência
  /// local, incluindo transações, migrações e consultas complexas.
  final AppDatabase db;

  /// Data Access Object específico para operações de usuário.
  ///
  /// Encapsula todas as operações SQL relacionadas à tabela de usuários,
  /// incluindo CRUD básico e consultas personalizadas. Inicializado
  /// automaticamente a partir da instância do banco de dados.
  final UsuarioDao usuarioDao;

  /// Construtor do repositório de usuários.
  ///
  /// Inicializa o repositório com as dependências necessárias e
  /// configura o DAO de usuário a partir da instância do banco.
  ///
  /// ## Parâmetros:
  /// - `dio`: Cliente HTTP para comunicação com APIs (obrigatório)
  /// - `db`: Instância do banco de dados local (obrigatório)
  ///
  /// ## Inicialização:
  /// O `usuarioDao` é inicializado automaticamente através de `db.usuarioDao`,
  /// garantindo que todas as operações de banco sejam executadas corretamente.
  UsuarioRepo({required this.dio, required this.db})
      : usuarioDao = db.usuarioDao;

  // ============================================================================
  // OPERAÇÕES DE LEITURA (READ)
  // ============================================================================

  /// Lista todos os usuários cadastrados no banco de dados local.
  ///
  /// Recupera todos os registros da tabela de usuários e os converte
  /// para DTOs padronizados, fornecendo uma lista completa de usuários
  /// disponíveis no sistema.
  ///
  /// ## Retorno:
  /// - `Future<List<UsuarioTableDto>>`: Lista de todos os usuários
  ///
  /// ## Comportamento:
  /// - Busca todos os registros da tabela usuários
  /// - Converte cada entidade para DTO correspondente
  /// - Retorna lista vazia se não houver usuários cadastrados
  ///
  /// ## Casos de Uso:
  /// - Carregamento inicial da lista de usuários
  /// - Atualização de interface após sincronização
  /// - Relatórios e consultas gerais
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuarios = await usuarioRepo.listar();
  /// usuarios.forEach((usuario) => print('${usuario.nome} - ${usuario.matricula}'));
  /// ```
  Future<List<UsuarioTableDto>> listar() async {
    /// Executa consulta no banco para obter todas as entidades de usuário.
    final usuarios = await usuarioDao.listar();

    /// Converte cada entidade para DTO padronizado e retorna como lista.
    return usuarios
        .map((usuario) => UsuarioTableDto.fromEntity(usuario))
        .toList();
  }

  /// Busca um usuário específico pelo seu identificador único.
  ///
  /// Localiza um usuário no banco de dados através do ID primário
  /// e retorna os dados completos em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do usuário (int)
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados completos do usuário encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por ID
  /// - Converte entidade para DTO
  /// - Lança exceção se usuário não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Visualização de perfil do usuário
  /// - Edição de dados específicos
  /// - Validação de existência de usuário
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuario = await usuarioRepo.buscarPorId(123);
  /// print('Usuário: ${usuario.nome}');
  /// ```
  Future<UsuarioTableDto> buscarPorId(int id) async {
    /// Executa consulta específica por ID no banco de dados.
    final usuario = await usuarioDao.buscarPorId(id);

    /// Converte a entidade encontrada para DTO padronizado.
    return UsuarioTableDto.fromEntity(usuario);
  }

  /// Busca um usuário específico pela sua matrícula.
  ///
  /// Localiza um usuário no banco de dados através da matrícula
  /// (identificador único de negócio) e retorna os dados completos
  /// em formato DTO padronizado.
  ///
  /// ## Parâmetros:
  /// - `matricula`: Matrícula do usuário (String)
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados completos do usuário encontrado
  ///
  /// ## Comportamento:
  /// - Busca registro específico por matrícula
  /// - Converte entidade para DTO
  /// - Lança exceção se usuário não for encontrado
  ///
  /// ## Casos de Uso:
  /// - Autenticação de usuário
  /// - Busca por identificador de negócio
  /// - Validação de matrícula existente
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuario = await usuarioRepo.buscarPorMatricula('12345');
  /// print('Usuário encontrado: ${usuario.nome}');
  /// ```
  Future<UsuarioTableDto> buscarPorMatricula(String matricula) async {
    /// Executa consulta específica por matrícula no banco de dados.
    final usuario = await usuarioDao.buscarPorMatricula(matricula);

    /// Converte a entidade encontrada para DTO padronizado.
    return UsuarioTableDto.fromEntity(usuario);
  }

  // ============================================================================
  // OPERAÇÕES DE ESCRITA (CREATE, UPDATE, DELETE)
  // ============================================================================

  /// Insere um novo usuário no banco de dados.
  ///
  /// Adiciona um novo registro de usuário ao banco de dados local,
  /// gerando automaticamente um ID único e retornando os dados
  /// completos do usuário inserido.
  ///
  /// ## Parâmetros:
  /// - `usuario`: DTO com dados do usuário a ser inserido
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados completos do usuário inserido
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Insere registro e recebe ID gerado
  /// - Busca registro inserido para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Cadastro de novos usuários
  /// - Importação de dados externos
  /// - Sincronização de dados
  ///
  /// ## Exemplo:
  /// ```dart
  /// final novoUsuario = UsuarioTableDto(
  ///   nome: 'João Silva',
  ///   matricula: '12345',
  ///   email: 'joao@exemplo.com',
  /// );
  /// final usuarioInserido = await usuarioRepo.inserir(novoUsuario);
  /// print('ID gerado: ${usuarioInserido.id}');
  /// ```
  Future<UsuarioTableDto> inserir(UsuarioTableDto usuario) async {
    /// Converte DTO para Companion (formato de inserção do Drift).
    /// O ID é omitido para permitir geração automática pelo banco.
    final id = await usuarioDao.inserir(usuario.toCompanion());

    /// Busca o registro recém-inserido para obter dados completos
    /// incluindo o ID gerado automaticamente.
    final usuarioInserido = await usuarioDao.buscarPorId(id);

    /// Converte a entidade para DTO e retorna dados completos.
    return UsuarioTableDto.fromEntity(usuarioInserido);
  }

  /// Atualiza os dados de um usuário existente.
  ///
  /// Modifica os dados de um usuário já cadastrado no banco de dados,
  /// mantendo o ID original e retornando os dados atualizados.
  ///
  /// ## Parâmetros:
  /// - `usuario`: DTO com dados atualizados do usuário (deve conter ID válido)
  ///
  /// ## Retorno:
  /// - `Future<UsuarioTableDto>`: Dados completos do usuário atualizado
  ///
  /// ## Comportamento:
  /// - Converte DTO para entidade do banco
  /// - Atualiza registro existente por ID
  /// - Busca registro atualizado para retornar dados completos
  /// - Converte resultado de volta para DTO
  ///
  /// ## Casos de Uso:
  /// - Edição de perfil do usuário
  /// - Atualização de dados pessoais
  /// - Sincronização de mudanças
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuarioAtualizado = UsuarioTableDto(
  ///   id: '123',
  ///   nome: 'João Silva Santos',
  ///   matricula: '12345',
  ///   email: 'joao.novo@exemplo.com',
  /// );
  /// final resultado = await usuarioRepo.atualizar(usuarioAtualizado);
  /// print('Usuário atualizado: ${resultado.nome}');
  /// ```
  Future<UsuarioTableDto> atualizar(UsuarioTableDto usuario) async {
    /// Converte DTO para entidade e executa atualização no banco.
    await usuarioDao.atualizar(usuario.toEntity());

    /// Busca o registro atualizado para garantir dados consistentes
    /// e obter qualquer valor calculado ou modificado pelo banco.
    final usuarioAtualizado =
        await usuarioDao.buscarPorId(int.parse(usuario.id));

    /// Converte a entidade atualizada para DTO e retorna.
    return UsuarioTableDto.fromEntity(usuarioAtualizado);
  }

  /// Remove um usuário do banco de dados.
  ///
  /// Exclui permanentemente um registro de usuário do banco de dados
  /// local através do seu identificador único. Esta operação é
  /// irreversível e deve ser usada com cuidado.
  ///
  /// ## Parâmetros:
  /// - `id`: Identificador único do usuário a ser removido
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
  /// - Exclusão de conta de usuário
  /// - Limpeza de dados obsoletos
  /// - Remoção de registros duplicados
  ///
  /// ## Exemplo:
  /// ```dart
  /// await usuarioRepo.deletar(123);
  /// print('Usuário removido com sucesso');
  /// ```
  ///
  /// ## ⚠️ Atenção:
  /// Esta operação é **irreversível**. Certifique-se de que o usuário
  /// realmente deve ser removido antes de executar esta operação.
  Future<void> deletar(int id) async {
    /// Executa exclusão do registro específico por ID.
    /// A operação é atômica e falhará completamente se houver problemas.
    await usuarioDao.deletar(id);
  }

  Future<LoginResponseDto> login(String matricula, String senha) async {
    try {
      final response = await dio.post(ApiConstants.login, data: {
        'matricula': matricula,
        'senha': senha,
      });
      return LoginResponseDto.fromJson(response.data);
    } catch (e, s) {
      final erro = ErrorHandler.tratar(e, s);
      AppLogger.e(
        '[usuario_repository_impl - login] ${erro.mensagem}',
        tag: 'UsuarioRepositoryImpl',
        error: e,
        stackTrace: s,
      );
      throw erro;
    }
  }

  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(ApiConstants.refreshToken, data: {
        'refreshToken': refreshToken,
      });
      return LoginResponseDto.fromJson(response.data);
    } catch (e, s) {
      final erro = ErrorHandler.tratar(e, s);
      AppLogger.e(
        '[usuario_repository_impl - refreshToken] ${erro.mensagem}',
        tag: 'UsuarioRepositoryImpl',
        error: e,
        stackTrace: s,
      );
      throw erro;
    }
  }
}
