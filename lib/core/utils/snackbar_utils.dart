import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utilitário para exibir snackbars padronizados na aplicação.
///
/// **REGRA DE USO:**
/// - ✅ Mostrar apenas erros
/// - ❌ NÃO mostrar sucessos (apenas navegar)
///
/// Todos os snackbars de erro seguem o mesmo padrão visual:
/// - Fundo vermelho
/// - Texto branco
/// - Ícone de erro
/// - Posição na parte inferior
class SnackbarUtils {
  /// Exibe snackbar de erro padronizado.
  ///
  /// ## Parâmetros:
  /// - `titulo`: Título do erro (ex: "Erro", "Falha na conexão")
  /// - `mensagem`: Descrição detalhada do erro
  /// - `duracao`: Duração de exibição (padrão: 4 segundos)
  ///
  /// ## Exemplo:
  /// ```dart
  /// SnackbarUtils.erro(
  ///   titulo: 'Erro ao salvar',
  ///   mensagem: 'Não foi possível salvar os dados. Tente novamente.',
  /// );
  /// ```
  static void erro({
    required String titulo,
    required String mensagem,
    Duration duracao = const Duration(seconds: 4),
  }) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      icon: Icon(
        Icons.error_outline,
        color: Get.theme.colorScheme.onError,
      ),
      duration: duracao,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Exibe snackbar de validação (quando usuário esquece algo).
  ///
  /// ## Parâmetros:
  /// - `mensagem`: Descrição do que precisa ser corrigido
  ///
  /// ## Exemplo:
  /// ```dart
  /// SnackbarUtils.validacao('Preencha todos os campos obrigatórios');
  /// ```
  static void validacao(String mensagem) {
    erro(
      titulo: 'Atenção',
      mensagem: mensagem,
      duracao: const Duration(seconds: 3),
    );
  }

  /// Exibe snackbar de erro de conexão.
  ///
  /// ## Exemplo:
  /// ```dart
  /// SnackbarUtils.conexao();
  /// ```
  static void conexao() {
    erro(
      titulo: 'Erro de Conexão',
      mensagem: 'Verifique sua internet e tente novamente.',
    );
  }

  /// Exibe snackbar de erro genérico.
  ///
  /// ## Exemplo:
  /// ```dart
  /// SnackbarUtils.erroGenerico();
  /// ```
  static void erroGenerico() {
    erro(
      titulo: 'Erro',
      mensagem: 'Ocorreu um erro inesperado. Tente novamente.',
    );
  }

  /// Exibe snackbar de sucesso padronizado.
  ///
  /// ## Parâmetros:
  /// - `titulo`: Título do sucesso (ex: "Sucesso", "Salvo com sucesso")
  /// - `mensagem`: Descrição detalhada do sucesso
  /// - `duracao`: Duração de exibição (padrão: 3 segundos)
  ///
  /// ## Exemplo:
  /// ```dart
  /// SnackbarUtils.sucesso(
  ///   titulo: 'Turno Fechado',
  ///   mensagem: 'Turno foi fechado com sucesso!',
  /// );
  /// ```
  static void sucesso({
    required String titulo,
    required String mensagem,
    Duration duracao = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      icon: Icon(
        Icons.check_circle_outline,
        color: Get.theme.colorScheme.onPrimary,
      ),
      duration: duracao,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}

