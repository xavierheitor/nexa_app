/// Enumeração para categorização de tipos de erro na aplicação.
///
/// Este enum define as categorias principais de erro que podem ocorrer
/// na aplicação, permitindo tratamento específico e mapeamento de
/// mensagens amigáveis baseadas no tipo de problema identificado.
///
/// ## Funcionalidades Principais:
///
/// 1. **Categorização**: Classifica erros por origem e natureza
/// 2. **Tratamento Específico**: Permite tratamento diferenciado por tipo
/// 3. **Mapeamento de Mensagens**: Facilita geração de mensagens amigáveis
/// 4. **Debugging**: Ajuda na identificação de padrões de erro
/// 5. **Monitoramento**: Suporte para analytics e métricas de erro
/// 6. **Extensibilidade**: Base para futuras categorias de erro
///
/// ## Arquitetura:
///
/// - **Enum Simples**: Valores constantes para categorização
/// - **Comprehensive**: Cobre todos os tipos principais de erro
/// - **Hierarchical**: Organizado por camadas da aplicação
/// - **Self-Documenting**: Nomes descritivos e comentários explicativos
///
/// ## Uso:
///
/// ```dart
/// // Categorização de erro
/// final tipo = TipoErro.api;
///
/// // Tratamento baseado em tipo
/// switch (error.tipo) {
///   case TipoErro.api:
///     // Tratar erro de API
///     break;
///   case TipoErro.validacao:
///     // Tratar erro de validação
///     break;
/// }
///
/// // Mapeamento para mensagens
/// final mensagem = ErrorHandler.mensagemUsuario(error);
/// ```
///
/// ## Integração:
///
/// - **AppException**: Utilizado como propriedade principal
/// - **ErrorHandler**: Base para mapeamento de mensagens
/// - **Logging**: Categorização para logs estruturados
/// - **Analytics**: Tracking de tipos de erro mais comuns
enum TipoErro {
  /// Erros relacionados a APIs e comunicação externa.
  ///
  /// Inclui falhas de requisição HTTP, timeouts, problemas de conectividade,
  /// erros de serialização de dados e falhas de comunicação com serviços
  /// externos. Cobre códigos de status HTTP (400, 401, 404, 500, etc.).
  ///
  /// ## Exemplos:
  /// - Timeout de requisição
  /// - Erro 500 do servidor
  /// - Falha de conectividade
  /// - Problemas de DNS
  /// - Erros de SSL/TLS
  api,

  /// Problemas de processamento e manipulação de dados.
  ///
  /// Inclui falhas de parsing, serialização, deserialização, conversão de
  /// tipos e problemas relacionados ao processamento de informações
  /// recebidas ou enviadas pela aplicação.
  ///
  /// ## Exemplos:
  /// - JSON malformado
  /// - Falha de parsing de dados
  /// - Campos ausentes em resposta
  /// - Problemas de serialização
  /// - Conversão de tipos falhada
  dados,

  /// Erros de autenticação e autorização.
  ///
  /// Inclui falhas relacionadas a credenciais inválidas, tokens expirados,
  /// problemas de sessão, falhas de autorização e questões de segurança
  /// de acesso a recursos protegidos.
  ///
  /// ## Exemplos:
  /// - Credenciais inválidas
  /// - Token expirado
  /// - Sessão inválida
  /// - Acesso negado
  /// - Falha de autorização
  credenciais,

  /// Falhas no banco de dados e armazenamento local.
  ///
  /// Inclui problemas de SQLite, cache, armazenamento local, falhas de
  /// transações, problemas de migração de dados e erros relacionados
  /// ao acesso e manipulação de dados locais.
  ///
  /// ## Exemplos:
  /// - Falha de conexão SQLite
  /// - Problema de cache
  /// - Erro de transação
  /// - Falha de migração
  /// - Problema de armazenamento
  banco,

  /// Erros de validação de DTOs e dados de entrada.
  ///
  /// Inclui falhas de validação de campos obrigatórios, formatos inválidos,
  /// problemas de conversão de tipos, validação de regras de negócio e
  /// outros erros relacionados à validação de dados de entrada.
  ///
  /// ## Exemplos:
  /// - Campo obrigatório ausente
  /// - Formato de email inválido
  /// - Data em formato incorreto
  /// - Valor fora do range permitido
  /// - Violação de regras de negócio
  validacao,

  /// Erros não classificados ou desconhecidos.
  ///
  /// Usado como fallback para erros que não se encaixam nas outras
  /// categorias ou quando não é possível determinar a origem exata
  /// do problema. Serve como categoria de segurança para garantir
  /// que todos os erros sejam tratados.
  ///
  /// ## Exemplos:
  /// - Erros não mapeados
  /// - Exceções inesperadas
  /// - Problemas de sistema
  /// - Falhas não identificadas
  /// - Erros de terceiros não categorizados
  desconhecido,
}
