abstract class ApiConstants {
  static const int maxRefreshAttempts = 3;
  static const baseUrl = 'http://192.168.0.248:3001/api';

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

}
