import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistOpcaoRespostaRelacao.
class ChecklistOpcaoRespostaRelacaoTableDto {
  final int id;
  final int? remoteId;
  final int checklistOpcaoRespostaId;
  final int checklistModeloId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistOpcaoRespostaRelacaoTableDto({
    required this.id,
    this.remoteId,
    required this.checklistOpcaoRespostaId,
    required this.checklistModeloId,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistOpcaoRespostaRelacaoTableDto.fromTable(ChecklistOpcaoRespostaRelacaoTableData data) {
    return ChecklistOpcaoRespostaRelacaoTableDto(
      id: data.id,
      remoteId: data.remoteId,
      checklistOpcaoRespostaId: data.checklistOpcaoRespostaId,
      checklistModeloId: data.checklistModeloId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistOpcaoRespostaRelacaoTableCompanion toCompanion() {
    return ChecklistOpcaoRespostaRelacaoTableCompanion(
      id: id == 0 ? const Value.absent() : Value(id), // Autoincrement se for 0
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      checklistOpcaoRespostaId: Value(checklistOpcaoRespostaId),
      checklistModeloId: Value(checklistModeloId),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistOpcaoRespostaRelacaoTableDto copyWith({
    int? id,
    int? remoteId,
    int? checklistOpcaoRespostaId,
    int? checklistModeloId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistOpcaoRespostaRelacaoTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      checklistOpcaoRespostaId: checklistOpcaoRespostaId ?? this.checklistOpcaoRespostaId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistOpcaoRespostaRelacaoTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.checklistOpcaoRespostaId == checklistOpcaoRespostaId &&
        other.checklistModeloId == checklistModeloId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      checklistOpcaoRespostaId,
      checklistModeloId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistOpcaoRespostaRelacaoTableDto(id: $id, remoteId: $remoteId, checklistOpcaoRespostaId: $checklistOpcaoRespostaId, checklistModeloId: $checklistModeloId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
