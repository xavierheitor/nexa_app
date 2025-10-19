import 'package:nexa_app/data/models/eletricista_table_dto.dart';

/// Classe responsável por centralizar todas as validações relacionadas à abertura de turno.
///
/// Esta classe encapsula a lógica de validação, mantendo o controller limpo
/// e facilitando a manutenção e testes das regras de negócio.
///
/// ## Funcionalidades:
/// - Validação de KM inicial
/// - Validação de eletricistas selecionados
/// - Validação de motorista obrigatório
/// - Validação de quantidade mínima de eletricistas
class TurnoValidator {
  // ============================================================================
  // CONSTANTES DE VALIDAÇÃO
  // ============================================================================

  /// Quantidade mínima de eletricistas necessários.
  static const int minEletricistas = 2;

  /// KM mínimo permitido.
  static const int minKm = 0;

  /// KM máximo permitido.
  static const int maxKm = 999999;

  /// Tamanho mínimo da descrição de serviço.
  static const int minDescricaoLength = 5;

  // ============================================================================
  // VALIDAÇÕES DE KM
  // ============================================================================

  /// Valida campo de KM inicial.
  ///
  /// ## Parâmetros:
  /// - `value`: Valor do KM a ser validado
  ///
  /// ## Retorno:
  /// - `String?`: Mensagem de erro ou null se válido
  ///
  /// ## Regras de Validação:
  /// - Campo obrigatório
  /// - Deve ser um número válido
  /// - Não pode ser negativo
  /// - Máximo 999.999 km
  static String? validateKmInicial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'KM inicial é obrigatório';
    }

    final km = int.tryParse(value.trim());
    if (km == null) {
      return 'KM deve ser um número válido';
    }

    if (km < minKm) {
      return 'KM não pode ser negativo';
    }

    if (km > maxKm) {
      return 'KM muito alto (máximo $maxKm)';
    }

    return null;
  }

  // ============================================================================
  // VALIDAÇÕES DE ELETRICISTAS
  // ============================================================================

  /// Valida lista de eletricistas selecionados.
  ///
  /// ## Parâmetros:
  /// - `eletricistas`: Lista de eletricistas selecionados
  ///
  /// ## Retorno:
  /// - `String?`: Mensagem de erro ou null se válido
  ///
  /// ## Regras de Validação:
  /// - Mínimo de 2 eletricistas
  /// - Pelo menos 1 motorista obrigatório
  static String? validateEletricistas(
      List<EletricistaSelecionado> eletricistas) {
    if (eletricistas.isEmpty) {
      return 'Pelo menos $minEletricistas eletricistas são obrigatórios';
    }

    if (eletricistas.length < minEletricistas) {
      return 'Mínimo de $minEletricistas eletricistas necessários';
    }

    // Verifica se há pelo menos um motorista selecionado
    final temMotorista = eletricistas.any((e) => e.isMotorista);
    if (!temMotorista) {
      return 'É obrigatório marcar um motorista';
    }

    return null;
  }

  /// Valida se há motorista selecionado.
  ///
  /// ## Parâmetros:
  /// - `eletricistas`: Lista de eletricistas selecionados
  ///
  /// ## Retorno:
  /// - `bool`: true se há motorista, false caso contrário
  static bool temMotorista(List<EletricistaSelecionado> eletricistas) {
    return eletricistas.any((e) => e.isMotorista);
  }

  /// Conta quantos motoristas estão selecionados.
  ///
  /// ## Parâmetros:
  /// - `eletricistas`: Lista de eletricistas selecionados
  ///
  /// ## Retorno:
  /// - `int`: Quantidade de motoristas selecionados
  static int contarMotoristas(List<EletricistaSelecionado> eletricistas) {
    return eletricistas.where((e) => e.isMotorista).length;
  }

  // ============================================================================
  // VALIDAÇÕES DE SERVIÇOS
  // ============================================================================

  /// Valida descrição de serviço.
  ///
  /// ## Parâmetros:
  /// - `value`: Descrição a ser validada
  ///
  /// ## Retorno:
  /// - `String?`: Mensagem de erro ou null se válido
  ///
  /// ## Regras de Validação:
  /// - Campo obrigatório
  /// - Mínimo de 5 caracteres
  static String? validateDescricaoServico(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }

    if (value.trim().length < minDescricaoLength) {
      return 'Descrição deve ter pelo menos $minDescricaoLength caracteres';
    }

    return null;
  }

  // ============================================================================
  // VALIDAÇÕES COMPOSTAS
  // ============================================================================

  /// Valida se todos os dados necessários para abertura de turno estão presentes.
  ///
  /// ## Parâmetros:
  /// - `veiculoSelecionado`: Veículo selecionado
  /// - `equipeSelecionada`: Equipe selecionada
  /// - `kmInicial`: KM inicial
  /// - `eletricistas`: Lista de eletricistas
  ///
  /// ## Retorno:
  /// - `String?`: Primeira mensagem de erro encontrada ou null se tudo válido
  static String? validateDadosCompletosTurno({
    required dynamic veiculoSelecionado,
    required dynamic equipeSelecionada,
    required String kmInicial,
    required List<EletricistaSelecionado> eletricistas,
  }) {
    // Valida veículo
    if (veiculoSelecionado == null) {
      return 'Veículo é obrigatório';
    }

    // Valida equipe
    if (equipeSelecionada == null) {
      return 'Equipe é obrigatória';
    }

    // Valida KM inicial
    final erroKm = validateKmInicial(kmInicial);
    if (erroKm != null) {
      return erroKm;
    }

    // Valida eletricistas
    final erroEletricistas = validateEletricistas(eletricistas);
    if (erroEletricistas != null) {
      return erroEletricistas;
    }

    return null;
  }
}

/// Classe para representar um eletricista selecionado com suas propriedades.
class EletricistaSelecionado {
  final EletricistaTableDto eletricista;
  final bool isMotorista;

  EletricistaSelecionado({
    required this.eletricista,
    this.isMotorista = false,
  });

  EletricistaSelecionado copyWith({
    EletricistaTableDto? eletricista,
    bool? isMotorista,
  }) {
    return EletricistaSelecionado(
      eletricista: eletricista ?? this.eletricista,
      isMotorista: isMotorista ?? this.isMotorista,
    );
  }
}
