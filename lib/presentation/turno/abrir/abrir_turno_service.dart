import 'package:get/get.dart';
import 'package:nexa_app/data/models/eletricista_table_dto.dart';
import 'package:nexa_app/data/models/equipe_table_dto.dart';
import 'package:nexa_app/data/models/veiculo_table_dto.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/presentation/turno/abrir/models/abrir_turno_dados.dart';

/// Serviço responsável por buscar dados necessários para abertura de turno.
///
/// Centraliza a lógica de busca de veículos, eletricistas e equipes,
/// fornecendo uma interface limpa para o controller de abertura de turno.
///
/// ## Funcionalidades:
/// - Busca veículos disponíveis
/// - Busca eletricistas disponíveis
/// - Busca equipes disponíveis
/// - Tratamento de erros centralizado
/// - Logs detalhados para debugging
class AbrirTurnoService extends GetxService {
  // ============================================================================
  // DEPENDÊNCIAS
  // ============================================================================

  /// Repositório de veículos disponível para consultas.
  final VeiculoRepo _veiculoRepo;

  /// Repositório responsável pelas informações dos eletricistas.
  final EletricistaRepo _eletricistaRepo;

  /// Repositório com os dados de equipes persistidos localmente.
  final EquipeRepo _equipeRepo;

  // ============================================================================
  // CACHE EM MEMÓRIA
  // ============================================================================

  /// Cache imutável utilizado para reaproveitar a última carga de veículos.
  List<VeiculoTableDto>? _veiculosCache;

  /// Cache imutável utilizado para reaproveitar a última carga de eletricistas.
  List<EletricistaTableDto>? _eletricistasCache;

  /// Cache imutável utilizado para reaproveitar a última carga de equipes.
  List<EquipeTableDto>? _equipesCache;

  // ============================================================================
  // CONSTRUTOR
  // ============================================================================

  /// Injeta explicitamente os repositórios necessários para abertura de turno.
  ///
  /// Essa abordagem facilita a reutilização do serviço em testes e em outros
  /// módulos, uma vez que dependências podem ser substituídas por fakes sem
  /// acoplamento a chamadas diretas de `Get.find()`.
  AbrirTurnoService({
    required VeiculoRepo veiculoRepo,
    required EletricistaRepo eletricistaRepo,
    required EquipeRepo equipeRepo,
  })  : _veiculoRepo = veiculoRepo,
        _eletricistaRepo = eletricistaRepo,
        _equipeRepo = equipeRepo;

  // ============================================================================
  // MÉTODOS PÚBLICOS
  // ============================================================================

  /// Busca veículos disponíveis para abertura de turno com suporte a cache.
  ///
  /// Defina [forceRefresh] como `true` para obrigar uma nova consulta aos
  /// repositórios ignorando os dados mantidos em memória.
  Future<List<VeiculoTableDto>> buscarVeiculos({
    bool forceRefresh = false,
  }) async {
    return _carregarLista<VeiculoTableDto>(
      entidade: 'veículos',
      cache: _veiculosCache,
      forceRefresh: forceRefresh,
      loader: _veiculoRepo.listar,
      cacheSetter: (dados) => _veiculosCache = dados,
    );
  }

  /// Busca eletricistas elegíveis para abertura de turno, reutilizando cache
  /// quando disponível.
  Future<List<EletricistaTableDto>> buscarEletricistas({
    bool forceRefresh = false,
  }) async {
    return _carregarLista<EletricistaTableDto>(
      entidade: 'eletricistas',
      cache: _eletricistasCache,
      forceRefresh: forceRefresh,
      loader: _eletricistaRepo.listar,
      cacheSetter: (dados) => _eletricistasCache = dados,
    );
  }

  /// Busca equipes disponíveis, reaproveitando a última carga sempre que
  /// possível.
  Future<List<EquipeTableDto>> buscarEquipes({
    bool forceRefresh = false,
  }) async {
    return _carregarLista<EquipeTableDto>(
      entidade: 'equipes',
      cache: _equipesCache,
      forceRefresh: forceRefresh,
      loader: _equipeRepo.listar,
      cacheSetter: (dados) => _equipesCache = dados,
    );
  }

  /// Recupera todos os dados necessários para abertura de turno em uma única
  /// chamada, garantindo consistência entre as listas utilizadas na UI.
  Future<AbrirTurnoDados> buscarDadosIniciais({
    bool forceRefresh = false,
  }) async {
    try {
      AppLogger.d('Buscando pacote completo de dados para abertura de turno',
          tag: 'AbrirTurnoService');

      final resultados = await Future.wait([
        buscarVeiculos(forceRefresh: forceRefresh),
        buscarEletricistas(forceRefresh: forceRefresh),
        buscarEquipes(forceRefresh: forceRefresh),
      ]);

      final dados = AbrirTurnoDados(
        veiculos: resultados[0] as List<VeiculoTableDto>,
        eletricistas: resultados[1] as List<EletricistaTableDto>,
        equipes: resultados[2] as List<EquipeTableDto>,
      );

      AppLogger.d('Pacote carregado com sucesso', tag: 'AbrirTurnoService');
      return dados;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar dados iniciais',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Limpa o cache em memória, útil em fluxos que exigem refetch explícito.
  void limparCache() {
    AppLogger.d('Limpando cache do AbrirTurnoService',
        tag: 'AbrirTurnoService');
    _veiculosCache = null;
    _eletricistasCache = null;
    _equipesCache = null;
  }

  // ============================================================================
  // MÉTODOS PRIVADOS
  // ============================================================================

  /// Carrega uma lista do repositório associado, reaproveitando o cache local.
  ///
  /// A função recebe um loader tipado que será executado apenas quando não
  /// houver cache disponível ou quando [forceRefresh] estiver habilitado.
  Future<List<T>> _carregarLista<T>({
    required String entidade,
    required List<T>? cache,
    required bool forceRefresh,
    required Future<List<T>> Function() loader,
    required void Function(List<T>) cacheSetter,
  }) async {
    if (!forceRefresh && cache != null) {
      AppLogger.d(
        'Reutilizando cache de $entidade (${cache.length} itens)',
        tag: 'AbrirTurnoService',
      );
      return cache;
    }

    try {
      AppLogger.d('Buscando $entidade para abertura de turno',
          tag: 'AbrirTurnoService');

      final dados = await loader();
      final listaImutavel = List<T>.unmodifiable(dados);
      cacheSetter(listaImutavel);

      AppLogger.d('${listaImutavel.length} $entidade encontrados',
          tag: 'AbrirTurnoService');
      return listaImutavel;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar $entidade',
          tag: 'AbrirTurnoService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
