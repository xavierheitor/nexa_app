import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/app/routes/routes.dart';

/// Middleware de autenticação para proteção de rotas da aplicação.
///
/// Este middleware implementa o padrão de segurança de interceptação de navegação,
/// verificando o status de autenticação do usuário antes de permitir o acesso
/// a rotas protegidas. Ele atua como um guardião das rotas que requerem
/// autenticação válida.
///
/// ## Funcionalidades Principais:
///
/// 1. **Interceptação de Navegação**: Captura tentativas de acesso a rotas protegidas
/// 2. **Verificação de Sessão**: Valida se o usuário possui uma sessão ativa e válida
/// 3. **Redirecionamento Automático**: Direciona usuários não autenticados para login
/// 4. **Logging de Segurança**: Registra tentativas de acesso para auditoria
/// 5. **Controle de Fluxo**: Permite ou bloqueia navegação baseado na autenticação
///
/// ## Arquitetura:
///
/// - **GetMiddleware**: Extensão do framework GetX para interceptação de rotas
/// - **SessionManager**: Gerenciador centralizado de sessões de usuário
/// - **RouteSettings**: Configurações de rota para redirecionamento
/// - **AppLogger**: Sistema de logging para monitoramento de segurança
///
/// ## Fluxo de Funcionamento:
///
/// 1. Usuário tenta navegar para uma rota protegida
/// 2. Middleware intercepta a navegação
/// 3. Verifica status de autenticação via `SessionManager`
/// 4. Se não autenticado: redireciona para login + registra log
/// 5. Se autenticado: permite navegação + registra log de sucesso
///
/// ## Uso:
///
/// ```dart
/// // Aplicar middleware em uma rota específica
/// GetPage(
///   name: Routes.home,
///   page: () => HomePage(),
///   middlewares: [AuthMiddleware()], // Protege a rota
/// )
/// ```
///
/// ## Segurança:
///
/// - **Verificação Centralizada**: Utiliza `SessionManager` como única fonte de verdade
/// - **Logging Completo**: Registra todas as tentativas de acesso para auditoria
/// - **Redirecionamento Seguro**: Sempre redireciona para rota de login válida
/// - **Sem Bypass**: Não permite acesso a rotas protegidas sem autenticação
///
/// ## Dependências:
/// - `SessionManager`: Gerenciamento de sessões de usuário
/// - `AppLogger`: Sistema de logging para monitoramento
/// - `Routes`: Definições de rotas da aplicação
/// - `GetX`: Framework para middleware e navegação
class AuthMiddleware extends GetMiddleware {
  // ============================================================================
  // INTERCEPTAÇÃO E REDIRECIONAMENTO DE ROTAS
  // ============================================================================

  /// Intercepta a navegação e decide se o acesso deve ser permitido ou bloqueado.
  ///
  /// Este método é chamado automaticamente pelo GetX sempre que uma rota
  /// protegida por este middleware é acessada. Ele verifica o status de
  /// autenticação e determina o próximo passo da navegação.
  ///
  /// ## Parâmetros:
  /// - `route`: Nome da rota que está sendo acessada
  ///
  /// ## Retorno:
  /// - `RouteSettings`: Configuração de redirecionamento se acesso negado
  /// - `null`: Permite navegação normal se acesso autorizado
  ///
  /// ## Comportamento:
  /// - **Usuário Autenticado**: Permite navegação e registra log de sucesso
  /// - **Usuário Não Autenticado**: Redireciona para login e registra log de acesso negado
  @override
  RouteSettings? redirect(String? route) {
    // ========================================================================
    // VERIFICAÇÃO DE AUTENTICAÇÃO
    // ========================================================================

    /// Obtém a instância do SessionManager através do sistema de injeção
    /// de dependências do GetX. O SessionManager é responsável por gerenciar
    /// todo o estado de autenticação do usuário na aplicação.
    final sessionManager = Get.find<SessionManager>();

    // ========================================================================
    // LÓGICA DE DECISÃO DE ACESSO
    // ========================================================================

    /// Verifica se o usuário está autenticado através do SessionManager.
    /// A propriedade `estaLogado` encapsula toda a lógica de validação
    /// de sessão, incluindo verificação de token, expiração e validade.
    if (!sessionManager.estaLogado) {
      // ====================================================================
      // ACESSO NEGADO - REDIRECIONAMENTO PARA LOGIN
      // ====================================================================

      /// Registra tentativa de acesso negado para fins de auditoria e debugging.
      /// O log inclui o nome da rota que foi tentada acessar, facilitando
      /// a identificação de padrões de uso e possíveis problemas de segurança.
      AppLogger.w(
          '🔐 Acesso negado à rota "$route". Redirecionando para login.',
          tag: 'AuthMiddleware');

      /// Retorna configuração de redirecionamento para a página de login.
      /// O usuário será automaticamente direcionado para esta rota,
      /// onde poderá se autenticar antes de tentar acessar novamente.
      return const RouteSettings(name: Routes.login);
    }

    // ========================================================================
    // ACESSO AUTORIZADO - NAVEGAÇÃO PERMITIDA
    // ========================================================================

    /// Registra acesso autorizado para monitoramento e debugging.
    /// Este log ajuda a rastrear o fluxo de navegação de usuários autenticados
    /// e identificar possíveis problemas de performance ou comportamento.
    AppLogger.i('✅ Acesso autorizado à rota "$route"', tag: 'AuthMiddleware');

    /// Retorna null para indicar que a navegação deve prosseguir normalmente.
    /// O GetX interpreta null como "sem redirecionamento necessário",
    /// permitindo que o usuário acesse a rota solicitada.
    return null;
  }
}
