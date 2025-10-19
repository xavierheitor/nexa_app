# Guia de Início - Nexa App

> **Seu primeiro dia no projeto**  
> **Siga este guia passo a passo para começar a desenvolver**

---

## 📋 Checklist de Onboarding

- [ ] Ambiente configurado
- [ ] Código rodando localmente
- [ ] Entendeu a arquitetura básica
- [ ] Criou sua primeira feature de teste
- [ ] Fez seu primeiro commit

**Tempo estimado:** 2-3 horas

---

## 1️⃣ Setup do Ambiente (30 min)

### Pré-requisitos

```bash
# Verificar Flutter
flutter doctor

# Deve mostrar:
# [✓] Flutter (Channel stable, 3.x.x)
# [✓] Android toolchain
# [✓] Xcode (para iOS, se Mac)
# [✓] VS Code / Android Studio
```

Se algo falhar:

- **Flutter:**
- **Android SDK:** Via Android Studio
- **Xcode:** Via App Store (Mac apenas)

---

### Instalação do Projeto

```bash
# 1. Clonar repositório
git clone <url-do-repo>
cd nexa_app

# 2. Instalar dependências
flutter pub get

# 3. Gerar código (Drift database)
dart run build_runner build --delete-conflicting-outputs

# 4. Verificar se compila
flutter analyze

# 5. Executar app
flutter run
```

**Resultado esperado:**

- ✅ App abre no emulador/dispositivo
- ✅ Tela de splash aparece
- ✅ Login funciona (use credenciais de teste)

---

## 2️⃣ Explorar o App (30 min)

### Navegação Guiada

1. **Splash** → Aguarde carregar
2. **Login** → Entre com:
   - Matrícula: `TESTE001`
   - Senha: `senha123`
3. **Home** → Explore o dashboard
4. **Abrir Turno** → Clique no botão "Turno"
   - Selecione veículo
   - Selecione equipe
   - Adicione 2+ eletricistas
   - Marque um motorista
   - Informe KM inicial
5. **Checklists** → Complete:
   - Checklist Veicular
   - Checklist EPC
   - Checklist EPI (todos eletricistas)
6. **Serviços** → Adicione serviços
7. **Fechar Turno** → Finalize o turno

**Objetivo:** Entender o fluxo completo do app!

---

## 3️⃣ Entender a Arquitetura (45 min)

### Leitura Obrigatória

Leia nesta ordem (30 min total):

1. **[OVERVIEW.md](OVERVIEW.md)** (10 min)

   - Já leu? ✅ Ótimo!
   - Não leu? Volte e leia primeiro!

2. **[DIAGRAMS.md](DIAGRAMS.md)** (15 min)

   - Visualize os fluxos
   - Entenda as camadas
   - Veja comunicação entre módulos

3. **[ARCHITECTURE.md](ARCHITECTURE.md) - Seções principais** (15 min)
   - Estrutura de Pastas
   - Organização por Módulos
   - Fluxo de Dados

### Exercício Prático (15 min)

Explore o código seguindo este roteiro:

```bash
1. Abra: lib/presentation/home/home_page.dart
   └─ Veja como a UI é construída

2. Abra: lib/presentation/home/home_controller.dart
   └─ Veja como o estado é gerenciado

3. Abra: lib/presentation/home/home_binding.dart
   └─ Veja como dependências são injetadas

4. Abra: lib/data/repositories/turno_repo.dart
   └─ Veja como dados são acessados

5. Abra: lib/data/datasources/local/turno_dao.dart
   └─ Veja queries do banco
```

**Objetivo:** Entender o fluxo Page → Controller → Repository → DAO → Database

---

## 4️⃣ Criar Sua Primeira Feature (45 min)

Vamos criar um módulo simples de **"Perfil do Usuário"**!

### Passo 1: Criar Estrutura (5 min)

```bash
# Criar pasta do módulo
mkdir -p lib/presentation/perfil

# Criar arquivos
touch lib/presentation/perfil/perfil_controller.dart
touch lib/presentation/perfil/perfil_page.dart
touch lib/presentation/perfil/perfil_binding.dart
```

### Passo 2: Criar Controller (10 min)

Abra `lib/presentation/perfil/perfil_controller.dart` e copie do template:

```dart
import 'package:get/get.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Controller do perfil do usuário.
class PerfilController extends GetxController {
  final SessionManager _sessionManager = Get.find<SessionManager>();

  // Estado
  final RxBool isLoading = false.obs;

  // Getters
  String get nomeUsuario => _sessionManager.usuario?.nome ?? 'Usuário';
  String get matricula => _sessionManager.usuario?.matricula ?? 'N/A';

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('PerfilController inicializado', tag: 'PerfilController');
  }

  // Ação de logout
  Future<void> logout() async {
    try {
      await _sessionManager.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao fazer logout');
    }
  }
}
```

