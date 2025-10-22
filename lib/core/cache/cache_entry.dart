/// Entrada de cache que armazena dados com metadados de controle.
///
/// Esta classe encapsula os dados em cache junto com informações de controle
/// como TTL (Time To Live), timestamp de criação e invalidação.
class CacheEntry<T> {
  /// Dados armazenados no cache
  final T data;
  
  /// Timestamp de quando o cache foi criado
  final DateTime createdAt;
  
  /// Duração de vida do cache (TTL)
  final Duration ttl;
  
  /// Chave única do cache
  final String key;
  
  /// Se o cache foi invalidado manualmente
  bool _isInvalidated = false;

  CacheEntry({
    required this.data,
    required this.key,
    required this.ttl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Verifica se o cache ainda é válido
  bool get isValid {
    if (_isInvalidated) return false;
    
    final now = DateTime.now();
    final expirationTime = createdAt.add(ttl);
    return now.isBefore(expirationTime);
  }

  /// Verifica se o cache expirou
  bool get isExpired {
    final now = DateTime.now();
    final expirationTime = createdAt.add(ttl);
    return now.isAfter(expirationTime);
  }

  /// Invalida o cache manualmente
  void invalidate() {
    _isInvalidated = true;
  }

  /// Tempo restante até expirar
  Duration? get timeToExpire {
    if (_isInvalidated) return null;
    
    final now = DateTime.now();
    final expirationTime = createdAt.add(ttl);
    
    if (now.isAfter(expirationTime)) return null;
    
    return expirationTime.difference(now);
  }

  /// Idade do cache
  Duration get age => DateTime.now().difference(createdAt);

  @override
  String toString() {
    return 'CacheEntry(key: $key, valid: $isValid, age: ${age.inSeconds}s, ttl: ${ttl.inSeconds}s)';
  }
}
