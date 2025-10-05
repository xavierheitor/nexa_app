import 'package:get/get.dart';
import 'package:nexa_app/core/domain/dto/checklist_modelo_table_dto.dart';
import 'package:nexa_app/core/domain/dto/veiculo_table_dto.dart';
import 'package:nexa_app/core/domain/models/checklist_model.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Service responsável por buscar e montar checklists completos.
class ChecklistService extends GetxService {
  /// Repositório responsável pelos modelos de checklist persistidos localmente.
  final ChecklistModeloRepo _checklistModeloRepo;

  /// Repositório que expõe as perguntas vinculadas a um modelo de checklist.
  final ChecklistPerguntaRepo _checklistPerguntaRepo;

  /// Repositório que recupera as opções de resposta disponíveis por modelo.
  final ChecklistOpcaoRespostaRepo _checklistOpcaoRespostaRepo;

  /// Repositório que oferece operações de consulta para os turnos abertos.
  final TurnoRepo _turnoRepo;

  /// Repositório que disponibiliza informações detalhadas dos veículos.
  final VeiculoRepo _veiculoRepo;

  /// Repositório responsável pelos dados das equipes vinculadas ao turno.
  final EquipeRepo _equipeRepo;

  /// Repositório para persistir checklists preenchidos.
  final ChecklistPreenchidoRepo _checklistPreenchidoRepo;

  /// Repositório para persistir respostas individuais.
  final ChecklistRespostaRepo _checklistRespostaRepo;

  // IDs remotos padrão dos modelos de checklist enquanto o vínculo por tipo de
  // equipe não é configurado dinamicamente.
  // ignore: unused_field
  static const int _fallbackChecklistEpiRemoteId = 2;
  static const int _fallbackChecklistEpcRemoteId = 3;

  /// Construtor com injeção explícita de dependências utilizadas pelo serviço.
  ///
  /// A adoção da injeção por construtor facilita testes unitários (permitindo
  /// substituir os repositórios por fakes/mocks) e deixa explícito quais
  /// camadas de dados o serviço consome para montar o checklist completo.
  ChecklistService({
    required ChecklistModeloRepo checklistModeloRepo,
    required ChecklistPerguntaRepo checklistPerguntaRepo,
    required ChecklistOpcaoRespostaRepo checklistOpcaoRespostaRepo,
    required TurnoRepo turnoRepo,
    required VeiculoRepo veiculoRepo,
    required EquipeRepo equipeRepo,
    required ChecklistPreenchidoRepo checklistPreenchidoRepo,
    required ChecklistRespostaRepo checklistRespostaRepo,
  })  : _checklistModeloRepo = checklistModeloRepo,
        _checklistPerguntaRepo = checklistPerguntaRepo,
        _checklistOpcaoRespostaRepo = checklistOpcaoRespostaRepo,
        _turnoRepo = turnoRepo,
        _veiculoRepo = veiculoRepo,
        _equipeRepo = equipeRepo,
        _checklistPreenchidoRepo = checklistPreenchidoRepo,
        _checklistRespostaRepo = checklistRespostaRepo;

  /// Busca o checklist completo para um tipo de veículo específico.
  ///
  /// Retorna o checklist com todas as perguntas e opções de resposta.
  Future<ChecklistCompletoModel?> buscarChecklistPorTipoVeiculo(
      int tipoVeiculoId) async {
    try {
      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Iniciando busca de checklist para tipoVeiculoId: $tipoVeiculoId',
          tag: 'ChecklistService');

      final modelos =
          await _checklistModeloRepo.buscarPorTipoVeiculo(tipoVeiculoId);

      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Resultado da busca: ${modelos.length} modelos encontrados',
          tag: 'ChecklistService');

      if (modelos.isNotEmpty) {
        for (int i = 0; i < modelos.length; i++) {
          final modelo = modelos[i];
          AppLogger.d(
              '🔍 [DIAGNÓSTICO] Modelo $i: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
              tag: 'ChecklistService');
        }
      }

