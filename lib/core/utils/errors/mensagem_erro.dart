/// Modelo de dados para mensagens de erro amigáveis ao usuário.
///
/// Esta classe representa uma mensagem de erro estruturada que pode ser
/// exibida diretamente ao usuário, contendo título e descrição claros
/// sem expor detalhes técnicos ou informações sensíveis.
///
/// ## Funcionalidades Principais:
///
/// 1. **Estrutura Padronizada**: Título e descrição organizados
/// 2. **User-Friendly**: Linguagem clara e compreensível
/// 3. **Imutável**: Campos finais para thread safety
/// 4. **Reutilizável**: Pode ser usada em diferentes contextos de UI
/// 5. **Localização**: Preparada para internacionalização futura
///
/// ## Arquitetura:
///
/// - **Data Class**: Modelo simples de dados sem lógica de negócio
/// - **Immutable**: Campos finais para evitar modificações acidentais
/// - **Required Parameters**: Construtor com parâmetros obrigatórios
/// - **UI Ready**: Estruturada para uso direto em interfaces
///
/// ## Uso:
///
/// ```dart
/// final mensagem = MensagemErro(
///   titulo: 'Erro de conexão',
///   descricao: 'Não foi possível conectar ao servidor.',
/// );
///
/// // Exibir em dialog
/// showDialog(
///   title: mensagem.titulo,
///   content: mensagem.descricao,
/// );
///
/// // Exibir em snackbar
/// ScaffoldMessenger.of(context).showSnackBar(
///   SnackBar(
///     title: Text(mensagem.titulo),
///     content: Text(mensagem.descricao),
///   ),
/// );
/// ```
///
/// ## Casos de Uso:
///
/// - **Dialogs de Erro**: Pop-ups informativos para o usuário
/// - **Snackbars**: Notificações temporárias de erro
/// - **Toast Messages**: Mensagens de feedback rápido
/// - **Error Pages**: Páginas de erro com informações claras
/// - **Form Validation**: Mensagens de validação de campos
///
/// ## Boas Práticas:
///
/// - **Títulos Concisos**: Máximo 3-4 palavras
/// - **Descrições Úteis**: Explicam o problema e sugerem ações
/// - **Linguagem Clara**: Evitar jargões técnicos
/// - **Tom Amigável**: Não alarmar desnecessariamente o usuário
/// - **Ações Sugeridas**: Incluir próximos passos quando possível
class MensagemErro {
  // ============================================================================
  // PROPRIEDADES DA MENSAGEM DE ERRO
  // ============================================================================

  /// Título conciso da mensagem de erro.
  ///
  /// Deve ser breve e direto, identificando rapidamente o tipo de problema.
  /// Idealmente 3-4 palavras que resumem o erro de forma clara.
  ///
  /// ## Exemplos:
  /// - "Erro de conexão"
  /// - "Dados inválidos"
  /// - "Acesso negado"
  /// - "Serviço indisponível"
  final String titulo;

  /// Descrição detalhada do erro e orientações para o usuário.
  ///
  /// Deve explicar o que aconteceu de forma clara e, quando possível,
  /// sugerir ações que o usuário pode tomar para resolver o problema.
  /// Evitar jargões técnicos e usar linguagem acessível.
  ///
  /// ## Exemplos:
  /// - "Não foi possível conectar ao servidor. Verifique sua internet e tente novamente."
  /// - "O campo email está em formato inválido. Digite um email válido."
  /// - "Sua sessão expirou. Faça login novamente para continuar."
  final String descricao;

  /// Construtor para mensagens de erro amigáveis.
  ///
  /// ## Parâmetros:
  /// - `titulo`: Título conciso do erro (obrigatório)
  /// - `descricao`: Descrição detalhada com orientações (obrigatório)
  ///
  /// ## Exemplo:
  /// ```dart
  /// final mensagem = MensagemErro(
  ///   titulo: 'Erro de validação',
  ///   descricao: 'O campo email é obrigatório.',
  /// );
  /// ```
  MensagemErro({required this.titulo, required this.descricao});
}
