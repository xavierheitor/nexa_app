import 'package:nexa_app/data/models/base/base_dto.dart';
import 'package:nexa_app/data/models/base/base_table_dto.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// DTO para resposta de login da API.
///
/// Representa os dados retornados pelo servidor após autenticação bem-sucedida,
/// incluindo tokens de acesso, informações do usuário e metadados de expiração.
/// Este DTO é usado exclusivamente para comunicação com a API e não persiste
/// no banco de dados local.
///
/// ## Funcionalidades Principais:
///
/// 1. **Tokens de Autenticação**: Token de acesso e refresh token
/// 2. **Informações do Usuário**: Dados básicos do usuário autenticado
/// 3. **Controle de Expiração**: Datas de validade dos tokens (opcionais)
/// 4. **Validação de Dados**: Verificação de integridade dos campos
/// 5. **Serialização**: Conversão bidirecional JSON ↔ DTO
/// 6. **Identificação**: ID e matrícula do usuário
///
/// ## Arquitetura:
///
/// - **Response DTO**: Específico para respostas de API
/// - **Não Persistente**: Não é salvo no banco local
/// - **Validação Rigorosa**: Campos essenciais obrigatórios, datas opcionais
/// - **Type Safety**: Conversões seguras de tipos
///
/// ## Fluxo de Uso:
///
/// 1. Recebe resposta JSON da API de login
/// 2. Valida estrutura e tipos dos dados
/// 3. Converte para DTO tipado
/// 4. Permite acesso seguro aos dados de autenticação
/// 5. Usado para configurar sessão do usuário
///
/// ## Exemplo de Uso:
///
/// ```dart
/// final response = await dio.post('/auth/login', data: credentials);
/// final loginData = await LoginResponseDto.fromJson(response.data);
///
/// print('Token: ${loginData.token}');
/// print('Usuário: ${loginData.nome}');
/// print('Matrícula: ${loginData.matricula}');
/// print('Expira em: ${loginData.expiresAt ?? "Nunca"}');
/// ```
///
/// ## Dependências:
/// - `BaseTableDto`: Funcionalidades base de DTOs de tabela
/// - `BaseDto`: Métodos de validação e conversão
/// - Campos de API: Token, refresh token, dados do usuário
class LoginResponseDto extends BaseTableDto {
  // ============================================================================
  // PROPRIEDADES DE AUTENTICAÇÃO
  // ============================================================================

  /// Token de acesso JWT para autenticação de requisições.
  ///
  /// Token principal usado para autorizar requisições subsequentes à API.
  /// Deve ser incluído no header Authorization como "Bearer {token}".
  /// Tem validade limitada definida por `expiresAt`.
  final String token;

  /// Token de renovação para obter novos tokens de acesso.
  ///
  /// Token especial usado para renovar o token de acesso quando ele expira,
  /// sem necessidade de nova autenticação com credenciais. Tem validade
  /// mais longa definida por `refreshTokenExpiresAt`.
  final String refreshToken;

  /// Data e hora de expiração do token de acesso.
  ///
  /// Define quando o token de acesso se torna inválido e precisa ser renovado.
  /// Após esta data, requisições com o token atual falharão com erro 401.
  final DateTime? expiresAt;

  /// Data e hora de expiração do refresh token.
  ///
  /// Define quando o refresh token se torna inválido. Após esta data,
  /// é necessário fazer novo login com credenciais para obter novos tokens.
  final DateTime? refreshTokenExpiresAt;

  // ============================================================================
  // PROPRIEDADES DO USUÁRIO
  // ============================================================================

  /// Nome completo do usuário autenticado.
  ///
  /// Nome de exibição do usuário, usado em interfaces e logs.
  /// Valor retornado pelo servidor após validação das credenciais.
  final String nome;

  /// Matrícula do usuário no sistema.
  ///
  /// Identificador de negócio do usuário, usado para login e
  /// identificação em processos internos da aplicação.
  final String matricula;

  /// Construtor do DTO de resposta de login.
  ///
  /// Inicializa todas as propriedades necessárias para representar
  /// uma resposta completa de autenticação da API.
  ///
  /// ## Parâmetros:
  /// - `token`: Token de acesso JWT (obrigatório)
  /// - `refreshToken`: Token de renovação (obrigatório)
  /// - `expiresAt`: Data de expiração do token (opcional)
  /// - `refreshTokenExpiresAt`: Data de expiração do refresh token (opcional)
  /// - `nome`: Nome do usuário (obrigatório)
  /// - `matricula`: Matrícula do usuário (obrigatório)
  /// - `id`: ID do usuário (obrigatório)
  /// - `createdAt`: Data de criação do registro (obrigatório)
  LoginResponseDto({
    required this.token,
    required this.refreshToken,
    this.expiresAt,
    this.refreshTokenExpiresAt,
    required this.nome,
    required this.matricula,
    required super.id,
    required super.createdAt,
  });

  // ============================================================================
  // IMPLEMENTAÇÕES OBRIGATÓRIAS (NÃO APLICÁVEIS PARA RESPONSE DTO)
  // ============================================================================

  /// Método não aplicável para DTOs de resposta de API.
  ///
  /// LoginResponseDto não persiste no banco local, portanto não possui
  /// representação como entidade do Drift. Este método lança exceção
  /// para indicar uso incorreto.
  @override
  toCompanion() {
    throw UnimplementedError(
        'LoginResponseDto não possui Companion - é um DTO de resposta de API');
  }

  /// Método não aplicável para DTOs de resposta de API.
  ///
  /// LoginResponseDto não persiste no banco local, portanto não possui
  /// representação como entidade do Drift. Este método lança exceção
  /// para indicar uso incorreto.
  @override
  toEntity() {
    throw UnimplementedError(
        'LoginResponseDto não possui Entity - é um DTO de resposta de API');
  }

