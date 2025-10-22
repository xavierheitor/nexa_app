import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/usuario_dao.dart';
import 'package:nexa_app/data/models/login_response_dto.dart';
import 'package:nexa_app/data/models/usuario_table_dto.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;
import 'package:nexa_app/core/cache/cache_mixin.dart';

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
class UsuarioRepo with log_mixin.LoggingMixin, CacheMixin {
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
  // IMPLEMENTAÇÃO DO LOGGING MIXIN
  // ============================================================================

  @override
  String get repositoryName => 'UsuarioRepository';

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
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        return await listarComCache(
          'usuarios',
          () async {
            final usuarios = await usuarioDao.listar();
            return usuarios
                .map((usuario) => UsuarioTableDto.fromEntity(usuario))
                .toList();
          },
        );
      },
    );
  }

  Future<UsuarioTableDto> buscarPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarPorId',
      operation: () async {
        return await buscarPorIdComCache(
              'usuarios',
              id,
              () async {
                final usuario = await usuarioDao.buscarPorIdOuFalha(id);
                return UsuarioTableDto.fromEntity(usuario);
              },
            ) ??
            (throw Exception('Usuário não encontrado'));
      },
    );
  }

  Future<UsuarioTableDto> buscarPorMatricula(String matricula) async {
    return await executeWithLogging(
      operationName: 'buscarPorMatricula',
      operation: () async {
        final usuario = await usuarioDao.buscarPorMatricula(matricula);
        return UsuarioTableDto.fromEntity(usuario);
      },
    );
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
    return await executeWithLogging(
      operationName: 'inserir',
      operation: () async {
        final id = await usuarioDao
            .inserirOuAtualizarPorMatricula(usuario.toCompanion());
        final usuarioInserido = await usuarioDao.buscarPorIdOuFalha(id);
        return UsuarioTableDto.fromEntity(usuarioInserido);
      },
    );
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
    return await executeWithLogging(
      operationName: 'atualizar',
      operation: () async {
        await usuarioDao.atualizarPorId(
            int.parse(usuario.id), usuario.toCompanion());
        final usuarioAtualizado =
            await usuarioDao.buscarPorIdOuFalha(int.parse(usuario.id));
        return UsuarioTableDto.fromEntity(usuarioAtualizado);
      },
    );
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
    return await executeVoidWithLogging(
      operationName: 'deletar',
      operation: () async {
        await usuarioDao.deletar(id);
      },
    );
  }

  // ============================================================================
  // OPERAÇÕES DE AUTENTICAÇÃO (API)
  // ============================================================================

  /// Autentica um usuário através da API externa.
  ///
  /// Realiza login do usuário enviando credenciais para o servidor
  /// e retorna dados completos de autenticação incluindo tokens
  /// de acesso e informações do usuário.
  ///
  /// ## Parâmetros:
  /// - `matricula`: Matrícula do usuário (String)
  /// - `senha`: Senha do usuário (String)
  ///
  /// ## Retorno:
  /// - `Future<LoginResponseDto>`: Dados completos de autenticação
  ///
  /// ## Comportamento:
  /// - Envia credenciais para endpoint de login
  /// - Processa resposta JSON da API
  /// - Converte para DTO tipado e validado
  /// - Trata erros de rede e validação
  /// - Registra logs detalhados de erro
  ///
  /// ## Casos de Uso:
  /// - Login inicial do usuário
  /// - Autenticação após logout
  /// - Validação de credenciais
  /// - Obtenção de tokens de acesso
  ///
  /// ## Exemplo:
  /// ```dart
  /// final loginData = await usuarioRepo.login('12345', 'senha123');
  /// print('Token: ${loginData.token}');
  /// print('Usuário: ${loginData.nome}');
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - **Rede**: Falhas de conectividade ou timeout
  /// - **Autenticação**: Credenciais inválidas (401)
  /// - **Validação**: Dados de resposta inválidos
  /// - **Servidor**: Erros internos do servidor (500)
  ///
  /// ## Logs:
  /// - Registra erros detalhados com stack trace
  /// - Tag específica: `UsuarioRepositoryImpl`
  /// - Contexto: `[usuario_repository_impl - login]`
  Future<LoginResponseDto> login(String matricula, String senha) async {
    return await executeWithLogging(
      operationName: 'login',
      operation: () async {
        final response = await dio.post(ApiConstants.login, data: {
          'matricula': matricula,
          'senha': senha,
        });
        return await LoginResponseDto.fromJson(response.data);
      },
      logLevel: log_mixin.LogLevel.info,
    );
  }

  /// Renova tokens de autenticação usando refresh token.
  ///
  /// Solicita novos tokens de acesso ao servidor usando o refresh token
  /// válido, mantendo a sessão do usuário ativa sem necessidade de
  /// nova autenticação com credenciais.
  ///
  /// ## Parâmetros:
  /// - `refreshToken`: Token de renovação válido (String)
  ///
  /// ## Retorno:
  /// - `Future<LoginResponseDto>`: Novos dados de autenticação
  ///
  /// ## Comportamento:
  /// - Envia refresh token para endpoint de renovação
  /// - Recebe novos tokens de acesso e refresh
  /// - Converte resposta para DTO tipado e validado
  /// - Trata erros de token expirado ou inválido
  /// - Registra logs detalhados de erro
  ///
  /// ## Casos de Uso:
  /// - Renovação automática de tokens
  /// - Manutenção de sessão ativa
  /// - Recuperação após expiração de token
  /// - Sincronização de tokens com servidor
  ///
  /// ## Exemplo:
  /// ```dart
  /// final novosTokens = await usuarioRepo.refreshToken(refreshToken);
  /// print('Novo token: ${novosTokens.token}');
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - **Token Expirado**: Refresh token inválido ou expirado (401)
  /// - **Rede**: Falhas de conectividade ou timeout
  /// - **Validação**: Dados de resposta inválidos
  /// - **Servidor**: Erros internos do servidor (500)
  ///
  /// ## Logs:
  /// - Registra erros detalhados com stack trace
  /// - Tag específica: `UsuarioRepositoryImpl`
  /// - Contexto: `[usuario_repository_impl - refreshToken]`
  ///
  /// ## ⚠️ Importante:
  /// Se este método falhar, o usuário precisará fazer novo login
  /// com credenciais, pois o refresh token pode ter expirado.
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    return await executeWithLogging(
      operationName: 'refreshToken',
      operation: () async {
        final response = await dio.post(ApiConstants.refreshToken, data: {
          'refreshToken': refreshToken,
        });
        return await LoginResponseDto.fromJson(response.data);
      },
      logLevel: log_mixin.LogLevel.info,
    );
  }
}
