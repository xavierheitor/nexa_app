import 'package:dio/dio.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/datasources/local/turno_dao.dart';
import 'package:nexa_app/data/datasources/local/turno_eletricistas_dao.dart';
import 'package:nexa_app/data/models/turno_table_dto.dart';
import 'package:nexa_app/data/models/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/network/dio_client.dart';
import 'package:nexa_app/core/mixins/logging_mixin.dart' as log_mixin;
import 'package:nexa_app/core/cache/cache_mixin.dart';

/// Repositório unificado para gerenciar turnos e seus eletricistas.
///
/// Este repositório combina operações de turno e relacionamentos turno-eletricista
/// em uma única interface, já que eles sempre trabalham juntos no contexto
/// de abertura e fechamento de turnos.
class TurnoRepo with log_mixin.LoggingMixin, CacheMixin {
  // ignore: unused_field
  final DioClient _dio;
  final AppDatabase _db;
  late final TurnoDao _turnoDao;
  late final TurnoEletricistasDao _turnoEletricistasDao;

  TurnoRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _turnoDao = TurnoDao(_db);
    _turnoEletricistasDao = TurnoEletricistasDao(_db);
  }

  @override
  String get repositoryName => 'TurnoRepository';

  // ============================================================================
  // OPERAÇÕES DE TURNO
  // ============================================================================

  Future<List<TurnoTableDto>> listarTurnos() async {
    return await executeWithLogging(
      operationName: 'listarTurnos',
      operation: () async {
        return await listarComCache(
          'turnos',
          () async => await _turnoDao.listar(),
        );
      },
    );
  }

  Future<TurnoTableDto?> buscarTurnoPorId(int id) async {
    return await executeWithLogging(
      operationName: 'buscarTurnoPorId',
      operation: () async => await _turnoDao.buscarPorId(id),
    );
  }

  Future<TurnoTableDto?> buscarTurnoPorRemoteId(int remoteId) async {
    return await executeWithLogging(
      operationName: 'buscarTurnoPorRemoteId',
      operation: () async => await _turnoDao.buscarPorRemoteId(remoteId),
    );
  }

  Future<TurnoTableDto?> buscarTurnoAtivo() async {
    return await executeWithLogging(
      operationName: 'buscarTurnoAtivo',
      operation: () async {
        return await cacheExecute(
          'turno_ativo',
          'buscarTurnoAtivo',
          () async => await _turnoDao.buscarTurnoAtivo(),
        );
      },
    );
  }

  Future<List<TurnoTableDto>> buscarTurnosPorSituacao(
      SituacaoTurno situacao) async {
    return await executeWithLogging(
      operationName: 'buscarTurnosPorSituacao',
      operation: () async => await _turnoDao.buscarPorSituacao(situacao),
    );
  }

  Future<List<TurnoTableDto>> buscarTurnosPorVeiculo(int veiculoId) async {
    return await executeWithLogging(
      operationName: 'buscarTurnosPorVeiculo',
      operation: () async => await _turnoDao.buscarPorVeiculo(veiculoId),
    );
  }

  Future<List<TurnoTableDto>> buscarTurnosPorEquipe(int equipeId) async {
    return await executeWithLogging(
      operationName: 'buscarTurnosPorEquipe',
      operation: () async => await _turnoDao.buscarPorEquipe(equipeId),
    );
  }

  Future<int> salvarTurno(TurnoTableDto turno) async {
    return await executeWithLogging(
      operationName: 'salvarTurno',
      operation: () async => await _turnoDao.inserirOuAtualizar(turno),
    );
  }

  Future<bool> atualizarTurno(TurnoTableDto turno) async {
    return await executeWithLogging(
      operationName: 'atualizarTurno',
      operation: () async => await _turnoDao.atualizar(turno),
    );
  }

  Future<bool> deletarTurno(int turnoId) async {
    return await executeWithLogging(
      operationName: 'deletarTurno',
      operation: () async => await _turnoDao.deletar(turnoId),
    );
  }

  Future<int> contarTurnos() async {
    return await executeWithLogging(
      operationName: 'contarTurnos',
      operation: () async => await _turnoDao.contar(),
    );
  }

  Future<int> contarTurnosPorSituacao(SituacaoTurno situacao) async {
    return await executeWithLogging(
      operationName: 'contarTurnosPorSituacao',
      operation: () async => await _turnoDao.contarPorSituacao(situacao),
    );
  }

  // ============================================================================
  // OPERAÇÕES DE ELETRICISTAS DO TURNO
  // ============================================================================

  Future<List<TurnoEletricistasTableDto>> buscarEletricistasDoTurno(
      int turnoId) async {
    return await executeWithLogging(
      operationName: 'buscarEletricistasDoTurno',
      operation: () async =>
          await _turnoEletricistasDao.buscarPorTurno(turnoId),
    );
  }

  Future<List<TurnoEletricistasTableDto>> buscarTurnosDoEletricista(
      int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'buscarTurnosDoEletricista',
      operation: () async =>
          await _turnoEletricistasDao.buscarPorEletricista(eletricistaId),
    );
  }

  Future<bool> eletricistaEstaNoTurno(int turnoId, int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'eletricistaEstaNoTurno',
      operation: () async => await _turnoEletricistasDao.eletricistaEstaNoTurno(
          turnoId, eletricistaId),
    );
  }

  Future<bool> validarAberturaTurnoOnline({
    required int turnoId,
    int? turnoRemoteId,
  }) async {
    return await executeWithLogging(
      operationName: 'validarAberturaTurnoOnline',
      operation: () async {
        AppLogger.d(
            'Validando abertura do turno (id=$turnoId, remoteId=$turnoRemoteId)',
            tag: repositoryName);
        return true;
      },
    );
  }

  Future<int> enviarAberturaTurno(Map<String, dynamic> payload) async {
    return await executeWithLogging(
      operationName: 'enviarAberturaTurno',
      logLevel: log_mixin.LogLevel.info,
      operation: () async {
        try {
          final response =
              await _dio.post(ApiConstants.turnoAbrir, data: payload);

          final status = response.statusCode ?? 0;
          if (status != 200 && status != 201) {
            throw Exception('Erro ao enviar abertura do turno. Status $status');
          }

          final data = response.data;
          if (data is Map<String, dynamic>) {
            int? remoteId;

            if (data['remoteId'] != null) {
              remoteId = data['remoteId'] as int?;
            } else if (data['data'] is Map<String, dynamic>) {
              final dataObj = data['data'] as Map<String, dynamic>;
              if (dataObj['id'] != null) {
                remoteId = dataObj['id'] as int?;
              }
            } else if (data['id'] != null) {
              remoteId = data['id'] as int?;
            }

            if (remoteId != null) {
              AppLogger.d('✅ Abertura registrada com remoteId=$remoteId',
                  tag: repositoryName);
              return remoteId;
            }
          }

          AppLogger.e('❌ Estrutura da resposta não reconhecida: $data',
              tag: repositoryName);
          throw Exception(
              'Resposta da API não contém o identificador do turno');
        } on DioException catch (dioError) {
          final httpStatus = dioError.response?.statusCode ?? 0;
          final responseData = dioError.response?.data;

          AppLogger.e('❌ Erro Dio - HTTP Status: $httpStatus',
              tag: repositoryName, error: dioError);

          if (responseData != null) {
            AppLogger.v('📋 Resposta completa da API: $responseData',
                tag: repositoryName);
          }

          int statusCode = httpStatus;
          if (responseData is Map<String, dynamic> &&
              responseData['statusCode'] != null) {
            statusCode = responseData['statusCode'] as int;
            AppLogger.d('📋 StatusCode da API: $statusCode (HTTP: $httpStatus)',
                tag: repositoryName);
          }

          final errorMessage = _extrairMensagemErro(statusCode, responseData);
          throw TurnoAberturaException(
            statusCode: statusCode,
            message: errorMessage,
            originalError: dioError,
            responseData: responseData,
          );
        }
      },
    );
  }

  /// Extrai mensagem de erro personalizada baseada no status e resposta da API
  String _extrairMensagemErro(int statusCode, dynamic responseData) {
    // Tenta extrair mensagem específica da resposta da API
    if (responseData is Map<String, dynamic>) {
      // Estrutura possível: { "message": "...", "error": "...", "statusCode": 422, "data": {...} }
      // Ou: { "statusCode": 400, "message": { "message": [...], "error": "..." } }

      String? extractedMessage;

      // 1. Tenta extrair 'error' direto (string)
      final directError = responseData['error'];
      if (directError is String && directError.isNotEmpty) {
        extractedMessage = directError;
      }

      // 2. Tenta extrair 'message' - pode ser string ou objeto
      final messageField = responseData['message'];
      if (messageField is String && messageField.isNotEmpty) {
        extractedMessage = messageField;
      } else if (messageField is Map<String, dynamic>) {
        // Estrutura aninhada: message.message pode ser uma lista ou string, message.error é string
        final nestedError = messageField['error'] as String?;
        final nestedMessage = messageField['message'];
        final nestedMessageList = nestedMessage is List ? nestedMessage : null;

        if (nestedError != null && nestedError.isNotEmpty) {
          extractedMessage = nestedError;
        } else if (nestedMessageList != null && nestedMessageList.isNotEmpty) {
          // Pega o primeiro erro da lista de validação
          final firstError = nestedMessageList.first;
          if (firstError is String) {
            extractedMessage = firstError;
          } else {
            // Se for lista de strings, junta todas
            final errorStrings = nestedMessageList
                .whereType<String>()
                .cast<String>()
                .toList();
            if (errorStrings.isNotEmpty) {
              extractedMessage = errorStrings.join('; ');
            }
          }
        }
      }

      // 3. Fallback para 'detail'
      if (extractedMessage == null) {
        final detailMessage = responseData['detail'] as String?;
        if (detailMessage != null && detailMessage.isNotEmpty) {
          extractedMessage = detailMessage;
        }
      }

      // Se conseguiu extrair uma mensagem, retorna
      if (extractedMessage != null && extractedMessage.isNotEmpty) {
        return extractedMessage;
      }
    }

    // Fallback para mensagens baseadas no status code
    switch (statusCode) {
      case 400:
        return 'Erro de validação: Verifique os dados enviados';
      case 409:
        return 'Conflito: Já existe turno aberto com este veículo, equipe ou eletricista';
      case 422:
        return 'Dados inválidos: Verifique as informações do turno';
      case 500:
        return 'Erro interno do servidor. Tente novamente mais tarde';
      case 503:
        return 'Serviço temporariamente indisponível';
      default:
        return 'Erro ao abrir turno. Status: $statusCode';
    }
  }

  Future<int> adicionarEletricistaAoTurno(
      int turnoId, int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'adicionarEletricistaAoTurno',
      operation: () async {
        final relacionamento = TurnoEletricistasTableDto(
          id: 0,
          turnoId: turnoId,
          eletricistaId: eletricistaId,
        );
        return await _turnoEletricistasDao.inserir(relacionamento);
      },
    );
  }

  Future<void> adicionarEletricistasAoTurno(
      int turnoId, List<int> eletricistaIds) async {
    return await executeVoidWithLogging(
      operationName: 'adicionarEletricistasAoTurno',
      operation: () async {
        final relacionamentos = eletricistaIds
            .map((eletricistaId) => TurnoEletricistasTableDto(
                  id: 0,
                  turnoId: turnoId,
                  eletricistaId: eletricistaId,
                ))
            .toList();
        await _turnoEletricistasDao.inserirMultiplos(relacionamentos);
      },
    );
  }

  Future<bool> removerEletricistaDoTurno(int turnoId, int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'removerEletricistaDoTurno',
      operation: () async {
        final relacionamentos =
            await _turnoEletricistasDao.buscarPorTurno(turnoId);
        final relacionamento = relacionamentos.firstWhere(
          (r) => r.eletricistaId == eletricistaId,
          orElse: () => throw Exception('Eletricista não encontrado no turno'),
        );
        return await _turnoEletricistasDao.deletar(relacionamento.id);
      },
    );
  }

  Future<int> removerTodosEletricistasDoTurno(int turnoId) async {
    return await executeWithLogging(
      operationName: 'removerTodosEletricistasDoTurno',
      operation: () async =>
          await _turnoEletricistasDao.deletarPorTurno(turnoId),
    );
  }

  Future<int> contarEletricistasDoTurno(int turnoId) async {
    return await executeWithLogging(
      operationName: 'contarEletricistasDoTurno',
      operation: () async =>
          await _turnoEletricistasDao.contarPorTurno(turnoId),
    );
  }

  Future<int> contarTurnosDoEletricista(int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'contarTurnosDoEletricista',
      operation: () async =>
          await _turnoEletricistasDao.contarPorEletricista(eletricistaId),
    );
  }

  // ============================================================================
  // OPERAÇÕES DE MOTORISTA
  // ============================================================================

  Future<TurnoEletricistasTableDto?> buscarMotoristaDoTurno(int turnoId) async {
    return await executeWithLogging(
      operationName: 'buscarMotoristaDoTurno',
      operation: () async {
        final result =
            await _turnoEletricistasDao.buscarMotoristaPorTurno(turnoId);
        return result != null
            ? TurnoEletricistasTableDto.fromTable(result)
            : null;
      },
    );
  }

  Future<void> definirMotorista(int turnoId, int eletricistaId) async {
    return await executeVoidWithLogging(
      operationName: 'definirMotorista',
      operation: () async {
        await _turnoEletricistasDao.definirMotorista(turnoId, eletricistaId);
        AppLogger.i('Motorista definido com sucesso', tag: repositoryName);
      },
    );
  }

  Future<void> removerMotorista(int turnoId) async {
    return await executeVoidWithLogging(
      operationName: 'removerMotorista',
      operation: () async {
        await _turnoEletricistasDao.removerMotorista(turnoId);
        AppLogger.i('Motorista removido com sucesso', tag: repositoryName);
      },
    );
  }

  Future<bool> ehMotorista(int turnoId, int eletricistaId) async {
    return await executeWithLogging(
      operationName: 'ehMotorista',
      operation: () async =>
          await _turnoEletricistasDao.ehMotorista(turnoId, eletricistaId),
    );
  }

  // ============================================================================
  // OPERAÇÕES COMPOSTAS (TURNO + ELETRICISTAS)
  // ============================================================================

  /// Abre um novo turno com eletricistas.
  ///
  /// Cria um turno e adiciona os eletricistas especificados em uma transação.
  /// Se `motoristaId` for fornecido, marca esse eletricista como motorista.
  Future<int> abrirTurno({
    required int veiculoId,
    required int equipeId,
    required int kmInicial,
    required List<int> eletricistaIds,
    int? motoristaId,
    String? latitude,
    String? longitude,
  }) async {
    return await executeWithLogging(
      operationName: 'abrirTurno',
      logLevel: log_mixin.LogLevel.info,
      operation: () async {
        final turno = TurnoTableDto(
          id: 0,
          veiculoId: veiculoId,
          equipeId: equipeId,
          kmInicial: kmInicial,
          horaInicio: DateTime.now(),
          situacaoTurno: SituacaoTurno.emAbertura,
          latitude: latitude,
          longitude: longitude,
        );

        final turnoId = await salvarTurno(turno);

        if (eletricistaIds.isNotEmpty) {
          await adicionarEletricistasAoTurno(turnoId, eletricistaIds);
        }

        if (motoristaId != null) {
          await definirMotorista(turnoId, motoristaId);
          AppLogger.d('Motorista $motoristaId definido para turno $turnoId',
              tag: repositoryName);
        }

        AppLogger.d('Turno $turnoId aberto com sucesso', tag: repositoryName);
        return turnoId;
      },
    );
  }

  Future<bool> fecharTurno(
    int turnoId, {
    int? kmFinal,
    String? latitude,
    String? longitude,
  }) async {
    return await executeWithLogging(
      operationName: 'fecharTurno',
      logLevel: log_mixin.LogLevel.info,
      operation: () async {
        final turno = await buscarTurnoPorId(turnoId);
        if (turno == null) {
          throw Exception('Turno não encontrado');
        }

        // Primeiro tenta enviar para a API
        try {
          await _enviarFechamentoParaApi(turnoId, kmFinal, latitude, longitude);

          // Se chegou aqui, a API confirmou o fechamento
          AppLogger.i('API confirmou fechamento do turno $turnoId',
              tag: repositoryName);

          // Agora atualiza localmente
          final turnoAtualizado = turno.copyWith(
            situacaoTurno: SituacaoTurno.fechado,
            horaFim: DateTime.now(),
            kmFinal: kmFinal,
            latitude: latitude,
            longitude: longitude,
          );

          final sucesso = await atualizarTurno(turnoAtualizado);
          if (sucesso) {
            // Invalida cache do turno ativo para forçar recarregamento
            await invalidarCacheAposSincronizacao('turno_ativo');
            AppLogger.d('Turno $turnoId fechado com sucesso',
                tag: repositoryName);
            AppLogger.d('🔄 Cache do turno ativo invalidado após fechamento',
                tag: repositoryName);
          }
          return sucesso;
          
        } catch (e) {
          // Se a API falhou, NÃO fecha o turno localmente
          AppLogger.e('Erro ao enviar fechamento para API: $e',
              tag: repositoryName);
          AppLogger.w(
              'Turno $turnoId NÃO será fechado localmente devido ao erro da API',
              tag: repositoryName);

          // Re-lança o erro para que o controller saiba que falhou
          rethrow;
        }
      },
    );
  }

  /// Envia o fechamento do turno para a API
  Future<void> _enviarFechamentoParaApi(
    int turnoId,
    int? kmFinal,
    String? latitude,
    String? longitude,
  ) async {
    try {
      // Busca o turno para obter o remoteId
      final turno = await buscarTurnoPorId(turnoId);
      if (turno == null) {
        throw Exception('Turno não encontrado');
      }

      if (turno.remoteId == null) {
        throw Exception(
            'Turno não possui remoteId - não foi sincronizado com a API');
      }

      final payload = {
        'turnoId': turno.remoteId, // Envia o remoteId da API, não o ID local
        'kmFinal': kmFinal,
        'latitude': latitude,
        'longitude': longitude,
        'horaFim': DateTime.now().toIso8601String(),
      };

      AppLogger.d(
          '📤 Enviando fechamento para API - RemoteID: ${turno.remoteId}, LocalID: $turnoId',
          tag: repositoryName);

      final response = await _dio.post(
        '/turno/fechar', // Será resolvido pelo interceptor
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao fechar turno na API: ${response.statusCode}');
      }

      AppLogger.i('Turno $turnoId enviado para API com sucesso',
          tag: repositoryName);
    } catch (e) {
      AppLogger.e('Erro ao enviar fechamento para API: $e',
          tag: repositoryName);
      rethrow; // Re-lança para que o método fecharTurno saiba que houve erro
    }
  }


  Future<Map<String, dynamic>?> buscarTurnoCompleto(int turnoId) async {
    return await executeWithLogging(
      operationName: 'buscarTurnoCompleto',
      operation: () async {
        final turno = await buscarTurnoPorId(turnoId);
        if (turno == null) return null;

        final eletricistas = await buscarEletricistasDoTurno(turnoId);
        final eletricistaIds =
            eletricistas.map((e) => e.eletricistaId).toList();

        return {
          'turno': turno,
          'eletricistaIds': eletricistaIds,
        };
      },
    );
  }

  Future<bool> temTurnoAtivo() async {
    return await executeWithLogging(
      operationName: 'temTurnoAtivo',
      operation: () async {
        final turnoAtivo = await buscarTurnoAtivo();
        return turnoAtivo != null;
      },
    );
  }

  /// Abre o turno remotamente enviando todos os dados para a API.
  ///
  /// Este método:
  /// 1. Busca o turno ativo em abertura
  /// 2. Coleta todos os checklists preenchidos
  /// 3. Empacota tudo em um payload
  /// 4. Envia para a API
  /// 5. Atualiza o status do turno para "aberto"
  /// 6. Salva o remoteId retornado pela API
  Future<bool> abrirTurnoRemoto() async {
    try {
      return await executeWithLogging(
        operationName: 'abrirTurnoRemoto',
        logLevel: log_mixin.LogLevel.info,
        operation: () async {
          AppLogger.d('🚀 [ABERTURA REMOTA] Iniciando...', tag: repositoryName);

          final turnoAtivo = await buscarTurnoAtivo();
          if (turnoAtivo == null) {
            AppLogger.e('❌ Nenhum turno em abertura encontrado',
                tag: repositoryName);
            throw Exception('Nenhum turno em abertura encontrado');
          }

          if (turnoAtivo.situacaoTurno != SituacaoTurno.emAbertura) {
            AppLogger.e('❌ Turno não está em situação de abertura',
                tag: repositoryName);
            throw Exception('Turno não está em situação de abertura');
          }

          AppLogger.d('📦 Turno encontrado: ${turnoAtivo.id}',
              tag: repositoryName);

          final eletricistas = await buscarEletricistasDoTurno(turnoAtivo.id);
          AppLogger.d('👷 ${eletricistas.length} eletricistas encontrados',
              tag: repositoryName);

          final payload = {
            'turno': {
              'veiculoId': turnoAtivo.veiculoId,
              'equipeId': turnoAtivo.equipeId,
              'kmInicial': turnoAtivo.kmInicial,
              'horaInicio': turnoAtivo.horaInicio.toIso8601String(),
            },
            'eletricistas': eletricistas
                .map((e) => {
                      'eletricistaId': e.eletricistaId,
                      'motorista': e.motorista,
                    })
                .toList(),
          };

          AppLogger.d('📤 Enviando payload para API...', tag: repositoryName);

          final response =
              await _dio.post(ApiConstants.turnoAbrir, data: payload);

          if (response.statusCode != 200 && response.statusCode != 201) {
            AppLogger.e('❌ Erro na resposta da API: ${response.statusCode}',
                tag: repositoryName);
            throw Exception('Erro ao abrir turno na API');
          }

          final responseData = response.data;
          if (responseData == null) {
            AppLogger.e('❌ API retornou resposta vazia', tag: repositoryName);
            throw Exception('API retornou resposta vazia');
          }

          final remoteId = responseData['id'] as int?;
          if (remoteId == null) {
            AppLogger.e('❌ API não retornou ID do turno', tag: repositoryName);
            throw Exception('API não retornou ID do turno');
          }

          AppLogger.d('✅ Turno criado na API com ID: $remoteId',
              tag: repositoryName);

          final turnoAtualizado = TurnoTableDto(
            id: turnoAtivo.id,
            remoteId: remoteId,
            veiculoId: turnoAtivo.veiculoId,
            equipeId: turnoAtivo.equipeId,
            horaInicio: turnoAtivo.horaInicio,
            horaFim: turnoAtivo.horaFim,
            kmInicial: turnoAtivo.kmInicial,
            kmFinal: turnoAtivo.kmFinal,
            latitude: turnoAtivo.latitude,
            longitude: turnoAtivo.longitude,
            situacaoTurno: SituacaoTurno.aberto,
          );

          await _turnoDao.atualizar(turnoAtualizado);

          // Invalida cache do turno ativo para forçar recarregamento
          await invalidarCacheAposSincronizacao('turno_ativo');

          AppLogger.i('✅ Turno aberto com sucesso! RemoteID: $remoteId',
              tag: repositoryName);
          return true;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao abrir turno remotamente',
          tag: repositoryName, error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

/// Exceção customizada para erros específicos de abertura de turno
class TurnoAberturaException implements Exception {
  final int statusCode;
  final String message;
  final DioException? originalError;
  final dynamic responseData;

  TurnoAberturaException({
    required this.statusCode,
    required this.message,
    this.originalError,
    this.responseData,
  });

  @override
  String toString() {
    return 'TurnoAberturaException(statusCode: $statusCode, message: $message)';
  }

  /// Verifica se é um erro de conflito (409) - turno já existe
  bool get isConflictError => statusCode == 409;

  /// Verifica se é um erro de validação (400/422)
  bool get isValidationError => statusCode == 400 || statusCode == 422;

  /// Verifica se é um erro de servidor (5xx)
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Obtém dados extras da resposta da API (ex: turnoLocalId, timestamp)
  Map<String, dynamic>? get apiData {
    if (responseData is Map<String, dynamic>) {
      return responseData['data'] as Map<String, dynamic>?;
    }
    return null;
  }

  /// Obtém o ID do turno local dos dados da API
  int? get turnoLocalId {
    final data = apiData;
    if (data != null && data['turnoLocalId'] != null) {
      return data['turnoLocalId'] as int?;
    }
    return null;
  }
}