  // ============================================================================
  // SERIALIZAÇÃO E VALIDAÇÃO
  // ============================================================================

  /// Converte os campos específicos do DTO para formato JSON.
  ///
  /// Serializa apenas os campos específicos do LoginResponseDto,
  /// excluindo campos herdados da classe base. Usado internamente
  /// pelo método `toJson()` da classe pai.
  ///
  /// ## Retorno:
  /// - `Map<String, dynamic>`: Mapa com campos específicos serializados
  ///
  /// ## Campos Incluídos:
  /// - `token`: Token de acesso
  /// - `refreshToken`: Token de renovação
  /// - `expiresAt`: Data de expiração do token (ISO 8601)
  /// - `refreshTokenExpiresAt`: Data de expiração do refresh token (ISO 8601)
  /// - `nome`: Nome do usuário
  /// - `matricula`: Matrícula do usuário
  @override
  Map<String, dynamic> toSpecificJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'refreshTokenExpiresAt': refreshTokenExpiresAt?.toIso8601String(),
      'nome': nome,
      'matricula': matricula,
    };
  }

  /// Valida os campos específicos do LoginResponseDto.
  ///
  /// Executa validações rigorosas em todos os campos obrigatórios,
  /// garantindo que o DTO está em estado válido para uso. Chamado
  /// automaticamente pelo método `validate()` da classe base.
  ///
  /// ## Validações Executadas:
  /// - **Token**: String não vazia e válida
  /// - **RefreshToken**: String não vazia e válida
  /// - **Nome**: String não vazia e válida
  /// - **Matrícula**: String não vazia e válida
  /// - **ExpiresAt**: Data válida e não futura (se informado)
  /// - **RefreshTokenExpiresAt**: Data válida e não futura (se informado)
  ///
  /// ## Exceções:
  /// Lança `RequiredFieldError` ou `DtoError` se validação falhar.
  @override
  void validateSpecific() {
    /// Valida token de acesso (obrigatório e não vazio).
    BaseDto.validateRequiredString(token, 'token');

    /// Valida refresh token (obrigatório e não vazio).
    BaseDto.validateRequiredString(refreshToken, 'refreshToken');

    /// Valida nome do usuário (obrigatório e não vazio).
    BaseDto.validateRequiredString(nome, 'nome');

    /// Valida matrícula do usuário (obrigatório e não vazio).
    BaseDto.validateRequiredString(matricula, 'matricula');

    /// Valida data de expiração do token se informada (não pode ser futura).
    if (expiresAt != null) {
      validateNotFutureDate(expiresAt!, 'expiresAt');
    }

    /// Valida data de expiração do refresh token se informada (não pode ser futura).
    if (refreshTokenExpiresAt != null) {
      validateNotFutureDate(refreshTokenExpiresAt!, 'refreshTokenExpiresAt');
    }
  }

  // ============================================================================
  // FACTORY METHODS
  // ============================================================================

  /// Cria LoginResponseDto a partir de dados JSON da API.
  ///
  /// Factory method que processa a resposta JSON do servidor e cria
  /// uma instância tipada do DTO com validação completa dos dados.
  ///
  /// ## Parâmetros:
  /// - `data`: Dados JSON da resposta da API (Map<String, dynamic>)
  ///
  /// ## Retorno:
  /// - `Future<LoginResponseDto>`: Instância do DTO criada e validada
  ///
  /// ## Processamento:
  /// 1. Valida estrutura JSON recebida
  /// 2. Converte campos com tipos apropriados
  /// 3. Cria instância do DTO
  /// 4. Executa validação completa
  /// 5. Retorna DTO pronto para uso
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dio.post('/auth/login', data: credentials);
  /// final loginData = await LoginResponseDto.fromJson(response.data);
  /// ```
  ///
  /// ## Exceções:
  /// Lança `DtoError` se estrutura JSON for inválida ou campos obrigatórios ausentes.
  static Future<LoginResponseDto> fromJson(Map<String, dynamic> data) async {
    return BaseTableDto.fromJson(data, (json) {
      /// Extrai dados do objeto usuário aninhado.
      final usuario = json['usuario'] as Map<String, dynamic>?;
      if (usuario == null) {
        throw DtoError('Campo obrigatório não informado', field: 'usuario');
      }

      return LoginResponseDto(
        /// Converte e valida token de acesso.
        token: BaseDto.validateRequiredString(json['token'], 'token'),

        /// Converte e valida refresh token.
        refreshToken: BaseDto.validateRequiredString(
            json['refreshToken'], 'refreshToken'),

        /// Converte data de expiração do token (opcional).
        expiresAt:
            BaseDto.parseOptionalDateTime(json['expiresAt'], 'expiresAt'),

        /// Converte data de expiração do refresh token (opcional).
        refreshTokenExpiresAt: BaseDto.parseOptionalDateTime(
            json['refreshTokenExpiresAt'], 'refreshTokenExpiresAt'),

        /// Converte e valida nome do usuário (do objeto aninhado).
        nome: BaseDto.validateRequiredString(usuario['nome'], 'usuario.nome'),

        /// Converte e valida matrícula do usuário (do objeto aninhado).
        matricula: BaseDto.validateRequiredString(
            usuario['matricula'], 'usuario.matricula'),

        /// Converte ID do usuário de int para String (do objeto aninhado).
        id: usuario['id']?.toString() ?? '',

        /// Usa data atual como createdAt (não vem da API).
        createdAt: DateTime.now(),
      );
    });
  }
}
