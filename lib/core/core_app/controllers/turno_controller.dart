import 'package:get/get.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/models/turno_table_dto.dart';
import 'package:nexa_app/data/models/eletricista_table_dto.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/app/routes/routes.dart';

/// Controlador global responsável pelo gerenciamento de estado de turnos.
///
/// Este controlador fica disponível durante todo o ciclo de vida da aplicação,
/// gerenciando o estado do turno ativo e fornecendo acesso a informações
/// do turno para qualquer parte da aplicação.
///
/// ## Responsabilidades:
///
/// 1. **Estado Global**: Mantém turno ativo carregado em memória
/// 2. **Sincronização**: Carrega turno do banco quando necessário
/// 3. **Navegação**: Determina para onde ir baseado no estado do turno
/// 4. **Acesso Rápido**: Fornece getters para informações do turno
///
/// ## ⚠️ Importante:
///
/// Este controller **NÃO implementa** as ações de abrir/fechar turno.
/// Ele apenas **lê o estado** do banco.
///
/// **Implementações reais**:
/// - Abrir turno: `AbrirTurnoController` (lib/presentation/turno/abrir/)
/// - Enviar para API: `AbrindoTurnoController` (lib/presentation/turno/abrindo/)
/// - Fechar turno: `TurnoServicosController` (lib/presentation/turno/servicos/)
///
/// ## Uso:
///
/// ```dart
/// final turnoController = Get.find<TurnoController>();
/// if (turnoController.hasTurnoAberto) {
///   // Lógica quando há turno aberto
/// }
/// ```
class TurnoController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  late final TurnoRepo _turnoRepo;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Turno ativo atual (se houver).
  final Rxn<TurnoTableDto> turnoAtivo = Rxn<TurnoTableDto>();

  /// Lista de eletricistas do turno atual.
  final RxList<EletricistaTableDto> eletricistas = <EletricistaTableDto>[].obs;

  /// Flag indicando se está carregando.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Verifica se há turno aberto.
  bool get hasTurnoAberto =>
      turnoAtivo.value?.situacaoTurno == SituacaoTurno.aberto;

  /// Verifica se há turno em abertura.
  bool get hasTurnoEmAbertura =>
      turnoAtivo.value?.situacaoTurno == SituacaoTurno.emAbertura;

  /// Verifica se há turno fechado.
  bool get hasTurnoFechado =>
      turnoAtivo.value?.situacaoTurno == SituacaoTurno.fechado;

  /// Verifica se há algum turno (qualquer situação).
  bool get hasTurno => turnoAtivo.value != null;

  /// Retorna o turno atual (se houver).
  TurnoTableDto? get turno => turnoAtivo.value;

  /// Retorna a lista de eletricistas do turno.
  List<EletricistaTableDto> get eletricistasDoTurno => eletricistas;

  /// Retorna os nomes dos eletricistas como string.
  String get nomesEletricistas => eletricistas.map((e) => e.nome).join(', ');

  /// Retorna a placa do veículo do turno.
  String? get placaVeiculo => turno?.veiculoId.toString();

  /// Retorna o prefixo do turno.
  String? get prefixoTurno => 'A-${turno?.id}';

  // ============================================================================
  // INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _turnoRepo = Get.find<TurnoRepo>();
    AppLogger.i('TurnoController inicializado', tag: 'TurnoController');
    carregarTurnoAtivo();
  }

  /// Carrega turno ativo do banco local.
  ///
  /// SEMPRE busca do banco para garantir dados atualizados.
  Future<void> carregarTurnoAtivo() async {
    try {
      isLoading.value = true;
      AppLogger.d('🔄 Carregando turno ativo do banco...',
          tag: 'TurnoController');

      // SEMPRE busca do banco - não confia na memória
      final turnoAtivoDb = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivoDb != null) {
        // Carrega eletricistas do turno
        await _carregarEletricistasDoTurno(turnoAtivoDb.id);

        // Usa diretamente o TurnoTableDto
        turnoAtivo.value = turnoAtivoDb;

        AppLogger.i(
            '✅ Turno carregado do banco: ${turnoAtivoDb.id} (${turnoAtivoDb.situacaoTurno.name})',
            tag: 'TurnoController');
      } else {
        // Limpa tudo - não há turno ativo
        _limparEstado();
        AppLogger.i('ℹ️ Nenhum turno ativo encontrado no banco',
            tag: 'TurnoController');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao carregar turno do banco',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      _limparEstado();
    } finally {
      isLoading.value = false;
    }
  }

  /// Limpa todo o estado do controller.
  void _limparEstado() {
    turnoAtivo.value = null;
    eletricistas.clear();
  }

  /// Carrega eletricistas do turno atual.
  Future<void> _carregarEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('🔄 Carregando eletricistas do turno: $turnoId',
          tag: 'TurnoController');

      // Busca relacionamentos turno-eletricista
      final relacionamentos =
          await _turnoRepo.buscarEletricistasDoTurno(turnoId);

      if (relacionamentos.isNotEmpty) {
        // Buscar dados completos dos eletricistas
        // Por enquanto, limpa a lista
        eletricistas.clear();

        AppLogger.i('✅ ${relacionamentos.length} relacionamentos encontrados',
            tag: 'TurnoController');
      } else {
        eletricistas.clear();
        AppLogger.i('ℹ️ Nenhum eletricista encontrado para o turno',
            tag: 'TurnoController');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao carregar eletricistas do turno',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      eletricistas.clear();
    }
  }

  // ============================================================================
  // NAVEGAÇÃO E FLUXO
  // ============================================================================

  /// Determina para onde navegar baseado no estado do turno.
  ///
  /// Retorna a rota de destino:
  /// - null: Nenhum turno (vai para abertura)
  /// - '/checklists': Turno em abertura (vai para checklists)
  /// - '/servicos': Turno aberto (vai para serviços)
  String? determinarProximaRota() {
    if (!hasTurno) {
      AppLogger.d('Nenhum turno encontrado - redirecionando para abertura',
          tag: 'TurnoController');
      return null; // Vai para tela de abertura
    }

    if (hasTurnoEmAbertura) {
      AppLogger.d('Turno em abertura - redirecionando para checklists',
          tag: 'TurnoController');
      return Routes.turnoChecklist;
    }

    if (hasTurnoAberto) {
      AppLogger.d('Turno aberto - redirecionando para serviços',
          tag: 'TurnoController');
      return Routes.turnoServicos;
    }

    if (hasTurnoFechado) {
      AppLogger.d('Turno fechado - redirecionando para abertura',
          tag: 'TurnoController');
      return null; // Vai para tela de abertura
    }

    AppLogger.w(
        'Estado de turno não reconhecido - redirecionando para abertura',
        tag: 'TurnoController');
    return null;
  }

  /// Navega para a tela apropriada baseada no estado do turno.
  Future<void> navegarParaTelaApropriada() async {
    final rota = determinarProximaRota();

    if (rota == null) {
      // Vai para tela de abertura de turno
      AppLogger.d('Navegando para tela de abertura de turno',
          tag: 'TurnoController');
      // Utiliza a rota nomeada centralizada para manter consistência e
      // facilitar futuras alterações de caminho sem afetar chamadas diretas.
      Get.toNamed(Routes.turnoAbrir);
    } else {
      // Vai para a rota específica
      AppLogger.d('Navegando para: $rota', tag: 'TurnoController');
      Get.toNamed(rota);
    }
  }

  /// Obtém informações resumidas do turno para exibição.
  Map<String, dynamic> obterInfoTurno() {
    final turno = turnoAtivo.value;

    if (turno == null) {
      return {
        'temTurno': false,
        'situacao': 'Nenhum turno',
        'mensagem': 'Nenhum turno ativo',
      };
    }

    final situacao = turno.situacaoTurno.name;

    String mensagem;
    switch (turno.situacaoTurno) {
      case SituacaoTurno.emAbertura:
        mensagem = 'Turno em abertura - Aguardando checklists';
        break;
      case SituacaoTurno.aberto:
        mensagem = 'Turno ativo - ${eletricistas.length} eletricistas';
        break;
      case SituacaoTurno.fechado:
        mensagem = 'Turno finalizado';
        break;
    }

    return {
      'temTurno': true,
      'situacao': situacao,
      'mensagem': mensagem,
      'turnoId': turno.id,
      'horaInicio': turno.horaInicio,
      'horaFim': turno.horaFim,
      'eletricistas': eletricistas.map((e) => e.nome).toList(),
    };
  }

  // ============================================================================
  // AÇÕES DE ATUALIZAÇÃO
  // ============================================================================

  /// Atualiza dados do turno.
  Future<void> atualizar() async {
    AppLogger.d('Atualizando turno...', tag: 'TurnoController');
    await carregarTurnoAtivo();
  }

  /// Força recarregamento completo dos dados.
  Future<void> recarregar() async {
    AppLogger.d('🔄 Recarregando dados do turno...', tag: 'TurnoController');
    await carregarTurnoAtivo();
  }

  /// Método chamado pelo pull-to-refresh da home.
  ///
  /// SEMPRE recarrega do banco para garantir dados atualizados.
  Future<void> atualizarAposSync() async {
    AppLogger.d('🔄 Atualizando turno após sincronização...',
        tag: 'TurnoController');

    try {
      // Força recarregamento do banco
      await carregarTurnoAtivo();

      AppLogger.i('✅ Turno atualizado após sincronização',
          tag: 'TurnoController');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao atualizar turno após sincronização',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Limpeza do controlador.
  ///
  /// **NOTA IMPORTANTE**: Este controller é **permanent**, portanto este método
  /// raramente será chamado (apenas quando o app for completamente fechado).
  /// No entanto, mantemos a limpeza adequada para casos edge e boa prática.
  ///
  /// ## Recursos Liberados:
  /// - Estados reativos (turnoAtivo, eletricistas, servicos, isLoading)
  /// - Qualquer listener ou subscription ativa
  /// - Limpeza de referências para facilitar garbage collection
  ///
  /// ## Comportamento:
  /// - Não afeta a lógica do turno durante uso normal
  /// - Apenas limpa memória quando controller é realmente destruído
  @override
  void onClose() {
    /// Limpa listas observáveis para liberar memória.
    eletricistas.clear();

    /// Reseta estados reativos.
    turnoAtivo.value = null;
    isLoading.value = false;

    /// Registra finalização do controlador.
    AppLogger.d(
        'TurnoController finalizado e recursos liberados (permanent controller)',
        tag: 'TurnoController');

    super.onClose();
  }
}
