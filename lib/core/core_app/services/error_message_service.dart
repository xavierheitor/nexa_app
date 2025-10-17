import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço para gerenciar mensagens de erro persistentes na aplicação.
///
/// Permite armazenar e exibir mensagens de erro que devem ficar visíveis
/// até serem explicitamente removidas pelo usuário.
class ErrorMessageService extends GetxService {
  /// Mensagem de erro atual (null se não houver erro)
  final RxnString _mensagemErro = RxnString();

  /// Tipo do erro (para estilização)
  final RxnString _tipoErro = RxnString();

  /// Status code do erro (se disponível)
  final RxnInt _statusCode = RxnInt();

  /// Getters observáveis
  String? get mensagemErro => _mensagemErro.value;
  String? get tipoErro => _tipoErro.value;
  int? get statusCode => _statusCode.value;

  /// Verifica se há erro ativo
  bool get temErro {
    final mensagem = _mensagemErro.value;
    return mensagem != null && mensagem.isNotEmpty;
  }

  /// Define uma mensagem de erro de abertura de turno
  void definirErroAberturaTurno({
    required String mensagem,
    int? statusCode,
    String tipo = 'error',
  }) {
    AppLogger.w(
        '🔴 [ERROR_SERVICE] Definindo erro de abertura de turno: $mensagem',
        tag: 'ErrorMessageService');

    _mensagemErro.value = mensagem;
    _tipoErro.value = tipo;
    _statusCode.value = statusCode;
  }

  /// Define uma mensagem de erro de conflito (409)
  void definirErroConflito(String mensagem) {
    definirErroAberturaTurno(
      mensagem: mensagem,
      statusCode: 409,
      tipo: 'conflict',
    );
  }

  /// Define uma mensagem de erro de validação (400/422)
  void definirErroValidacao(String mensagem) {
    definirErroAberturaTurno(
      mensagem: mensagem,
      statusCode: 400,
      tipo: 'validation',
    );
  }

  /// Define uma mensagem de erro de servidor (5xx)
  void definirErroServidor(String mensagem) {
    definirErroAberturaTurno(
      mensagem: mensagem,
      statusCode: 500,
      tipo: 'server',
    );
  }

  /// Remove a mensagem de erro atual
  void limparErro() {
    AppLogger.d('🟢 [ERROR_SERVICE] Limpando mensagem de erro',
        tag: 'ErrorMessageService');

    _mensagemErro.value = null;
    _tipoErro.value = null;
    _statusCode.value = null;
  }

  /// Verifica se é um erro de conflito de turno
  bool get isErroConflito =>
      _tipoErro.value == 'conflict' || _statusCode.value == 409;

  /// Verifica se é um erro de validação
  bool get isErroValidacao =>
      _tipoErro.value == 'validation' ||
      (_statusCode.value != null &&
          _statusCode.value! >= 400 &&
          _statusCode.value! < 500);

  /// Verifica se é um erro de servidor
  bool get isErroServidor =>
      _tipoErro.value == 'server' ||
      (_statusCode.value != null && _statusCode.value! >= 500);

  @override
  void onClose() {
    limparErro();
    super.onClose();
  }
}
