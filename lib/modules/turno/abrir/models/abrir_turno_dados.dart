import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/domain/dto/equipe_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';

/// Value object que concentra todos os dados necessários para abrir um turno.
///
/// O objetivo desta classe é evitar que camadas superiores manipulem mapas
/// dinâmicos sem tipo, facilitando a reutilização do pacote de dados carregado
/// pelo [AbrirTurnoService] e deixando explícitas as dependências de UI.
class AbrirTurnoDados {
  /// Conjunto de veículos disponíveis para seleção.
  final List<VeiculoTableDto> veiculos;

  /// Conjunto de eletricistas elegíveis para o turno.
  final List<EletricistaTableDto> eletricistas;

  /// Conjunto de equipes disponíveis.
  final List<EquipeTableDto> equipes;

  /// Cria um contêiner imutável com os dados necessários para abertura de turno.
  const AbrirTurnoDados({
    required this.veiculos,
    required this.eletricistas,
    required this.equipes,
  });

  /// Retorna uma nova instância com alguma das coleções atualizada.
  ///
  /// Mantemos cópias imutáveis para evitar efeitos colaterais entre camadas.
  AbrirTurnoDados copyWith({
    List<VeiculoTableDto>? veiculos,
    List<EletricistaTableDto>? eletricistas,
    List<EquipeTableDto>? equipes,
  }) {
    return AbrirTurnoDados(
      veiculos: veiculos ?? this.veiculos,
      eletricistas: eletricistas ?? this.eletricistas,
      equipes: equipes ?? this.equipes,
    );
  }
}
