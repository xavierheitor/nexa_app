import 'package:get/get.dart';
import 'package:nexa_app/core/network/connectivity_service.dart';

/// Binding para inicializar o ConnectivityService.
///
/// Registra o serviço de conectividade no GetX para uso em toda a aplicação.
class ConnectivityBinding extends Bindings {
  @override
  void dependencies() {
    // Registra ConnectivityService como um serviço singleton
    Get.put<ConnectivityService>(
      ConnectivityService(),
      permanent: true, // Mantém o serviço ativo durante toda a vida da app
      tag: 'ConnectivityService',
    );
  }
}
