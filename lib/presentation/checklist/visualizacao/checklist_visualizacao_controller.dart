import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/data/models/checklist_preenchido_table_dto.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/models/checklist_modelo_table_dto.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/models/eletricista_table_dto.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/models/checklist_pergunta_table_dto.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/models/checklist_resposta_table_dto.dart';
import 'package:nexa_app/data/repositories/checklist_resposta_repo.dart';

/// Controller responsável pela visualização detalhada de um checklist.
///
/// Este controller gerencia a exibição das respostas detalhadas de um
/// checklist específico, incluindo perguntas e respostas selecionadas.
///
/// ## Responsabilidades:
///
/// 1. **Carregamento de Dados**: Busca dados completos do checklist
/// 2. **Formatação de Dados**: Prepara dados para exibição na UI
/// 3. **Gerenciamento de Estado**: Controla loading e erros
/// 4. **Navegação**: Gerencia navegação de volta
///
/// ## Funcionalidades:
///
/// - Exibe informações do checklist
/// - Lista perguntas e respostas
/// - Mostra informações do eletricista (se aplicável)
/// - Interface de leitura apenas
///
/// ## Uso:
///
/// ```dart
/// final controller = Get.find<ChecklistVisualizacaoController>();
/// await controller.carregarChecklist(checklistId);
/// ```
class ChecklistVisualizacaoController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  late final ChecklistPreenchidoRepo _checklistPreenchidoRepo;
  late final ChecklistModeloRepo _checklistModeloRepo;
  late final EletricistaRepo _eletricistaRepo;
  late final ChecklistPerguntaRepo _checklistPerguntaRepo;
  late final ChecklistOpcaoRespostaRepo _checklistOpcaoRespostaRepo;
  late final ChecklistRespostaRepo _checklistRespostaRepo;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Checklist preenchido atual.
  final Rxn<ChecklistPreenchidoTableDto> checklistPreenchido =
      Rxn<ChecklistPreenchidoTableDto>();

  /// Modelo do checklist.
  final Rxn<ChecklistModeloTableDto> checklistModelo =
      Rxn<ChecklistModeloTableDto>();

  /// Eletricista (se aplicável).
  final Rxn<EletricistaTableDto> eletricista = Rxn<EletricistaTableDto>();

  /// Lista de perguntas do checklist.
  final RxList<ChecklistPerguntaTableDto> perguntas =
      <ChecklistPerguntaTableDto>[].obs;

  /// Lista de respostas do checklist.
  final RxList<ChecklistRespostaTableDto> respostas =
      <ChecklistRespostaTableDto>[].obs;

  /// Lista formatada para exibição.
  final RxList<ChecklistVisualizacaoItem> itensFormatados =
      <ChecklistVisualizacaoItem>[].obs;

  /// Flag indicando se está carregando dados.
  final RxBool isLoading = false.obs;

  /// Flag indicando se há erro.
  final RxBool temErro = false.obs;

  /// Mensagem de erro.
  final RxString mensagemErro = ''.obs;

  /// ID do checklist sendo visualizado.
  int? _checklistId;

  /// Nome do checklist (passado via argumentos).
  String _checklistNome = '';

  /// Subtítulo do checklist (passado via argumentos).
  String _checklistSubtitulo = '';

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Retorna o nome do checklist.
  String get checklistNome => _checklistNome;

  /// Retorna o subtítulo do checklist.
  String get checklistSubtitulo => _checklistSubtitulo;

  /// Retorna a data de preenchimento formatada.
  String get dataPreenchimento {
    final checklist = checklistPreenchido.value;
    if (checklist == null) return '';

    final data = checklist.dataPreenchimento;
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================================
  // INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    _inicializarDependencias();
    _processarArgumentos();
    AppLogger.i('ChecklistVisualizacaoController inicializado',
        tag: 'ChecklistVisualizacaoController');
  }

  @override
  void onReady() {
    super.onReady();
    if (_checklistId != null) {
      carregarChecklist(_checklistId!);
    }
  }

  /// Inicializa as dependências necessárias.
  void _inicializarDependencias() {
    _checklistPreenchidoRepo = Get.find<ChecklistPreenchidoRepo>();
    _checklistModeloRepo = Get.find<ChecklistModeloRepo>();
    _eletricistaRepo = Get.find<EletricistaRepo>();
    _checklistPerguntaRepo = Get.find<ChecklistPerguntaRepo>();
    _checklistOpcaoRespostaRepo = Get.find<ChecklistOpcaoRespostaRepo>();
    _checklistRespostaRepo = Get.find<ChecklistRespostaRepo>();
  }

  /// Processa os argumentos passados via navegação.
  void _processarArgumentos() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      // O checklistId pode vir como String ou int, vamos tratar ambos os casos
      final checklistIdValue = arguments['checklistId'];
      if (checklistIdValue is int) {
        _checklistId = checklistIdValue;
      } else if (checklistIdValue is String) {
        _checklistId = int.tryParse(checklistIdValue);
      }

      _checklistNome = arguments['checklistNome'] as String? ?? 'Checklist';
      _checklistSubtitulo = arguments['checklistSubtitulo'] as String? ?? '';
    }
  }

  // ============================================================================
  // MÉTODOS DE CARREGAMENTO
  // ============================================================================

  /// Carrega os dados completos do checklist.
  Future<void> carregarChecklist(int checklistId) async {
    try {
      isLoading.value = true;
      temErro.value = false;

      AppLogger.v('Carregando checklist preenchido com id $checklistId',
          tag: 'ChecklistVisualizacaoController');

      // 1. Busca o checklist preenchido
      final checklist = await _checklistPreenchidoRepo.buscarPorId(checklistId);
      if (checklist == null) {
        throw Exception('Checklist não encontrado');
      }

      AppLogger.v('Checklist preenchido encontrado com id ${checklist.id}',
          tag: 'ChecklistVisualizacaoController');

      checklistPreenchido.value = checklist;

      // 2. Busca o modelo do checklist pelo remoteId
      final modelo = await _checklistModeloRepo
          .buscarPorRemoteId(checklist.checklistModeloId);
      if (modelo == null) {
        throw Exception('Modelo do checklist não encontrado');
      }
      checklistModelo.value = modelo;

      AppLogger.d(
          '📋 Modelo encontrado - ID: ${modelo.id}, remoteId: ${modelo.remoteId}, Nome: ${modelo.nome}',
          tag: 'ChecklistVisualizacaoController');

      // 3. Busca o eletricista (se aplicável)
      if (checklist.eletricistaRemoteId != null) {
        final eletricistas = await _eletricistaRepo.listar();
        final eletricistaData = eletricistas.firstWhereOrNull((e) =>
            e.remoteId.toString() == checklist.eletricistaRemoteId.toString());
        if (eletricistaData != null) {
          eletricista.value = eletricistaData;
        }
      }

      // 4. Busca as perguntas do modelo específico do checklist
      if (modelo.remoteId == null) {
        throw Exception('Modelo do checklist sem remoteId');
      }
      final perguntasList =
          await _checklistPerguntaRepo.buscarPorModelo(modelo.remoteId!);
      perguntas.value = perguntasList;

      AppLogger.d(
          '📝 Total de perguntas carregadas para o modelo de id ${modelo.id} e nome ${modelo.nome}: ${perguntasList.length}',
          tag: 'ChecklistVisualizacaoController');


      // 5. Busca as respostas do checklist
      final respostasList = await _checklistRespostaRepo
          .buscarPorChecklistPreenchido(checklistId);
      respostas.value = respostasList;

      // 6. Formata os dados para exibição
      await _formatarDadosParaExibicao();

      AppLogger.i('Checklist carregado com sucesso',
          tag: 'ChecklistVisualizacaoController');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar checklist',
          tag: 'ChecklistVisualizacaoController',
          error: e,
          stackTrace: stackTrace);

      temErro.value = true;
      mensagemErro.value = 'Erro ao carregar checklist: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Formata os dados para exibição na UI.
  ///
  /// Mostra apenas as perguntas que foram respondidas (que estão na tabela checklist_resposta_table).
  Future<void> _formatarDadosParaExibicao() async {
    try {
      final List<ChecklistVisualizacaoItem> itens = [];

      AppLogger.d('📝 Formatando ${respostas.length} respostas para exibição',
          tag: 'ChecklistVisualizacaoController');

      // Processa apenas as respostas que existem (perguntas que foram respondidas)
      for (final resposta in respostas) {
        // Busca a pergunta correspondente pelo remoteId
        // resposta.perguntaId agora armazena o remoteId da pergunta
        final pergunta =
            perguntas.firstWhereOrNull((p) => p.remoteId == resposta.perguntaId);

        if (pergunta == null) {
          AppLogger.w(
              '⚠️ Pergunta não encontrada para resposta ID: ${resposta.id}, perguntaRemoteId: ${resposta.perguntaId}',
              tag: 'ChecklistVisualizacaoController');
          continue;
        }

        // Busca a opção de resposta selecionada pelo remoteId
        // resposta.opcaoRespostaId agora armazena o remoteId da opção
        String respostaTexto = 'Não respondida';
        final opcao = await _checklistOpcaoRespostaRepo
            .buscarPorRemoteId(resposta.opcaoRespostaId);
        if (opcao != null) {
          respostaTexto = opcao.nome;
          AppLogger.d(
              '✅ Pergunta: ${pergunta.nome} | Resposta: ${respostaTexto}',
              tag: 'ChecklistVisualizacaoController');
        } else {
          AppLogger.w(
              '⚠️ Opção de resposta não encontrada para remoteId: ${resposta.opcaoRespostaId}',
              tag: 'ChecklistVisualizacaoController');
        }

        itens.add(ChecklistVisualizacaoItem(
          pergunta: pergunta,
          resposta: resposta,
          respostaTexto: respostaTexto,
        ));
      }

      itensFormatados.value = itens;

      AppLogger.d('📊 Total de ${itens.length} itens formatados para exibição',
          tag: 'ChecklistVisualizacaoController');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao formatar dados para exibição',
          tag: 'ChecklistVisualizacaoController',
          error: e,
          stackTrace: stackTrace);
    }
  }

  // ============================================================================
  // AÇÕES
  // ============================================================================

  /// Volta para a tela anterior.
  void voltar() {
    Get.back();
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  @override
  void onClose() {
    AppLogger.d('ChecklistVisualizacaoController sendo removido',
        tag: 'ChecklistVisualizacaoController');
    super.onClose();
  }
}

/// Classe para representar um item formatado para visualização.
class ChecklistVisualizacaoItem {
  final ChecklistPerguntaTableDto pergunta;
  final ChecklistRespostaTableDto? resposta;
  final String respostaTexto;

  ChecklistVisualizacaoItem({
    required this.pergunta,
    required this.resposta,
    required this.respostaTexto,
  });
}
