import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/widgets/custom_searcheable_dropdown.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';

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

  /// Instância do banco de dados.
  final AppDatabase _db = Get.find<AppDatabase>();

  // ============================================================================
  // CONTROLADORES DE FORMULÁRIO
  // ============================================================================

  /// Controlador do campo de prefixo.
  final prefixoController = TextEditingController();

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

    // Carrega veículos iniciais
    _carregarVeiculosIniciais();
    
    AppLogger.d('AbrirTurnoController inicializado',
        tag: 'AbrirTurnoController');
  }

  @override
  void onClose() {
    prefixoController.dispose();
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

  /// Carrega veículos iniciais do banco local.
  Future<void> _carregarVeiculosIniciais() async {
    try {
      final veiculos = await _db.veiculoDao.listar();
      final veiculoDtos =
          veiculos.map((v) => VeiculoTableDto.fromEntity(v)).toList();
      veiculoDropdownController.setItems(veiculoDtos);
    } catch (e) {
      AppLogger.e('Erro ao carregar veículos iniciais',
          tag: 'AbrirTurnoController', error: e);
    }
  }

  /// Busca veículos remotamente.
  Future<List<VeiculoTableDto>> _buscarVeiculos(String query) async {
    try {
      if (query.isEmpty) {
        return veiculoDropdownController.items;
      }

      final veiculos = await _db.veiculoDao.listar();
      final veiculoDtos = veiculos
          .map((v) => VeiculoTableDto.fromEntity(v))
          .where((v) => v.placa.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return veiculoDtos;
    } catch (e) {
      AppLogger.e('Erro ao buscar veículos',
          tag: 'AbrirTurnoController', error: e);
      return [];
    }
  }
}

