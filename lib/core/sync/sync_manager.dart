import 'package:nexa_app/core/sync/sync_result.dart';
import 'package:nexa_app/core/sync/syncable_repository.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Gerenciador central de sincronização de dados.
///
/// Esta classe é responsável por coordenar a sincronização de dados entre
/// o servidor e o banco de dados local. Ela mantém um registro de todos os
/// repositórios sincronizáveis e oferece métodos para sincronização completa
/// ou por módulo específico.
///
/// ## Funcionalidades Principais:
///
/// 1. **Registro de Repositórios**: Gerencia repositórios sincronizáveis
/// 2. **Sincronização Completa**: Sincroniza todos os módulos registrados
/// 3. **Sincronização Seletiva**: Sincroniza módulos específicos
/// 4. **Controle de Estado**: Verifica se há dados locais antes de sincronizar
/// 5. **Tratamento de Erros**: Gerencia falhas de sincronização
/// 6. **Flexibilidade**: Permite forçar sincronização mesmo com dados locais
///
/// ## Arquitetura:
///
/// - **Registry Pattern**: Mantém mapa de repositórios por nome de entidade
/// - **Strategy Pattern**: Cada repositório implementa sua própria estratégia de sync
/// - **Fail-Safe**: Continua operação mesmo com falhas parciais
/// - **Stateless**: Não mantém estado interno além do registro
///
/// ## Como Registrar Repositórios:
///
/// ```dart
/// // 1. Crie um repositório que implemente SyncableRepository<T>
/// class UsuarioSyncRepo implements SyncableRepository<UsuarioDto> {
///   @override
///   String get nomeEntidade => 'usuario';
///
///   @override
///   Future<List<UsuarioDto>> buscarDaApi() async {
///     // Implementar busca na API
///   }
///
///   @override
///   Future<void> sincronizarComBanco(List<UsuarioDto> itens) async {
///     // Implementar persistência no banco
///   }
///
///   @override
///   Future<bool> estaVazio(String entidade) async {
///     // Verificar se tabela está vazia
///   }
/// }
///
/// // 2. Registre no SyncManager
/// final syncManager = SyncManager();
/// syncManager.registrar(UsuarioSyncRepo());
///
/// // 3. Use a sincronização
/// await syncManager.sincronizarTudo();
/// ```
///
/// ## Onde Registrar:
///
/// O ideal é registrar os repositórios em um local centralizado, como:
/// - `lib/core/core_app/services/sync_service.dart` (recomendado)
/// - `lib/core/core_app/bindings/initial_binding.dart`
/// - Um factory ou service locator específico
///
/// ## Fluxo de Sincronização:
///
/// 1. **Verificação**: Checa se módulo está vazio (se não forçado)
/// 2. **Busca**: Obtém dados da API via repositório
/// 3. **Persistência**: Salva dados no banco local
/// 4. **Resultado**: Retorna status da operação
///
/// ## Tratamento de Erros:
///
/// - Falhas individuais não interrompem sincronização completa
/// - Dados locais existentes permitem continuar operação
/// - Logs detalhados para debugging
/// - Resultado consolidado indica sucesso geral
class SyncManager {
  /// Mapa de repositórios sincronizáveis indexados por nome da entidade.
  ///
  /// Cada repositório é identificado por um nome único (ex: 'usuario', 'produto')
  /// que permite referenciar módulos específicos para sincronização.
  final Map<String, SyncableRepository> _repos = {};

  /// Registra um repositório sincronizável no gerenciador.
  ///
  /// Adiciona um repositório ao mapa interno, permitindo que ele seja
  /// incluído nas operações de sincronização. O repositório é indexado
  /// pelo seu `nomeEntidade` para referência posterior.
  ///
  /// ## Parâmetros:
  /// - `repo`: Repositório que implementa `SyncableRepository<T>`
  ///
  /// ## Comportamento:
  /// - Substitui repositório existente se mesmo nome de entidade
  /// - Não valida implementação (responsabilidade do desenvolvedor)
  /// - Operação síncrona e imediata
  ///
  /// ## Exemplo:
  /// ```dart
  /// final usuarioRepo = UsuarioSyncRepo();
  /// syncManager.registrar(usuarioRepo);
  /// ```
  ///
  /// ## ⚠️ Importante:
  /// - Nome da entidade deve ser único
  /// - Repositório deve implementar todos os métodos obrigatórios
  /// - Registro deve ser feito antes de usar sincronização
  void registrar<T>(SyncableRepository<T> repo) {
    _repos[repo.nomeEntidade] = repo;
  }