      if (modelos.isEmpty) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Nenhum checklist encontrado para tipo de veículo $tipoVeiculoId',
            tag: 'ChecklistService');
        return null;
      }

      return await _montarChecklistCompleto(modelos.first);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca o checklist completo para um tipo de equipe específico.
  Future<ChecklistCompletoModel?> buscarChecklistPorTipoEquipe(
      int tipoEquipeId) async {
    try {
      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Iniciando busca de checklist para tipoEquipeId: $tipoEquipeId',
          tag: 'ChecklistService');

      final modelos =
          await _checklistModeloRepo.buscarPorTipoEquipe(tipoEquipeId);

      AppLogger.d(
          '🔍 [DIAGNÓSTICO] Resultado da busca: ${modelos.length} modelos encontrados',
          tag: 'ChecklistService');

      if (modelos.isNotEmpty) {
        for (int i = 0; i < modelos.length; i++) {
          final modelo = modelos[i];
          AppLogger.d(
              '🔍 [DIAGNÓSTICO] Modelo $i: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
              tag: 'ChecklistService');
        }
      }

      if (modelos.isEmpty) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Nenhum checklist encontrado para tipo de equipe $tipoEquipeId',
            tag: 'ChecklistService');
        return null;
      }

      return await _montarChecklistCompleto(modelos.first);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist por tipo de equipe',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca o checklist EPI aplicado individualmente por eletricista.
  Future<ChecklistCompletoModel?> buscarChecklistEPIParaEletricista(
      int eletricistaRemoteId) async {
    AppLogger.d(
      '🔍 Carregando checklist EPI para eletricista remoto $eletricistaRemoteId',
      tag: 'ChecklistService',
    );

    final checklist =
        await _buscarChecklistPorRemoteId(_fallbackChecklistEpiRemoteId);

    if (checklist == null) {
      AppLogger.w(
        '⚠️ Checklist EPI (remoteId=$_fallbackChecklistEpiRemoteId) não encontrado',
        tag: 'ChecklistService',
      );
    }

    return checklist;
  }

  int get checklistEpiModeloRemoteId => _fallbackChecklistEpiRemoteId;

  Future<ChecklistCompletoModel?> _montarChecklistCompleto(
      ChecklistModeloTableDto modelo) async {
    if (modelo.remoteId == null) {
      AppLogger.w(
          '⚠️ [DIAGNÓSTICO] Checklist ${modelo.nome} não possui remoteId para buscar relacionamentos',
          tag: 'ChecklistService');
      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modelo.remoteId ?? modelo.id,
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: const [],
      );
    }

    AppLogger.i('✅ Checklist encontrado: ${modelo.nome}',
        tag: 'ChecklistService');

    final perguntas =
        await _checklistPerguntaRepo.buscarPorModelo(modelo.remoteId!);

    if (perguntas.isEmpty) {
      AppLogger.w('⚠️ Nenhuma pergunta encontrada para o checklist',
          tag: 'ChecklistService');
      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modelo.remoteId!,
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: const [],
      );
    }

    AppLogger.d('📋 ${perguntas.length} perguntas encontradas',
        tag: 'ChecklistService');

    final opcoes =
        await _checklistOpcaoRespostaRepo.buscarPorModelo(modelo.remoteId!);

    final opcoesModel = opcoes.map((opcao) {
      if (opcao.remoteId == null) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Opção ${opcao.nome} sem remoteId vinculada ao checklist ${modelo.nome}',
            tag: 'ChecklistService');
      }
      return ChecklistOpcaoRespostaModel(
        id: opcao.id,
        remoteId: opcao.remoteId ?? opcao.id,
        nome: opcao.nome,
        geraPendencia: opcao.geraPendencia,
      );
    }).toList();

    final perguntasCompletas = perguntas.map((pergunta) {
      if (pergunta.remoteId == null) {
        AppLogger.w(
            '⚠️ [DIAGNÓSTICO] Pergunta ${pergunta.nome} não possui remoteId; mantendo opções, mas sem associação remota',
            tag: 'ChecklistService');
      }

      AppLogger.d(
        '✅ [VALIDAÇÃO] Pergunta ${pergunta.nome} recebeu ${opcoesModel.length} opções convertidas',
        tag: 'ChecklistService',
      );

      return ChecklistPerguntaModel(
        id: pergunta.id,
        remoteId: pergunta.remoteId ?? pergunta.id,
        nome: pergunta.nome,
        opcoes: opcoesModel,
      );
    }).toList();

    AppLogger.i('✅ Checklist completo montado com sucesso',
        tag: 'ChecklistService');

    return ChecklistCompletoModel(
      id: modelo.id,
      remoteId: modelo.remoteId!,
      nome: modelo.nome,
      tipoChecklistId: modelo.tipoChecklistId,
      perguntas: perguntasCompletas,
    );
  }

  Future<ChecklistCompletoModel?> _buscarChecklistPorRemoteId(
      int remoteId) async {
    try {
      AppLogger.d('🔄 [FALLBACK] Buscando checklist por remoteId: $remoteId',
          tag: 'ChecklistService');
      final modelo = await _checklistModeloRepo.buscarPorRemoteId(remoteId);

      if (modelo == null) {
        AppLogger.w('⚠️ Nenhum checklist encontrado para remoteId $remoteId',
            tag: 'ChecklistService');
        return null;
      }

      return await _montarChecklistCompleto(modelo);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist por remoteId $remoteId',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Persiste o checklist preenchido e suas respostas no banco local.
  Future<bool> salvarChecklistPreenchido({
    required ChecklistCompletoModel checklist,
    required List<ChecklistPerguntaModel> perguntasRespondidas,
    double? latitude,
    double? longitude,
    int? eletricistaRemoteId,
  }) async {
    AppLogger.d(
        '💾 Salvando checklist preenchido (remoteId=${checklist.remoteId})',
        tag: 'ChecklistService');

    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado para salvar checklist',
            tag: 'ChecklistService');
        return false;
      }

      final checklistPreenchidoId =
          await _checklistPreenchidoRepo.salvarChecklistCompleto(
        turnoId: turnoAtivo.id,
        checklistModeloId: checklist.remoteId,
        respostas: const [],
        latitude: latitude,
        longitude: longitude,
        eletricistaRemoteId: eletricistaRemoteId,
      );

      AppLogger.d(
        '✅ Checklist preenchido salvo com ID local: $checklistPreenchidoId',
        tag: 'ChecklistService',
      );

      final respostas = <Map<String, dynamic>>[];

      for (final pergunta in perguntasRespondidas) {
        final respostaSelecionada = pergunta.respostaSelecionada;
        if (respostaSelecionada == null) {
          continue;
        }

        ChecklistOpcaoRespostaModel? opcaoSelecionada;
        for (final opcao in pergunta.opcoes) {
          if (opcao.id == respostaSelecionada) {
            opcaoSelecionada = opcao;
            break;
          }
        }

        final opcaoRemoteId = opcaoSelecionada?.remoteId ?? respostaSelecionada;

        respostas.add({
          'perguntaId': pergunta.remoteId,
          'opcaoRespostaId': opcaoRemoteId,
        });
      }

      if (respostas.isNotEmpty) {
        await _checklistRespostaRepo.salvarRespostas(
          checklistPreenchidoId: checklistPreenchidoId,
          respostas: respostas,
        );
        AppLogger.d(
          '✅ ${respostas.length} respostas persistidas para checklist $checklistPreenchidoId',
          tag: 'ChecklistService',
        );
      }

      AppLogger.i('✅ Checklist preenchido registrado com sucesso',
          tag: 'ChecklistService');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao salvar checklist preenchido',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Verifica se um modelo de checklist já foi preenchido no turno atual.
  Future<bool> checklistJaPreenchido(int checklistModeloRemoteId,
      {int? eletricistaRemoteId}) async {
    AppLogger.d(
      '🔎 Verificando preenchimento prévio do checklist $checklistModeloRemoteId',
      tag: 'ChecklistService',
    );

    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado para validação',
            tag: 'ChecklistService');
        return false;
      }

      final preenchidos =
          await _checklistPreenchidoRepo.buscarPorTurno(turnoAtivo.id);

      final encontrado = preenchidos.any((item) {
        if (item.checklistModeloId != checklistModeloRemoteId) {
          return false;
        }

        if (eletricistaRemoteId == null) {
          return item.eletricistaRemoteId == null;
        }

        return item.eletricistaRemoteId == eletricistaRemoteId;
      });

      AppLogger.d(
        '📌 Checklist $checklistModeloRemoteId já preenchido: $encontrado',
        tag: 'ChecklistService',
      );

      return encontrado;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar checklist preenchido',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Busca o checklist para o turno ativo.
  ///
  /// Busca o veículo do turno e retorna o checklist correspondente.
  Future<ChecklistCompletoModel?> buscarChecklistDoTurnoAtivo() async {
    try {
      AppLogger.d('🔍 Buscando checklist do turno ativo',
          tag: 'ChecklistService');

      // 1. Buscar o turno ativo
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d('✅ Turno ativo encontrado: ID ${turnoAtivo.id}',
          tag: 'ChecklistService');

      // 2. Buscar o veículo do turno pelo remoteId (correção)
      VeiculoTableDto? veiculoDto;
      try {
        veiculoDto = await _veiculoRepo.buscarPorId(turnoAtivo.veiculoId);
      } catch (error, stackTrace) {
        AppLogger.e(
          '❌ Erro ao buscar veículo ${turnoAtivo.veiculoId} via VeiculoRepo',
          tag: 'ChecklistService',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final veiculo = veiculoDto;

      if (veiculo == null) {
        AppLogger.w(
            '⚠️ Veículo do turno não encontrado (ID: ${turnoAtivo.veiculoId})',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d(
          '✅ Veículo encontrado: ${veiculo.placa} (Tipo: ${veiculo.tipoVeiculoId})',
          tag: 'ChecklistService');

      // 3. Buscar checklist diretamente pelo tipoVeiculoId do veículo
      AppLogger.d(
          '🔍 [SIMPLIFICADO] Buscando checklist para tipoVeiculoId: ${veiculo.tipoVeiculoId}',
          tag: 'ChecklistService');

      return await buscarChecklistPorTipoVeiculo(veiculo.tipoVeiculoId);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist do turno ativo',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca o checklist EPC considerando o turno ativo.
  Future<ChecklistCompletoModel?> buscarChecklistEPCDoTurnoAtivo() async {
    try {
      AppLogger.d('🔍 Buscando checklist EPC do turno ativo',
          tag: 'ChecklistService');

      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();

      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado',
            tag: 'ChecklistService');
        return null;
      }

      AppLogger.d('✅ Turno ativo encontrado: ID ${turnoAtivo.id}',
          tag: 'ChecklistService');

      int? tipoEquipeId;

      try {
        final equipe =
            await _equipeRepo.buscarPorId(turnoAtivo.equipeId.toString());

        if (equipe != null) {
          tipoEquipeId = equipe.tipoEquipeId;
          AppLogger.d(
              '✅ Equipe vinculada ao turno: ${equipe.nome} (tipo=${equipe.tipoEquipeId})',
              tag: 'ChecklistService');
        } else {
          AppLogger.w(
              '⚠️ Equipe do turno não encontrada (ID: ${turnoAtivo.equipeId})',
              tag: 'ChecklistService');
        }
      } catch (error, stackTrace) {
        AppLogger.e(
          '❌ Erro ao buscar equipe ${turnoAtivo.equipeId} via EquipeRepo',
          tag: 'ChecklistService',
          error: error,
          stackTrace: stackTrace,
        );
      }

      ChecklistCompletoModel? checklist;

      if (tipoEquipeId != null) {
        checklist = await buscarChecklistPorTipoEquipe(tipoEquipeId);
      }

      if (checklist == null) {
        AppLogger.w(
          '⚠️ Checklist EPC não encontrado pelo tipo de equipe. Aplicando fallback remoto $_fallbackChecklistEpcRemoteId',
          tag: 'ChecklistService',
        );
        checklist =
            await _buscarChecklistPorRemoteId(_fallbackChecklistEpcRemoteId);
      }

      return checklist;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist EPC do turno ativo',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
