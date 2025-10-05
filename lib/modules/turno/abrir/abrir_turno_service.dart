import 'package:get/get.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço responsável por buscar dados necessários para abertura de turno.
///
/// Centraliza a lógica de busca de veículos, eletricistas e equipes,
/// fornecendo uma interface limpa para o controller de abertura de turno.
///
/// ## Funcionalidades:
/// - Busca veículos disponíveis
/// - Busca eletricistas disponíveis
/// - Busca equipes disponíveis
/// - Tratamento de erros centralizado
/// - Logs detalhados para debugging
class AbrirTurnoService extends GetxService {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Repositório de veículos.
  final VeiculoRepo _veiculoRepo = Get.find<VeiculoRepo>();

  /// Repositório de eletricistas.
  final EletricistaRepo _eletricistaRepo = Get.find<EletricistaRepo>();

  /// Repositório de equipes.
  final EquipeRepo _equipeRepo = Get.find<EquipeRepo>();

  // ============================================================================
  // MÉTODOS PÚBLICOS
  // ============================================================================

  /// Busca veículos disponíveis para abertura de turno.
  ///
  /// ## Retorno:
  /// - `Future<List<VeiculoTableDto>>`: Lista de veículos disponíveis
  ///
  /// ## Exceções:
  /// - Propaga erros dos repositórios com logs detalhados
  Future<List<VeiculoTableDto>> buscarVeiculos() async {
    try {
      AppLogger.d('Buscando veículos para abertura de turno',
          tag: 'AbrirTurnoService');

      final veiculos = await _veiculoRepo.listar();

      AppLogger.d('${veiculos.length} veículos encontrados',
          tag: 'AbrirTurnoService');
      return veiculos;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar veículos',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca eletricistas disponíveis para abertura de turno.
  ///
  /// ## Retorno:
  /// - `Future<List<EletricistaTableDto>>`: Lista de eletricistas disponíveis
  ///
  /// ## Exceções:
  /// - Propaga erros dos repositórios com logs detalhados
  Future<List<EletricistaTableDto>> buscarEletricistas() async {
    try {
      AppLogger.d('Buscando eletricistas para abertura de turno',
          tag: 'AbrirTurnoService');

      final eletricistas = await _eletricistaRepo.listar();

      AppLogger.d('${eletricistas.length} eletricistas encontrados',
          tag: 'AbrirTurnoService');
      return eletricistas;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar eletricistas',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca equipes disponíveis para abertura de turno.
  ///
  /// ## Retorno:
  /// - `Future<List<EquipeTableDto>>`: Lista de equipes disponíveis
  ///
  /// ## Exceções:
  /// - Propaga erros dos repositórios com logs detalhados
  Future<List<EquipeTableDto>> buscarEquipes() async {
    try {
      AppLogger.d('Buscando equipes para abertura de turno',
          tag: 'AbrirTurnoService');

      final equipes = await _equipeRepo.listar();

      AppLogger.d('${equipes.length} equipes encontradas',
          tag: 'AbrirTurnoService');
      return equipes;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar equipes',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca todos os dados necessários para abertura de turno.
  ///
  /// Método de conveniência que busca veículos, eletricistas e equipes
  /// em uma única operação, útil para carregamento inicial da tela.
  ///
  /// ## Retorno:
  /// - `Future<Map<String, dynamic>>`: Mapa com todos os dados
  ///
  /// ## Estrutura do Retorno:
  /// ```dart
  /// {
  ///   'veiculos': List<VeiculoTableDto>,
  ///   'eletricistas': List<EletricistaTableDto>,
  ///   'equipes': List<EquipeTableDto>,
  /// }
  /// ```
  Future<Map<String, dynamic>> buscarTodosDados() async {
    try {
      AppLogger.d('Buscando todos os dados para abertura de turno',
          tag: 'AbrirTurnoService');

      final futures = await Future.wait([
        buscarVeiculos(),
        buscarEletricistas(),
        buscarEquipes(),
      ]);

      final resultado = {
        'veiculos': futures[0] as List<VeiculoTableDto>,
        'eletricistas': futures[1] as List<EletricistaTableDto>,
        'equipes': futures[2] as List<EquipeTableDto>,
      };

      AppLogger.d('Todos os dados carregados com sucesso',
          tag: 'AbrirTurnoService');
      return resultado;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar todos os dados',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
