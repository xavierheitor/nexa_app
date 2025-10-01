import 'package:get/get.dart';
import 'package:nexa_app/core/domain/models/turno_model.dart';
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
  // ESTADO REATIVO
  // ============================================================================

  /// Turno ativo atual (se houver).
  final Rxn<TurnoModel> turnoAtivo = Rxn<TurnoModel>();

  /// Lista de serviços executados no turno atual.
  final RxList<ServicoModel> servicos = <ServicoModel>[].obs;

  /// Flag indicando se está carregando.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Verifica se há turno aberto.
  bool get hasTurnoAberto => turnoAtivo.value?.estaAberto ?? false;

  /// Verifica se há turno fechado.
  bool get hasTurnoFechado => turnoAtivo.value?.estaFechado ?? false;

  /// Retorna o turno atual (se houver).
  TurnoModel? get turno => turnoAtivo.value;

  // ============================================================================
  // INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('TurnoController inicializado', tag: 'TurnoController');
    _carregarTurnoAtivo();
  }

  /// Carrega turno ativo do banco local.
  Future<void> _carregarTurnoAtivo() async {
    try {
      isLoading.value = true;
      AppLogger.d('Carregando turno ativo...', tag: 'TurnoController');

      // TODO: Buscar turno real do banco/API
      await Future.delayed(const Duration(milliseconds: 500));

      // Simula turno aberto (remover quando integrar com API)
      turnoAtivo.value = TurnoModel(
        id: '1',
        prefixo: 'A-123',
        veiculo: 'Volkswagen Gol',
        placa: 'ABC-1234',
        horaInicio: DateTime.now().subtract(const Duration(hours: 2)),
        status: StatusTurno.aberto,
      );

      if (hasTurnoAberto) {
        await _carregarServicos();
      }

      AppLogger.i('Turno carregado: ${turnoAtivo.value?.prefixo ?? "Nenhum"}',
          tag: 'TurnoController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar turno',
          tag: 'TurnoController', error: e, stackTrace: stackTrace);
      turnoAtivo.value = null;
    } finally {
      isLoading.value = false;
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

