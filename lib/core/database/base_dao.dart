import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Classe base abstrata para todos os DAOs do projeto.
///
/// Fornece implementações genéricas de operações CRUD comuns,
/// eliminando duplicação de código e garantindo consistência.
///
/// ## Benefícios:
///
/// - ✅ **DRY**: Elimina ~80 linhas duplicadas por DAO
/// - ✅ **Consistência**: Comportamento padronizado
/// - ✅ **Manutenção**: Bugs corrigidos em 1 lugar
/// - ✅ **Testabilidade**: Testes genéricos reutilizáveis
///
/// ## Uso:
///
/// ```dart
/// @DriftAccessor(tables: [VeiculoTable])
/// class VeiculoDao extends BaseDao<VeiculoTable, VeiculoTableData>
///     with _$VeiculoDaoMixin {
///   VeiculoDao(super.db);
///
///   @override
///   TableInfo<VeiculoTable, VeiculoTableData> get table => db.veiculoTable;
///
///   // Apenas métodos específicos
///   Future<VeiculoTableData?> buscarPorPlaca(String placa) async {
///     return await (select(table)..where((v) => v.placa.equals(placa)))
///         .getSingleOrNull();
///   }
/// }
/// ```
///
/// ## Métodos Fornecidos:
///
/// - `listar()`: Lista todos os registros
/// - `buscarPorId()`: Busca por ID local
/// - `inserir()`: Insere novo registro
/// - `atualizar()`: Atualiza registro existente
/// - `deletar()`: Remove registro por ID
/// - `deletarTodos()`: Limpa tabela
/// - `contar()`: Conta registros
/// - `existe()`: Verifica se registro existe
///
/// ## Tipos Genéricos:
///
/// - `T`: Tipo da tabela (extends Table)
/// - `D`: Tipo dos dados (Data class gerada pelo Drift)
abstract class BaseDao<T extends Table, D> extends DatabaseAccessor<AppDatabase> {
  BaseDao(super.db);

  /// Tabela gerenciada por este DAO.
  ///
  /// Deve ser implementado por cada subclasse apontando para a tabela específica.
  ///
  /// Exemplo:
  /// ```dart
  /// @override
  /// TableInfo<VeiculoTable, VeiculoTableData> get table => db.veiculoTable;
  /// ```
  TableInfo<T, D> get table;

  /// Nome da tabela para logging.
  ///
  /// Usado em logs para identificar qual DAO está executando operação.
  String get tableName => table.actualTableName;

  // ==========================================================================
  // MÉTODOS DE LEITURA
  // ==========================================================================

