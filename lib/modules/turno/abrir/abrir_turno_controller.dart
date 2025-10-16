import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';
import 'package:nexa_app/widgets/custom_searcheable_dropdown.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_service.dart';
import 'package:nexa_app/modules/turno/abrir/models/abrir_turno_dados.dart';
import 'package:nexa_app/modules/turno/abrir/validators/turno_validator.dart';

/// Controlador da tela de abrir turno.
///
/// Gerencia o formulário e o processo de abertura de um novo turno,
/// validando dados e integrando com o TurnoController global.
class AbrirTurnoController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Controlador global de turno.
  final TurnoController _turnoController = Get.find<TurnoController>();

  /// Serviço para buscar dados de abertura de turno.
  final AbrirTurnoService _abrirTurnoService = Get.find<AbrirTurnoService>();

  /// Cache local com os dados carregados do serviço para evitar requisições
  /// repetidas ao digitar nas buscas dos dropdowns.
  AbrirTurnoDados? _dadosCarregados;

  /// Repositório de turno para operações de banco.
  final TurnoRepo _turnoRepo = Get.find<TurnoRepo>();

  // ============================================================================
  // CONTROLADORES DE FORMULÁRIO
  // ============================================================================

  /// Controlador do campo de prefixo.
  final prefixoController = TextEditingController();

  /// Controlador do campo de KM inicial.
  final kmInicialController = TextEditingController();

  /// Chave do formulário para validação.
  final formKey = GlobalKey<FormState>();

  // ============================================================================
  // CONTROLADORES DE DROPDOWN
  // ============================================================================

  /// Controlador do dropdown de veículos.
  late final SearchableDropdownController<VeiculoTableDto>
      veiculoDropdownController;


  /// Controlador do dropdown de equipes.
  late final SearchableDropdownController<EquipeTableDto>
      equipeDropdownController;

  /// Controlador do dropdown de eletricistas.
  late final SearchableDropdownController<EletricistaTableDto>
      eletricistaDropdownController;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se está salvando.
  final RxBool isLoading = false.obs;

  /// Lista de eletricistas selecionados.
  final RxList<EletricistaSelecionado> eletricistasSelecionados =
      <EletricistaSelecionado>[].obs;

  // ============================================================================
  // VALIDAÇÕES
  // ============================================================================

  /// Valida seleção de veículo.
  String? validateVeiculo() {
    if (veiculoDropdownController.selected.value == null) {
      return 'Veículo é obrigatório';
    }
    return null;
  }


  /// Valida seleção de equipe.
  String? validateEquipe() {
    if (equipeDropdownController.selected.value == null) {
      return 'Equipe é obrigatória';
    }
    return null;
  }

  /// Valida campo de KM inicial.
  String? validateKmInicial(String? value) =>
      TurnoValidator.validateKmInicial(value);

  /// Valida lista de eletricistas.
  String? validateEletricistas() =>
      TurnoValidator.validateEletricistas(eletricistasSelecionados);

  /// Adiciona eletricista à lista.
  void adicionarEletricista(EletricistaTableDto eletricista) {
    // Verifica se já não está na lista
    final jaExiste = eletricistasSelecionados.any(
      (e) => e.eletricista.id == eletricista.id,
    );

    if (!jaExiste) {
      eletricistasSelecionados.add(
        EletricistaSelecionado(eletricista: eletricista),
      );
      AppLogger.d('Eletricista adicionado: ${eletricista.nome}',
          tag: 'AbrirTurnoController');
    }
  }

  /// Remove eletricista da lista.
  void removerEletricista(String eletricistaId) {
    eletricistasSelecionados.removeWhere(
      (e) => e.eletricista.id == eletricistaId,
    );
    AppLogger.d('Eletricista removido: $eletricistaId',
        tag: 'AbrirTurnoController');
  }

  /// Alterna status de motorista de um eletricista.
  void alternarMotorista(String eletricistaId) {
    final index = eletricistasSelecionados.indexWhere(
      (e) => e.eletricista.id == eletricistaId,
    );

    if (index != -1) {
      final eletricista = eletricistasSelecionados[index];

      // Se está marcando como motorista, desmarca os outros
      if (!eletricista.isMotorista) {
        for (int i = 0; i < eletricistasSelecionados.length; i++) {
          eletricistasSelecionados[i] = eletricistasSelecionados[i].copyWith(
            isMotorista: false,
          );
        }
      }

      // Alterna o status do eletricista selecionado
      eletricistasSelecionados[index] = eletricista.copyWith(
        isMotorista: !eletricista.isMotorista,
      );

      AppLogger.d('Motorista alternado: ${eletricista.eletricista.nome}',
          tag: 'AbrirTurnoController');
    }
  }

  // ============================================================================
  // AÇÕES
  // ============================================================================

  /// Abre um novo turno.
  Future<void> abrirTurno() async {
    // Valida formulário
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Valida eletricistas (incluindo motorista obrigatório)
    final erroEletricistas = validateEletricistas();
    if (erroEletricistas != null) {
      AppLogger.w('Erro na validação de eletricistas: $erroEletricistas',
          tag: 'AbrirTurnoController');
      Get.snackbar(
        'Validação',
        erroEletricistas,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    try {
      isLoading.value = true;
      AppLogger.i('Abrindo novo turno...', tag: 'AbrirTurnoController');

      final veiculoSelecionado = veiculoDropdownController.selected.value!;
      final equipeSelecionada = equipeDropdownController.selected.value!;
      final kmInicial = int.tryParse(kmInicialController.text) ?? 0;

      // Prepara lista de IDs dos eletricistas
      // CORREÇÃO: Usar remoteId para eletricistas também
      final eletricistaIds = eletricistasSelecionados
          .map((e) => int.parse(e.eletricista.remoteId))
          .toList();

      // Encontra o motorista (eletricista com isMotorista = true)
      final motoristaSelecionado =
          eletricistasSelecionados.where((e) => e.isMotorista).firstOrNull;

      final motoristaId = motoristaSelecionado != null
          ? int.parse(motoristaSelecionado.eletricista.remoteId)
          : null;

      AppLogger.d('Dados do turno:', tag: 'AbrirTurnoController');
      AppLogger.d(
          '- Veículo: ${veiculoSelecionado.placa} (ID local: ${veiculoSelecionado.id}, RemoteID: ${veiculoSelecionado.remoteId})',
          tag: 'AbrirTurnoController');
      AppLogger.d(
          '- Equipe: ${equipeSelecionada.nome} (ID local: ${equipeSelecionada.id}, RemoteID: ${equipeSelecionada.remoteId})',
          tag: 'AbrirTurnoController');
      AppLogger.d('- KM Inicial: $kmInicial', tag: 'AbrirTurnoController');
      AppLogger.d('- Eletricistas: ${eletricistaIds.length}',
          tag: 'AbrirTurnoController');
      AppLogger.d(
          '- Motorista: ${motoristaId != null ? 'ID $motoristaId' : 'Nenhum'}',
          tag: 'AbrirTurnoController');

      // CORREÇÃO: Usar ID local para veículo e equipe no turno
      final veiculoId = int.parse(veiculoSelecionado.id);
      final equipeId = int.parse(equipeSelecionada.id);

      AppLogger.d(
          '🔧 [CORREÇÃO] Usando IDs locais: veiculo=$veiculoId, equipe=$equipeId',
          tag: 'AbrirTurnoController');

      // Abre o turno usando TurnoRepo
      final turnoId = await _turnoRepo.abrirTurno(
        veiculoId: veiculoId,
        equipeId: equipeId,
        kmInicial: kmInicial,
        eletricistaIds: eletricistaIds,
        motoristaId: motoristaId,
      );

      AppLogger.i('Turno $turnoId aberto com sucesso',
          tag: 'AbrirTurnoController');

      // Atualiza o TurnoController global
      await _turnoController.carregarTurnoAtivo();

      // Fecha a tela de abertura
      Get.back();

      // Navega diretamente para o checklist
      Get.toNamed(Routes.turnoChecklist);

      Get.snackbar(
        'Sucesso',
        'Turno aberto com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao abrir turno',
          tag: 'AbrirTurnoController', error: e, stackTrace: stackTrace);

      Get.snackbar(
        'Erro',
        'Erro inesperado ao abrir turno.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onInit() {
    super.onInit();

    // Inicializa controladores dos dropdowns
    veiculoDropdownController = SearchableDropdownController<VeiculoTableDto>(
      itemLabel: (veiculo) => veiculo.placa,
      remoteSearch: _buscarVeiculos,
    );


    equipeDropdownController = SearchableDropdownController<EquipeTableDto>(
      itemLabel: (equipe) => equipe.nome,
      remoteSearch: _buscarEquipes,
    );

    eletricistaDropdownController =
        SearchableDropdownController<EletricistaTableDto>(
      itemLabel: (eletricista) =>
          '${eletricista.matricula} - ${eletricista.nome}',
      remoteSearch: _buscarEletricistas,
    );

    // Carrega dados iniciais
    _carregarDadosIniciais();

    AppLogger.d('AbrirTurnoController inicializado',
        tag: 'AbrirTurnoController');
  }

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - TextEditingControllers (prefixo, kmInicial)
  /// - SearchableDropdownControllers (veículo, equipe, eletricista)
  /// - Listas observáveis (eletricistasSelecionados)
  /// - Estados reativos (isLoading)
  /// - Cache de dados (_dadosCarregados)
  @override
  void onClose() {
    /// Dispose de TextEditingControllers.
    prefixoController.dispose();
    kmInicialController.dispose();

    /// Dispose de SearchableDropdownControllers.
    veiculoDropdownController.dispose();
    equipeDropdownController.dispose();
    eletricistaDropdownController.dispose();

    /// Limpa listas observáveis.
    eletricistasSelecionados.clear();

    /// Reseta estados reativos.
    isLoading.value = false;

    /// Limpa cache de dados.
    _dadosCarregados = null;

    /// Registra finalização do controlador.
    AppLogger.d('AbrirTurnoController finalizado e recursos liberados',
        tag: 'AbrirTurnoController');

    super.onClose();
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================


  /// Carrega dados iniciais usando o serviço e reaproveita o resultado em cache.
  Future<void> _carregarDadosIniciais() async {
    try {
      final dados = await _obterDadosCarregados(forceRefresh: true);

      AppLogger.d(
        'Dados iniciais carregados: '
        '${dados.veiculos.length} veículos, '
        '${dados.equipes.length} equipes, '
        '${dados.eletricistas.length} eletricistas',
        tag: 'AbrirTurnoController',
      );
    } catch (e) {
      AppLogger.e('Erro ao carregar dados iniciais',
          tag: 'AbrirTurnoController', error: e);
    }
  }

  /// Busca veículos remotamente utilizando os dados já carregados em cache.
  Future<List<VeiculoTableDto>> _buscarVeiculos(String query) async {
    try {
      final veiculos = (await _obterDadosCarregados()).veiculos;

      if (query.isEmpty) {
        return veiculos;
      }

      final filtro = query.toLowerCase();
      return veiculos
          .where((v) => v.placa.toLowerCase().contains(filtro))
          .toList();
    } catch (e) {
      AppLogger.e('Erro ao buscar veículos',
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }

  /// Busca equipes remotamente reutilizando os dados carregados.
  Future<List<EquipeTableDto>> _buscarEquipes(String query) async {
    try {
      final equipes = (await _obterDadosCarregados()).equipes;

      if (query.isEmpty) {
        return equipes;
      }

      final filtro = query.toLowerCase();
      return equipes
          .where((e) => e.nome.toLowerCase().contains(filtro))
          .toList();
    } catch (e) {
      AppLogger.e('Erro ao buscar equipes',
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }

  /// Busca eletricistas remotamente utilizando os dados em cache.
  Future<List<EletricistaTableDto>> _buscarEletricistas(String query) async {
    try {
      final eletricistas = (await _obterDadosCarregados()).eletricistas;

      if (query.isEmpty) {
        return eletricistas;
      }

      final filtro = query.toLowerCase();
      return eletricistas
          .where((e) =>
              e.nome.toLowerCase().contains(filtro) ||
              e.matricula.toLowerCase().contains(filtro))
          .toList();
    } catch (e) {
      AppLogger.e('Erro ao buscar eletricistas',
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }

  /// Busca os dados previamente carregados ou realiza uma nova busca se
  /// necessário, atualizando os dropdowns ao mesmo tempo.
  Future<AbrirTurnoDados> _obterDadosCarregados({bool forceRefresh = false}) async {
    if (!forceRefresh && _dadosCarregados != null) {
      return _dadosCarregados!;
    }

    final dados = await _abrirTurnoService.buscarDadosIniciais(
      forceRefresh: forceRefresh,
    );
    _dadosCarregados = dados;

    if (veiculoDropdownController.items.isEmpty || forceRefresh) {
      veiculoDropdownController.setItems(dados.veiculos);
    }
    if (equipeDropdownController.items.isEmpty || forceRefresh) {
      equipeDropdownController.setItems(dados.equipes);
    }
    if (eletricistaDropdownController.items.isEmpty || forceRefresh) {
      eletricistaDropdownController.setItems(dados.eletricistas);
    }

    return dados;
  }
}