  /// Lista os nomes dos módulos registrados e disponíveis para sincronização.
  ///
  /// Retorna uma lista com todos os nomes de entidades que possuem
  /// repositórios registrados, útil para debugging e validação.
  ///
  /// ## Retorno:
  /// - `List<String>`: Lista de nomes de entidades registradas
  ///
  /// ## Casos de Uso:
  /// - Verificar se módulo está registrado
  /// - Debugging de configuração
  /// - Validação de setup
  ///
  /// ## Exemplo:
  /// ```dart
  /// final modulos = syncManager.modulosDisponiveis;
  /// print('Módulos disponíveis: $modulos'); // ['usuario', 'produto']
  /// ```
  List<String> get modulosDisponiveis => _repos.keys.toList();

  /// Sincroniza todos os módulos registrados.
  ///
  /// Executa sincronização completa de todos os repositórios registrados,
  /// seguindo a estratégia de verificar dados locais antes de sincronizar
  /// (a menos que seja forçado). Retorna resultado consolidado da operação.
  ///
  /// ## Parâmetros:
  /// - `force`: Se true, força sincronização mesmo com dados locais existentes
  ///
  /// ## Retorno:
  /// - `Future<SyncResult>`: Resultado consolidado da sincronização
  ///
  /// ## Comportamento:
  /// 1. Itera por todos os repositórios registrados
  /// 2. Verifica se módulo está vazio (se não forçado)
  /// 3. Busca dados da API via repositório
  /// 4. Persiste dados no banco local
  /// 5. Trata erros individuais sem interromper processo
  /// 6. Retorna resultado consolidado
  ///
  /// ## Estratégia de Verificação:
  /// - **Sem force**: Pula módulos com dados locais existentes
  /// - **Com force**: Sincroniza todos os módulos independente do estado
  ///
  /// ## Tratamento de Erros:
  /// - Falhas individuais não interrompem processo completo
  /// - Dados locais existentes permitem continuar operação
  /// - Resultado indica se houve falhas e se pode continuar
  ///
  /// ## Exemplo:
  /// ```dart
  /// final resultado = await syncManager.sincronizarTudo();
  /// if (resultado.sucesso) {
  ///   print('Sincronização completa bem-sucedida');
  /// } else if (resultado.podeContinuar) {
  ///   print('Sincronização parcial, mas pode continuar');
  /// } else {
  ///   print('Falha crítica na sincronização');
  /// }
  /// ```
  Future<SyncResult> sincronizarTudo({bool force = false}) async {
    bool falhou = false;
    bool temDadosLocais = false;
    int totalModulos = _repos.length;
    int modulosProcessados = 0;
    int modulosPulados = 0;
    int modulosComErro = 0;

    AppLogger.v('🔄 Iniciando sincronização de $totalModulos módulos',
        tag: 'SyncManager');

    for (var entry in _repos.entries) {
      final nomeEntidade = entry.key;
      final repo = entry.value;
      modulosProcessados++;

      AppLogger.v(
          '📦 Processando módulo $modulosProcessados/$totalModulos: $nomeEntidade',
          tag: 'SyncManager');

      try {
        // Verifica se deve pular módulo com dados locais
        if (!force) {
          final vazio = await repo.estaVazio(nomeEntidade);
          if (!vazio) {
            temDadosLocais = true;
            modulosPulados++;
            AppLogger.v(
                '⏭️ Módulo $nomeEntidade pulado (dados locais existentes)',
                tag: 'SyncManager');
            continue;
          }
        }

        AppLogger.v('🌐 Buscando dados da API para $nomeEntidade...',
            tag: 'SyncManager');
        final dados = await repo.buscarDaApi();
        final quantidadeDados = dados.length;

        AppLogger.v(
            '📊 API retornou $quantidadeDados registros para $nomeEntidade',
            tag: 'SyncManager');

        if (quantidadeDados > 0) {
          AppLogger.v(
              '💾 Salvando $quantidadeDados registros no banco local para $nomeEntidade...',
              tag: 'SyncManager');
          await repo.sincronizarComBanco(dados);
          AppLogger.v(
              '✅ Módulo $nomeEntidade sincronizado com sucesso ($quantidadeDados registros)',
              tag: 'SyncManager');
        } else {
          AppLogger.v('⚠️ Módulo $nomeEntidade retornou 0 registros da API',
              tag: 'SyncManager');
        }
      } catch (e, stackTrace) {
        falhou = true;
        modulosComErro++;
        AppLogger.e('❌ Erro ao sincronizar módulo $nomeEntidade',
            tag: 'SyncManager', error: e, stackTrace: stackTrace);

        // Verifica se tem dados locais para continuar
        try {
          final vazio = await repo.estaVazio(nomeEntidade);
          if (!vazio) temDadosLocais = true;
        } catch (_) {
          // Ignora erro na verificação de dados locais
        }
      }
    }

    AppLogger.v('📈 Resumo da sincronização:', tag: 'SyncManager');
    AppLogger.v('   • Total de módulos: $totalModulos', tag: 'SyncManager');
    AppLogger.v('   • Processados: $modulosProcessados', tag: 'SyncManager');
    AppLogger.v('   • Pulados: $modulosPulados', tag: 'SyncManager');
    AppLogger.v('   • Com erro: $modulosComErro', tag: 'SyncManager');
    AppLogger.v('   • Sucesso: ${!falhou}', tag: 'SyncManager');
    AppLogger.v('   • Pode continuar: ${!falhou || temDadosLocais}',
        tag: 'SyncManager');

    return SyncResult(
      sucesso: !falhou,
      podeContinuar: !falhou || temDadosLocais,
    );
  }

