import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Serviço de conectividade que monitora o status da conexão em tempo real.
///
/// Funcionalidades:
/// - ✅ Detecta se está online/offline
/// - ✅ Identifica tipo de conexão (WiFi, dados móveis, ethernet)
/// - ✅ Monitoramento em tempo real
/// - ✅ Feedback visual automático
class ConnectivityService extends GetxService {
  // ==========================================================================
  // PROPRIEDADES OBSERVÁVEIS
  // ==========================================================================

  /// Status de conectividade (true = online, false = offline)
  final RxBool isOnline = false.obs;

  /// Tipo de conexão atual
  final Rx<ConnectionType> connectionType = ConnectionType.none.obs;

  /// Última vez que foi detectada conectividade
  final Rx<DateTime?> lastConnectedAt = Rx<DateTime?>(null);

  /// Última vez que foi detectada desconexão
  final Rx<DateTime?> lastDisconnectedAt = Rx<DateTime?>(null);

  // ==========================================================================
  // PROPRIEDADES PRIVADAS
  // ==========================================================================

  /// Stream subscription para mudanças de conectividade
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Verifica se está conectado via WiFi
  bool get isWifi => connectionType.value == ConnectionType.wifi;

  /// Verifica se está conectado via dados móveis
  bool get isMobileData => connectionType.value == ConnectionType.mobile;

  /// Verifica se está conectado via ethernet
  bool get isEthernet => connectionType.value == ConnectionType.ethernet;

  /// Verifica se está offline há mais de X minutos
  bool get isOfflineForLongTime {
    if (isOnline.value || lastDisconnectedAt.value == null) return false;
    return DateTime.now().difference(lastDisconnectedAt.value!).inMinutes > 5;
  }

  /// Descrição amigável do tipo de conexão
  String get connectionTypeDescription {
    switch (connectionType.value) {
      case ConnectionType.wifi:
        return 'WiFi';
      case ConnectionType.mobile:
        return 'Dados Móveis';
      case ConnectionType.ethernet:
        return 'Ethernet';
      case ConnectionType.bluetooth:
        return 'Bluetooth';
      case ConnectionType.vpn:
        return 'VPN';
      case ConnectionType.other:
        return 'Outro';
      case ConnectionType.none:
        return 'Sem Conexão';
    }
  }

  // ==========================================================================
  // INICIALIZAÇÃO
  // ==========================================================================

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Inicializa o monitoramento de conectividade
  Future<void> _initializeConnectivity() async {
    try {
      AppLogger.i('🔌 Inicializando ConnectivityService', tag: 'ConnectivityService');
      
      // Verifica conectividade inicial
      await _checkInitialConnectivity();
      
      // Inicia monitoramento em tempo real
      _startConnectivityMonitoring();
      
      AppLogger.i('✅ ConnectivityService inicializado com sucesso', tag: 'ConnectivityService');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao inicializar ConnectivityService',
          tag: 'ConnectivityService', error: e, stackTrace: stackTrace);
    }
  }

  /// Verifica conectividade inicial
  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      AppLogger.e('Erro ao verificar conectividade inicial',
          tag: 'ConnectivityService', error: e);
      _setOffline();
    }
  }

  /// Inicia monitoramento em tempo real
  void _startConnectivityMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectivityStatus,
      onError: (error) {
        AppLogger.e('Erro no monitoramento de conectividade',
            tag: 'ConnectivityService', error: error);
        _setOffline();
      },
    );
  }

  // ==========================================================================
  // ATUALIZAÇÃO DE STATUS
  // ==========================================================================

  /// Atualiza o status de conectividade
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && 
        !results.contains(ConnectivityResult.none);
    
    if (hasConnection) {
      _setOnline(results);
    } else {
      _setOffline();
    }
  }

  /// Define status como online
  void _setOnline(List<ConnectivityResult> results) {
    final wasOffline = !isOnline.value;
    
    isOnline.value = true;
    connectionType.value = _determineConnectionType(results);
    lastConnectedAt.value = DateTime.now();
    
    if (wasOffline) {
      AppLogger.i('🌐 Conectado via $connectionTypeDescription',
          tag: 'ConnectivityService');
      _showConnectionRestoredMessage();
    }
  }

  /// Define status como offline
  void _setOffline() {
    final wasOnline = isOnline.value;
    
    isOnline.value = false;
    connectionType.value = ConnectionType.none;
    lastDisconnectedAt.value = DateTime.now();
    
    if (wasOnline) {
      AppLogger.w('🔌 Desconectado - sem internet', tag: 'ConnectivityService');
      _showOfflineMessage();
    }
  }

  /// Determina o tipo de conexão baseado nos resultados
  ConnectionType _determineConnectionType(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectionType.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionType.mobile;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectionType.ethernet;
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return ConnectionType.bluetooth;
    } else if (results.contains(ConnectivityResult.vpn)) {
      return ConnectionType.vpn;
    } else if (results.contains(ConnectivityResult.other)) {
      return ConnectionType.other;
    } else {
      return ConnectionType.none;
    }
  }

  // ==========================================================================
  // FEEDBACK VISUAL
  // ==========================================================================

  /// Mostra mensagem quando conexão é restaurada
  void _showConnectionRestoredMessage() {
    // Removido snackbar - agora o indicador visual no AppBar mostra o status
    AppLogger.i('🌐 Conexão restaurada via $connectionTypeDescription',
        tag: 'ConnectivityService');
  }

  /// Mostra mensagem quando fica offline
  void _showOfflineMessage() {
    // Removido snackbar - agora o indicador visual no AppBar mostra o status
    AppLogger.w('🔌 Desconectado - sem internet', tag: 'ConnectivityService');
  }

  // ==========================================================================
  // MÉTODOS PÚBLICOS
  // ==========================================================================

  /// Executa uma operação apenas se estiver online
  Future<T?> executeIfOnline<T>(Future<T> Function() operation) async {
    if (!isOnline.value) {
      AppLogger.w('Operação cancelada: sem conexão',
          tag: 'ConnectivityService');
      return null;
    }
    
    return await operation();
  }

  /// Força verificação de conectividade
  Future<void> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      AppLogger.e('Erro ao verificar conectividade',
          tag: 'ConnectivityService', error: e);
      _setOffline();
    }
  }

  /// Obtém informações detalhadas da conexão
  Map<String, dynamic> getConnectionInfo() {
    return {
      'isOnline': isOnline.value,
      'connectionType': connectionType.value.name,
      'connectionTypeDescription': connectionTypeDescription,
      'lastConnectedAt': lastConnectedAt.value?.toIso8601String(),
      'lastDisconnectedAt': lastDisconnectedAt.value?.toIso8601String(),
      'isWifi': isWifi,
      'isMobileData': isMobileData,
      'isEthernet': isEthernet,
      'isOfflineForLongTime': isOfflineForLongTime,
    };
  }
}

// ==========================================================================
// ENUMS
// ==========================================================================

/// Tipos de conexão suportados
enum ConnectionType {
  none,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
}
