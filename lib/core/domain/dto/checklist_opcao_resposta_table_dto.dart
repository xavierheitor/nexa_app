import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela ChecklistOpcaoResposta.
class ChecklistOpcaoRespostaTableDto {
  final int id;
  final int? remoteId;
  final String nome;
  final bool geraPendencia;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChecklistOpcaoRespostaTableDto({
    required this.id,
    this.remoteId,
    required this.nome,
    required this.geraPendencia,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um DTO a partir de uma linha da tabela.
  factory ChecklistOpcaoRespostaTableDto.fromTable(ChecklistOpcaoRespostaTableData data) {
    return ChecklistOpcaoRespostaTableDto(
      id: data.id,
      remoteId: data.remoteId,
      nome: data.nome,
      geraPendencia: data.geraPendencia,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte para Companion (para inserção/atualização).
  ChecklistOpcaoRespostaTableCompanion toCompanion() {
    return ChecklistOpcaoRespostaTableCompanion(
      id: Value(id),
      remoteId: remoteId != null ? Value(remoteId!) : const Value.absent(),
      nome: Value(nome),
      geraPendencia: Value(geraPendencia),
      createdAt: createdAt != null ? Value(createdAt!) : const Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : const Value.absent(),
    );
  }

  /// Cria uma cópia com campos alterados.
  ChecklistOpcaoRespostaTableDto copyWith({
    int? id,
    int? remoteId,
    String? nome,
    bool? geraPendencia,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistOpcaoRespostaTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      geraPendencia: geraPendencia ?? this.geraPendencia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChecklistOpcaoRespostaTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.nome == nome &&
        other.geraPendencia == geraPendencia &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      remoteId,
      nome,
      geraPendencia,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChecklistOpcaoRespostaTableDto(id: $id, remoteId: $remoteId, nome: $nome, geraPendencia: $geraPendencia, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
