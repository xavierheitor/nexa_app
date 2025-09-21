// lib/app.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/bindings/initial_binding.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/app_pages.dart';

/// Widget principal do aplicativo NexaApp.
///
/// Esta classe representa o ponto de entrada da interface do usuário do aplicativo,
/// configurando e inicializando todos os componentes essenciais do framework GetX
/// e definindo a estrutura de navegação e roteamento da aplicação.
///
/// ## Responsabilidades Principais:
///
/// 1. **Configuração do GetMaterialApp**: Estabelece o widget raiz da aplicação
///    com todas as configurações necessárias do framework GetX.
///
/// 2. **Gerenciamento de Rotas**: Define o sistema de navegação da aplicação,
///    incluindo rota inicial e todas as rotas disponíveis.
///
/// 3. **Inicialização de Dependências**: Configura o binding inicial para
///    carregar todas as dependências necessárias no início da aplicação.
///
/// 4. **Monitoramento de Navegação**: Implementa observadores para capturar
///    erros durante a navegação e problemas de roteamento.
///
/// 5. **Configuração de Interface**: Define configurações visuais e de
///    comportamento da aplicação.
///
/// ## Arquitetura:
///
/// - **StatelessWidget**: Widget imutável que não mantém estado interno
/// - **GetMaterialApp**: Extensão do MaterialApp com funcionalidades do GetX
/// - **Roteamento**: Baseado no sistema de rotas do GetX para navegação
/// - **Dependency Injection**: Utiliza bindings para injeção de dependências
///
/// ## Fluxo de Inicialização:
///
/// 1. Carregamento do `InitialBinding` com dependências globais
/// 2. Configuração das rotas através de `AppPages`
/// 3. Definição da rota inicial da aplicação
/// 4. Ativação dos observadores de navegação
/// 5. Renderização da interface principal
///
/// ## Dependências:
/// - `InitialBinding`: Configuração inicial de dependências
/// - `AppPages`: Definição de rotas e páginas da aplicação
/// - `AppLogger`: Sistema de logging para monitoramento
/// - `GetX`: Framework para gerenciamento de estado e navegação
class NexaApp extends StatelessWidget {
  /// Construtor da classe NexaApp.
  ///
  /// Utiliza o construtor padrão do StatelessWidget com chave opcional
  /// para identificação única do widget na árvore de componentes.
  const NexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================================
    // CONFIGURAÇÃO DO WIDGET PRINCIPAL DA APLICAÇÃO
    // ============================================================================

    /// GetMaterialApp é o widget raiz que estende o MaterialApp padrão do Flutter
    /// com funcionalidades adicionais do framework GetX, incluindo:
    /// - Sistema de navegação aprimorado
    /// - Gerenciamento de estado global
    /// - Injeção de dependências
    /// - Roteamento dinâmico
    return GetMaterialApp(
      // ==========================================================================
      // CONFIGURAÇÕES BÁSICAS DA APLICAÇÃO
      // ==========================================================================

      /// Título da aplicação exibido na barra de tarefas e configurações do sistema
      /// Este valor é usado pelo sistema operacional para identificar o app
      title: 'Nexa',

      // ==========================================================================
      // CONFIGURAÇÃO DO SISTEMA DE ROTEAMENTO
      // ==========================================================================

      /// Define a rota inicial que será carregada quando o aplicativo iniciar
      /// Esta rota deve estar definida em AppPages.routes para funcionar corretamente
      initialRoute: AppPages.initial,

      /// Lista de todas as rotas disponíveis na aplicação
      /// Cada rota é definida com um nome, uma função de construção e opcionalmente
      /// bindings específicos para injeção de dependências por página
      getPages: AppPages.routes,

      // ==========================================================================
      // CONFIGURAÇÕES VISUAIS E DE DEBUG
      // ==========================================================================

      /// Remove o banner de debug que aparece no canto superior direito
      /// em modo de desenvolvimento, proporcionando uma interface mais limpa
      debugShowCheckedModeBanner: false,

      // ==========================================================================
      // INICIALIZAÇÃO DE DEPENDÊNCIAS
      // ==========================================================================

      /// Binding inicial que é executado antes da primeira rota ser carregada
      /// Responsável por inicializar dependências globais, serviços compartilhados
      /// e configurações que serão utilizadas em toda a aplicação
      initialBinding: InitialBinding(),

      // ==========================================================================
      // MONITORAMENTO DE NAVEGAÇÃO E TRATAMENTO DE ERROS
      // ==========================================================================

      /// Lista de observadores que monitoram eventos de navegação
      /// Útil para analytics, logging de navegação e tratamento de erros de rota
      navigatorObservers: [
        /// Observador personalizado do GetX para monitorar mudanças de rota
        /// e capturar erros que possam ocorrer durante a navegação
        GetObserver(
          /// Callback executado sempre que uma nova rota é empilhada ou removida
          /// Recebe informações sobre a rota atual e permite tratamento de eventos
          (route) {
            /// Verifica se a rota atual contém um erro (ex: página não encontrada)
            /// e registra o erro no sistema de logging para debugging e monitoramento
            if (route?.current is Error) {
              AppLogger.e('[NavigatorObserver] ${route?.current}',
                  tag: 'NexaApp');
            }
          },
        ),
      ],
    );
  }
}
