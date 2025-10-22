import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/base_dao.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Classe base para DAOs de tabelas sincronizáveis.
///
/// Herda todos os métodos de [BaseDao] e adiciona funcionalidades específicas
/// para tabelas que possuem `remote_id` (ID do servidor) e precisam de sincronização.
///
/// ## Funcionalidades Adicionais:
///
/// - ✅ **Busca por Remote ID**: `buscarPorRemoteId()`
/// - ✅ **Upsert**: `inserirOuAtualizar()` baseado em remote_id
/// - ✅ **Sincronização**: `sincronizar()` lista de registros
/// - ✅ **Busca Segura**: Métodos `*OuNull` para evitar exceções
///
/// ## Diferença entre ID e Remote ID:
///
/// ```
/// ID Local (id):
/// - Autoincrement do SQLite
/// - Único no dispositivo
/// - Usado para Foreign Keys locais
///
/// ID Remoto (remote_id):
/// - ID do servidor/API
/// - Usado para sincronização
/// - Pode ser null se não sincronizado
/// ```
///
/// ## Uso:
///
/// ```dart
/// @DriftAccessor(tables: [VeiculoTable])
/// class VeiculoDao extends SyncableDao<VeiculoTable, VeiculoTableData>
///     with _$VeiculoDaoMixin {
///   VeiculoDao(super.db);
///
///   @override
///   TableInfo<VeiculoTable, VeiculoTableData> get table => db.veiculoTable;
///
///   // Herda automaticamente:
///   // - Todos os métodos do BaseDao
///   // - buscarPorRemoteId()
///   // - inserirOuAtualizar()
///   // - sincronizar()
/// }
/// ```
///
/// ## Métodos Herdados do BaseDao:
///
/// - `listar()`, `buscarPorId()`, `inserir()`, `atualizar()`,
///   `deletar()`, `deletarTodos()`, `contar()`, `existe()`
///
/// ## Métodos Adicionados:
///
/// - `buscarPorRemoteId()`: Busca por ID do servidor
/// - `buscarPorRemoteIdOuNull()`: Busca segura
/// - `inserirOuAtualizar()`: Upsert baseado em remote_id
/// - `sincronizar()`: Sincroniza lista de registros
abstract class SyncableDao<T extends SyncableTable, D>
    extends BaseDao<T, D> {
  SyncableDao(super.db);

  // ==========================================================================
  // MÉTODOS DE BUSCA POR REMOTE ID
  // ==========================================================================

  /// Busca um registro por remote ID (ID do servidor).
  ///
  /// Retorna null se não encontrar (não lança exceção).
  ///
  /// ## Parâmetros:
  /// - `remoteId`: ID do servidor
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorRemoteId(100);
  /// if (veiculo != null) {
  ///   print('Veículo do servidor 100: ${veiculo.placa}');
  /// }
  /// ```
  Future<D?> buscarPorRemoteId(int remoteId) async {
    try {
      AppLogger.d('Buscando registro remoteId=$remoteId em $tableName',
          tag: 'SyncableDao');
      final result = await (select(table)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();
      
      if (result != null) {
        AppLogger.d('Registro remoteId=$remoteId encontrado em $tableName',
            tag: 'SyncableDao');
      } else {
        AppLogger.d('Registro remoteId=$remoteId não encontrado em $tableName',
            tag: 'SyncableDao');
      }
      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar remoteId=$remoteId em $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca um registro por remote ID de forma segura.
  ///
  /// Retorna `null` se não encontrar (não lança exceção).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorRemoteIdOuNull(100);
  /// if (veiculo != null) {
  ///   print('Encontrado: ${veiculo.placa}');
  /// } else {
  ///   print('Não encontrado');
  /// }
  /// ```
  Future<D?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      AppLogger.d('Buscando registro remoteId=$remoteId em $tableName',
          tag: 'SyncableDao');
      final result = await (select(table)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();

      if (result != null) {
        AppLogger.d('Registro remoteId=$remoteId encontrado em $tableName',
            tag: 'SyncableDao');
      } else {
        AppLogger.d('Registro remoteId=$remoteId não encontrado em $tableName',
            tag: 'SyncableDao');
      }

      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar remoteId=$remoteId em $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Busca um registro por remote ID lançando exceção se não encontrar.
  ///
  /// Use este método quando você tem certeza que o registro existe.
  /// Para upserts, use `buscarPorRemoteId()` ou `buscarPorRemoteIdOuNull()`.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorRemoteIdOuFalha(100);
  /// print('Veículo: ${veiculo.placa}');
  /// ```
  Future<D> buscarPorRemoteIdOuFalha(int remoteId) async {
    try {
      AppLogger.d('Buscando registro remoteId=$remoteId em $tableName (ou falha)',
          tag: 'SyncableDao');
      final result = await (select(table)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingle();
      AppLogger.d('Registro remoteId=$remoteId encontrado em $tableName',
          tag: 'SyncableDao');
      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar remoteId=$remoteId em $tableName - registro não encontrado',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ==========================================================================
  // MÉTODOS DE SINCRONIZAÇÃO
  // ==========================================================================

  /// Insere ou atualiza um registro baseado no remote ID (Upsert).
  ///
  /// Se já existe registro com o mesmo `remote_id`, atualiza.
  /// Caso contrário, insere novo.
  ///
  /// Retorna o número de linhas afetadas.
  ///
  /// ## Lógica:
  /// 1. Busca registro existente por remote_id
  /// 2. Se existe: UPDATE
  /// 3. Se não existe: INSERT
  ///
  /// ## Exemplo:
  /// ```dart
  /// final linhas = await veiculoDao.inserirOuAtualizar(
  ///   VeiculoTableCompanion(
  ///     remoteId: Value(100),
  ///     placa: Value('ABC-1234'),
  ///     tipoVeiculoId: Value(1),
  ///   ),
  /// );
  /// print('$linhas linha(s) afetada(s)');
  /// ```
  Future<int> inserirOuAtualizar(Insertable<D> entity) async {
    try {
      final companion = entity as UpdateCompanion<D>;
      final remoteId = (companion as dynamic).remoteId.value as int?;

      if (remoteId == null) {
        AppLogger.w('⚠️ Tentando inserirOuAtualizar sem remoteId em $tableName',
            tag: 'SyncableDao');
        // Se não tem remote_id, apenas insere
        return await inserir(entity);
      }

      AppLogger.d('Upsert de remoteId=$remoteId em $tableName',
          tag: 'SyncableDao');

      // Verifica se já existe
      final existente = await buscarPorRemoteIdOuNull(remoteId);

      if (existente != null) {
        // Atualiza registro existente
        AppLogger.d('Registro remoteId=$remoteId já existe, atualizando...',
            tag: 'SyncableDao');

        final linhasAfetadas = await (update(table)
              ..where((t) => t.remoteId.equals(remoteId)))
            .write(companion);

        AppLogger.i(
            'Registro remoteId=$remoteId atualizado em $tableName ($linhasAfetadas linhas)',
            tag: 'SyncableDao');
        return linhasAfetadas;
      } else {
        // Insere novo registro
        AppLogger.d('Registro remoteId=$remoteId não existe, inserindo...',
            tag: 'SyncableDao');

        final id = await into(table).insert(entity);

        AppLogger.i('Registro remoteId=$remoteId inserido em $tableName com ID=$id',
            tag: 'SyncableDao');
        return id;
      }
    } catch (e, stackTrace) {
      AppLogger.e('Erro no upsert de $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Sincroniza uma lista de registros (upsert em lote).
  ///
  /// Executa `inserirOuAtualizar()` para cada registro.
  ///
  /// ## Uso típico:
  /// Sincronizar dados vindos da API.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculosApi = await api.getVeiculos();
  /// await veiculoDao.sincronizar(veiculosApi.map((v) => v.toCompanion()));
  /// print('${veiculosApi.length} veículos sincronizados');
  /// ```
  Future<void> sincronizar(List<Insertable<D>> entities) async {
    try {
      AppLogger.d('Sincronizando ${entities.length} registros em $tableName',
          tag: 'SyncableDao');

      int inseridos = 0;
      int atualizados = 0;

      for (final entity in entities) {
        try {
          final companion = entity as UpdateCompanion<D>;
          final remoteId = (companion as dynamic).remoteId.value as int?;

          if (remoteId != null) {
            final existente = await buscarPorRemoteIdOuNull(remoteId);
            if (existente != null) {
              atualizados++;
            } else {
              inseridos++;
            }
          }

          await inserirOuAtualizar(entity);
        } catch (e) {
          AppLogger.w('⚠️ Erro ao sincronizar registro individual em $tableName: $e',
              tag: 'SyncableDao');
          // Continua sincronizando os outros mesmo se um falhar
        }
      }

      AppLogger.i(
          '✅ Sincronização de $tableName concluída: $inseridos inseridos, $atualizados atualizados',
          tag: 'SyncableDao');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao sincronizar lista em $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca registros não sincronizados.
  ///
  /// Retorna registros onde `sincronizado = false`.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final naoSincronizados = await veiculoDao.buscarNaoSincronizados();
  /// print('${naoSincronizados.length} veículos aguardando sincronização');
  /// ```
  Future<List<D>> buscarNaoSincronizados() async {
    try {
      AppLogger.d('Buscando registros não sincronizados em $tableName',
          tag: 'SyncableDao');
      final result = await (select(table)
            ..where((t) => t.sincronizado.equals(false)))
          .get();
      AppLogger.d('${result.length} registros não sincronizados em $tableName',
          tag: 'SyncableDao');
      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar não sincronizados em $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Marca um registro como sincronizado.
  ///
  /// Atualiza apenas o campo `sincronizado` para `true` e `updatedAt` para agora.
  ///
  /// ## Exemplo:
  /// ```dart
  /// await veiculoDao.marcarComoSincronizado(1);
  /// ```
  Future<bool> marcarComoSincronizado(int id) async {
    try {
      AppLogger.d('Marcando ID=$id como sincronizado em $tableName',
          tag: 'SyncableDao');

      // Usa customUpdate para atualizar campos específicos
      final updated = await customUpdate(
        'UPDATE $tableName SET sincronizado = 1, updated_at = ? WHERE id = ?',
        variables: [
          Variable.withDateTime(DateTime.now()),
          Variable.withInt(id),
        ],
        updates: {table},
      );

      AppLogger.i('Registro ID=$id marcado como sincronizado em $tableName',
          tag: 'SyncableDao');
      return updated > 0;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao marcar ID=$id como sincronizado em $tableName',
          tag: 'SyncableDao', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

