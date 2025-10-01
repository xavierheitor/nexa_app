/// Interface abstrata para repositórios sincronizáveis.
///
/// Esta interface define o contrato que todos os repositórios devem implementar
/// para serem compatíveis com o sistema de sincronização. Ela estabelece os
/// métodos obrigatórios para busca de dados na API, persistência no banco local
/// e verificação de estado dos dados.
///
/// ## Propósito:
///
/// O `SyncableRepository` padroniza a forma como diferentes tipos de dados
/// são sincronizados, permitindo que o `SyncManager` trate todos os repositórios
/// de forma uniforme, independente do tipo de entidade.
///
/// ## Funcionalidades Obrigatórias:
///
/// 1. **Busca na API**: Obter dados atualizados do servidor
/// 2. **Persistência Local**: Salvar dados no banco local
/// 3. **Verificação de Estado**: Checar se há dados locais existentes
/// 4. **Identificação**: Fornecer nome único da entidade
///
/// ## Arquitetura:
///
/// - **Generic Type**: Suporta qualquer tipo de DTO/entidade
/// - **Strategy Pattern**: Cada repositório implementa sua estratégia
/// - **Dependency Inversion**: Interface define contrato, implementação é flexível
/// - **Single Responsibility**: Focado apenas em sincronização de um tipo
///
/// ## Implementação Típica:
///
/// ```dart
/// class UsuarioSyncRepo implements SyncableRepository<UsuarioDto> {
///   final DioClient dio;
///   final UsuarioDao usuarioDao;
///
///   UsuarioSyncRepo({required this.dio, required this.usuarioDao});
///
///   @override
///   String get nomeEntidade => 'usuario';
///
///   @override
///   Future<List<UsuarioDto>> buscarDaApi() async {
///     final response = await dio.get('/api/usuarios');
///     return (response.data as List)
///         .map((json) => UsuarioDto.fromJson(json))
///         .toList();
///   }
///
///   @override
///   Future<void> sincronizarComBanco(List<UsuarioDto> itens) async {
///     await usuarioDao.limparTabela();
///     for (final item in itens) {
///       await usuarioDao.inserir(item.toEntity());
///     }
///   }
///
///   @override
///   Future<bool> estaVazio(String entidade) async {
///     final count = await usuarioDao.contar();
///     return count == 0;
///   }
/// }
/// ```
///
/// ## Registro no SyncManager:
///
/// ```dart
/// final syncManager = SyncManager();
/// syncManager.registrar(UsuarioSyncRepo(dio: dio, usuarioDao: dao));
/// ```
///
/// ## Boas Práticas:
///
/// - **Nome Único**: `nomeEntidade` deve ser único no sistema
/// - **Tratamento de Erros**: Implementar tratamento robusto de erros
/// - **Transações**: Usar transações para operações de banco
/// - **Logging**: Adicionar logs para debugging
/// - **Validação**: Validar dados antes de persistir
///
/// ## Considerações de Performance:
///
/// - **Batch Operations**: Processar dados em lotes quando possível
/// - **Memory Management**: Evitar carregar grandes volumes na memória
/// - **Network Optimization**: Implementar paginação se necessário
/// - **Database Efficiency**: Usar operações otimizadas do banco
abstract class SyncableRepository<T> {
  /// Sincroniza uma lista de itens com o banco de dados local.
  ///
  /// Este método é responsável por persistir os dados obtidos da API
  /// no banco de dados local, substituindo ou atualizando os dados existentes.
  ///
  /// ## Parâmetros:
  /// - `itens`: Lista de itens a serem sincronizados com o banco
  ///
  /// ## Comportamento Esperado:
  /// - Substituir dados existentes pelos novos dados
  /// - Manter integridade referencial do banco
  /// - Usar transações para operações atômicas
  /// - Tratar erros de persistência adequadamente
  ///
  /// ## Estratégias Comuns:
  /// - **Replace All**: Limpar tabela e inserir novos dados
  /// - **Upsert**: Atualizar existentes e inserir novos
  /// - **Merge**: Combinar dados existentes com novos
  ///
  /// ## Exemplo:
  /// ```dart
  /// @override
  /// Future<void> sincronizarComBanco(List<UsuarioDto> itens) async {
  ///   await db.transaction(() async {
  ///     await usuarioDao.limparTabela();
  ///     for (final usuario in itens) {
  ///       await usuarioDao.inserir(usuario.toEntity());
  ///     }
  ///   });
  /// }
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Erros de banco devem ser propagados
  /// - Implementar rollback em caso de falha
  /// - Logs detalhados para debugging
  Future<void> sincronizarComBanco(List<T> itens);

