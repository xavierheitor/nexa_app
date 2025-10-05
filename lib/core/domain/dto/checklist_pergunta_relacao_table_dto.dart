import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistPerguntaRelacao.
class ChecklistPerguntaRelacaoTableDto {
  final int id;
  final int? remoteId;
  final int checklistModeloId;
  final int checklistPerguntaId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistPerguntaRelacaoTableDto({
    required this.id,
    this.remoteId,
    required this.checklistModeloId,
    required this.checklistPerguntaId,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistPerguntaRelacaoTableDto.fromTable(ChecklistPerguntaRelacaoTableData data) {
    return ChecklistPerguntaRelacaoTableDto(
      id: data.id,
      remoteId: data.remoteId,
      checklistModeloId: data.checklistModeloId,
      checklistPerguntaId: data.checklistPerguntaId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistPerguntaRelacaoTableCompanion toCompanion() {
    return ChecklistPerguntaRelacaoTableCompanion(
      id: Value(id),
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      checklistModeloId: Value(checklistModeloId),
      checklistPerguntaId: Value(checklistPerguntaId),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistPerguntaRelacaoTableDto copyWith({
    int? id,
    int? remoteId,
    int? checklistModeloId,
    int? checklistPerguntaId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistPerguntaRelacaoTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      checklistPerguntaId: checklistPerguntaId ?? this.checklistPerguntaId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistPerguntaRelacaoTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.checklistModeloId == checklistModeloId &&
        other.checklistPerguntaId == checklistPerguntaId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      checklistModeloId,
      checklistPerguntaId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistPerguntaRelacaoTableDto(id: $id, remoteId: $remoteId, checklistModeloId: $checklistModeloId, checklistPerguntaId: $checklistPerguntaId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