  /// Lista todos os registros da tabela.
  ///
  /// Retorna lista vazia se não houver registros.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculos = await veiculoDao.listar();
  /// print('Total: ${veiculos.length}');
  /// ```
  Future<List<D>> listar() async {
    try {
      AppLogger.d('Listando todos os registros de $tableName',
          tag: 'BaseDao');
      final result = await select(table).get();
      AppLogger.d('${result.length} registros encontrados em $tableName',
          tag: 'BaseDao');
      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar registros de $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca um registro por ID local.
  ///
  /// Retorna `null` se não encontrar.
  ///
  /// ## Parâmetros:
  /// - `id`: ID local do registro (autoincrement)
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorId(1);
  /// if (veiculo != null) {
  ///   print('Encontrado: ${veiculo.placa}');
  /// }
  /// ```
  Future<D?> buscarPorId(int id) async {
    try {
      AppLogger.d('Buscando registro ID=$id em $tableName', tag: 'BaseDao');
      final result = await (select(table)
            ..where((t) => (t as dynamic).id.equals(id)))
          .getSingleOrNull();

      if (result != null) {
        AppLogger.d('Registro ID=$id encontrado em $tableName', tag: 'BaseDao');
      } else {
        AppLogger.d('Registro ID=$id não encontrado em $tableName',
            tag: 'BaseDao');
      }

      return result;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar registro ID=$id em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca um registro por ID local (lança exceção se não encontrar).
  ///
  /// Use este método quando você tem certeza que o registro existe.
  /// Para busca segura, use `buscarPorId()`.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorIdOuFalha(1);
  /// print('Veículo: ${veiculo.placa}'); // Não precisa verificar null
  /// ```
  Future<D> buscarPorIdOuFalha(int id) async {
    final result = await buscarPorId(id);
    if (result == null) {
      throw Exception('Registro ID=$id não encontrado em $tableName');
    }
    return result;
  }

  /// Verifica se um registro existe por ID.
  ///
  /// ## Exemplo:
  /// ```dart
  /// if (await veiculoDao.existe(1)) {
  ///   print('Veículo existe');
  /// }
  /// ```
  Future<bool> existe(int id) async {
    final result = await buscarPorId(id);
    return result != null;
  }

  // ==========================================================================
  // MÉTODOS DE ESCRITA
  // ==========================================================================

  /// Insere um novo registro.
  ///
  /// Retorna o ID do registro inserido.
  ///
  /// ## Parâmetros:
  /// - `entity`: Companion com dados para inserir
  ///
  /// ## Exemplo:
  /// ```dart
  /// final id = await veiculoDao.inserir(
  ///   VeiculoTableCompanion.insert(
  ///     placa: 'ABC-1234',
  ///     tipoVeiculoId: 1,
  ///   ),
  /// );
  /// print('Veículo inserido com ID: $id');
  /// ```
  Future<int> inserir(Insertable<D> entity) async {
    try {
      AppLogger.d('Inserindo registro em $tableName', tag: 'BaseDao');
      final id = await into(table).insert(entity);
      AppLogger.i('Registro inserido em $tableName com ID=$id', tag: 'BaseDao');
      return id;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao inserir registro em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Insere múltiplos registros em batch.
  ///
  /// Mais eficiente que inserir um por um.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final ids = await veiculoDao.inserirLote([
  ///   VeiculoTableCompanion.insert(placa: 'ABC-1234'),
  ///   VeiculoTableCompanion.insert(placa: 'DEF-5678'),
  /// ]);
  /// print('${ids.length} veículos inseridos');
  /// ```
  Future<List<int>> inserirLote(List<Insertable<D>> entities) async {
    try {
      AppLogger.d('Inserindo ${entities.length} registros em $tableName',
          tag: 'BaseDao');

      final ids = <int>[];
      for (final entity in entities) {
        final id = await into(table).insert(entity);
        ids.add(id);
      }

      AppLogger.i('${ids.length} registros inseridos em $tableName',
          tag: 'BaseDao');
      return ids;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao inserir lote em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Atualiza um registro existente usando replace (requer ID no companion).
  ///
  /// **ATENÇÃO**: Este método usa `replace()` do Drift que requer que o companion
  /// tenha o ID definido e todos os campos obrigatórios preenchidos.
  /// 
  /// Para atualizar apenas campos específicos, use sobrecarga com ID separado.
  ///
  /// Retorna `true` se atualizado com sucesso, `false` se não encontrou ou erro.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final companion = VeiculoTableCompanion(
  ///   id: Value(123),  // ID obrigatório!
  ///   placa: Value('ABC-1234'),
  ///   // ... todos os outros campos
  /// );
  /// final sucesso = await veiculoDao.atualizar(companion);
  /// ```
  Future<bool> atualizar(Insertable<D> entity) async {
    try {
      AppLogger.d('Atualizando registro em $tableName', tag: 'BaseDao');
      final updated = await update(table).replace(entity);
      AppLogger.i('Registro atualizado em $tableName: $updated',
          tag: 'BaseDao');
      return updated;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar registro em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Atualiza um registro específico por ID.
  ///
  /// Permite atualizar apenas os campos fornecidos no companion,
  /// mantendo os demais inalterados.
  ///
  /// ## Parâmetros:
  /// - `id`: ID do registro a atualizar
  /// - `companion`: Companion com os campos a atualizar (ID não necessário)
  ///
  /// ## Retorno:
  /// - `true` se atualizou, `false` se não encontrou
  ///
  /// ## Exemplo:
  /// ```dart
  /// final sucesso = await veiculoDao.atualizarPorId(
  ///   123,
  ///   VeiculoTableCompanion(placa: Value('ABC-1234')),
  /// );
  /// ```
  Future<bool> atualizarPorId(int id, Insertable<D> companion) async {
    try {
      AppLogger.d('Atualizando registro ID=$id em $tableName', tag: 'BaseDao');
      final rowsAffected = await (update(table)
            ..where((tbl) => (tbl as dynamic).id.equals(id)))
          .write(companion);
      final success = rowsAffected > 0;
      AppLogger.d('Registro ${success ? 'atualizado' : 'não encontrado'} em $tableName',
          tag: 'BaseDao');
      return success;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar registro ID=$id em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  // ==========================================================================
  // MÉTODOS DE REMOÇÃO
  // ==========================================================================

  /// Remove um registro por ID.
  ///
  /// Retorna o número de registros removidos (0 ou 1).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final removidos = await veiculoDao.deletar(1);
  /// if (removidos > 0) {
  ///   print('Veículo removido');
  /// }
  /// ```
  Future<int> deletar(int id) async {
    try {
      AppLogger.d('Removendo registro ID=$id de $tableName', tag: 'BaseDao');
      final deleted = await (delete(table)
            ..where((t) => (t as dynamic).id.equals(id)))
          .go();
      AppLogger.i('$deleted registro(s) removido(s) de $tableName',
          tag: 'BaseDao');
      return deleted;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover registro ID=$id de $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove todos os registros da tabela.
  ///
  /// ⚠️ **ATENÇÃO**: Operação destrutiva!
  ///
  /// ## Exemplo:
  /// ```dart
  /// await veiculoDao.deletarTodos();
  /// print('Todos os veículos removidos');
  /// ```
  Future<void> deletarTodos() async {
    try {
      AppLogger.w('⚠️ Removendo TODOS os registros de $tableName',
          tag: 'BaseDao');
      await delete(table).go();
      AppLogger.i('Todos os registros removidos de $tableName',
          tag: 'BaseDao');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover todos os registros de $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ==========================================================================
  // MÉTODOS DE CONTAGEM
  // ==========================================================================

  /// Conta o número total de registros na tabela.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final total = await veiculoDao.contar();
  /// print('Total de veículos: $total');
  /// ```
  Future<int> contar() async {
    try {
      AppLogger.d('Contando registros em $tableName', tag: 'BaseDao');
      final countExpression = table.$columns.first.count();
      final query = selectOnly(table)..addColumns([countExpression]);
      final result = await query.getSingle();
      final count = result.read(countExpression) ?? 0;
      AppLogger.d('Total de registros em $tableName: $count', tag: 'BaseDao');
      return count;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar registros em $tableName',
          tag: 'BaseDao', error: e, stackTrace: stackTrace);
      return 0;
    }
  }

  /// Verifica se a tabela está vazia.
  ///
  /// ## Exemplo:
  /// ```dart
  /// if (await veiculoDao.estaVazia()) {
  ///   print('Nenhum veículo cadastrado');
  /// }
  /// ```
  Future<bool> estaVazia() async {
    final count = await contar();
    return count == 0;
  }
}

