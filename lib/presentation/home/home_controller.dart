import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/services/error_message_service.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/snackbar_utils.dart';
import 'package:nexa_app/app/routes/routes.dart';

/// Controlador responsável pelo gerenciamento da tela principal (home).
class HomeController extends GetxController {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Gerenciador de sessão para acesso aos dados do usuário.
  final SessionManager _sessionManager;

  /// Serviço de autenticação para operações de logout.
  final AuthService _authService;

  /// Serviço de sincronização para atualização de dados.
  final SyncService _syncService;

  /// Serviço de mensagens de erro.
  final ErrorMessageService _errorMessageService =
      Get.find<ErrorMessageService>();

  /// Controlador global de turno.
  final TurnoController turnoController = Get.find<TurnoController>();

  /// Construtor do controlador.
  HomeController({
    required SessionManager sessionManager,
    required AuthService authService,
    required SyncService syncService,
  })  : _sessionManager = sessionManager,
        _authService = authService,
        _syncService = syncService;

  // ============================================================================
  // ESTADO REATIVO
  // ============================================================================

  /// Flag indicando se está carregando dados.
  final RxBool isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  /// Nome do usuário logado.
  String get nomeUsuario => _sessionManager.usuario?.nome ?? 'Usuário';

  /// Matrícula do usuário logado.
  String get matriculaUsuario => _sessionManager.usuario?.matricula ?? 'N/A';

  /// Verifica se há turno aberto.
  bool get hasTurnoAberto => turnoController.hasTurnoAberto;

  /// Verifica se há erro de abertura de turno
  bool get temErroAberturaTurno => _errorMessageService.temErro;

  /// Mensagem de erro de abertura de turno
  String? get mensagemErroAberturaTurno => _errorMessageService.mensagemErro;

  /// Verifica se há erro de fechamento de turno
  bool get temErroFechamentoTurno => _errorMessageService.temErro;

  /// Mensagem de erro de fechamento de turno
  String? get mensagemErroFechamentoTurno => _errorMessageService.mensagemErro;

  /// Verifica se há algum erro (abertura ou fechamento)
  bool get temErro => _errorMessageService.temErro;

  /// Mensagem de erro unificada
  String? get mensagemErro => _errorMessageService.mensagemErro;

  // ============================================================================
  // GETTERS PARA HABILITAÇÃO DE FUNCIONALIDADES
  // ============================================================================

  /// Verifica se a funcionalidade de checklist deve estar habilitada.
  /// Só habilitada quando há turno aberto.
  bool get checklistHabilitado => turnoController.hasTurnoAberto;

  /// Verifica se a funcionalidade de APR deve estar habilitada.
  /// Só habilitada quando há turno aberto.
  bool get aprHabilitado => turnoController.hasTurnoAberto;

  /// Verifica se a funcionalidade de almoxarifado deve estar habilitada.
  /// Sempre habilitada independente do estado do turno.
  bool get almoxarifadoHabilitado => true;

  /// Verifica se o botão de logout deve estar visível.
  /// Só aparece quando NÃO há turno aberto.
  bool get logoutVisivel => !turnoController.hasTurnoAberto;

