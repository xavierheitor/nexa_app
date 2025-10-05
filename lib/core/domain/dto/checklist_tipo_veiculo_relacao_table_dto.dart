import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistTipoVeiculoRelacao.
class ChecklistTipoVeiculoRelacaoTableDto {
  final int id;
  final int? remoteId;
  final int checklistModeloId;
  final int tipoVeiculoId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistTipoVeiculoRelacaoTableDto({
    required this.id,
    this.remoteId,
    required this.checklistModeloId,
    required this.tipoVeiculoId,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistTipoVeiculoRelacaoTableDto.fromTable(ChecklistTipoVeiculoRelacaoTableData data) {
    return ChecklistTipoVeiculoRelacaoTableDto(
      id: data.id,
      remoteId: data.remoteId,
      checklistModeloId: data.checklistModeloId,
      tipoVeiculoId: data.tipoVeiculoId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistTipoVeiculoRelacaoTableCompanion toCompanion() {
    return ChecklistTipoVeiculoRelacaoTableCompanion(
      id: id == 0 ? const Value.absent() : Value(id), // Autoincrement se for 0
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      checklistModeloId: Value(checklistModeloId),
      tipoVeiculoId: Value(tipoVeiculoId),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistTipoVeiculoRelacaoTableDto copyWith({
    int? id,
    int? remoteId,
    int? checklistModeloId,
    int? tipoVeiculoId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistTipoVeiculoRelacaoTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      checklistModeloId: checklistModeloId ?? this.checklistModeloId,
      tipoVeiculoId: tipoVeiculoId ?? this.tipoVeiculoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistTipoVeiculoRelacaoTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.checklistModeloId == checklistModeloId &&
        other.tipoVeiculoId == tipoVeiculoId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      checklistModeloId,
      tipoVeiculoId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistTipoVeiculoRelacaoTableDto(id: $id, remoteId: $remoteId, checklistModeloId: $checklistModeloId, tipoVeiculoId: $tipoVeiculoId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
