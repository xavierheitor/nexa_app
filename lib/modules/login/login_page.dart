import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/modules/login/login_controller.dart';

/// Página de login com design minimalista e moderno.
///
/// Esta página implementa uma interface de login limpa e elegante,
/// seguindo princípios de design minimalista com foco na usabilidade
/// e experiência do usuário. Utiliza o LoginController para gerenciar
/// toda a lógica de negócio e estado da interface.
///
/// ## Características de Design:
///
/// 1. **Minimalista**: Interface limpa sem elementos desnecessários
/// 2. **Responsiva**: Adapta-se a diferentes tamanhos de tela
/// 3. **Acessível**: Contraste adequado e navegação por teclado
/// 4. **Intuitiva**: Fluxo claro e feedback visual adequado
/// 5. **Moderno**: Uso de Material Design 3 com customizações
/// 6. **Consistente**: Padrões visuais uniformes
///
/// ## Componentes da Interface:
///
/// - **Header**: Logo e título da aplicação
/// - **Formulário**: Campos de matrícula e senha com validação
/// - **Botão de Login**: Ação principal com estado de loading
/// - **Feedback**: Mensagens de erro e sucesso
/// - **Footer**: Informações adicionais (opcional)
///
/// ## Fluxo de Interação:
///
/// 1. Usuário visualiza interface de login
/// 2. Preenche campos de matrícula e senha
/// 3. Validação em tempo real dos campos
/// 4. Submissão do formulário
/// 5. Feedback visual durante processamento
/// 6. Navegação ou exibição de erro
///
/// ## Responsividade:
///
/// - **Mobile**: Layout vertical otimizado para telas pequenas
/// - **Tablet**: Layout centralizado com largura máxima
/// - **Desktop**: Layout centralizado com largura fixa
class LoginPage extends StatelessWidget {
  /// Construtor da página de login.
  ///
  /// Inicializa a página com chave opcional para identificação
  /// no widget tree durante desenvolvimento e debugging.
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Obtém instância do controlador via GetX.
    final controller = Get.find<LoginController>();

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Espaçamento superior responsivo.
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                /// Header com logo e título.
                _buildHeader(context, colorScheme),

                /// Espaçamento entre header e formulário.
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                /// Card do formulário de login.
                _buildLoginCard(context, controller, theme, colorScheme),

                /// Espaçamento inferior responsivo.
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                /// Footer com informações adicionais.
                _buildFooter(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o header da página com logo e título.
  ///
  /// Cria a seção superior da página contendo o logo da aplicação
  /// e o título, seguindo o design minimalista com hierarquia visual clara.
  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        /// Logo da aplicação.
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.business_outlined,
            size: 40,
            color: colorScheme.onPrimary,
          ),
        ),

        const SizedBox(height: 24),

        /// Título da aplicação.
        Text(
          'Nexa App',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        /// Subtítulo descritivo.
        Text(
          'Faça login para continuar',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Constrói o card do formulário de login.
  ///
  /// Cria o card principal contendo o formulário de login com
  /// campos de entrada, validação e botão de ação, seguindo
  /// Material Design 3 com customizações minimalistas.
  Widget _buildLoginCard(
    BuildContext context,
    LoginController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Título do formulário.
              Text(
                'Entrar',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              /// Campo de matrícula.
              _buildMatriculaField(controller, theme, colorScheme),

              const SizedBox(height: 20),

              /// Campo de senha.
              _buildSenhaField(controller, theme, colorScheme),

              const SizedBox(height: 24),

              /// Mensagem de erro.
              Obx(() => _buildErrorMessage(controller, colorScheme)),

              const SizedBox(height: 24),

              /// Botão de login.
              _buildLoginButton(controller, theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o campo de entrada para matrícula.
  ///
  /// Cria um campo de texto estilizado para entrada da matrícula
  /// com validação em tempo real e feedback visual adequado.
  Widget _buildMatriculaField(
    LoginController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return TextFormField(
      controller: controller.matriculaController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: controller.validateMatricula,
      onChanged: (_) => controller.clearError(),
      decoration: InputDecoration(
        labelText: 'Matrícula',
        hintText: 'Digite sua matrícula',
        prefixIcon: Icon(
          Icons.badge_outlined,
          color: colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  /// Constrói o campo de entrada para senha.
  ///
  /// Cria um campo de texto estilizado para entrada da senha
  /// com opção de mostrar/ocultar senha e validação em tempo real.
  Widget _buildSenhaField(
    LoginController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Obx(() => TextFormField(
          controller: controller.senhaController,
          obscureText: !controller.isPasswordVisible,
          textInputAction: TextInputAction.done,
          validator: controller.validateSenha,
          onChanged: (_) => controller.clearError(),
          onFieldSubmitted: (_) => controller.login(),
          decoration: InputDecoration(
            labelText: 'Senha',
            hintText: 'Digite sua senha',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: colorScheme.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ));
  }

  /// Constrói a mensagem de erro.
  ///
  /// Exibe mensagem de erro de forma reativa quando há
  /// problemas durante o processo de login.
  Widget _buildErrorMessage(
      LoginController controller, ColorScheme colorScheme) {
    if (controller.errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.errorMessage,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o botão de login.
  ///
  /// Cria o botão principal de login com estado de loading
  /// e feedback visual adequado durante o processo.
  Widget _buildLoginButton(
    LoginController controller,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Obx(() => SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isLoading ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: colorScheme.primary.withOpacity(0.6),
            ),
            child: controller.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                : const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ));
  }

  /// Constrói o footer da página.
  ///
  /// Cria a seção inferior com informações adicionais
  /// e links úteis, seguindo o design minimalista.
  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        /// Linha divisória sutil.
        Container(
          height: 1,
          width: double.infinity,
          color: colorScheme.outline.withOpacity(0.2),
        ),

        const SizedBox(height: 24),

        /// Informações de suporte.
        Text(
          'Precisa de ajuda? Entre em contato com o suporte.',
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        /// Versão da aplicação.
        Text(
          'Versão 1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
