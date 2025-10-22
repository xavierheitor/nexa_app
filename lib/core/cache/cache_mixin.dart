import 'package:nexa_app/core/cache/cache_config.dart';
import 'package:nexa_app/core/cache/cache_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Mixin para adicionar funcionalidades de cache aos repositories.
///
/// Este mixin fornece métodos convenientes para operações de cache
/// padronizadas, eliminando duplicação de código entre repositories.
mixin CacheMixin {
  // ==========================================================================
  // CACHE MANAGER
  // ==========================================================================

  /// Instância do CacheManager (singleton)
  CacheManager get _cache => CacheManager.instance;

  // ==========================================================================
  // OPERAÇÕES BÁSICAS DE CACHE
  // ==========================================================================

  /// Armazena dados no cache com TTL baseado na entidade
  Future<void> cacheSet<T>(
    String entity,
    String operation,
    T data, {
    Map<String, dynamic>? params,
    Duration? customTTL,
  }) async {
    final key = CacheConfig.getCacheKey(entity, operation, params);
    final ttl = customTTL ?? CacheConfig.getTTLForEntity(entity);
    
    await _cache.set(key, data, ttl: ttl, entity: entity);
    
    AppLogger.d('📦 [$entity] Cached: $operation', tag: 'CacheMixin');
  }

  /// Recupera dados do cache
  Future<T?> cacheGet<T>(
    String entity,
    String operation, {
    Map<String, dynamic>? params,
  }) async {
    final key = CacheConfig.getCacheKey(entity, operation, params);
    final result = await _cache.get<T>(key);
    
    if (result != null) {
      AppLogger.d('📦 [$entity] Cache HIT: $operation', tag: 'CacheMixin');
    } else {
      AppLogger.d('📦 [$entity] Cache MISS: $operation', tag: 'CacheMixin');
    }
    
    return result;
  }

  /// Executa operação com cache automático
  Future<T> cacheExecute<T>(
    String entity,
    String operation,
    Future<T> Function() operationFunction, {
    Map<String, dynamic>? params,
    Duration? customTTL,
  }) async {
    final key = CacheConfig.getCacheKey(entity, operation, params);
    final ttl = customTTL ?? CacheConfig.getTTLForEntity(entity);
    
    return await _cache.executeWithCache(
      key,
      operationFunction,
      ttl: ttl,
      entity: entity,
    );
  }

  /// Invalida cache de uma entidade específica
  Future<void> cacheInvalidateEntity(String entity) async {
    await _cache.invalidateEntity(entity);
    AppLogger.d('📦 [$entity] Cache invalidated', tag: 'CacheMixin');
  }

  /// Invalida cache de uma operação específica
  Future<void> cacheInvalidate(
    String entity,
    String operation, {
    Map<String, dynamic>? params,
  }) async {
    final key = CacheConfig.getCacheKey(entity, operation, params);
    await _cache.invalidate(key);
    AppLogger.d('📦 [$entity] Cache invalidated: $operation', tag: 'CacheMixin');
  }

  // ==========================================================================
  // MÉTODOS CONVENIENTES PARA REPOSITORIES
  // ==========================================================================

  /// Lista dados com cache automático
  Future<List<T>> listarComCache<T>(
    String entity,
    Future<List<T>> Function() listarFunction,
  ) async {
    return await cacheExecute(
      entity,
      'listar',
      listarFunction,
    );
  }

  /// Busca por ID com cache automático
  Future<T?> buscarPorIdComCache<T>(
    String entity,
    int id,
    Future<T?> Function() buscarFunction,
  ) async {
    return await cacheExecute(
      entity,
      'buscarPorId',
      buscarFunction,
      params: {'id': id},
    );
  }

  /// Busca por remote ID com cache automático
  Future<T?> buscarPorRemoteIdComCache<T>(
    String entity,
    int remoteId,
    Future<T?> Function() buscarFunction,
  ) async {
    return await cacheExecute(
      entity,
      'buscarPorRemoteId',
      buscarFunction,
      params: {'remoteId': remoteId},
    );
  }

  /// Busca dados específicos com cache automático
  Future<T> buscarComCache<T>(
    String entity,
    String operation,
    Future<T> Function() buscarFunction, {
    Map<String, dynamic>? params,
  }) async {
    return await cacheExecute(
      entity,
      operation,
      buscarFunction,
      params: params,
    );
  }

  // ==========================================================================
  // INVALIDAÇÃO INTELIGENTE
  // ==========================================================================

  /// Invalida cache após operações de escrita
  Future<void> invalidarCacheAposEscrita(String entity) async {
    // Invalida operações de leitura que podem ter sido afetadas
    await cacheInvalidate(entity, 'listar');
    await cacheInvalidate(entity, 'buscar');
    await cacheInvalidate(entity, 'contar');
    
    AppLogger.d('📦 [$entity] Cache invalidated after write operation', 
        tag: 'CacheMixin');
  }

  /// Invalida cache após sincronização
  Future<void> invalidarCacheAposSincronizacao(String entity) async {
    // Invalida todo o cache da entidade após sincronização
    await cacheInvalidateEntity(entity);
    
    // Invalida entidades relacionadas se necessário
    await _invalidarEntidadesRelacionadas(entity);
    
    AppLogger.d('📦 [$entity] Cache invalidated after sync', tag: 'CacheMixin');
  }

  /// Invalida entidades relacionadas baseado na entidade principal
  Future<void> _invalidarEntidadesRelacionadas(String entity) async {
    // Mapeamento de entidades relacionadas
    final relacionamentos = {
      'veiculo': ['turno'],
      'equipe': ['turno'],
      'eletricista': ['turno'],
      'checklist_modelo': ['checklist_pergunta', 'checklist_opcao_resposta'],
      'checklist_pergunta': ['checklist_opcao_resposta'],
    };
    
    final entidadesRelacionadas = relacionamentos[entity] ?? [];
    
    for (final entidadeRelacionada in entidadesRelacionadas) {
      await cacheInvalidateEntity(entidadeRelacionada);
    }
  }

  // ==========================================================================
  // MÉTRICAS E DEBUG
  // ==========================================================================

  /// Obtém estatísticas do cache
  Map<String, dynamic> obterEstatisticasCache() {
    return _cache.getStats();
  }

  /// Loga estatísticas do cache
  void logarEstatisticasCache() {
    _cache.logStats();
  }

  /// Limpa todo o cache (para debug/testes)
  Future<void> limparCache() async {
    await _cache.clear();
    AppLogger.d('📦 Cache cleared manually', tag: 'CacheMixin');
  }
}