  /// Sincroniza um módulo específico por nome da entidade.
  ///
  /// Executa sincronização apenas do módulo especificado, útil para
  /// atualizações pontuais ou correções de dados específicos.
  ///
  /// ## Parâmetros:
  /// - `nomeEntidade`: Nome da entidade a ser sincronizada
  /// - `force`: Se true, força sincronização mesmo com dados locais existentes
  ///
  /// ## Retorno:
  /// - `Future<void>`: Completa quando sincronização termina
  ///
  /// ## Comportamento:
  /// 1. Busca repositório pelo nome da entidade
  /// 2. Verifica se módulo está vazio (se não forçado)
  /// 3. Executa ciclo completo de sincronização
  /// 4. Lança exceção se módulo não encontrado
  ///
  /// ## Exceções:
  /// - `Exception`: Se nenhum repositório registrado para a entidade
  ///
  /// ## Exemplo:
  /// ```dart
  /// // Sincronizar apenas usuários
  /// await syncManager.sincronizarModulo('usuario');
  ///
  /// // Forçar sincronização mesmo com dados locais
  /// await syncManager.sincronizarModulo('produto', force: true);
  /// ```
  Future<void> sincronizarModulo(String nomeEntidade,
      {bool force = false}) async {
    final repo = _repos[nomeEntidade];
    if (repo == null) {
      throw Exception('Nenhum repositório registrado para $nomeEntidade');
    }

    if (!force) {
      final vazio = await repo.estaVazio(nomeEntidade);
      if (!vazio) return;
    }

    await _executar(repo);
  }

  /// Executa o ciclo de sincronização de um repositório específico.
  ///
  /// Método interno que coordena as operações de busca na API e
  /// persistência no banco local para um repositório específico.
  ///
  /// ## Parâmetros:
  /// - `repo`: Repositório a ser sincronizado
  ///
  /// ## Comportamento:
  /// 1. Busca dados da API via `buscarDaApi()`
  /// 2. Persiste dados no banco via `sincronizarComBanco()`
  /// 3. Propaga erros para camada superior
  ///
  /// ## Fluxo:
  /// ```
  /// API → [dados] → Banco Local
  /// ```
  ///
  /// ## Tratamento de Erros:
  /// - Erros de API são propagados
  /// - Erros de persistência são propagados
  /// - Não há retry automático (responsabilidade do chamador)
  Future<void> _executar(SyncableRepository repo) async {
    AppLogger.v('🔄 Executando sincronização para ${repo.nomeEntidade}...',
        tag: 'SyncManager');
    
    final dados = await repo.buscarDaApi();
    AppLogger.v(
        '📊 Dados obtidos da API para ${repo.nomeEntidade}: ${dados.length} registros',
        tag: 'SyncManager');
    
    await repo.sincronizarComBanco(dados);
    AppLogger.v('💾 Dados salvos no banco local para ${repo.nomeEntidade}',
        tag: 'SyncManager');
  }
}
