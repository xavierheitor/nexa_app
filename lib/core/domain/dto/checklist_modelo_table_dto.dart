import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistModelo.
class ChecklistModeloTableDto {
  final int id;
  final int? remoteId;
  final String nome;
  final int tipoChecklistId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistModeloTableDto({
    required this.id,
    this.remoteId,
    required this.nome,
    required this.tipoChecklistId,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistModeloTableDto.fromTable(ChecklistModeloTableData data) {
    return ChecklistModeloTableDto(
      id: data.id,
      remoteId: data.remoteId,
      nome: data.nome,
      tipoChecklistId: data.tipoChecklistId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistModeloTableCompanion toCompanion() {
    return ChecklistModeloTableCompanion(
      id: Value(id),
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      nome: Value(nome),
      tipoChecklistId: Value(tipoChecklistId),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistModeloTableDto copyWith({
    int? id,
    int? remoteId,
    String? nome,
    int? tipoChecklistId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistModeloTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      tipoChecklistId: tipoChecklistId ?? this.tipoChecklistId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistModeloTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.nome == nome &&
        other.tipoChecklistId == tipoChecklistId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      nome,
      tipoChecklistId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistModeloTableDto(id: $id, remoteId: $remoteId, nome: $nome, tipoChecklistId: $tipoChecklistId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