  /// Busca dados atualizados da API externa.
  ///
  /// Este método é responsável por obter os dados mais recentes do servidor,
  /// fazendo requisições HTTP para os endpoints apropriados e convertendo
  /// as respostas para o formato esperado.
  ///
  /// ## Retorno:
  /// - `Future<List<T>>`: Lista de itens obtidos da API
  ///
  /// ## Comportamento Esperado:
  /// - Fazer requisição HTTP para endpoint correto
  /// - Processar resposta JSON da API
  /// - Converter dados para DTOs tipados
  /// - Tratar erros de rede e validação
  ///
  /// ## Exemplo:
  /// ```dart
  /// @override
  /// Future<List<UsuarioDto>> buscarDaApi() async {
  ///   try {
  ///     final response = await dio.get('/api/usuarios');
  ///     return (response.data as List)
  ///         .map((json) => UsuarioDto.fromJson(json))
  ///         .toList();
  ///   } catch (e) {
  ///     AppLogger.e('Erro ao buscar usuários da API', error: e);
  ///     rethrow;
  ///   }
  /// }
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Erros de rede devem ser propagados
  /// - Implementar retry logic se necessário
  /// - Logs detalhados para debugging
  /// - Timeout adequado para requisições
  Future<List<T>> buscarDaApi();

  /// Verifica se a tabela/entidade está vazia no banco local.
  ///
  /// Este método é usado pelo `SyncManager` para determinar se deve
  /// sincronizar dados ou pular a sincronização (quando não forçado).
  ///
  /// ## Parâmetros:
  /// - `entidade`: Nome da entidade a ser verificada (geralmente igual a `nomeEntidade`)
  ///
  /// ## Retorno:
  /// - `Future<bool>`: `true` se vazio, `false` se contém dados
  ///
  /// ## Comportamento Esperado:
  /// - Verificar contagem de registros na tabela
  /// - Retornar `true` se contagem for zero
  /// - Retornar `false` se contagem for maior que zero
  /// - Tratar erros de banco adequadamente
  ///
  /// ## Exemplo:
  /// ```dart
  /// @override
  /// Future<bool> estaVazio(String entidade) async {
  ///   try {
  ///     final count = await usuarioDao.contar();
  ///     return count == 0;
  ///   } catch (e) {
  ///     AppLogger.e('Erro ao verificar se tabela está vazia', error: e);
  ///     return false; // Assume que não está vazio em caso de erro
  ///   }
  /// }
  /// ```
  ///
  /// ## Estratégia de Fallback:
  /// - Em caso de erro, assumir que não está vazio
  /// - Isso evita perda de dados por falhas de verificação
  /// - Logs detalhados para debugging
  Future<bool> estaVazio(String entidade);

  /// Nome único da entidade gerenciada por este repositório.
  ///
  /// Este getter deve retornar um identificador único que será usado
  /// pelo `SyncManager` para indexar e referenciar este repositório.
  ///
  /// ## Retorno:
  /// - `String`: Nome único da entidade (ex: 'usuario', 'produto', 'categoria')
  ///
  /// ## Requisitos:
  /// - Deve ser único no sistema
  /// - Deve ser consistente (mesmo valor sempre)
  /// - Deve ser descritivo e legível
  /// - Não deve conter espaços ou caracteres especiais
  ///
  /// ## Exemplos:
  /// ```dart
  /// @override
  /// String get nomeEntidade => 'usuario';
  ///
  /// @override
  /// String get nomeEntidade => 'produto';
  ///
  /// @override
  /// String get nomeEntidade => 'categoria_produto';
  /// ```
  ///
  /// ## Uso pelo SyncManager:
  /// - Indexação no mapa interno de repositórios
  /// - Referência para sincronização seletiva
  /// - Validação de existência de repositório
  /// - Debugging e logging
  String get nomeEntidade;
}
