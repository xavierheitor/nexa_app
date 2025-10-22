import 'dart:async';
import 'package:nexa_app/core/cache/cache_config.dart';
import 'package:nexa_app/core/cache/cache_entry.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Gerenciador de cache centralizado para a aplicação.
///
/// Este singleton gerencia cache em memória com TTL configurável,
/// invalidação automática e manual, e limpeza periódica de dados expirados.
///
/// ## Funcionalidades:
/// - ✅ Cache com TTL configurável por entidade
/// - ✅ Invalidação manual e automática
/// - ✅ Limpeza automática de dados expirados
/// - ✅ Logs detalhados de operações
/// - ✅ Métricas de performance
/// - ✅ Thread-safe para operações concorrentes
class CacheManager {
  // ==========================================================================
  // SINGLETON PATTERN
  // ==========================================================================

  static CacheManager? _instance;
  static CacheManager get instance => _instance ??= CacheManager._internal();
  
  CacheManager._internal() {
    _startCleanupTimer();
    AppLogger.i('📦 CacheManager inicializado', tag: 'CacheManager');
  }

  // ==========================================================================
  // PROPRIEDADES
  // ==========================================================================

  /// Cache em memória thread-safe
  final Map<String, CacheEntry> _cache = {};

  /// Timer para limpeza automática
  Timer? _cleanupTimer;

  /// Métricas de performance
  int _hits = 0;
  int _misses = 0;
  int _invalidations = 0;

  // ==========================================================================
  // OPERAÇÕES BÁSICAS
  // ==========================================================================

  /// Armazena dados no cache com TTL configurado
  Future<void> set<T>(
    String key,
    T data, {
    Duration? ttl,
    String? entity,
  }) async {
    final effectiveTTL = ttl ?? 
        (entity != null ? CacheConfig.getTTLForEntity(entity) : CacheConfig.defaultTTL);
    
    final entry = CacheEntry<T>(
      key: key,
      data: data,
      ttl: effectiveTTL,
    );

    _cache[key] = entry;
    
    AppLogger.d('📦 Cache SET: $key (TTL: ${effectiveTTL.inMinutes}m)', 
        tag: 'CacheManager');
  }

  /// Recupera dados do cache
  Future<T?> get<T>(String key) async {
    final entry = _cache[key] as CacheEntry<T>?;
    
    if (entry == null) {
      _misses++;
      AppLogger.d('📦 Cache MISS: $key', tag: 'CacheManager');
      return null;
    }
    
    if (!entry.isValid) {
      _cache.remove(key);
      _misses++;
      AppLogger.d('📦 Cache EXPIRED: $key', tag: 'CacheManager');
      return null;
    }
    
    _hits++;
    AppLogger.d('📦 Cache HIT: $key (age: ${entry.age.inSeconds}s)', 
        tag: 'CacheManager');
    return entry.data;
  }

  /// Verifica se uma chave existe no cache
  bool contains(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    
    if (!entry.isValid) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  /// Remove uma entrada específica do cache
  Future<void> invalidate(String key) async {
    final entry = _cache.remove(key);
    if (entry != null) {
      _invalidations++;
      AppLogger.d('📦 Cache INVALIDATED: $key', tag: 'CacheManager');
    }
  }

  /// Invalida todas as entradas de uma entidade
  Future<void> invalidateEntity(String entity) async {
    final keysToRemove = <String>[];
    
    for (final key in _cache.keys) {
      if (key.startsWith('${entity}_')) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      await invalidate(key);
    }
    
    AppLogger.d('📦 Cache INVALIDATED ENTITY: $entity (${keysToRemove.length} entries)', 
        tag: 'CacheManager');
  }

  /// Limpa todo o cache
  Future<void> clear() async {
    final size = _cache.length;
    _cache.clear();
    _hits = 0;
    _misses = 0;
    _invalidations = 0;
    
    AppLogger.d('📦 Cache CLEARED: $size entries removed', tag: 'CacheManager');
  }

  // ==========================================================================
  // OPERAÇÕES AVANÇADAS
  // ==========================================================================

  /// Executa operação com cache automático
  Future<T> executeWithCache<T>(
    String key,
    Future<T> Function() operation, {
    Duration? ttl,
    String? entity,
  }) async {
    // Tenta buscar do cache primeiro
    final cached = await get<T>(key);
    if (cached != null) {
      return cached;
    }
    
    // Se não tem cache, executa operação
    final result = await operation();
    
    // Armazena resultado no cache
    await set(key, result, ttl: ttl, entity: entity);
    
    return result;
  }

  /// Obtém ou cria entrada de cache
  Future<T> getOrSet<T>(
    String key,
    Future<T> Function() factory, {
    Duration? ttl,
    String? entity,
  }) async {
    return await executeWithCache(key, factory, ttl: ttl, entity: entity);
  }

  // ==========================================================================
  // LIMPEZA AUTOMÁTICA
  // ==========================================================================

  /// Inicia timer de limpeza automática
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(CacheConfig.cleanupInterval, (_) {
      _cleanupExpiredEntries();
    });
  }

  /// Remove entradas expiradas do cache
  void _cleanupExpiredEntries() {
    final keysToRemove = <String>[];
    
    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        keysToRemove.add(entry.key);
      }
    }
    
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
    
    if (keysToRemove.isNotEmpty) {
      AppLogger.d('📦 Cache CLEANUP: ${keysToRemove.length} expired entries removed', 
          tag: 'CacheManager');
    }
  }

  // ==========================================================================
  // MÉTRICAS E ESTATÍSTICAS
  // ==========================================================================

  /// Obtém estatísticas do cache
  Map<String, dynamic> getStats() {
    final totalRequests = _hits + _misses;
    final hitRate = totalRequests > 0 ? (_hits / totalRequests) * 100 : 0.0;
    
    return {
      'size': _cache.length,
      'hits': _hits,
      'misses': _misses,
      'invalidations': _invalidations,
      'hitRate': hitRate.toStringAsFixed(2),
      'totalRequests': totalRequests,
    };
  }

  /// Obtém informações detalhadas do cache
  Map<String, dynamic> getDetailedStats() {
    final stats = getStats();
    final entries = <Map<String, dynamic>>[];
    
    for (final entry in _cache.entries) {
      entries.add({
        'key': entry.key,
        'valid': entry.value.isValid,
        'age': entry.value.age.inSeconds,
        'ttl': entry.value.ttl.inSeconds,
        'timeToExpire': entry.value.timeToExpire?.inSeconds,
      });
    }
    
    return {
      ...stats,
      'entries': entries,
    };
  }

  /// Loga estatísticas do cache
  void logStats() {
    final stats = getStats();
    AppLogger.i('📊 Cache Stats: ${stats['size']} entries, '
        '${stats['hitRate']}% hit rate, '
        '${stats['hits']} hits, ${stats['misses']} misses', 
        tag: 'CacheManager');
  }

  // ==========================================================================
  // DESTRUIÇÃO
  // ==========================================================================

  /// Limpa recursos do cache
  void dispose() {
    _cleanupTimer?.cancel();
    _cache.clear();
    AppLogger.i('📦 CacheManager disposed', tag: 'CacheManager');
  }
}
