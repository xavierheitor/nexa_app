import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Exemplo de como usar o sistema de sincronização.
///
/// Este arquivo demonstra como utilizar o SyncService para sincronizar
/// dados entre o servidor e o banco local, incluindo sincronização
/// completa, por módulo específico e verificação de status.
///
/// ## Repositórios Registrados:
///
/// - **veiculo**: Sincroniza dados de veículos
/// - **tipo_veiculo**: Sincroniza dados de tipos de veículo
///
/// ## Como Usar:
///
/// ```dart
/// // 1. Obter instância do SyncService
/// final syncService = Get.find<SyncService>();
///
/// // 2. Sincronizar todos os dados
/// final sucesso = await syncService.sincronizar();
///
/// // 3. Sincronizar módulo específico
/// await syncService.sincronizarModulo('veiculo');
///
/// // 4. Verificar módulos disponíveis
/// final modulos = syncService.modulosDisponiveis;
/// ```
class SyncExample {
  /// Exemplo de sincronização completa.
  ///
  /// Sincroniza todos os módulos registrados (veículos e tipos de veículo)
  /// com o servidor, baixando os dados mais recentes e salvando no banco local.
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida
  ///
  /// ## Exemplo:
  /// ```dart
  /// final exemplo = SyncExample();
  /// final sucesso = await exemplo.sincronizarTodosDados();
  /// if (sucesso) {
  ///   print('Dados sincronizados com sucesso!');
  /// }
  /// ```
  static Future<bool> sincronizarTodosDados() async {
    try {
      /// Obtém instância do SyncService via GetX.
      final syncService = Get.find<SyncService>();

      /// Executa sincronização completa de todos os módulos.
      final sucesso = await syncService.sincronizar();

      if (sucesso) {
        AppLogger.i('✅ Sincronização completa realizada com sucesso',
            tag: 'SyncExample');
      } else {
        AppLogger.w('⚠️ Sincronização completa falhou ou foi parcial',
            tag: 'SyncExample');
      }

      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante sincronização completa',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Exemplo de sincronização de módulo específico.
  ///
  /// Sincroniza apenas um módulo específico (veículos ou tipos de veículo)
  /// com o servidor, útil para atualizações pontuais.
  ///
  /// ## Parâmetros:
  /// - `nomeModulo`: Nome do módulo a ser sincronizado
  /// - `force`: Se true, força sincronização mesmo com dados locais
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida
  ///
  /// ## Exemplo:
  /// ```dart
  /// // Sincronizar apenas veículos
  /// await SyncExample.sincronizarModulo('veiculo');
  ///
  /// // Forçar sincronização de tipos de veículo
  /// await SyncExample.sincronizarModulo('tipo_veiculo', force: true);
  /// ```
  static Future<bool> sincronizarModulo(String nomeModulo,
      {bool force = false}) async {
    try {
      /// Obtém instância do SyncService via GetX.
      final syncService = Get.find<SyncService>();

      /// Executa sincronização do módulo específico.
      final sucesso = await syncService.sincronizarModulo(nomeModulo, force: force);

      if (sucesso) {
        AppLogger.i('✅ Módulo $nomeModulo sincronizado com sucesso',
            tag: 'SyncExample');
      } else {
        AppLogger.w('⚠️ Falha na sincronização do módulo $nomeModulo',
            tag: 'SyncExample');
      }

      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante sincronização do módulo $nomeModulo',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Exemplo de verificação de módulos disponíveis.
  ///
  /// Lista todos os módulos que estão registrados e disponíveis
  /// para sincronização no SyncService.
  ///
  /// ## Retorno:
  /// - `List<String>`: Lista de nomes dos módulos disponíveis
  ///
  /// ## Exemplo:
  /// ```dart
  /// final modulos = await SyncExample.verificarModulosDisponiveis();
  /// print('Módulos disponíveis: $modulos');
  /// // Saída: ['veiculo', 'tipo_veiculo']
  /// ```
  static List<String> verificarModulosDisponiveis() {
    try {
      /// Obtém instância do SyncService via GetX.
      final syncService = Get.find<SyncService>();

      /// Lista módulos disponíveis para sincronização.
      final modulos = syncService.modulosDisponiveis;

      AppLogger.i('📋 Módulos disponíveis para sincronização: $modulos',
          tag: 'SyncExample');

      return modulos;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar módulos disponíveis',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Exemplo de sincronização rápida.
  ///
  /// Executa sincronização rápida de dados essenciais,
  /// útil para atualizações rápidas sem bloquear o usuário.
  ///
  /// ## Retorno:
  /// - `Future<bool>`: true se sincronização foi bem-sucedida
  ///
  /// ## Exemplo:
  /// ```dart
  /// final sucesso = await SyncExample.sincronizacaoRapida();
  /// if (sucesso) {
  ///   print('Sincronização rápida concluída!');
  /// }
  /// ```
  static Future<bool> sincronizacaoRapida() async {
    try {
      /// Obtém instância do SyncService via GetX.
      final syncService = Get.find<SyncService>();

      /// Executa sincronização rápida.
      final sucesso = await syncService.sincronizarRapida();

      if (sucesso) {
        AppLogger.i('⚡ Sincronização rápida realizada com sucesso',
            tag: 'SyncExample');
      } else {
        AppLogger.w('⚠️ Sincronização rápida falhou ou foi parcial',
            tag: 'SyncExample');
      }

      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante sincronização rápida',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Exemplo de verificação de status de sincronização.
  ///
  /// Verifica se o SyncService está atualmente executando
  /// alguma operação de sincronização.
  ///
  /// ## Retorno:
  /// - `bool`: true se está sincronizando, false caso contrário
  ///
  /// ## Exemplo:
  /// ```dart
  /// if (SyncExample.estaSincronizando()) {
  ///   print('Sincronização em andamento...');
  /// } else {
  ///   print('Sistema pronto para sincronizar');
  /// }
  /// ```
  static bool estaSincronizando() {
    try {
      /// Obtém instância do SyncService via GetX.
      final syncService = Get.find<SyncService>();

      /// Verifica se está sincronizando.
      final sincronizando = syncService.isSyncing;

      if (sincronizando) {
        AppLogger.i('🔄 Sincronização em andamento', tag: 'SyncExample');
      } else {
        AppLogger.i('✅ Sistema pronto para sincronizar', tag: 'SyncExample');
      }

      return sincronizando;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar status de sincronização',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Exemplo completo de uso do sistema de sincronização.
  ///
  /// Demonstra um fluxo completo de sincronização, incluindo
  /// verificação de status, listagem de módulos e execução
  /// de sincronização com tratamento de erros.
  ///
  /// ## Exemplo:
  /// ```dart
  /// await SyncExample.exemploCompleto();
  /// ```
  static Future<void> exemploCompleto() async {
    AppLogger.i('🚀 Iniciando exemplo completo de sincronização',
        tag: 'SyncExample');

    try {
      /// 1. Verificar módulos disponíveis
      final modulos = verificarModulosDisponiveis();
      AppLogger.i('📋 Módulos encontrados: $modulos', tag: 'SyncExample');

      /// 2. Verificar se está sincronizando
      if (estaSincronizando()) {
        AppLogger.w('⚠️ Sincronização já em andamento, aguardando...',
            tag: 'SyncExample');
        return;
      }

      /// 3. Executar sincronização completa
      AppLogger.i('🔄 Iniciando sincronização completa...',
          tag: 'SyncExample');
      final sucesso = await sincronizarTodosDados();

      if (sucesso) {
        AppLogger.i('✅ Exemplo completo executado com sucesso!',
            tag: 'SyncExample');
      } else {
        AppLogger.w('⚠️ Exemplo completo executado com falhas',
            tag: 'SyncExample');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro durante exemplo completo',
          tag: 'SyncExample', error: e, stackTrace: stackTrace);
    }
  }
}
