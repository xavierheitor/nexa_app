import 'package:get/get.dart';
import 'package:nexa_app/core/domain/models/turno_model.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Controlador global responsável pelo gerenciamento de turnos.
///
/// Este controlador fica disponível durante todo o ciclo de vida da aplicação,
/// gerenciando o estado do turno ativo e fornecendo acesso a informações
/// do turno para qualquer parte da aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Gerenciamento de Turno**: Controla turno aberto/fechado
/// 2. **Estado Global**: Acessível de qualquer parte da aplicação
/// 3. **Persistência**: Salva e carrega turno do banco local
/// 4. **Validações**: Verifica se pode abrir/fechar turno
/// 5. **Serviços**: Gerencia serviços executados no turno
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
  final Rxn<TurnoModel> turnoAtivo = Rxn<TurnoModel>();

  /// Dados completos do turno atual (incluindo eletricistas).
  final Rxn<TurnoTableDto> turnoCompleto = Rxn<TurnoTableDto>();

  /// Lista de eletricistas do turno atual.
  final RxList<EletricistaTableDto> eletricistas = <EletricistaTableDto>[].obs;

  /// Lista de serviços executados no turno atual.
  final RxList<ServicoModel> servicos = <ServicoModel>[].obs;

  /// Flag indicando se está carregando.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Verifica se há turno aberto.
  bool get hasTurnoAberto =>
      turnoCompleto.value?.situacaoTurno == SituacaoTurno.aberto;

  /// Verifica se há turno em abertura.
  bool get hasTurnoEmAbertura =>
      turnoCompleto.value?.situacaoTurno == SituacaoTurno.emAbertura;

  /// Verifica se há turno fechado.
  bool get hasTurnoFechado =>
      turnoCompleto.value?.situacaoTurno == SituacaoTurno.fechado;

  /// Verifica se há algum turno (qualquer situação).
  bool get hasTurno => turnoCompleto.value != null;

  /// Retorna o turno atual (se houver).
  TurnoModel? get turno => turnoAtivo.value;

  /// Retorna os dados completos do turno.
  TurnoTableDto? get turnoCompletoData => turnoCompleto.value;

  /// Retorna a lista de eletricistas do turno.
  List<EletricistaTableDto> get eletricistasDoTurno => eletricistas;

  /// Retorna os nomes dos eletricistas como string.
  String get nomesEletricistas => eletricistas.map((e) => e.nome).join(', ');

  /// Retorna a placa do veículo do turno.
  String? get placaVeiculo => turno?.placa;

  /// Retorna o prefixo do turno.
  String? get prefixoTurno => turno?.prefixo;

  // ============================================================================
  // INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _turnoRepo = Get.find<TurnoRepo>();
    AppLogger.i('TurnoController inicializado', tag: 'TurnoController');
    _carregarTurnoAtivo();
  }

  /// Carrega turno ativo do banco local.
  ///
  /// SEMPRE busca do banco para garantir dados atualizados.
  Future<void> _carregarTurnoAtivo() async {
    try {
      isLoading.value = true;
      AppLogger.d('🔄 Carregando turno ativo do banco...',
          tag: 'TurnoController');

      // SEMPRE busca do banco - não confia na memória
      final turnoAtivoDb = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivoDb != null) {
        turnoCompleto.value = turnoAtivoDb;

        // Carrega eletricistas do turno
        await _carregarEletricistasDoTurno(turnoAtivoDb.id);

        // Converte para TurnoModel unificado
        turnoAtivo.value = await _converterParaTurnoModelCompleto(turnoAtivoDb);

        if (hasTurnoAberto) {
          await _carregarServicos();
        }

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
    turnoCompleto.value = null;
    turnoAtivo.value = null;
    eletricistas.clear();
    servicos.clear();
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
        // TODO: Buscar dados completos dos eletricistas
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

  /// Carrega serviços do turno atual.
  Future<void> _carregarServicos() async {
    try {
      AppLogger.d('Carregando serviços do turno...', tag: 'TurnoController');

      // TODO: Buscar serviços reais do banco/API
      await Future.delayed(const Duration(milliseconds: 300));

      // Simula alguns serviços (remover quando integrar com API)
      servicos.value = [
        ServicoModel(
          id: '1',
          descricao: 'Coleta de lixo - Rua Principal',
          horario: DateTime.now().subtract(const Duration(hours: 1)),
          tipo: TipoServico.coleta,
        ),
        ServicoModel(
          id: '2',
          descricao: 'Limpeza de calçada - Praça Central',
          horario: DateTime.now().subtract(const Duration(minutes: 30)),
          tipo: TipoServico.limpeza,
        ),
      ];

      AppLogger.i('${servicos.length} serviços carregados',
          tag: 'TurnoController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar serviços',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      servicos.clear();
    }
  }

  /// Converte TurnoTableDto para TurnoModel com dados completos.
  Future<TurnoModel> _converterParaTurnoModelCompleto(
      TurnoTableDto turnoDto) async {
    // TODO: Buscar dados reais do veículo e prefixo
    final prefixo = 'A-${turnoDto.id}';
    final veiculo = 'Veículo ${turnoDto.veiculoId}';
    final placa = 'PLACA-${turnoDto.veiculoId}';

    return TurnoModel(
      id: turnoDto.id.toString(),
      prefixo: prefixo,
      veiculo: veiculo,
      placa: placa,
      horaInicio: turnoDto.horaInicio,
      horaFim: turnoDto.horaFim,
      status: _converterSituacaoParaStatus(turnoDto.situacaoTurno),
    );
  }

  /// Converte TurnoTableDto para TurnoModel (compatibilidade).
  TurnoModel _converterParaTurnoModel(TurnoTableDto turnoDto) {
    return TurnoModel(
      id: turnoDto.id.toString(),
      prefixo: 'A-${turnoDto.id}', // TODO: Buscar prefixo real
      veiculo:
          'Veículo ${turnoDto.veiculoId}', // TODO: Buscar nome real do veículo
      placa: 'PLACA-${turnoDto.veiculoId}', // TODO: Buscar placa real
      horaInicio: turnoDto.horaInicio,
      horaFim: turnoDto.horaFim,
      status: _converterSituacaoParaStatus(turnoDto.situacaoTurno),
    );
  }

  /// Converte SituacaoTurno para StatusTurno.
  StatusTurno _converterSituacaoParaStatus(SituacaoTurno situacao) {
    switch (situacao) {
      case SituacaoTurno.aberto:
        return StatusTurno.aberto;
      case SituacaoTurno.fechado:
        return StatusTurno.fechado;
      case SituacaoTurno.emAbertura:
        return StatusTurno.aberto; // Considera em abertura como aberto
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
      return '/checklists';
    }

    if (hasTurnoAberto) {
      AppLogger.d('Turno aberto - redirecionando para serviços',
          tag: 'TurnoController');
      return '/servicos';
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
      Get.toNamed('/abrir-turno');
    } else {
      // Vai para a rota específica
      AppLogger.d('Navegando para: $rota', tag: 'TurnoController');
      Get.toNamed(rota);
    }
  }

  /// Obtém informações resumidas do turno para exibição.
  Map<String, dynamic> obterInfoTurno() {
    if (!hasTurno) {
      return {
        'temTurno': false,
        'situacao': 'Nenhum turno',
        'mensagem': 'Nenhum turno ativo',
      };
    }

    final turno = turnoCompletoData!;
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
  // AÇÕES DE TURNO
  // ============================================================================

  /// Abre um novo turno.
  Future<bool> abrirTurno({
    required String prefixo,
    required String veiculo,
    required String placa,
  }) async {
    try {
      if (hasTurnoAberto) {
        AppLogger.w('Já existe um turno aberto', tag: 'TurnoController');
        return false;
      }

      isLoading.value = true;
      AppLogger.i('Abrindo novo turno: $prefixo', tag: 'TurnoController');

      // TODO: Salvar turno no banco/API
      await Future.delayed(const Duration(seconds: 1));

      turnoAtivo.value = TurnoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        prefixo: prefixo,
        veiculo: veiculo,
        placa: placa,
        horaInicio: DateTime.now(),
        status: StatusTurno.aberto,
      );

      servicos.clear();

      AppLogger.i('Turno aberto com sucesso', tag: 'TurnoController');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao abrir turno',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fecha o turno atual.
  Future<bool> fecharTurno() async {
    try {
      if (!hasTurnoAberto) {
        AppLogger.w('Não há turno aberto para fechar', tag: 'TurnoController');
        return false;
      }

      isLoading.value = true;
      AppLogger.i('Fechando turno: ${turno?.prefixo}', tag: 'TurnoController');

      // TODO: Atualizar turno no banco/API
      await Future.delayed(const Duration(seconds: 1));

      turnoAtivo.value = turno?.copyWith(
        horaFim: DateTime.now(),
        status: StatusTurno.fechado,
      );

      AppLogger.i('Turno fechado com sucesso', tag: 'TurnoController');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fechar turno',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // AÇÕES DE SERVIÇOS
  // ============================================================================

  /// Adiciona um novo serviço ao turno.
  Future<bool> adicionarServico({
    required String descricao,
    required TipoServico tipo,
  }) async {
    try {
      if (!hasTurnoAberto) {
        AppLogger.w('Não há turno aberto', tag: 'TurnoController');
        return false;
      }

      isLoading.value = true;
      AppLogger.i('Adicionando serviço: $descricao', tag: 'TurnoController');

      // TODO: Salvar serviço no banco/API
      await Future.delayed(const Duration(milliseconds: 500));

      final novoServico = ServicoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descricao: descricao,
        horario: DateTime.now(),
        tipo: tipo,
      );

      servicos.add(novoServico);

      AppLogger.i('Serviço adicionado com sucesso', tag: 'TurnoController');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar serviço',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove um serviço do turno.
  Future<bool> removerServico(String servicoId) async {
    try {
      isLoading.value = true;
      AppLogger.i('Removendo serviço: $servicoId', tag: 'TurnoController');

      // TODO: Remover serviço do banco/API
      await Future.delayed(const Duration(milliseconds: 300));

      servicos.removeWhere((s) => s.id == servicoId);

      AppLogger.i('Serviço removido com sucesso', tag: 'TurnoController');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover serviço',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Atualiza dados do turno e serviços.
  Future<void> atualizar() async {
    AppLogger.d('Atualizando turno...', tag: 'TurnoController');
    await _carregarTurnoAtivo();
  }

  /// Força recarregamento completo dos dados.
  Future<void> recarregar() async {
    AppLogger.d('🔄 Recarregando dados do turno...', tag: 'TurnoController');
    await _carregarTurnoAtivo();
  }

  /// Método chamado pelo pull-to-refresh da home.
  ///
  /// SEMPRE recarrega do banco para garantir dados atualizados.
  Future<void> atualizarAposSync() async {
    AppLogger.d('🔄 Atualizando turno após sincronização...',
        tag: 'TurnoController');

    try {
      // Força recarregamento do banco
      await _carregarTurnoAtivo();

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

  @override
  void onClose() {
    AppLogger.d('TurnoController finalizado', tag: 'TurnoController');
    super.onClose();
  }
}

// ============================================================================
// MODELO DE SERVIÇO
// ============================================================================

/// Modelo para representação de um serviço executado no turno.
class ServicoModel {
  final String id;
  final String descricao;
  final DateTime horario;
  final TipoServico tipo;

  ServicoModel({
    required this.id,
    required this.descricao,
    required this.horario,
    required this.tipo,
  });
}

/// Tipos de serviços disponíveis.
enum TipoServico {
  coleta,
  limpeza,
  manutencao,
  outro,
}

/// Extensão para obter nome legível do tipo de serviço.
extension TipoServicoExtension on TipoServico {
  String get nome {
    switch (this) {
      case TipoServico.coleta:
        return 'Coleta';
      case TipoServico.limpeza:
        return 'Limpeza';
      case TipoServico.manutencao:
        return 'Manutenção';
      case TipoServico.outro:
        return 'Outro';
    }
  }
}
