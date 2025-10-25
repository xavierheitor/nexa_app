import 'package:nexa_app/core/constants/api_constants.dart';

/// Enum para representar os tipos de checklist.
enum ChecklistTipo {
  veicular,
  epc,
  epi,
}

/// Extensão para adicionar métodos utilitários ao enum.
extension ChecklistTipoExtension on ChecklistTipo {
  /// Converte um ID de tipo para o enum correspondente.
  static ChecklistTipo fromId(int tipoId) {
    switch (tipoId) {
      case ApiConstants.tipoChecklistVeicularId:
        return ChecklistTipo.veicular;
      case ApiConstants.tipoChecklistEpcId:
        return ChecklistTipo.epc;
      case ApiConstants.tipoChecklistEpiId:
        return ChecklistTipo.epi;
      default:
        return ChecklistTipo.veicular;
    }
  }

  /// Retorna o ID correspondente ao tipo.
  int get id {
    switch (this) {
      case ChecklistTipo.veicular:
        return 1;
      case ChecklistTipo.epc:
        return 2;
      case ChecklistTipo.epi:
        return 3;
    }
  }
}
