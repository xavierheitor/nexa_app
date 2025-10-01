/// Resultado consolidado da sincronização de dados.
///
/// Esta classe encapsula o resultado de uma operação de sincronização,
/// fornecendo informações sobre o sucesso da operação e a capacidade
/// do aplicativo de continuar funcionando mesmo em caso de falhas parciais.
///
/// ## Propósito:
///
/// O `SyncResult` é essencial para determinar o comportamento do app
/// após tentativas de sincronização, permitindo decisões inteligentes
/// sobre continuidade da operação mesmo com falhas parciais.
///
/// ## Cenários de Uso:
///
/// 1. **Sincronização Completa**: Todos os módulos sincronizados com sucesso
/// 2. **Sincronização Parcial**: Alguns módulos falharam, mas há dados locais
/// 3. **Falha Total**: Nenhum módulo sincronizado e sem dados locais
/// 4. **Falha com Dados**: Sincronização falhou, mas dados locais existem
///
/// ## Estratégias de Decisão:
///
/// - **`sucesso = true`**: App pode funcionar normalmente
/// - **`sucesso = false` + `podeContinuar = true`**: App funciona com dados locais
/// - **`sucesso = false` + `podeContinuar = false`**: App precisa de nova tentativa
///
/// ## Exemplo de Uso:
///
/// ```dart
/// final resultado = await syncManager.sincronizarTudo();
///
/// if (resultado.sucesso) {
///   // Sincronização completa - app atualizado
///   navegarParaHome();
/// } else if (resultado.podeContinuar) {
///   // Falha parcial - usar dados locais
///   mostrarAviso('Usando dados locais - alguns dados podem estar desatualizados');
///   navegarParaHome();
/// } else {
///   // Falha crítica - tentar novamente
///   mostrarErro('Falha na sincronização - tente novamente');
///   mostrarBotaoTentarNovamente();
/// }
/// ```
class SyncResult {
  /// Indica se todas as operações de sincronização concluíram sem erro.
  ///
  /// Quando `true`, significa que todos os módulos registrados foram
  /// sincronizados com sucesso, garantindo que o app tenha os dados
  /// mais recentes do servidor.
  ///
  /// ## Valores:
  /// - `true`: Todas as operações foram bem-sucedidas
  /// - `false`: Pelo menos uma operação falhou
  ///
  /// ## Implicações:
  /// - `true`: App pode funcionar com dados atualizados
  /// - `false`: Verificar `podeContinuar` para decidir próxima ação
  final bool sucesso;

  /// Indica se o app pode continuar funcionando mesmo com falhas parciais.
  ///
  /// Quando `true`, significa que existem dados locais suficientes para
  /// permitir navegação e uso básico do aplicativo, mesmo que alguns
  /// módulos não tenham sido sincronizados com sucesso.
  ///
  /// ## Valores:
  /// - `true`: Há dados locais suficientes para continuar
  /// - `false`: Dados insuficientes, app pode não funcionar adequadamente
  ///
  /// ## Cenários:
  /// - **Sincronização completa**: `sucesso = true`, `podeContinuar = true`
  /// - **Falha com dados locais**: `sucesso = false`, `podeContinuar = true`
  /// - **Falha sem dados**: `sucesso = false`, `podeContinuar = false`
  ///
  /// ## Estratégia de Fallback:
  /// - `true`: Usar dados locais existentes
  /// - `false`: Requer nova tentativa de sincronização ou modo offline
  final bool podeContinuar;

  /// Construtor do resultado de sincronização.
  ///
  /// Cria uma instância com os valores de sucesso e capacidade de continuar.
  ///
  /// ## Parâmetros:
  /// - `sucesso`: Se todas as operações foram bem-sucedidas
  /// - `podeContinuar`: Se o app pode continuar com dados locais
  ///
  /// ## Validação:
  /// - Não há validação automática de consistência
  /// - Responsabilidade do desenvolvedor garantir lógica coerente
  ///
  /// ## Exemplo:
  /// ```dart
  /// final resultado = SyncResult(
  ///   sucesso: true,
  ///   podeContinuar: true,
  /// );
  /// ```
  SyncResult({required this.sucesso, required this.podeContinuar});

  /// Retorna representação em string do resultado.
  ///
  /// Útil para debugging e logging de resultados de sincronização.
  ///
  /// ## Formato:
  /// `SyncResult(sucesso: true/false, podeContinuar: true/false)`
  ///
  /// ## Exemplo:
  /// ```dart
  /// print(resultado.toString());
  /// // Output: SyncResult(sucesso: true, podeContinuar: true)
  /// ```
  @override
  String toString() {
    return 'SyncResult(sucesso: $sucesso, podeContinuar: $podeContinuar)';
  }

  /// Verifica se o resultado indica sucesso completo.
  ///
  /// Método de conveniência que retorna `true` apenas quando
  /// tanto `sucesso` quanto `podeContinuar` são `true`.
  ///
  /// ## Retorno:
  /// - `true`: Sincronização completa e app pode funcionar normalmente
  /// - `false`: Houve falhas ou dados insuficientes
  ///
  /// ## Uso:
  /// ```dart
  /// if (resultado.isCompleto) {
  ///   // Sincronização perfeita
  ///   navegarParaHome();
  /// }
  /// ```
  bool get isCompleto => sucesso && podeContinuar;

  /// Verifica se o resultado indica falha crítica.
  ///
  /// Método de conveniência que retorna `true` quando
  /// tanto `sucesso` quanto `podeContinuar` são `false`.
  ///
  /// ## Retorno:
  /// - `true`: Falha crítica - app não pode funcionar
  /// - `false`: App pode funcionar (com ou sem falhas parciais)
  ///
  /// ## Uso:
  /// ```dart
  /// if (resultado.isFalhaCritica) {
  ///   // Falha total - mostrar erro e botão de retry
  ///   mostrarErroCritico();
  /// }
  /// ```
  bool get isFalhaCritica => !sucesso && !podeContinuar;
}
