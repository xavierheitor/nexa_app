import 'package:dio/dio.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/turno_dao.dart';
import 'package:nexa_app/core/database/daos/turno_eletricistas_dao.dart';
import 'package:nexa_app/core/domain/dto/turno_table_dto.dart';
import 'package:nexa_app/core/domain/dto/turno_eletricistas_table_dto.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

/// Repositório unificado para gerenciar turnos e seus eletricistas.
///
/// Este repositório combina operações de turno e relacionamentos turno-eletricista
/// em uma única interface, já que eles sempre trabalham juntos no contexto
/// de abertura e fechamento de turnos.
class TurnoRepo {
  // ignore: unused_field
  final DioClient _dio; // TODO: Será usado para sincronização com API
  final AppDatabase _db;
  late final TurnoDao _turnoDao;
  late final TurnoEletricistasDao _turnoEletricistasDao;

  TurnoRepo({required DioClient dio, required AppDatabase db})
      : _dio = dio,
        _db = db {
    _turnoDao = TurnoDao(_db);
    _turnoEletricistasDao = TurnoEletricistasDao(_db);
  }

  // ============================================================================
  // OPERAÇÕES DE TURNO
  // ============================================================================

  /// Lista todos os turnos.
  Future<List<TurnoTableDto>> listarTurnos() async {
    try {
      AppLogger.d('Listando todos os turnos', tag: 'TurnoRepo');
      return await _turnoDao.listar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao listar turnos',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID.
  Future<TurnoTableDto?> buscarTurnoPorId(int id) async {
    try {
      AppLogger.d('Buscando turno por ID: $id', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorId(id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por ID',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno por ID remoto.
  Future<TurnoTableDto?> buscarTurnoPorRemoteId(int remoteId) async {
    try {
      AppLogger.d('Buscando turno por remote ID: $remoteId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorRemoteId(remoteId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno por remote ID',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno ativo (em abertura).
  Future<TurnoTableDto?> buscarTurnoAtivo() async {
    try {
      AppLogger.d('Buscando turno ativo', tag: 'TurnoRepo');
      return await _turnoDao.buscarTurnoAtivo();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno ativo',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por situação.
  Future<List<TurnoTableDto>> buscarTurnosPorSituacao(
      SituacaoTurno situacao) async {
    try {
      AppLogger.d('Buscando turnos por situação: ${situacao.name}',
          tag: 'TurnoRepo');
      return await _turnoDao.buscarPorSituacao(situacao);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por situação',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por veículo.
  Future<List<TurnoTableDto>> buscarTurnosPorVeiculo(int veiculoId) async {
    try {
      AppLogger.d('Buscando turnos por veículo: $veiculoId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorVeiculo(veiculoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por veículo',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos por equipe.
  Future<List<TurnoTableDto>> buscarTurnosPorEquipe(int equipeId) async {
    try {
      AppLogger.d('Buscando turnos por equipe: $equipeId', tag: 'TurnoRepo');
      return await _turnoDao.buscarPorEquipe(equipeId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos por equipe',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Salva um turno (insere ou atualiza).
  Future<int> salvarTurno(TurnoTableDto turno) async {
    try {
      AppLogger.d('Salvando turno', tag: 'TurnoRepo');
      return await _turnoDao.inserirOuAtualizar(turno);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao salvar turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Atualiza um turno existente.
  Future<bool> atualizarTurno(TurnoTableDto turno) async {
    try {
      AppLogger.d('Atualizando turno: ${turno.id}', tag: 'TurnoRepo');
      return await _turnoDao.atualizar(turno);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao atualizar turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Deleta um turno.
  Future<bool> deletarTurno(int turnoId) async {
    try {
      AppLogger.d('Deletando turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoDao.deletar(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao deletar turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta total de turnos.
  Future<int> contarTurnos() async {
    try {
      AppLogger.d('Contando turnos', tag: 'TurnoRepo');
      return await _turnoDao.contar();
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos por situação.
  Future<int> contarTurnosPorSituacao(SituacaoTurno situacao) async {
    try {
      AppLogger.d('Contando turnos por situação: ${situacao.name}',
          tag: 'TurnoRepo');
      return await _turnoDao.contarPorSituacao(situacao);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos por situação',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // OPERAÇÕES DE ELETRICISTAS DO TURNO
  // ============================================================================

  /// Busca eletricistas de um turno específico.
  Future<List<TurnoEletricistasTableDto>> buscarEletricistasDoTurno(
      int turnoId) async {
    try {
      AppLogger.d('Buscando eletricistas do turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.buscarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar eletricistas do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turnos de um eletricista específico.
  Future<List<TurnoEletricistasTableDto>> buscarTurnosDoEletricista(
      int eletricistaId) async {
    try {
      AppLogger.d('Buscando turnos do eletricista: $eletricistaId',
          tag: 'TurnoRepo');
      return await _turnoEletricistasDao.buscarPorEletricista(eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turnos do eletricista',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se um eletricista está em um turno específico.
  Future<bool> eletricistaEstaNoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d(
          'Verificando se eletricista $eletricistaId está no turno $turnoId',
          tag: 'TurnoRepo');
      return await _turnoEletricistasDao.eletricistaEstaNoTurno(
          turnoId, eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar se eletricista está no turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Valida junto ao backend se é permitido liberar o turno para execução.
  Future<bool> validarAberturaTurnoOnline({
    required int turnoId,
    int? turnoRemoteId,
  }) async {
    try {
      AppLogger.d(
        'Validando abertura do turno (id=$turnoId, remoteId=$turnoRemoteId)',
        tag: 'TurnoRepo',
      );

      // TODO: Integrar com API real. Enquanto não disponível, assume sucesso.
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao validar abertura do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Envia o payload completo de abertura de turno para a API e retorna o
  /// identificador remoto atribuído ao turno.
  Future<int> enviarAberturaTurno(Map<String, dynamic> payload) async {
    try {
      AppLogger.d('📡 Enviando abertura de turno para API', tag: 'TurnoRepo');
      final response = await _dio.post(ApiConstants.turnoAbrir, data: payload);

      final status = response.statusCode ?? 0;
      if (status != 200 && status != 201) {
        throw Exception('Erro ao enviar abertura do turno. Status $status');
      }

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // A API pode retornar o ID em diferentes locais na resposta
        int? remoteId;

        // 1. Tenta data.remoteId (campo direto)
        if (data['remoteId'] != null) {
          remoteId = data['remoteId'] as int?;
        }
        // 2. Tenta data.data.id (dentro do objeto data)
        else if (data['data'] is Map<String, dynamic>) {
          final dataObj = data['data'] as Map<String, dynamic>;
          if (dataObj['id'] != null) {
            remoteId = dataObj['id'] as int?;
          }
        }
        // 3. Tenta data.id (campo direto na raiz)
        else if (data['id'] != null) {
          remoteId = data['id'] as int?;
        }

        if (remoteId != null) {
          AppLogger.d(
              '✅ Abertura de turno registrada na API com remoteId=$remoteId',
              tag: 'TurnoRepo');
          return remoteId;
        }
      }

      AppLogger.e('❌ Estrutura da resposta não reconhecida: $data',
          tag: 'TurnoRepo');
      throw Exception('Resposta da API não contém o identificador do turno');
    } on DioException catch (dioError) {
      // Captura erros específicos do Dio para extrair informações detalhadas
      final httpStatus = dioError.response?.statusCode ?? 0;
      final responseData = dioError.response?.data;

      AppLogger.e(
          '❌ Erro Dio ao enviar abertura de turno - HTTP Status: $httpStatus',
          tag: 'TurnoRepo',
          error: dioError);

      // Log da resposta completa da API para debugging
      if (responseData != null) {
        AppLogger.v('📋 Resposta completa da API: $responseData',
            tag: 'TurnoRepo');
      }

      // Tenta extrair statusCode da resposta da API, senão usa o HTTP status
      int statusCode = httpStatus;
      if (responseData is Map<String, dynamic> &&
          responseData['statusCode'] != null) {
        statusCode = responseData['statusCode'] as int;
        AppLogger.d('📋 StatusCode da API: $statusCode (HTTP: $httpStatus)',
            tag: 'TurnoRepo');
      }

      // Cria uma exceção customizada com informações detalhadas
      final errorMessage = _extrairMensagemErro(statusCode, responseData);
      throw TurnoAberturaException(
        statusCode: statusCode,
        message: errorMessage,
        originalError: dioError,
        responseData: responseData,
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao enviar abertura de turno para API',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
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

  /// Adiciona um eletricista a um turno.
  Future<int> adicionarEletricistaAoTurno(
      int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Adicionando eletricista $eletricistaId ao turno $turnoId',
          tag: 'TurnoRepo');

      final relacionamento = TurnoEletricistasTableDto(
        id: 0, // Será gerado automaticamente
        turnoId: turnoId,
        eletricistaId: eletricistaId,
      );

      return await _turnoEletricistasDao.inserir(relacionamento);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar eletricista ao turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Adiciona múltiplos eletricistas a um turno.
  Future<void> adicionarEletricistasAoTurno(
      int turnoId, List<int> eletricistaIds) async {
    try {
      AppLogger.d(
          'Adicionando ${eletricistaIds.length} eletricistas ao turno $turnoId',
          tag: 'TurnoRepo');

      final relacionamentos = eletricistaIds
          .map((eletricistaId) => TurnoEletricistasTableDto(
                id: 0, // Será gerado automaticamente
                turnoId: turnoId,
                eletricistaId: eletricistaId,
              ))
          .toList();

      await _turnoEletricistasDao.inserirMultiplos(relacionamentos);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao adicionar eletricistas ao turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove um eletricista de um turno.
  Future<bool> removerEletricistaDoTurno(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Removendo eletricista $eletricistaId do turno $turnoId',
          tag: 'TurnoRepo');

      // Busca o relacionamento específico
      final relacionamentos =
          await _turnoEletricistasDao.buscarPorTurno(turnoId);
      final relacionamento = relacionamentos.firstWhere(
        (r) => r.eletricistaId == eletricistaId,
        orElse: () => throw Exception('Eletricista não encontrado no turno'),
      );

      return await _turnoEletricistasDao.deletar(relacionamento.id);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover eletricista do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove todos os eletricistas de um turno.
  Future<int> removerTodosEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('Removendo todos os eletricistas do turno $turnoId',
          tag: 'TurnoRepo');
      return await _turnoEletricistasDao.deletarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover todos os eletricistas do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta eletricistas de um turno.
  Future<int> contarEletricistasDoTurno(int turnoId) async {
    try {
      AppLogger.d('Contando eletricistas do turno: $turnoId', tag: 'TurnoRepo');
      return await _turnoEletricistasDao.contarPorTurno(turnoId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar eletricistas do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Conta turnos de um eletricista.
  Future<int> contarTurnosDoEletricista(int eletricistaId) async {
    try {
      AppLogger.d('Contando turnos do eletricista: $eletricistaId',
          tag: 'TurnoRepo');
      return await _turnoEletricistasDao.contarPorEletricista(eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao contar turnos do eletricista',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // OPERAÇÕES DE MOTORISTA
  // ============================================================================

  /// Busca o motorista de um turno.
  Future<TurnoEletricistasTableDto?> buscarMotoristaDoTurno(int turnoId) async {
    try {
      AppLogger.d('Buscando motorista do turno: $turnoId', tag: 'TurnoRepo');
      final result =
          await _turnoEletricistasDao.buscarMotoristaPorTurno(turnoId);
      return result != null
          ? TurnoEletricistasTableDto.fromTable(result)
          : null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar motorista do turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Define um eletricista como motorista de um turno.
  /// Remove a flag de motorista dos outros eletricistas do mesmo turno.
  Future<void> definirMotorista(int turnoId, int eletricistaId) async {
    try {
      AppLogger.d('Definindo motorista $eletricistaId para turno $turnoId',
          tag: 'TurnoRepo');
      await _turnoEletricistasDao.definirMotorista(turnoId, eletricistaId);
      AppLogger.i('Motorista definido com sucesso', tag: 'TurnoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao definir motorista',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove a flag de motorista de todos os eletricistas de um turno.
  Future<void> removerMotorista(int turnoId) async {
    try {
      AppLogger.d('Removendo motorista do turno: $turnoId', tag: 'TurnoRepo');
      await _turnoEletricistasDao.removerMotorista(turnoId);
      AppLogger.i('Motorista removido com sucesso', tag: 'TurnoRepo');
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao remover motorista',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se um eletricista é o motorista de um turno.
  Future<bool> ehMotorista(int turnoId, int eletricistaId) async {
    try {
      return await _turnoEletricistasDao.ehMotorista(turnoId, eletricistaId);
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar se é motorista',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
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
    try {
      AppLogger.d(
          'Abrindo novo turno com ${eletricistaIds.length} eletricistas',
          tag: 'TurnoRepo');

      // Cria o turno
      final turno = TurnoTableDto(
        id: 0, // Será gerado automaticamente
        veiculoId: veiculoId,
        equipeId: equipeId,
        kmInicial: kmInicial,
        horaInicio: DateTime.now(),
        situacaoTurno: SituacaoTurno.emAbertura,
        latitude: latitude,
        longitude: longitude,
      );

      final turnoId = await salvarTurno(turno);

      // Adiciona os eletricistas
      if (eletricistaIds.isNotEmpty) {
        await adicionarEletricistasAoTurno(turnoId, eletricistaIds);
      }

      // Define o motorista, se fornecido
      if (motoristaId != null) {
        await definirMotorista(turnoId, motoristaId);
        AppLogger.d('Motorista $motoristaId definido para turno $turnoId',
            tag: 'TurnoRepo');
      }

      AppLogger.d('Turno $turnoId aberto com sucesso', tag: 'TurnoRepo');
      return turnoId;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao abrir turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Fecha um turno existente.
  ///
  /// Atualiza a situação do turno para fechado e define hora de fim.
  Future<bool> fecharTurno(int turnoId, {int? kmFinal}) async {
    try {
      AppLogger.d('Fechando turno: $turnoId', tag: 'TurnoRepo');

      final turno = await buscarTurnoPorId(turnoId);
      if (turno == null) {
        throw Exception('Turno não encontrado');
      }

      final turnoAtualizado = turno.copyWith(
        situacaoTurno: SituacaoTurno.fechado,
        horaFim: DateTime.now(),
        kmFinal: kmFinal,
      );

      final sucesso = await atualizarTurno(turnoAtualizado);

      if (sucesso) {
        AppLogger.d('Turno $turnoId fechado com sucesso', tag: 'TurnoRepo');
      }

      return sucesso;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao fechar turno',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Busca turno completo com seus eletricistas.
  ///
  /// Retorna o turno e a lista de IDs dos eletricistas associados.
  Future<Map<String, dynamic>?> buscarTurnoCompleto(int turnoId) async {
    try {
      AppLogger.d('Buscando turno completo: $turnoId', tag: 'TurnoRepo');

      final turno = await buscarTurnoPorId(turnoId);
      if (turno == null) return null;

      final eletricistas = await buscarEletricistasDoTurno(turnoId);
      final eletricistaIds = eletricistas.map((e) => e.eletricistaId).toList();

      return {
        'turno': turno,
        'eletricistaIds': eletricistaIds,
      };
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao buscar turno completo',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Verifica se existe turno ativo.
  Future<bool> temTurnoAtivo() async {
    try {
      AppLogger.d('Verificando se existe turno ativo', tag: 'TurnoRepo');
      final turnoAtivo = await buscarTurnoAtivo();
      return turnoAtivo != null;
    } catch (e, stackTrace) {
      AppLogger.e('Erro ao verificar turno ativo',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
      rethrow;
    }
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
      AppLogger.d('🚀 [ABERTURA REMOTA] Iniciando abertura de turno remoto',
          tag: 'TurnoRepo');

      // 1. Buscar turno em abertura
      final turnoAtivo = await buscarTurnoAtivo();
      if (turnoAtivo == null) {
        AppLogger.e('❌ [ABERTURA REMOTA] Nenhum turno em abertura encontrado',
            tag: 'TurnoRepo');
        throw Exception('Nenhum turno em abertura encontrado');
      }

      if (turnoAtivo.situacaoTurno != SituacaoTurno.emAbertura) {
        AppLogger.e(
            '❌ [ABERTURA REMOTA] Turno não está em situação de abertura',
            tag: 'TurnoRepo');
        throw Exception('Turno não está em situação de abertura');
      }

      AppLogger.d('📦 [ABERTURA REMOTA] Turno encontrado: ${turnoAtivo.id}',
          tag: 'TurnoRepo');

      // 2. Buscar eletricistas do turno
      final eletricistas = await buscarEletricistasDoTurno(turnoAtivo.id);
      AppLogger.d(
          '👷 [ABERTURA REMOTA] ${eletricistas.length} eletricistas encontrados',
          tag: 'TurnoRepo');

      // 3. TODO: Buscar checklists preenchidos do turno
      // final checklists = await buscarChecklistsDoTurno(turnoAtivo.id);

      // 4. Montar payload
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
        // 'checklists': checklists.map((c) => c.toJson()).toList(),
      };

      AppLogger.d('📤 [ABERTURA REMOTA] Enviando payload para API...',
          tag: 'TurnoRepo');

      // 5. Enviar para API
      final response = await _dio.post(ApiConstants.turnoAbrir, data: payload);

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppLogger.e(
            '❌ [ABERTURA REMOTA] Erro na resposta da API: ${response.statusCode}',
            tag: 'TurnoRepo');
        throw Exception('Erro ao abrir turno na API');
      }

      final remoteId = response.data['id'] as int?;
      if (remoteId == null) {
        AppLogger.e('❌ [ABERTURA REMOTA] API não retornou ID do turno',
            tag: 'TurnoRepo');
        throw Exception('API não retornou ID do turno');
      }

      AppLogger.d('✅ [ABERTURA REMOTA] Turno criado na API com ID: $remoteId',
          tag: 'TurnoRepo');

      // 6. Atualizar turno no banco
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

      AppLogger.i(
          '✅ [ABERTURA REMOTA] Turno aberto com sucesso! RemoteID: $remoteId',
          tag: 'TurnoRepo');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ABERTURA REMOTA] Erro ao abrir turno remotamente',
          tag: 'TurnoRepo', error: e, stackTrace: stackTrace);
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
