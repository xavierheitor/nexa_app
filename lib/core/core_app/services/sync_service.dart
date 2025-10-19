import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/checklist_tipo_equipe_relacao_repo.dart';
import 'package:nexa_app/data/repositories/checklist_tipo_veiculo_relacao_repo.dart';
import 'package:nexa_app/data/repositories/tipo_equipe_repo.dart';
import 'package:nexa_app/core/sync/sync_manager.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/data/repositories/tipo_veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:get/get.dart';

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
/// - **Modular**: Usa SyncManager para coordenar repositórios
///
/// ## Fluxo de Sincronização:
///
/// 1. Verifica conectividade
/// 2. Obtém timestamp da última sincronização
/// 3. Baixa dados modificados do servidor via SyncManager
/// 4. Atualiza banco local via repositórios registrados
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
  /// Gerenciador central de sincronização.
  ///
  /// Responsável por coordenar a sincronização de todos os repositórios
  /// registrados, oferecendo métodos para sincronização completa ou seletiva.
  late final SyncManager _syncManager;

  /// Indica se sincronização está em andamento.
  bool _isSyncing = false;

  /// Getter para verificar se está sincronizando.
  bool get isSyncing => _isSyncing;

  /// Construtor do serviço de sincronização.
  ///
  /// Inicializa o SyncManager e registra os repositórios sincronizáveis.
  /// Este é o local centralizado onde todos os repositórios devem ser
  /// registrados para participar do processo de sincronização.
  ///
  /// ## Repositórios Registrados:
  ///
  /// Atualmente nenhum repositório está registrado. Para adicionar novos
  /// repositórios sincronizáveis, implemente a interface `SyncableRepository<T>`
  /// e registre aqui no construtor.
  ///
  /// ## Exemplo de Registro:
  ///
  /// ```dart
  /// SyncService() {
  ///   _syncManager = SyncManager();
  ///
  ///   // Registrar repositórios sincronizáveis
  ///   _syncManager.registrar(UsuarioSyncRepo(dio: dio, dao: usuarioDao));
  ///   _syncManager.registrar(ProdutoSyncRepo(dio: dio, dao: produtoDao));
  ///   _syncManager.registrar(CategoriaSyncRepo(dio: dio, dao: categoriaDao));
  /// }
  /// ```
  ///
  /// ## Onde Implementar Repositórios:
  ///
  /// Crie os repositórios sincronizáveis em:
  /// - `lib/core/domain/repositories/sync/` (recomendado)
  /// - `lib/core/sync/repositories/` (alternativa)
  ///
  /// ## Estrutura Recomendada:
  ///
  /// ```
  /// lib/core/domain/repositories/sync/
  /// ├── usuario_sync_repo.dart
  /// ├── produto_sync_repo.dart
  /// ├── categoria_sync_repo.dart
  /// └── ...
  /// ```
  SyncService() {
    _syncManager = SyncManager();

    // Registrar repositórios sincronizáveis
    _syncManager.registrar(VeiculoRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(TipoVeiculoRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(TipoEquipeRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(EquipeRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(EletricistaRepo(dio: Get.find(), db: Get.find()));
    _syncManager
        .registrar(ChecklistModeloRepo(dio: Get.find(), db: Get.find()));
    _syncManager
        .registrar(ChecklistPerguntaRepo(dio: Get.find(), db: Get.find()));
    _syncManager
        .registrar(ChecklistOpcaoRespostaRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(
        ChecklistOpcaoRespostaRelacaoRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(
        ChecklistPerguntaRelacaoRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(
        ChecklistTipoEquipeRelacaoRepo(dio: Get.find(), db: Get.find()));
    _syncManager.registrar(
        ChecklistTipoVeiculoRelacaoRepo(dio: Get.find(), db: Get.find()));

    AppLogger.i(
        'SyncService inicializado com ${_syncManager.modulosDisponiveis.length} módulos: ${_syncManager.modulosDisponiveis}',
        tag: 'SyncService');
  }

  /// Executa sincronização completa de dados.
  ///
  /// Sincroniza todos os dados necessários entre servidor e app local,
  /// garantindo que o usuário tenha acesso às informações mais recentes.
  /// Utiliza o SyncManager para coordenar a sincronização de todos os
  /// repositórios registrados.
  ///
  /// ## Comportamento:
  /// 1. Verifica se já está sincronizando (evita duplicação)
  /// 2. Inicia processo de sincronização via SyncManager
  /// 3. Sincroniza todos os módulos registrados
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
      /// Executa sincronização completa via SyncManager.
      /// O SyncManager coordena todos os repositórios registrados.
      final resultado = await _syncManager.sincronizarTudo();

      if (resultado.sucesso) {
        AppLogger.i('✅ Sincronização concluída com sucesso',
            tag: 'SyncService');
        return true;
      } else if (resultado.podeContinuar) {
        AppLogger.w('⚠️ Sincronização parcial - usando dados locais',
            tag: 'SyncService');
        return true; // Pode continuar com dados locais
      } else {
        AppLogger.e('❌ Falha crítica na sincronização', tag: 'SyncService');
        return false;
      }
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
  /// Atualmente executa a mesma sincronização completa, mas pode ser
  /// customizada para sincronizar apenas módulos específicos.
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
      /// Executa sincronização completa (pode ser customizada para módulos específicos).
      /// TODO: Implementar sincronização seletiva de módulos essenciais
      final resultado = await _syncManager.sincronizarTudo();

      if (resultado.sucesso) {
        AppLogger.i('✅ Sincronização rápida concluída', tag: 'SyncService');
        return true;
      } else if (resultado.podeContinuar) {
        AppLogger.w('⚠️ Sincronização rápida parcial', tag: 'SyncService');
        return true;
      } else {
        AppLogger.e('❌ Falha na sincronização rápida', tag: 'SyncService');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante sincronização rápida',
          tag: 'SyncService', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Sincroniza um módulo específico.
  ///
  /// Executa sincronização apenas do módulo especificado, útil para
  /// atualizações pontuais ou correções de dados específicos.
  ///
  /// ## Parâmetros:
  /// - `nomeModulo`: Nome do módulo a ser sincronizado
  /// - `force`: Se true, força sincronização mesmo com dados locais existentes
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida, false caso contrário
  ///
  /// ## Exemplo:
  /// ```dart
  /// // Sincronizar apenas usuários
  /// await syncService.sincronizarModulo('usuario');
  ///
  /// // Forçar sincronização de produtos
  /// await syncService.sincronizarModulo('produto', force: true);
  /// ```
  Future<bool> sincronizarModulo(String nomeModulo,
      {bool force = false}) async {
    if (_isSyncing) {
      AppLogger.w('Sincronização já em andamento', tag: 'SyncService');
      return false;
    }

    _isSyncing = true;
    AppLogger.i('🔄 Sincronizando módulo: $nomeModulo', tag: 'SyncService');

    try {
      await _syncManager.sincronizarModulo(nomeModulo, force: force);
      AppLogger.i('✅ Módulo $nomeModulo sincronizado com sucesso',
          tag: 'SyncService');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao sincronizar módulo $nomeModulo',
          tag: 'SyncService', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Lista os módulos disponíveis para sincronização.
  ///
  /// Retorna uma lista com todos os nomes de módulos que possuem
  /// repositórios registrados no SyncManager.
  ///
  /// ## Retorno:
  /// - `List<String>`: Lista de nomes de módulos disponíveis
  ///
  /// ## Exemplo:
  /// ```dart
  /// final modulos = syncService.modulosDisponiveis;
  /// print('Módulos: $modulos'); // ['usuario', 'produto', 'categoria']
  /// ```
  List<String> get modulosDisponiveis => _syncManager.modulosDisponiveis;

  /// Executa sincronização completa de todas as tabelas.
  ///
  /// Método público que chama sincronizarTudo do SyncManager,
  /// sincronizando todos os repositórios registrados.
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida, false caso contrário
  Future<bool> sincronizarTudo() async {
    if (_isSyncing) {
      AppLogger.w('Sincronização já em andamento', tag: 'SyncService');
      return false;
    }

    _isSyncing = true;
    AppLogger.i('🔄 Iniciando sincronização completa (FORÇADA)',
        tag: 'SyncService');
    AppLogger.v('📋 Módulos disponíveis: ${_syncManager.modulosDisponiveis}',
        tag: 'SyncService');
    AppLogger.v('⚡ Modo FORÇADO: ignorando dados locais existentes',
        tag: 'SyncService');

    try {
      final resultado = await _syncManager.sincronizarTudo(force: true);

      if (resultado.sucesso) {
        AppLogger.i('✅ Sincronização completa concluída com sucesso',
            tag: 'SyncService');
        AppLogger.v(
            '📊 Resultado: sucesso=true, podeContinuar=${resultado.podeContinuar}',
            tag: 'SyncService');
        return true;
      } else if (resultado.podeContinuar) {
        AppLogger.w(
            '⚠️ Sincronização parcial - alguns módulos falharam mas pode continuar',
            tag: 'SyncService');
        AppLogger.v(
            '📊 Resultado: sucesso=false, podeContinuar=${resultado.podeContinuar}',
            tag: 'SyncService');
        return true;
      } else {
        AppLogger.e('❌ Falha crítica na sincronização completa',
            tag: 'SyncService');
        AppLogger.v(
            '📊 Resultado: sucesso=false, podeContinuar=${resultado.podeContinuar}',
            tag: 'SyncService');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro inesperado durante sincronização completa',
          tag: 'SyncService', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
      AppLogger.v('🏁 Sincronização finalizada (isSyncing=false)',
          tag: 'SyncService');
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
