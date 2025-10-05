import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/widgets/custom_searcheable_dropdown.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_service.dart';

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

  /// Controlador do dropdown de prefixos.
  late final SearchableDropdownController<String> prefixoDropdownController;

  /// Controlador do dropdown de equipes.
  late final SearchableDropdownController<EquipeTableDto>
      equipeDropdownController;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se está salvando.
  final RxBool isLoading = false.obs;

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

  /// Valida seleção de prefixo.
  String? validatePrefixo() {
    if (prefixoDropdownController.selected.value == null) {
      return 'Prefixo é obrigatório';
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
  String? validateKmInicial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'KM inicial é obrigatório';
    }

    final km = int.tryParse(value.trim());
    if (km == null) {
      return 'KM deve ser um número válido';
    }

    if (km < 0) {
      return 'KM não pode ser negativo';
    }

    if (km > 999999) {
      return 'KM muito alto (máximo 999.999)';
    }

    return null;
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

    try {
      isLoading.value = true;
      AppLogger.i('Abrindo novo turno...', tag: 'AbrirTurnoController');

      final veiculoSelecionado = veiculoDropdownController.selected.value!;
      final prefixoSelecionado = prefixoDropdownController.selected.value!;
      // Nota: equipe selecionada é validada mas não enviada para o TurnoController
      // pois o método abrirTurno não aceita esse parâmetro ainda

      final sucesso = await _turnoController.abrirTurno(
        prefixo: prefixoSelecionado,
        veiculo:
            'Veículo ${veiculoSelecionado.placa}', // Usando placa como identificador
        placa: veiculoSelecionado.placa,
      );

      if (sucesso) {
        AppLogger.i('Turno aberto com sucesso', tag: 'AbrirTurnoController');
        
        Get.back(); // Volta para home
        
        Get.snackbar(
          'Sucesso',
          'Turno aberto com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
        );
      } else {
        Get.snackbar(
          'Erro',
          'Erro ao abrir turno. Tente novamente.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.errorContainer,
        );
      }
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

    prefixoDropdownController = SearchableDropdownController<String>(
      initialItems: _getPrefixosIniciais(),
      itemLabel: (prefixo) => prefixo,
    );

    equipeDropdownController = SearchableDropdownController<EquipeTableDto>(
      itemLabel: (equipe) => equipe.nome,
      remoteSearch: _buscarEquipes,
    );

    // Carrega dados iniciais
    _carregarDadosIniciais();
    
    AppLogger.d('AbrirTurnoController inicializado',
        tag: 'AbrirTurnoController');
  }

  @override
  void onClose() {
    prefixoController.dispose();
    kmInicialController.dispose();
    AppLogger.d('AbrirTurnoController finalizado',
        tag: 'AbrirTurnoController');
    super.onClose();
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Lista de prefixos disponíveis.
  List<String> _getPrefixosIniciais() {
    return [
      'A-001',
      'A-002',
      'A-003',
      'B-001',
      'B-002',
      'B-003',
      'C-001',
      'C-002',
      'C-003',
      'D-001',
      'D-002',
      'D-003',
    ];
  }

  /// Carrega dados iniciais usando o serviço.
  Future<void> _carregarDadosIniciais() async {
    try {
      // Carrega veículos
      final veiculos = await _abrirTurnoService.buscarVeiculos();
      veiculoDropdownController.setItems(veiculos);

      // Carrega equipes
      final equipes = await _abrirTurnoService.buscarEquipes();
      equipeDropdownController.setItems(equipes);

      AppLogger.d(
          'Dados iniciais carregados: ${veiculos.length} veículos, ${equipes.length} equipes',
          tag: 'AbrirTurnoController');
    } catch (e) {
      AppLogger.e('Erro ao carregar dados iniciais', 
          tag: 'AbrirTurnoController', error: e);
    }
  }

  /// Busca veículos remotamente.
  Future<List<VeiculoTableDto>> _buscarVeiculos(String query) async {
    try {
      if (query.isEmpty) {
        return veiculoDropdownController.items;
      }
      
      final veiculos = await _abrirTurnoService.buscarVeiculos();
      final veiculoDtos = veiculos
          .where((v) => v.placa.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      return veiculoDtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar veículos', 
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }

  /// Busca equipes remotamente.
  Future<List<EquipeTableDto>> _buscarEquipes(String query) async {
    try {
      if (query.isEmpty) {
        return equipeDropdownController.items;
      }

      final equipes = await _abrirTurnoService.buscarEquipes();
      final equipeDtos = equipes
          .where((e) => e.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return equipeDtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar equipes',
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }
}

