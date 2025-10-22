/// Configurações padrão para diferentes tipos de cache.
///
/// Define TTLs (Time To Live) otimizados para diferentes tipos de dados
/// baseado na frequência de mudança e importância para a aplicação.
class CacheConfig {
  // ==========================================================================
  // TTLs POR TIPO DE DADOS
  // ==========================================================================

  /// Dados estáticos que raramente mudam (veículos, equipes, tipos)
  static const Duration staticData = Duration(minutes: 10);

  /// Dados de sessão do usuário (dados do usuário logado)
  static const Duration sessionData = Duration(minutes: 30);

  /// Dados de turno ativo (mudam mais frequentemente)
  static const Duration turnoData = Duration(minutes: 5);

  /// Dados de relacionamento (checklists, perguntas, opções)
  static const Duration relationshipData = Duration(minutes: 5);

  /// Dados críticos que precisam ser sempre atualizados
  static const Duration criticalData = Duration(minutes: 2);

  /// Cache de curta duração para dados temporários
  static const Duration shortTerm = Duration(minutes: 1);

  // ==========================================================================
  // CONFIGURAÇÕES POR ENTIDADE
  // ==========================================================================

  /// Mapeamento de entidades para TTLs específicos
  static const Map<String, Duration> entityTTL = {
    // Dados estáticos
    'veiculos': staticData,
    'equipes': staticData,
    'eletricistas': staticData,
    'tipo_veiculo': staticData,
    'tipo_equipe': staticData,
    
    // Dados de sessão
    'usuario': sessionData,
    'usuario_atual': sessionData,
    
    // Dados de turno
    'turno_ativo': turnoData,
    'turno_situacao': turnoData,
    
    // Dados de checklist
    'checklist_modelo': relationshipData,
    'checklist_pergunta': relationshipData,
    'checklist_opcao_resposta': relationshipData,
    'checklist_preenchido': criticalData,
    'checklist_resposta': criticalData,
    
    // Relacionamentos
    'checklist_pergunta_relacao': relationshipData,
    'checklist_opcao_resposta_relacao': relationshipData,
    'checklist_tipo_equipe_relacao': relationshipData,
    'checklist_tipo_veiculo_relacao': relationshipData,
  };

  // ==========================================================================
  // CONFIGURAÇÕES GERAIS
  // ==========================================================================

  /// Tamanho máximo do cache (número de entradas)
  static const int maxCacheSize = 100;

  /// TTL padrão para dados não mapeados
  static const Duration defaultTTL = Duration(minutes: 5);

  /// Intervalo para limpeza automática de cache expirado
  static const Duration cleanupInterval = Duration(minutes: 2);

  // ==========================================================================
  // MÉTODOS UTILITÁRIOS
  // ==========================================================================

  /// Obtém TTL para uma entidade específica
  static Duration getTTLForEntity(String entity) {
    return entityTTL[entity] ?? defaultTTL;
  }

  /// Obtém TTL para uma operação específica
  static Duration getTTLForOperation(String operation) {
    switch (operation.toLowerCase()) {
      case 'listar':
        return staticData;
      case 'buscar':
        return shortTerm;
      case 'sincronizar':
        return criticalData;
      default:
        return defaultTTL;
    }
  }

  /// Verifica se uma entidade deve usar cache
  static bool shouldCache(String entity) {
    return entityTTL.containsKey(entity);
  }

  /// Obtém chave de cache padronizada
  static String getCacheKey(String entity, String operation, [Map<String, dynamic>? params]) {
    final baseKey = '${entity}_$operation';
    
    if (params == null || params.isEmpty) {
      return baseKey;
    }
    
    // Ordena parâmetros para consistência
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    final paramString = sortedParams.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    
    return '$baseKey|$paramString';
  }
}
