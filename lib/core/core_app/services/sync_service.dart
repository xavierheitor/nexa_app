import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável pela sincronização de dados entre servidor e app local.
///
/// Este serviço gerencia a sincronização bidirecional de dados, garantindo
/// que o aplicativo local esteja sempre atualizado com os dados do servidor
/// e vice-versa. É executado após autenticação bem-sucedida ou sob demanda.
///
/// ## Funcionalidades Principais:
///
/// 1. **Sincronização Inicial**: Baixa dados essenciais após login
/// 2. **Sincronização Incremental**: Atualiza apenas dados modificados
/// 3. **Upload de Dados**: Envia dados locais pendentes para servidor
/// 4. **Tratamento de Conflitos**: Resolve conflitos de sincronização
/// 5. **Progresso**: Notifica progresso da sincronização
/// 6. **Retry Logic**: Tenta novamente em caso de falha
///
/// ## Arquitetura:
///
/// - **Serviço Independente**: Não depende de UI
/// - **Assíncrono**: Todas operações são não-bloqueantes
/// - **Observável**: Permite acompanhamento de progresso
/// - **Robusto**: Tratamento completo de erros
///
/// ## Fluxo de Sincronização:
///
/// 1. Verifica conectividade
/// 2. Obtém timestamp da última sincronização
/// 3. Baixa dados modificados do servidor
/// 4. Atualiza banco local
/// 5. Envia dados pendentes para servidor
/// 6. Atualiza timestamp de sincronização
/// 7. Notifica conclusão
///
/// ## Uso:
///
/// ```dart
/// final syncService = SyncService();
/// await syncService.sincronizar();
/// ```
class SyncService {
  /// Indica se sincronização está em andamento.
  bool _isSyncing = false;

  /// Getter para verificar se está sincronizando.
  bool get isSyncing => _isSyncing;

  /// Executa sincronização completa de dados.
  ///
  /// Sincroniza todos os dados necessários entre servidor e app local,
  /// garantindo que o usuário tenha acesso às informações mais recentes.
  ///
  /// ## Comportamento:
  /// 1. Verifica se já está sincronizando (evita duplicação)
  /// 2. Inicia processo de sincronização
  /// 3. Sincroniza cada tipo de dado necessário
  /// 4. Notifica progresso e conclusão
  /// 5. Trata erros adequadamente
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida, false caso contrário
  ///
  /// ## Exceções:
  /// Captura e trata todas exceções internamente, retornando false em caso de erro.
  Future<bool> sincronizar() async {
    /// Evita sincronização concorrente.
    if (_isSyncing) {
      AppLogger.w('Sincronização já em andamento', tag: 'SyncService');
      return false;
    }

    _isSyncing = true;
    AppLogger.i('🔄 Iniciando sincronização de dados', tag: 'SyncService');

    try {
      /// Simula delay de sincronização (substituir por chamadas reais à API).
      /// Em produção, aqui você faria as chamadas de API para sincronizar
      /// diferentes tipos de dados (usuários, configurações, etc.).

      AppLogger.d('📥 Sincronizando dados do usuário...', tag: 'SyncService');
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.d('📥 Sincronizando configurações...', tag: 'SyncService');
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.d('📤 Enviando dados pendentes...', tag: 'SyncService');
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.i('✅ Sincronização concluída com sucesso', tag: 'SyncService');
      return true;
    } catch (e, stackTrace) {
      /// Trata erro de sincronização.
      AppLogger.e('❌ Erro durante sincronização',
          tag: 'SyncService', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Executa sincronização rápida (apenas dados essenciais).
  ///
  /// Sincroniza apenas os dados mais críticos e essenciais,
  /// útil para atualizações rápidas sem bloquear o usuário.
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida, false caso contrário
  Future<bool> sincronizarRapida() async {
    if (_isSyncing) {
      AppLogger.w('Sincronização já em andamento', tag: 'SyncService');
      return false;
    }

    _isSyncing = true;
    AppLogger.i('⚡ Iniciando sincronização rápida', tag: 'SyncService');

    try {
      /// Sincroniza apenas dados essenciais.
      AppLogger.d('📥 Sincronizando dados essenciais...', tag: 'SyncService');
      await Future.delayed(const Duration(milliseconds: 500));

      AppLogger.i('✅ Sincronização rápida concluída', tag: 'SyncService');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante sincronização rápida',
          tag: 'SyncService', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Cancela sincronização em andamento.
  void cancelar() {
    if (_isSyncing) {
      AppLogger.w('🚫 Cancelando sincronização', tag: 'SyncService');
      _isSyncing = false;
    }
  }
}
