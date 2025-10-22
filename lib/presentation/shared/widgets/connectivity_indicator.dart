import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/network/connectivity_service.dart';

/// Widget indicador de conectividade que mostra o status da conexão.
///
/// Este widget exibe um ícone que muda de cor conforme o status:
/// - Verde: WiFi conectado
/// - Amarelo: Dados móveis conectado
/// - Vermelho: Offline
/// - Azul: Ethernet ou outras conexões
class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();
    
    return Obx(() {
      final isOnline = connectivityService.isOnline.value;
      final connectionType = connectivityService.connectionType.value;
      
      return Tooltip(
        message: _getTooltipMessage(connectivityService),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getIndicatorColor(connectionType, isOnline),
            boxShadow: [
              BoxShadow(
                color: _getIndicatorColor(connectionType, isOnline).withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            _getIndicatorIcon(connectionType),
            color: Colors.white,
            size: 18,
          ),
        ),
      );
    });
  }

  /// Retorna a cor do indicador baseada no tipo de conexão
  Color _getIndicatorColor(ConnectionType connectionType, bool isOnline) {
    if (!isOnline) {
      return Colors.red; // Vermelho para offline
    }
    
    switch (connectionType) {
      case ConnectionType.wifi:
        return Colors.green; // Verde para WiFi
      case ConnectionType.mobile:
        return Colors.orange; // Amarelo/Laranja para dados móveis
      case ConnectionType.ethernet:
        return Colors.blue; // Azul para Ethernet
      case ConnectionType.bluetooth:
        return Colors.purple; // Roxo para Bluetooth
      case ConnectionType.vpn:
        return Colors.indigo; // Índigo para VPN
      case ConnectionType.other:
        return Colors.cyan; // Ciano para outras conexões
      case ConnectionType.none:
        return Colors.red; // Vermelho para sem conexão
    }
  }

  /// Retorna o ícone baseado no tipo de conexão
  IconData _getIndicatorIcon(ConnectionType connectionType) {
    switch (connectionType) {
      case ConnectionType.wifi:
        return Icons.wifi;
      case ConnectionType.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectionType.ethernet:
        return Icons.cable;
      case ConnectionType.bluetooth:
        return Icons.bluetooth;
      case ConnectionType.vpn:
        return Icons.vpn_lock;
      case ConnectionType.other:
        return Icons.network_check;
      case ConnectionType.none:
        return Icons.wifi_off;
    }
  }

  /// Retorna a mensagem do tooltip
  String _getTooltipMessage(ConnectivityService connectivityService) {
    final isOnline = connectivityService.isOnline.value;
    final connectionType = connectivityService.connectionType.value;
    
    if (!isOnline) {
      return 'Sem conexão';
    }
    
    switch (connectionType) {
      case ConnectionType.wifi:
        return 'Conectado via WiFi';
      case ConnectionType.mobile:
        return 'Conectado via dados móveis';
      case ConnectionType.ethernet:
        return 'Conectado via Ethernet';
      case ConnectionType.bluetooth:
        return 'Conectado via Bluetooth';
      case ConnectionType.vpn:
        return 'Conectado via VPN';
      case ConnectionType.other:
        return 'Conectado via rede';
      case ConnectionType.none:
        return 'Sem conexão';
    }
  }
}
