import 'package:get/get.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/data/models/checklist_modelo_table_dto.dart';
import 'package:nexa_app/data/models/veiculo_table_dto.dart';
import 'package:nexa_app/domain/entities/checklist_model.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
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

  // CONFIGURAÇÃO DE IDs DE TIPO DE CHECKLIST
  // ============================================
  // Os IDs de tipo de checklist agora estão centralizados no ApiConstants
  // para permitir reutilização em outros services.
  // O sistema busca dinamicamente o modelo correto baseado no tipo de checklist + tipo de equipe.
  // Se não encontrar, usa fallback para o método antigo (tipo de veículo/equipe).

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

  /// Busca checklist por tipo de checklist e tipo de equipe.
  Future<ChecklistCompletoModel?> _buscarChecklistPorTipoChecklistETipoEquipe(
      int tipoChecklistId, int tipoEquipeId) async {
    try {
      AppLogger.d(
          '🔍 Buscando checklist para tipoChecklistId: $tipoChecklistId e tipoEquipeId: $tipoEquipeId',
          tag: 'ChecklistService');

      final modelos = await _checklistModeloRepo
          .buscarPorTipoChecklistETipoEquipe(tipoChecklistId, tipoEquipeId);

      AppLogger.d(
          '🔍 Resultado da busca: ${modelos.length} modelos encontrados',
          tag: 'ChecklistService');

      if (modelos.isEmpty) {
        AppLogger.w(
            '⚠️ Nenhum checklist encontrado para tipoChecklistId: $tipoChecklistId e tipoEquipeId: $tipoEquipeId',
            tag: 'ChecklistService');
        return null;
      }

      return await _montarChecklistCompleto(modelos.first);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist por tipo e equipe',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca o checklist EPI aplicado individualmente por eletricista.
  Future<ChecklistCompletoModel?> buscarChecklistEPIParaEletricista(
      int eletricistaRemoteId) async {
    AppLogger.d(
      '🔍 [CARREGAMENTO EPI] Iniciando carregamento para eletricista $eletricistaRemoteId',
      tag: 'ChecklistService',
    );

    // Primeiro tenta buscar pelo tipo de checklist EPI e tipo de equipe do turno ativo
    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo != null) {
        final equipe =
            await _equipeRepo.buscarPorId(turnoAtivo.equipeId.toString());
        if (equipe != null) {
          AppLogger.d(
              '🔍 [CARREGAMENTO EPI] Buscando modelo EPI para tipoEquipeId: ${equipe.tipoEquipeId}',
              tag: 'ChecklistService');

          final checklist = await _buscarChecklistPorTipoChecklistETipoEquipe(
              ApiConstants.tipoChecklistEpiId, equipe.tipoEquipeId);

          if (checklist != null) {
            AppLogger.d(
                '✅ Checklist EPI encontrado por tipo de equipe - Modelo: ${checklist.nome} (ID: ${checklist.remoteId}, Tipo: ${checklist.tipoChecklistId})',
                tag: 'ChecklistService');
            return checklist;
          } else {
            AppLogger.w(
                '❌ Nenhum modelo EPI encontrado para tipoEquipeId: ${equipe.tipoEquipeId}',
                tag: 'ChecklistService');
          }
        }
      }
    } catch (e, stackTrace) {
      AppLogger.e(
          '⚠️ Erro ao buscar checklist EPI por tipo de equipe, usando fallback',
          tag: 'ChecklistService',
          error: e,
          stackTrace: stackTrace);
    }

    // Se chegou até aqui, não foi possível encontrar o checklist EPI
    AppLogger.w(
        '⚠️ Checklist EPI não encontrado para tipo de checklist ${ApiConstants.tipoChecklistEpiId} e tipo de equipe do turno ativo',
        tag: 'ChecklistService');

    return null;
  }

  /// Retorna o ID do modelo de checklist EPI (não o tipo, mas o modelo específico)
  /// O modelo EPI tem ID 1, enquanto o tipo EPI tem ID 3
  int get checklistEpiModeloRemoteId => 1; // ID do modelo EPI específico

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

    // Validação segura de remoteId
    final modeloRemoteId = modelo.remoteId;
    if (modeloRemoteId == null) {
      AppLogger.e('❌ Modelo de checklist sem remoteId',
          tag: 'ChecklistService');
      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modelo.id, // Usa id local como fallback
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: const [],
      );
    }

    final perguntas =
        await _checklistPerguntaRepo.buscarPorModelo(modeloRemoteId);

    if (perguntas.isEmpty) {
      AppLogger.w('⚠️ Nenhuma pergunta encontrada para o checklist',
          tag: 'ChecklistService');
      return ChecklistCompletoModel(
        id: modelo.id,
        remoteId: modeloRemoteId,
        nome: modelo.nome,
        tipoChecklistId: modelo.tipoChecklistId,
        perguntas: const [],
      );
    }

    AppLogger.d('📋 ${perguntas.length} perguntas encontradas',
        tag: 'ChecklistService');

    final opcoes =
        await _checklistOpcaoRespostaRepo.buscarPorModelo(modeloRemoteId);

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
      remoteId: modeloRemoteId, // Já validado acima
      nome: modelo.nome,
      tipoChecklistId: modelo.tipoChecklistId,
      perguntas: perguntasCompletas,
    );
  }

  // ignore: unused_element
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

      // Remove respostas previamente associadas para evitar duplicidade.
      await _checklistRespostaRepo
          .removerPorChecklistPreenchido(checklistPreenchidoId);

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
      '🔎 Verificando preenchimento prévio do checklist modelo $checklistModeloRemoteId (eletricista: $eletricistaRemoteId)',
      tag: 'ChecklistService',
    );

    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo == null) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado para validação',
            tag: 'ChecklistService');
        return false;
      }

      AppLogger.d('🔍 [VERIFICAÇÃO] Turno ativo: ${turnoAtivo.id}',
          tag: 'ChecklistService');

      final preenchidos =
          await _checklistPreenchidoRepo.buscarPorTurno(turnoAtivo.id);

      AppLogger.d(
          '📋 [VERIFICAÇÃO] Total de checklists preenchidos: ${preenchidos.length}',
          tag: 'ChecklistService');

      for (final preenchido in preenchidos) {
        AppLogger.d(
            '  - Preenchido: id=${preenchido.id}, modeloId=${preenchido.checklistModeloId}, eletricistaId=${preenchido.eletricistaRemoteId}',
            tag: 'ChecklistService');
      }

      final encontrado = preenchidos.any((item) {
        AppLogger.d(
            '🔍 [VERIFICAÇÃO] Comparando: modeloId=${item.checklistModeloId} == $checklistModeloRemoteId, eletricistaId=${item.eletricistaRemoteId} == $eletricistaRemoteId',
            tag: 'ChecklistService');

        if (item.checklistModeloId != checklistModeloRemoteId) {
          AppLogger.d('  ❌ Modelo não confere', tag: 'ChecklistService');
          return false;
        }

        if (eletricistaRemoteId == null) {
          final match = item.eletricistaRemoteId == null;
          AppLogger.d('  🔍 Eletricista null - match: $match',
              tag: 'ChecklistService');
          return match;
        }

        final match = item.eletricistaRemoteId == eletricistaRemoteId;
        AppLogger.d('  🔍 Eletricista específico - match: $match',
            tag: 'ChecklistService');
        return match;
      });

      AppLogger.d(
        '📌 [VERIFICAÇÃO] RESULTADO: Checklist modelo $checklistModeloRemoteId já preenchido: $encontrado',
        tag: 'ChecklistService',
      );

      return encontrado;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar checklist preenchido',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Verifica se algum checklist de um determinado TIPO já foi preenchido.
  ///
  /// Diferente de checklistJaPreenchido que verifica por modelo específico,
  /// este método verifica se QUALQUER modelo daquele tipo foi preenchido.
  ///
  /// Útil para navegação: verificar se etapa (veicular/EPC/EPI) foi concluída.
  Future<bool> checklistPorTipoJaPreenchido(int tipoChecklistId,
      {int? eletricistaRemoteId}) async {
    AppLogger.i(
      '🔎 [VERIFICAÇÃO TIPO] ========================================',
      tag: 'ChecklistService',
    );
    AppLogger.i(
      '🔎 [VERIFICAÇÃO TIPO] Verificando se checklist do tipo $tipoChecklistId já foi preenchido',
      tag: 'ChecklistService',
    );
    AppLogger.i(
      '🔎 [VERIFICAÇÃO TIPO] eletricistaRemoteId: $eletricistaRemoteId',
      tag: 'ChecklistService',
    );

    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo == null) {
        AppLogger.w('⚠️ [VERIFICAÇÃO TIPO] Nenhum turno ativo encontrado',
            tag: 'ChecklistService');
        return false;
      }

      AppLogger.d('✅ [VERIFICAÇÃO TIPO] Turno ativo ID: ${turnoAtivo.id}',
          tag: 'ChecklistService');

      // Buscar modelos desse tipo
      AppLogger.d('🔍 [VERIFICAÇÃO TIPO] Buscando todos os modelos...',
          tag: 'ChecklistService');
      final modelos = await _checklistModeloRepo.listar();
      AppLogger.d(
          '📋 [VERIFICAÇÃO TIPO] Total de modelos no DB: ${modelos.length}',
          tag: 'ChecklistService');

      final modelosDesseTipo =
          modelos.where((m) => m.tipoChecklistId == tipoChecklistId).toList();

      AppLogger.i(
          '📋 [VERIFICAÇÃO TIPO] Modelos do tipo $tipoChecklistId: ${modelosDesseTipo.length}',
          tag: 'ChecklistService');

      for (final modelo in modelosDesseTipo) {
        AppLogger.d(
            '  - Modelo: id=${modelo.id}, remoteId=${modelo.remoteId}, nome=${modelo.nome}',
            tag: 'ChecklistService');
      }

      if (modelosDesseTipo.isEmpty) {
        AppLogger.w(
            '⚠️ [VERIFICAÇÃO TIPO] Nenhum modelo encontrado para tipo $tipoChecklistId',
            tag: 'ChecklistService');
        AppLogger.i(
            '🔎 [VERIFICAÇÃO TIPO] RESULTADO: false (nenhum modelo desse tipo)',
            tag: 'ChecklistService');
        return false;
      }

      // Buscar preenchimentos deste turno
      AppLogger.d(
          '🔍 [VERIFICAÇÃO TIPO] Buscando checklists preenchidos do turno ${turnoAtivo.id}...',
          tag: 'ChecklistService');
      final preenchidos =
          await _checklistPreenchidoRepo.buscarPorTurno(turnoAtivo.id);

      AppLogger.i(
          '📋 [VERIFICAÇÃO TIPO] Total de checklists preenchidos no turno: ${preenchidos.length}',
          tag: 'ChecklistService');

      for (final preenchido in preenchidos) {
        AppLogger.d(
            '  - Preenchido: id=${preenchido.id}, checklistModeloId=${preenchido.checklistModeloId}, eletricistaRemoteId=${preenchido.eletricistaRemoteId}',
            tag: 'ChecklistService');
      }

      // Verificar se algum modelo deste tipo foi preenchido
      AppLogger.d(
          '🔍 [VERIFICAÇÃO TIPO] Verificando se algum modelo deste tipo foi preenchido...',
          tag: 'ChecklistService');

      final encontrado = preenchidos.any((item) {
        // Verifica se é um modelo deste tipo
        final ehDesseTipo = modelosDesseTipo
            .any((modelo) => modelo.remoteId == item.checklistModeloId);

        AppLogger.d(
            '  - Item ${item.id}: ehDesseTipo=$ehDesseTipo, eletricistaRemoteId=${item.eletricistaRemoteId}',
            tag: 'ChecklistService');

        if (!ehDesseTipo) return false;

        // Se for EPI, verifica eletricista
        if (eletricistaRemoteId != null) {
          final match = item.eletricistaRemoteId == eletricistaRemoteId;
          AppLogger.d('    → Verificando EPI: match=$match',
              tag: 'ChecklistService');
          return match;
        }

        // Para veicular e EPC, não precisa de eletricista
        final match = item.eletricistaRemoteId == null;
        AppLogger.d('    → Verificando Veicular/EPC: match=$match',
            tag: 'ChecklistService');
        return match;
      });

      AppLogger.i(
        '📌 [VERIFICAÇÃO TIPO] RESULTADO: $encontrado (Checklist tipo $tipoChecklistId ${encontrado ? "JÁ PREENCHIDO" : "PENDENTE"})',
        tag: 'ChecklistService',
      );
      AppLogger.i(
        '🔎 [VERIFICAÇÃO TIPO] ========================================',
        tag: 'ChecklistService',
      );

      return encontrado;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao verificar checklist por tipo',
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

      // 3. Buscar a equipe para obter o tipo de equipe
      ChecklistCompletoModel? checklist;

      try {
        final equipe =
            await _equipeRepo.buscarPorId(turnoAtivo.equipeId.toString());
        if (equipe != null) {
          AppLogger.d(
              '🔍 Tentando buscar checklist veicular para tipoEquipeId: ${equipe.tipoEquipeId}',
              tag: 'ChecklistService');

          // Primeiro tenta buscar pelo tipo de checklist veicular + tipo de equipe
          checklist = await _buscarChecklistPorTipoChecklistETipoEquipe(
              ApiConstants.tipoChecklistVeicularId, equipe.tipoEquipeId);

          if (checklist != null) {
            AppLogger.d(
                '✅ Checklist veicular encontrado por tipo de checklist e equipe',
                tag: 'ChecklistService');
            return checklist;
          }
        }
      } catch (e, stackTrace) {
        AppLogger.e(
            '⚠️ Erro ao buscar checklist veicular por tipo de equipe, usando método antigo',
            tag: 'ChecklistService',
            error: e,
            stackTrace: stackTrace);
      }

      // Fallback: buscar diretamente pelo tipo de veículo (método antigo)
      AppLogger.d(
          '🔍 Fallback: Buscando checklist para tipoVeiculoId: ${veiculo.tipoVeiculoId}',
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

      // Primeiro tenta buscar pelo tipo de checklist EPC e tipo de equipe específicos
      if (tipoEquipeId != null) {
        AppLogger.d(
          '🔍 Tentando buscar checklist EPC para tipoEquipeId: $tipoEquipeId',
          tag: 'ChecklistService',
        );

        checklist = await _buscarChecklistPorTipoChecklistETipoEquipe(
            ApiConstants.tipoChecklistEpcId, tipoEquipeId);

        if (checklist != null) {
          AppLogger.d(
              '✅ Checklist EPC encontrado: id=${checklist.id}, remoteId=${checklist.remoteId}, nome=${checklist.nome}',
              tag: 'ChecklistService');
        }
      }

      // Se não encontrou, tenta buscar apenas por tipo de equipe (método antigo)
      if (checklist == null && tipoEquipeId != null) {
        AppLogger.d('🔍 Tentando busca genérica por tipo de equipe',
            tag: 'ChecklistService');
        checklist = await buscarChecklistPorTipoEquipe(tipoEquipeId);
      }

      // Se não encontrou nenhum checklist EPC
      if (checklist == null) {
        AppLogger.w(
          '⚠️ Checklist EPC não encontrado para tipo de checklist ${ApiConstants.tipoChecklistEpcId} e tipo de equipe $tipoEquipeId',
          tag: 'ChecklistService',
        );
      }

      return checklist;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao buscar checklist EPC do turno ativo',
          tag: 'ChecklistService', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
