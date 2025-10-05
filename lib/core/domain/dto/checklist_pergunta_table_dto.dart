import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistPergunta.
class ChecklistPerguntaTableDto {
  final int id;
  final int? remoteId;
  final String nome;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistPerguntaTableDto({
    required this.id,
    this.remoteId,
    required this.nome,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistPerguntaTableDto.fromTable(ChecklistPerguntaTableData data) {
    return ChecklistPerguntaTableDto(
      id: data.id,
      remoteId: data.remoteId,
      nome: data.nome,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistPerguntaTableCompanion toCompanion() {
    return ChecklistPerguntaTableCompanion(
      id: Value(id),
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      nome: Value(nome),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistPerguntaTableDto copyWith({
    int? id,
    int? remoteId,
    String? nome,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistPerguntaTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistPerguntaTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.nome == nome &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      nome,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistPerguntaTableDto(id: $id, remoteId: $remoteId, nome: $nome, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