  // ============================================================================
  // MÉTODOS DE INICIALIZAÇÃO
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController inicializado', tag: 'HomeController');
    // Garante que o turno seja carregado quando a home for inicializada
    _carregarTurnoSeNecessario();
  }

  @override
  void onReady() {
    super.onReady();
    // Recarrega o turno quando a página está pronta
    // Isso garante que o estado mais recente seja exibido
    _recarregarTurnoAtivo();
  }

  /// Carrega o turno ativo se ainda não foi carregado
  Future<void> _carregarTurnoSeNecessario() async {
    try {
      // Se o turnoController não tem turno carregado, força o carregamento
      if (!turnoController.hasTurno && !turnoController.isLoading.value) {
        AppLogger.d('Forçando carregamento do turno ativo na home',
            tag: 'HomeController');
        await turnoController.carregarTurnoAtivo();
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao carregar turno na inicialização da home',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
    }
  }

  /// Recarrega o turno ativo (útil quando volta para a home)
  Future<void> _recarregarTurnoAtivo() async {
    try {
      AppLogger.d('Recarregando turno ativo na home', tag: 'HomeController');
      await turnoController.carregarTurnoAtivo();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao recarregar turno na home',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
    }
  }

  // ============================================================================
  // AÇÕES DE NAVEGAÇÃO
  // ============================================================================

  /// Ação do botão Turno.
  ///
  /// **NOVO FLUXO INTELIGENTE:**
  /// - Navega para tela de loading que analisa o estado do turno
  /// - A tela de loading decide automaticamente para onde ir:
  ///   - Nenhum turno → Abrir turno
  ///   - Turno em abertura → Próximo checklist pendente
  ///   - Turno aberto → Lista de serviços
  ///
  /// Isso evita abrir múltiplas telas desnecessariamente.
  void abrirTurno() {
    AppLogger.i('🧭 [HOME] Navegando para decisão inteligente de turno',
        tag: 'HomeController');

    // Navega para a tela que decide automaticamente o próximo passo
    Get.toNamed(Routes.turnoNavigationLoading);
  }

  /// Navega para tela de APR (Análise Preliminar de Risco).
  void abrirAPR() {
    if (!aprHabilitado) {
      SnackbarUtils.validacao(
          'APR só está disponível quando há um turno aberto.');
      return;
    }

    AppLogger.i('Navegando para tela de APR', tag: 'HomeController');
    SnackbarUtils.validacao('Tela de APR em desenvolvimento');
  }

  /// Navega para tela de checklist.
  void abrirChecklist() {
    if (!checklistHabilitado) {
      SnackbarUtils.validacao(
          'Checklist só está disponível quando há um turno aberto.');
      return;
    }

    AppLogger.i('Navegando para tela de checklist', tag: 'HomeController');
    Get.toNamed(Routes.checklistLista);
  }

  /// Navega para tela de almoxarifado.
  void abrirAlmoxarifado() {
    AppLogger.i('Navegando para tela de almoxarifado', tag: 'HomeController');
    SnackbarUtils.validacao('Recurso ainda não implementado');
  }

  /// Fecha o turno atual com confirmação e captura de dados.
  Future<void> fecharTurno() async {
    try {
      final turno = turnoController.turnoAtivo.value;
      if (turno == null) {
        SnackbarUtils.erro(
          titulo: 'Erro',
          mensagem: 'Nenhum turno ativo encontrado.',
        );
        return;
      }

      AppLogger.i('Iniciando processo de fechamento do turno ${turno.id}',
          tag: 'HomeController');

      // Mostra dialog de confirmação com captura de KM final
      final result = await _showFecharTurnoDialog(turno);
      if (result != null && result['confirmed'] == true) {
        await _processarFechamentoTurno(turno, result);
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fechar turno',
          tag: 'HomeController', error: e, stackTrace: stackTrace);

      SnackbarUtils.erro(
        titulo: 'Erro ao Fechar Turno',
        mensagem: 'Não foi possível fechar o turno. Tente novamente.',
      );
    }
  }

  /// Mostra dialog de confirmação para fechar turno
  Future<Map<String, dynamic>?> _showFecharTurnoDialog(dynamic turno) async {
    final kmController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    return await Get.dialog<Map<String, dynamic>>(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.close, color: Colors.red),
                SizedBox(width: 8),
                Text('Fechar Turno'),
              ],
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirma o fechamento do turno ${turno.id}?',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: kmController,
                    decoration: const InputDecoration(
                      labelText: 'KM Final do Veículo',
                      hintText: 'Digite o KM final',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.speed),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'KM final é obrigatório';
                      }
                      final km = int.tryParse(value);
                      if (km == null || km < turno.kmInicial) {
                        return 'KM final deve ser maior que o inicial (${turno.kmInicial})';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    const Text(
                      '...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Get.back(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);

                          try {
                            // Captura localização
                            final location = await _capturarLocalizacao();

                            Get.back(result: {
                              'confirmed': true,
                              'kmFinal': int.parse(kmController.text),
                              'latitude': location['latitude'],
                              'longitude': location['longitude'],
                            });
                          } catch (e) {
                            setState(() => isLoading = false);
                            SnackbarUtils.erro(
                              titulo: 'Erro',
                              mensagem: 'Erro ao capturar localização: $e',
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Fechar Turno'),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  /// Captura a localização atual
  Future<Map<String, String?>> _capturarLocalizacao() async {
    try {
      // TODO: Implementar captura real de GPS
      // Por enquanto, retorna valores mock
      AppLogger.d('Capturando localização para fechamento do turno',
          tag: 'HomeController');

      return {
        'latitude': '-23.5505', // Mock - São Paulo
        'longitude': '-46.6333', // Mock - São Paulo
      };
    } catch (e) {
      AppLogger.w('Erro ao capturar localização: $e', tag: 'HomeController');
      return {
        'latitude': null,
        'longitude': null,
      };
    }
  }

  /// Processa o fechamento do turno
  Future<void> _processarFechamentoTurno(
    dynamic turno,
    Map<String, dynamic> dados,
  ) async {
    try {
      isLoading.value = true;

      AppLogger.i('Processando fechamento do turno ${turno.id}',
          tag: 'HomeController');

      // Importa o TurnoRepo
      final turnoRepo = Get.find<TurnoRepo>();

      // Fecha o turno
      try {
        final sucesso = await turnoRepo.fecharTurno(
          turno.id,
          kmFinal: dados['kmFinal'],
          latitude: dados['latitude'],
          longitude: dados['longitude'],
        );

        if (sucesso) {
          AppLogger.i('Turno ${turno.id} fechado com sucesso',
              tag: 'HomeController');

          SnackbarUtils.sucesso(
            titulo: 'Turno Fechado',
            mensagem: 'Turno ${turno.id} foi fechado com sucesso!',
          );

          // Recarrega o turno para atualizar o estado
          await turnoController.carregarTurnoAtivo();
        } else {
          throw Exception('Falha ao fechar turno no banco de dados');
        }
      } catch (e) {
        // Se houve erro na API, define mensagem de erro
        final errorMessage = _extrairMensagemErroFechamento(e);
        _errorMessageService.definirErroFechamentoTurno(
          mensagem: errorMessage,
          statusCode: _extrairStatusCodeFechamento(e),
        );

        AppLogger.e('Erro ao fechar turno: $e', tag: 'HomeController');
        rethrow; // Re-lança para que seja tratado no catch externo
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao processar fechamento do turno',
          tag: 'HomeController', error: e, stackTrace: stackTrace);

      SnackbarUtils.erro(
        titulo: 'Erro ao Fechar Turno',
        mensagem: 'Não foi possível fechar o turno: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================================
  // AÇÕES DO USUÁRIO
  // ============================================================================

  /// Executa logout do usuário.
  Future<void> logout() async {
    try {
      AppLogger.i('Iniciando logout', tag: 'HomeController');

      // Verifica se há turno aberto
      if (hasTurnoAberto) {
        AppLogger.w('Tentativa de logout com turno aberto',
            tag: 'HomeController');

        SnackbarUtils.erro(
          titulo: 'Turno Aberto',
          mensagem:
              'Não é possível fazer logout com turno aberto. Por favor, feche o turno antes de sair.',
        );
        return;
      }

      isLoading.value = true;

      await _authService.logout();

      AppLogger.i('Logout realizado com sucesso', tag: 'HomeController');

      Get.offAllNamed(Routes.login);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fazer logout',
          tag: 'HomeController', error: e, stackTrace: stackTrace);

      SnackbarUtils.erro(
        titulo: 'Erro ao Fazer Logout',
        mensagem: 'Não foi possível fazer logout. Tente novamente.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Atualiza dados da tela.
  Future<void> atualizar() async {
    AppLogger.d('Atualizando dados da home', tag: 'HomeController');
    
    try {
      // Executa sincronização completa
      final sucesso = await _syncService.sincronizarTudo();

      if (sucesso) {
        AppLogger.i('Sincronização concluída com sucesso',
            tag: 'HomeController');
        // Sucesso: apenas log, sem snackbar
      } else {
        AppLogger.w('Sincronização falhou', tag: 'HomeController');
        SnackbarUtils.erro(
          titulo: 'Erro na Sincronização',
          mensagem: 'Falha ao atualizar dados. Tente novamente.',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro durante sincronização',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
      SnackbarUtils.erro(
        titulo: 'Erro na Sincronização',
        mensagem: 'Erro inesperado durante sincronização.',
      );
    }

    // Atualiza dados do turno após sincronização
    await turnoController.atualizar();
  }

  /// Limpa a mensagem de erro de abertura de turno
  void limparErroAberturaTurno() {
    _errorMessageService.limparErro();
  }

  /// Limpa a mensagem de erro de fechamento de turno
  void limparErroFechamentoTurno() {
    _errorMessageService.limparErroFechamentoTurno();
  }

  /// Limpa qualquer mensagem de erro
  void limparErro() {
    _errorMessageService.limparErro();
  }

  /// Extrai mensagem de erro amigável do exception para fechamento
  String _extrairMensagemErroFechamento(dynamic error) {
    if (error.toString().contains('404')) {
      return 'Endpoint de fechamento de turno não está disponível no servidor. O turno não foi fechado.';
    } else if (error.toString().contains('500')) {
      return 'Erro interno do servidor. O turno não foi fechado.';
    } else if (error.toString().contains('timeout')) {
      return 'Timeout na comunicação com o servidor. O turno não foi fechado.';
    } else {
      return 'Erro de comunicação com o servidor. O turno não foi fechado.';
    }
  }

  /// Extrai status code do exception para fechamento
  int? _extrairStatusCodeFechamento(dynamic error) {
    if (error.toString().contains('404')) return 404;
    if (error.toString().contains('500')) return 500;
    if (error.toString().contains('timeout')) return 408;
    return null;
  }

  // ============================================================================
  // MÉTODOS AUXILIARES PARA DADOS DO TURNO
  // ============================================================================

  /// Busca o nome da equipe pelo ID.
  Future<String> buscarNomeEquipe(int equipeId) async {
    try {
      final equipeRepo = Get.find<EquipeRepo>();
      final equipe = await equipeRepo.buscarPorId(equipeId.toString());
      return equipe?.nome ?? 'Equipe $equipeId';
    } catch (e) {
      AppLogger.w('Erro ao buscar nome da equipe: $e', tag: 'HomeController');
      return 'Equipe $equipeId';
    }
  }

  /// Busca a placa do veículo pelo ID.
  Future<String> buscarPlacaVeiculo(int veiculoId) async {
    try {
      final veiculoRepo = Get.find<VeiculoRepo>();
      final veiculo = await veiculoRepo.buscarPorId(veiculoId);
      return veiculo.placa;
    } catch (e) {
      AppLogger.w('Erro ao buscar placa do veículo: $e', tag: 'HomeController');
      return 'Veículo $veiculoId';
    }
  }

  // ============================================================================
  // MÉTODOS HELPER PARA DEBUG
  // ============================================================================

  /// 🗑️ Limpa todos os checklists preenchidos do turno atual (apenas para debug/testes)
  Future<void> limparChecklistsDoTurnoAtual() async {
    try {
      AppLogger.d('🗑️ Iniciando limpeza de checklists do turno atual',
          tag: 'HomeController');

      if (!turnoController.hasTurnoAberto) {
        AppLogger.w('⚠️ Nenhum turno ativo encontrado', tag: 'HomeController');
        SnackbarUtils.validacao('Nenhum turno ativo encontrado');
        return;
      }

      final turnoId = turnoController.turnoAtivo.value?.id;
      if (turnoId == null) {
        AppLogger.w('⚠️ ID do turno ativo não encontrado',
            tag: 'HomeController');
        return;
      }

      final checklistPreenchidoRepo = Get.find<ChecklistPreenchidoRepo>();
      final removidos = await checklistPreenchidoRepo.removerPorTurno(turnoId);

      AppLogger.i(
          '✅ $removidos checklists preenchidos removidos do turno $turnoId',
          tag: 'HomeController');
      SnackbarUtils.sucesso(
        titulo: 'Checklists Removidos',
        mensagem: '$removidos checklists removidos! Agora preencha novamente.',
      );

      // Recarrega o estado do turno
      await turnoController.recarregar();
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao limpar checklists do turno atual',
          tag: 'HomeController', error: e, stackTrace: stackTrace);
      SnackbarUtils.erro(
        titulo: 'Erro ao Limpar',
        mensagem: 'Não foi possível limpar os checklists: $e',
      );
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - Estados reativos (isLoading)
  /// - Qualquer listener ou subscription ativa
  /// - Referências a serviços (já gerenciados pelo GetX)
  @override
  void onClose() {
    /// Limpa estados reativos.
    isLoading.value = false;

    /// Registra finalização do controlador.
    AppLogger.d('HomeController finalizado e recursos liberados',
        tag: 'HomeController');

    super.onClose();
  }
}
