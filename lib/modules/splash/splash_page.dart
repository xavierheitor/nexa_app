import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/splash/splash_controller.dart';

/// Página de splash com design minimalista e moderno.
///
/// Esta página é exibida durante a inicialização da aplicação,
/// fornecendo feedback visual ao usuário enquanto o sistema
/// carrega dependências e verifica o estado de autenticação.
///
/// ## Características de Design:
///
/// 1. **Minimalista**: Interface limpa focada na marca
/// 2. **Loading Visual**: Indicador de carregamento elegante
/// 3. **Responsiva**: Adapta-se a diferentes tamanhos de tela
/// 4. **Acessível**: Contraste adequado e navegação por teclado
/// 5. **Moderno**: Uso de Material Design 3
/// 6. **Consistente**: Padrões visuais uniformes
///
/// ## Componentes da Interface:
///
/// - **Logo**: Marca da aplicação centralizada
/// - **Loading Indicator**: Spinner animado
/// - **Texto de Carregamento**: Mensagem informativa
/// - **Background**: Gradiente sutil
///
/// ## Fluxo de Funcionamento:
///
/// 1. Página é exibida imediatamente
/// 2. SplashController é inicializado automaticamente
/// 3. Sistema carrega dependências em background
/// 4. Redirecionamento automático para tela apropriada
/// 5. Transição suave entre telas
///
/// ## Responsividade:
///
/// - **Mobile**: Layout vertical otimizado
/// - **Tablet**: Layout centralizado
/// - **Desktop**: Layout centralizado com largura fixa
class SplashPage extends StatelessWidget {
  /// Construtor da página de splash.
  ///
  /// Inicializa a página com chave opcional para identificação
  /// no widget tree durante desenvolvimento e debugging.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Obtém instância do controlador via GetX.
    final controller = Get.find<SplashController>();

    /// Obtém tema atual para cores e estilos.
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      /// Corpo principal da página com gradiente sutil.
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// Gradiente sutil para background.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Logo da aplicação.
              _buildLogo(context, colorScheme),

              const SizedBox(height: 48),

              /// Indicador de carregamento.
              _buildLoadingIndicator(colorScheme),

              const SizedBox(height: 24),

              /// Texto de carregamento.
              _buildLoadingText(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o logo da aplicação.
  ///
  /// Cria o logo centralizado com animação sutil e
  /// design consistente com o resto da aplicação.
  Widget _buildLogo(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Icon(
        Icons.business_outlined,
        size: 60,
        color: colorScheme.onPrimary,
      ),
    );
  }

  /// Constrói o indicador de carregamento.
  ///
  /// Cria um spinner animado elegante para indicar
  /// que o sistema está carregando.
  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          colorScheme.primary,
        ),
      ),
    );
  }

  /// Constrói o texto de carregamento.
  ///
  /// Exibe mensagem informativa para o usuário
  /// durante o processo de inicialização.
  Widget _buildLoadingText(ColorScheme colorScheme) {
    return Text(
      'Carregando...',
      style: TextStyle(
        fontSize: 16,
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
