abstract class ApiConstants {
  static const int maxRefreshAttempts = 3;
  static const baseUrl = 'http://192.168.1.211:3001/api';

  static const login = '/auth/login';
  static const refreshToken = '/auth/refresh';


  static const veiculos = '/veiculos/sync';
  static const tiposVeiculo = '/tipo-veiculo/sync';
  static const equipes = '/equipes/sync';
  static const tiposEquipe = '/tipo-equipe/sync';
  static const eletricistas = '/eletricistas/sync';

}
