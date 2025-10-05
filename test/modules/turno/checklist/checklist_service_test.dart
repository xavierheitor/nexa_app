import 'package:flutter_test/flutter_test.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/domain/dto/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/checklist_pergunta_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';

/// Conjunto de testes para validar a montagem do checklist após a refatoração.
///
/// A estratégia utiliza fakes simples dos repositórios injetados para garantir
/// que o serviço continue combinando modelos, perguntas e opções sem acessar o
/// banco de dados diretamente. Também valida o fluxo que depende do turno ativo.
void main() {
  group('ChecklistService (com fakes)', () {
    late _ChecklistModeloRepoFake checklistModeloRepo;
    late _ChecklistPerguntaRepoFake checklistPerguntaRepo;
    late _ChecklistOpcaoRespostaRepoFake checklistOpcaoRespostaRepo;
    late _TurnoRepoFake turnoRepo;
    late _VeiculoRepoFake veiculoRepo;
    late ChecklistService service;

    setUp(() {
      checklistModeloRepo = _ChecklistModeloRepoFake();
      checklistPerguntaRepo = _ChecklistPerguntaRepoFake();
      checklistOpcaoRespostaRepo = _ChecklistOpcaoRespostaRepoFake();
      turnoRepo = _TurnoRepoFake();
      veiculoRepo = _VeiculoRepoFake();

      checklistModeloRepo.modelos = [
        const ChecklistModeloTableDto(
          id: 1,
          remoteId: 100,
          nome: 'Checklist Caminhão',
          tipoChecklistId: 10,
        ),
      ];

      checklistPerguntaRepo.perguntas = [
        const ChecklistPerguntaTableDto(
          id: 11,
          remoteId: 1100,
          nome: 'Verificar pneus',
        ),
      ];

      checklistOpcaoRespostaRepo.opcoes = [
        const ChecklistOpcaoRespostaTableDto(
          id: 21,
          remoteId: 2100,
          nome: 'Conforme',
          geraPendencia: false,
        ),
        const ChecklistOpcaoRespostaTableDto(
          id: 22,
          remoteId: 2200,
          nome: 'Não conforme',
          geraPendencia: true,
        ),
      ];

      turnoRepo.turnoAtivo = TurnoTableDto(
        id: 5,
        remoteId: 500,
        veiculoId: 30,
        equipeId: 99,
        kmInicial: 1234,
        horaInicio: DateTime(2024, 1, 1, 8, 0),
        situacaoTurno: SituacaoTurno.emAbertura,
      );

      final agora = DateTime(2024, 1, 1, 7, 0);
      veiculoRepo.veiculos[30] = VeiculoTableDto(
        id: '30',
        remoteId: 3000,
        placa: 'ABC1D23',
        tipoVeiculoId: 7,
        createdAt: agora,
        updatedAt: agora,
        sincronizado: true,
      );

      service = ChecklistService(
        checklistModeloRepo: checklistModeloRepo,
        checklistPerguntaRepo: checklistPerguntaRepo,
        checklistOpcaoRespostaRepo: checklistOpcaoRespostaRepo,
        turnoRepo: turnoRepo,
        veiculoRepo: veiculoRepo,
      );
    });

    test('monta checklist completo a partir do tipo de veículo', () async {
      final checklist = await service.buscarChecklistPorTipoVeiculo(7);

      expect(checklist, isNotNull);
      expect(checklist!.nome, 'Checklist Caminhão');
      expect(checklist.perguntas, hasLength(1));
      expect(checklist.perguntas.first.opcoes, hasLength(2));
      expect(checklist.perguntas.first.opcoes.first.nome, 'Conforme');
    });

    test('usa turno ativo para descobrir o checklist adequado', () async {
      final checklist = await service.buscarChecklistDoTurnoAtivo();

      expect(checklist, isNotNull);
      expect(turnoRepo.buscarTurnoAtivoChamadas, 1);
      expect(veiculoRepo.buscarPorIdChamadas, 1);
      expect(checklist!.tipoChecklistId, 10);
    });
  });
}

/// Fake simples para o ChecklistModeloRepo, retornando modelos pré-configurados.
class _ChecklistModeloRepoFake implements ChecklistModeloRepo {
  List<ChecklistModeloTableDto> modelos = const [];

  @override
  Future<List<ChecklistModeloTableDto>> buscarPorTipoVeiculo(
    int tipoVeiculoId,
  ) async => modelos;

  @override
  String get nomeEntidade => 'checklist-modelo-fake';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake que devolve perguntas previamente definidas.
class _ChecklistPerguntaRepoFake implements ChecklistPerguntaRepo {
  List<ChecklistPerguntaTableDto> perguntas = const [];

  @override
  Future<List<ChecklistPerguntaTableDto>> buscarPorModelo(int checklistModeloId) async => perguntas;

  @override
  String get nomeEntidade => 'checklist-pergunta-fake';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake que representa as opções de resposta relacionadas ao modelo.
class _ChecklistOpcaoRespostaRepoFake implements ChecklistOpcaoRespostaRepo {
  List<ChecklistOpcaoRespostaTableDto> opcoes = const [];

  @override
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorModelo(int checklistModeloId) async => opcoes;

  @override
  String get nomeEntidade => 'checklist-opcao-fake';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake minimalista do TurnoRepo, contabilizando chamadas para facilitar asserts.
class _TurnoRepoFake implements TurnoRepo {
  TurnoTableDto? turnoAtivo;
  int buscarTurnoAtivoChamadas = 0;

  @override
  Future<TurnoTableDto?> buscarTurnoAtivo() async {
    buscarTurnoAtivoChamadas++;
    return turnoAtivo;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Fake do VeiculoRepo que retorna veículos pré-carregados e registra as chamadas.
class _VeiculoRepoFake implements VeiculoRepo {
  final Map<int, VeiculoTableDto> veiculos = {};
  int buscarPorIdChamadas = 0;

  @override
  Future<VeiculoTableDto> buscarPorId(int id) async {
    buscarPorIdChamadas++;
    final veiculo = veiculos[id];
    if (veiculo == null) {
      throw Exception('Veículo $id não encontrado no fake');
    }
    return veiculo;
  }

  @override
  String get nomeEntidade => 'veiculo-fake';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
