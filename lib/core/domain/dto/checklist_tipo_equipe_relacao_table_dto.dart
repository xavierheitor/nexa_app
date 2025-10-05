import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistTipoEquipeRelacao.
class ChecklistTipoEquipeRelacaoTableDto {
  final int id;
  final int? remoteId;
  final int checklistModeloId;
  final int tipoEquipeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistTipoEquipeRelacaoTableDto({
    required this.id,
    this.remoteId,
    required this.checklistModeloId,
    required this.tipoEquipeId,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistTipoEquipeRelacaoTableDto.fromTable(ChecklistTipoEquipeRelacaoTableData data) {
    return ChecklistTipoEquipeRelacaoTableDto(
      id: data.id,
      remoteId: data.remoteId,
      checklistModeloId: data.checklistModeloId,
      tipoEquipeId: data.tipoEquipeId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistTipoEquipeRelacaoTableCompanion toCompanion() {
    return ChecklistTipoEquipeRelacaoTableCompanion(
      id: Value(id),
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      checklistModeloId: Value(checklistModeloId),
      tipoEquipeId: Value(tipoEquipeId),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistTipoEquipeRelacaoTableDto copyWith({
    int? id,
    int? remoteId,
    int? checklistModeloId,
    int? tipoEquipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistTipoEquipeRelacaoTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      tipoEquipeId: tipoEquipeId ?? this.tipoEquipeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistTipoEquipeRelacaoTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.checklistModeloId == checklistModeloId &&
        other.tipoEquipeId == tipoEquipeId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      checklistModeloId,
      tipoEquipeId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistTipoEquipeRelacaoTableDto(id: $id, remoteId: $remoteId, checklistModeloId: $checklistModeloId, tipoEquipeId: $tipoEquipeId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