### Passo 3: Criar Page (15 min)

Abra `lib/presentation/perfil/perfil_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/perfil/perfil_controller.dart';

class PerfilPage extends GetView<PerfilController> {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),

            const SizedBox(height: 24),

            // Nome
            Text(
              controller.nomeUsuario,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Matrícula
            Text(
              'Matrícula: ${controller.matricula}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 48),

            // Botão de logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Passo 4: Criar Binding (5 min)

Abra `lib/presentation/perfil/perfil_binding.dart`:

```dart
import 'package:get/get.dart';
import 'package:nexa_app/presentation/perfil/perfil_controller.dart';

class PerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PerfilController());
  }
}
```

### Passo 5: Registrar Rota (5 min)

Abra `lib/app/routes/routes.dart` e adicione:

```dart
static const perfil = '/perfil';
```

Abra `lib/app/routes/app_pages.dart` e adicione:

```dart
import 'package:nexa_app/presentation/perfil/perfil_page.dart';
import 'package:nexa_app/presentation/perfil/perfil_binding.dart';

// Na lista de páginas:
GetPage(
  name: Routes.perfil,
  page: () => const PerfilPage(),
  binding: PerfilBinding(),
  middlewares: [AuthMiddleware()],  // Rota protegida
),
```

### Passo 6: Adicionar Navegação (5 min)

Na `lib/presentation/home/home_page.dart`, adicione um botão:

```dart
// No grid de funcionalidades ou em algum lugar visível:
ElevatedButton.icon(
  onPressed: () => Get.toNamed(Routes.perfil),
  icon: const Icon(Icons.person),
  label: const Text('Perfil'),
)
```

### Passo 7: Testar! (5 min)

```bash
# Hot reload
r

# Ou hot restart
R

# Ou executar novamente
flutter run
```

**Testar:**

- [ ] Botão "Perfil" aparece na home
- [ ] Ao clicar, navega para tela de perfil
- [ ] Mostra nome e matrícula do usuário
- [ ] Botão "Sair" funciona

---

## 5️⃣ Seu Primeiro Commit (15 min)

### Boas Práticas Git

```bash
# 1. Criar branch
git checkout -b feature/tela-perfil

# 2. Adicionar arquivos
git add lib/presentation/perfil/
git add lib/app/routes/

# 3. Commit descritivo
git commit -m "feat(perfil): adicionar tela de perfil do usuário

- Criar PerfilController com dados do SessionManager
- Criar PerfilPage com avatar e informações
- Criar PerfilBinding para DI
- Registrar rota /perfil
- Adicionar navegação na home"

# 4. Push
git push origin feature/tela-perfil

# 5. Criar Pull Request no GitHub/GitLab
```

---

## 📚 Recursos para Aprendizado

### GetX

```dart
// Estado reativo
final RxInt counter = 0.obs;
counter.value++;  // UI atualiza automaticamente

// Observar mudanças
Obx(() => Text('${counter.value}'))

// Navegação
Get.toNamed('/rota');
Get.back();
Get.offAllNamed('/home');

// Dependency Injection
Get.lazyPut(() => Controller());
final ctrl = Get.find<Controller>();
```

**Documentação:** https://github.com/jonataslaw/getx

---

### Drift (Database)

```dart
// Definir tabela
class Turno extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
}

// Query
final turnos = await select(turnoTable).get();

// Insert
await into(turnoTable).insert(turno);

// Update
await update(turnoTable).replace(turno);

// Delete
await delete(turnoTable).delete(turno);
```

**Documentação:** https://drift.simonbinder.eu/

---

## 🎯 Desafios Práticos

Após criar a tela de perfil, tente:

### Desafio 1: Adicionar Campo de Email

- Adicionar campo `email` no `UsuarioDto`
- Atualizar tabela no Drift
- Exibir na tela de perfil

### Desafio 2: Adicionar Foto de Perfil

- Usar `image_picker` para selecionar foto
- Salvar localmente
- Exibir no CircleAvatar

### Desafio 3: Editar Perfil

- Criar tela de edição
- Permitir alterar nome
- Salvar no banco
- Validar formulário

---

## 🐛 Erros Comuns e Soluções

### 1. "Instance not registered"

```dart
// ❌ ERRADO
class MyController extends GetxController {
  final MyService _service = Get.find<MyService>();  // Falha!
}

