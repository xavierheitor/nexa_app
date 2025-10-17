abstract class ApiConstants {
  static const int maxRefreshAttempts = 3;
  static const baseUrl = 'http://192.168.0.245:3001/api';

  static const login = '/auth/login';
  static const refreshToken = '/auth/refresh';

  static const veiculos = '/veiculos/sync';
  static const tiposVeiculo = '/tipo-veiculo/sync';
  static const equipes = '/equipes/sync';
  static const tiposEquipe = '/tipo-equipe/sync';
  static const eletricistas = '/eletricistas/sync';

  // Checklist
  static const checklistModelo = '/checklist/sync/modelos';
  static const checklistPergunta = '/checklist/sync/perguntas';
  static const checklistOpcaoResposta = '/checklist/sync/opcoes-resposta';
  static const checklistPerguntaRelacao = '/checklist/sync/perguntas/relacoes';
  static const checklistOpcaoRespostaRelacao =
      '/checklist/sync/opcoes-resposta/relacoes';
  static const checklistTipoEquipeRelacao =
      '/checklist/sync/tipos-equipe/relacoes';
  static const checklistTipoVeiculoRelacao =
      '/checklist/sync/tipos-veiculo/relacoes';

  // Turno
  static const turnoAbrir = '/turno/abrir';

  // ============================================================================
  // IDs DE TIPO DE CHECKLIST
  // ============================================================================
  // Estes são os IDs de tipo de checklist (categoria EPI/EPC/Veicular),
  // não de modelos específicos. Configure conforme sua base de dados.

  /// ID do tipo de checklist EPI
  static const int tipoChecklistEpiId = 3;

  /// ID do tipo de checklist EPC
  static const int tipoChecklistEpcId = 2;

  /// ID do tipo de checklist Veicular
  static const int tipoChecklistVeicularId = 1;
}