// ✅ CORRETO
class MyController extends GetxController {
  final MyService _service;

  MyController({required MyService service}) : _service = service;
}

// No Binding:
Get.lazyPut(() => MyService());
Get.lazyPut(() => MyController(service: Get.find()));
```

### 2. "Obx está reconstruindo tudo"

```dart
// ❌ RUIM
Obx(() => EntirePageWidget())

// ✅ BOM
Obx(() {
  final specificValue = controller.value.value;
  return SmallWidget(value: specificValue);
})
```

### 3. "Null check operator used on a null value"

```dart
// ❌ PERIGOSO
final nome = usuario!.nome;

// ✅ SEGURO
final nome = usuario?.nome ?? 'Padrão';
```

---

## 📖 Fluxo de Desenvolvimento

### Criar Nova Feature

```
1. Planejar
   └─ Definir módulo/feature
   └─ Listar requisitos
   └─ Verificar dependências

2. Criar Estrutura
   └─ presentation/[modulo]/[feature]/
   └─ controller.dart, page.dart, binding.dart

3. Implementar Backend
   └─ DTO (se necessário)
   └─ DAO (se necessário)
   └─ Repository (se necessário)

4. Implementar Frontend
   └─ Controller (estado e lógica)
   └─ Page (UI)
   └─ Widgets (componentes)

5. Registrar
   └─ Binding (DI)
   └─ Route (navegação)

6. Testar
   └─ Funcionalidade completa
   └─ Casos extremos
   └─ Performance

7. Documentar
   └─ Comentários no código
   └─ README do módulo (se complexo)

8. Code Review
   └─ Criar PR
   └─ Aguardar aprovação
   └─ Mergear
```

---

## 🎨 Padrões do Projeto

### Controllers

```dart
// SEMPRE:
✅ Injeção de dependências via construtor
✅ Estado reativo com Rx
✅ Logs em ações importantes
✅ Tratamento de erros
✅ Cleanup no onClose()

// NUNCA:
❌ Lógica de UI no controller
❌ Acesso direto ao DAO (use Repository)
❌ Get.find() no construtor
❌ Variáveis globais
```

### Pages

```dart
// SEMPRE:
✅ GetView<Controller> ou GetResponsiveView
✅ Const onde possível
✅ Métodos privados para organizar (_buildXxx)
✅ Obx granulares (pequenos e focados)

// NUNCA:
❌ Lógica de negócio na Page
❌ Obx gigantes
❌ setState (use GetX!)
```

### Organização

```dart
// ✅ BOM: Tudo junto
presentation/perfil/
├── perfil_controller.dart
├── perfil_page.dart
└── perfil_binding.dart

// ❌ RUIM: Separado
controllers/perfil_controller.dart
pages/perfil_page.dart
bindings/perfil_binding.dart
```

---

## 🧪 Debug e Troubleshooting

### Ver Logs

```dart
// No código, use:
import 'package:nexa_app/core/utils/logger/app_logger.dart';

AppLogger.d('Debug message', tag: 'MinhaClasse');
AppLogger.i('Info message', tag: 'MinhaClasse');
AppLogger.w('Warning message', tag: 'MinhaClasse');
AppLogger.e('Error message', tag: 'MinhaClasse', error: e);
```

### DevTools

```bash
# Abrir Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Em outro terminal, com app rodando:
flutter run --observatory-port=9200
```

**Use para:**

- 🔍 Inspecionar widget tree
- 📊 Ver performance (rebuilds)
- 💾 Explorar banco de dados
- 🐛 Debugar estado

---

## 📋 Checklist de Feature Completa

Antes de abrir PR, verificar:

### Código

- [ ] Segue [STYLE_GUIDE.md](STYLE_GUIDE.md)
- [ ] Imports organizados
- [ ] Código formatado (`dart format`)
- [ ] Sem warnings (`flutter analyze`)
- [ ] Null safety respeitado

### Funcionalidade

- [ ] Feature funciona como esperado
- [ ] Casos extremos tratados
- [ ] Erros com feedback adequado
- [ ] Loading states implementados
- [ ] Navegação funcionando

### Performance

- [ ] Obx granulares
- [ ] Const widgets usados
- [ ] Sem rebuilds desnecessários
- [ ] ListView.builder para listas

### Documentação

- [ ] Comentários em código complexo
- [ ] Métodos públicos documentados
- [ ] TODOs com contexto (se houver)

### Git

- [ ] Branch criada
- [ ] Commits semânticos
- [ ] PR com descrição clara

---

## 🎓 Materiais de Estudo

### Essenciais (Leia primeiro)

1. **[ARCHITECTURE.md](ARCHITECTURE.md)**

   - Arquitetura completa
   - Camadas e responsabilidades
   - Organização por módulos

2. **[STYLE_GUIDE.md](STYLE_GUIDE.md)**

   - Padrões de código
   - Convenções de nomenclatura
   - Boas práticas GetX

3. **[MODULE_TEMPLATE.md](MODULE_TEMPLATE.md)**
   - Templates prontos
   - Exemplos de código
   - Estrutura de módulos

### Complementares (Consulte quando necessário)

4. **[DIAGRAMS.md](DIAGRAMS.md)**

   - Diagramas visuais
   - Fluxos de dados
   - Comunicação entre camadas

5. **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)**
   - Histórico de migração
   - Scripts úteis
   - Troubleshooting

---

## 💡 Dicas para Produtividade

### Atalhos Úteis (VS Code/Cursor)

```
Ctrl + P        → Buscar arquivo
Ctrl + Shift + P → Command Palette
Ctrl + .        → Quick fixes
Ctrl + Space    → Autocomplete
F12             → Ir para definição
Shift + F12     → Ver referências
```

### Snippets Úteis

Crie snippets para templates comuns:

- `getc` → GetX Controller template
- `getp` → GetX Page template
- `getb` → GetX Binding template

### Hot Reload vs Hot Restart

```
r  → Hot Reload (rápido, mantém estado)
R  → Hot Restart (completo, limpa estado)
q  → Quit
```

**Quando usar cada um:**

- **Hot Reload (r)**: Mudanças em UI, cores, textos
- **Hot Restart (R)**: Mudanças em lógica, estado inicial, bindings

---

## 🔍 Explorando o Código

### Principais Arquivos

```
lib/
├── main.dart                              ← COMECE AQUI
│                                           Inicialização do app
│
├── app/app.dart                           ← MaterialApp e configurações
│
├── shared/bindings/initial_binding.dart   ← Dependências globais
│
├── core/database/app_database.dart        ← Definição do banco
│
├── presentation/
│   ├── home/                              ← Dashboard principal
│   ├── login/                             ← Autenticação
│   └── turno/                             ← Feature principal
│       ├── abrir/                         ← Abertura de turno
│       ├── checklist/                     ← Sistema de checklists
│       │   ├── veicular/
│       │   ├── epc/
│       │   └── epi/
│       └── servicos/                      ← Gestão de serviços
```

### Arquivos que Você Vai Mexer Muito

1. **Controllers** (`*_controller.dart`)
   - Onde você coloca lógica de estado
2. **Pages** (`*_page.dart`)
   - Onde você desenha a UI
3. **Repositories** (`data/repositories/*`)
   - Onde você acessa dados
4. **Routes** (`app/routes/app_pages.dart`)
   - Sempre que criar nova tela

---

## 🎯 Metas de Aprendizado

### Semana 1

- [ ] Ambiente configurado
- [ ] App rodando
- [ ] Primeira feature criada
- [ ] Primeiro PR aprovado

### Semana 2

- [ ] Arquitetura compreendida
- [ ] Criou 3+ features
- [ ] Contribuiu para code review
- [ ] Ajudou outro dev

### Mês 1

- [ ] Domínio completo do projeto
- [ ] Capaz de criar features complexas
- [ ] Referência para novos devs
- [ ] Propôs melhorias na arquitetura

---

## 📞 Suporte

### Onde Encontrar Ajuda

1. **Documentação** → [`docs/`](.)
2. **Code Review** → Peça feedback ao time
3. **Pair Programming** → Trabalhe com dev sênior
4. **Issues** → Verifique issues conhecidos

### Perguntas Frequentes

**Q: Onde criar nova feature?**  
A: Em `lib/presentation/[modulo]/[feature]/`

**Q: Como acessar banco de dados?**  
A: Via Repository → DAO → Drift

**Q: Como adicionar nova rota?**  
A: Registrar em `app/routes/app_pages.dart`

**Q: Como fazer loading?**  
A: `RxBool isLoading` + `Obx(() => if (loading) ...)`

**Q: GetX ou Bloc/Riverpod?**  
A: Projeto usa **GetX** - mantenha consistência

---

## 🎉 Parabéns!

Você completou o onboarding! Agora você está pronto para:

- ✅ Criar novas features
- ✅ Contribuir para o projeto
- ✅ Fazer code reviews
- ✅ Ajudar outros devs

**Próximo passo:** Escolha uma issue e comece a codificar! 💻

---

**Precisa de ajuda?** Consulte a [documentação completa](.) ou pergunte ao time! 🚀
