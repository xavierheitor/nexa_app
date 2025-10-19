# Guia de Estilo - Nexa App

> **Data:** Outubro 2025  
> **Status:** ✅ Guia Oficial de Desenvolvimento

---

## 📑 Índice

1. [Nomenclatura](#nomenclatura)
2. [Estrutura de Arquivos](#estrutura-de-arquivos)
3. [Código Dart](#código-dart)
4. [GetX Patterns](#getx-patterns)
5. [UI e Widgets](#ui-e-widgets)
6. [Comentários e Documentação](#comentários-e-documentação)
7. [Git e Versionamento](#git-e-versionamento)
8. [Performance](#performance)

---

## Nomenclatura

### Arquivos

**Sempre use `snake_case` para nomes de arquivos:**

```bash
✅ CORRETO:
home_controller.dart
abrir_turno_page.dart
custom_button_widget.dart

❌ ERRADO:
HomeController.dart
abrirTurnoPage.dart
CustomButtonWidget.dart
```

### Classes

**Use `PascalCase` para nomes de classes:**

```dart
✅ CORRETO:
class HomeController extends GetxController { }
class TurnoRepository { }
class CustomButton extends StatelessWidget { }

❌ ERRADO:
class homeController extends GetxController { }
class turno_repository { }
class customButton extends StatelessWidget { }
```

### Variáveis e Métodos

**Use `camelCase` para variáveis, métodos e parâmetros:**

```dart
✅ CORRETO:
final turnoAtivo = controller.turnoAtivo;
void abrirTurno() { }
int calcularDuracao() { }

❌ ERRADO:
final TurnoAtivo = controller.turnoAtivo;
void AbrirTurno() { }
int CalcularDuracao() { }
```

### Constantes

**Use `camelCase` para constantes:**

```dart
✅ CORRETO:
const apiBaseUrl = 'https://api.example.com';
const maxRetryAttempts = 3;

❌ ERRADO:
const API_BASE_URL = 'https://api.example.com';
const MAX_RETRY_ATTEMPTS = 3;
```

### Enums

**Use `PascalCase` para enums e `camelCase` para valores:**

```dart
✅ CORRETO:
enum SituacaoTurno {
  emAbertura,
  aberto,
  fechado,
}

❌ ERRADO:
enum situacao_turno {
  EM_ABERTURA,
  ABERTO,
  FECHADO,
}
```

### Prefixos e Sufixos

**Convenções específicas do projeto:**

| Tipo       | Padrão                    | Exemplo            |
| ---------- | ------------------------- | ------------------ |
| Privado    | `_prefixo`                | `_carregarDados()` |
| Observável | `sufixo.obs`              | `isLoading.obs`    |
| Controller | `[Feature]Controller`     | `HomeController`   |
| Page       | `[Feature]Page`           | `LoginPage`        |
| Widget     | `[Nome]Widget` (opcional) | `CustomButton`     |
| Repository | `[Nome]Repository`        | `TurnoRepository`  |
| DAO        | `[Nome]Dao`               | `TurnoDao`         |
| DTO        | `[Nome]Dto`               | `TurnoDto`         |

---

## Estrutura de Arquivos

### Organização de um Módulo

```bash
presentation/[modulo]/
├── [feature]/
│   ├── [feature]_controller.dart      # Obrigatório
│   ├── [feature]_page.dart            # Obrigatório
│   ├── [feature]_binding.dart         # Obrigatório
│   ├── widgets/                       # Opcional
│   │   └── [widget]_widget.dart
│   ├── models/                        # Opcional
│   │   └── [model].dart
│   └── services/                      # Raro
│       └── [service]_service.dart
```

### Quando Criar Subpastas

**`widgets/`** - Criar quando:

- ✅ Tem 2+ widgets específicos da feature
- ✅ Widget tem >100 linhas
- ✅ Widget é reutilizado dentro do módulo

**`models/`** - Criar quando:

- ✅ Tem models de formulário/UI
- ✅ Tem classes auxiliares da feature
- ❌ NÃO para entidades de domínio (vão em `domain/entities/`)

**`services/`** - Criar quando:

- ✅ Lógica complexa específica da feature
- ✅ Precisa ser injetada e testada separadamente
- ❌ Evite quando possível, prefira métodos no controller

---

## Código Dart

### Ordem de Imports

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Packages Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages externos
import 'package:get/get.dart';
import 'package:drift/drift.dart';

// 4. Projeto (ordem alfabética)
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/domain/entities/turno.dart';
import 'package:nexa_app/presentation/home/home_controller.dart';
```

### Ordem dentro de uma Classe

```dart
class ExampleController extends GetxController {
  // ====================================================================
  // 1. DEPENDÊNCIAS (final, injetadas)
  // ====================================================================

  final TurnoRepository _turnoRepository;
  final AuthService _authService;

  // ====================================================================
  // 2. ESTADO OBSERVÁVEL (RxObjects)
  // ====================================================================

  final RxBool isLoading = false.obs;
  final Rx<Turno?> turnoAtivo = Rx(null);
  final RxList<Servico> servicos = <Servico>[].obs;

  // ====================================================================
  // 3. VARIÁVEIS DE INSTÂNCIA (não observáveis)
  // ====================================================================

  Timer? _timer;
  StreamSubscription? _subscription;

  // ====================================================================
  // 4. GETTERS
  // ====================================================================

  bool get hasTurno => turnoAtivo.value != null;

  String get statusTurno => turnoAtivo.value?.situacao.name ?? 'Nenhum';

  // ====================================================================
  // 5. CONSTRUTOR
  // ====================================================================

  ExampleController({
    required TurnoRepository turnoRepository,
    required AuthService authService,
  })  : _turnoRepository = turnoRepository,
        _authService = authService;

  // ====================================================================
  // 6. LIFECYCLE METHODS
  // ====================================================================

  @override
  void onInit() {
    super.onInit();
    _carregarDadosIniciais();
  }

  @override
  void onReady() {
    super.onReady();
    _iniciarAtualizacaoAutomatica();
  }

  // ====================================================================
  // 7. MÉTODOS PÚBLICOS
  // ====================================================================

  Future<void> carregarTurno() async {
    isLoading.value = true;
    try {
      final turno = await _turnoRepository.buscarTurnoAtivo();
      turnoAtivo.value = turno;
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void abrirDetalhes(int turnoId) {
    Get.toNamed('/turno/detalhes', arguments: {'id': turnoId});
  }

  // ====================================================================
  // 8. MÉTODOS PRIVADOS
  // ====================================================================

  Future<void> _carregarDadosIniciais() async {
    await carregarTurno();
  }

  void _iniciarAtualizacaoAutomatica() {
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => carregarTurno(),
    );
  }

  void _handleError(dynamic error) {
    Get.snackbar('Erro', error.toString());
  }

  // ====================================================================
  // 9. LIFECYCLE CLEANUP
  // ====================================================================

  @override
  void onClose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.onClose();
  }
}
```

### Formatação

**Use formatação automática (dart format):**

```bash
# Formatar todo o projeto
dart format .

# Formatar arquivo específico
dart format lib/presentation/home/home_controller.dart
```

**Linha máxima:** 80 caracteres (flexível até 100 em casos específicos)

**Indentação:** 2 espaços

---

## GetX Patterns

### Controllers

#### ✅ **BOM**: Controller focado e testável

```dart
class HomeController extends GetxController {
  final ITurnoRepository _repository;

  final RxBool isLoading = false.obs;
  final Rx<Turno?> turno = Rx(null);

  HomeController({required ITurnoRepository repository})
      : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    carregarTurno();
  }

  Future<void> carregarTurno() async {
    isLoading.value = true;
    try {
      turno.value = await _repository.buscarTurnoAtivo();
    } finally {
      isLoading.value = false;
    }
  }
}
```

#### ❌ **RUIM**: Controller com lógica de negócio

```dart
class HomeController extends GetxController {
  // ❌ Acesso direto ao DAO
  final TurnoDao _dao = Get.find();

  Future<void> carregarTurno() async {
    // ❌ Lógica de negócio no controller
    final dados = await _dao.buscarTurnoAtivo();
    if (dados != null) {
      if (dados.horaFim == null) {
        // ❌ Transformação de dados no controller
        turno.value = Turno(
          id: dados.id,
          horaInicio: dados.horaInicio,
          // ...
        );
      }
    }
  }
}
```

### Observables (Rx)

#### ✅ **BOM**: Uso correto de observables

```dart
// Estados simples
final RxBool isLoading = false.obs;
final RxString userName = ''.obs;
final RxInt counter = 0.obs;

// Objetos complexos
final Rx<User?> user = Rx(null);
final RxList<Turno> turnos = <Turno>[].obs;

// Uso otimizado no widget
Obx(() {
  final turno = controller.turno.value;
  if (turno == null) return EmptyWidget();
  return TurnoCard(turno: turno);
})
```

#### ❌ **RUIM**: Overuse de observables

```dart
// ❌ Tudo observável desnecessariamente
final RxString version = '1.0.0'.obs;  // Nunca muda!
final RxInt maxRetries = 3.obs;        // Constante!

// ❌ Obx muito amplo
Obx(() => CompletePageWidget())  // Reconstrói tudo!
```

### Bindings

#### ✅ **BOM**: Binding com injeção limpa

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Injetar repository
    Get.lazyPut<ITurnoRepository>(
      () => TurnoRepositoryImpl(
        dao: Get.find(),
        api: Get.find(),
      ),
    );

    // Injetar controller
    Get.lazyPut(
      () => HomeController(
        repository: Get.find(),
      ),
    );
  }
}
```

#### ❌ **RUIM**: Binding com dependências hardcoded

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // ❌ Controller criando próprias dependências
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends GetxController {
  // ❌ Dependências hardcoded
  final _repository = TurnoRepository(
    dao: TurnoDao(Get.find()),
  );
}
```

---

## UI e Widgets

### Estrutura de uma Page

```dart
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  // Quebrar em métodos privados para melhor organização
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Home'),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoading();
      }

      if (controller.turno.value == null) {
        return _buildEmpty();
      }

      return _buildContent();
    });
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text('Nenhum turno ativo'),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        _buildTurnoCard(),
        _buildServicosList(),
      ],
    );
  }

  Widget _buildTurnoCard() {
    return Card(
      child: Obx(() {
        final turno = controller.turno.value;
        return ListTile(
          title: Text('Turno #${turno?.id}'),
        );
      }),
    );
  }

  Widget _buildServicosList() {
    // ...
  }

  Widget? _buildFAB() {
    return FloatingActionButton(
      onPressed: controller.abrirTurno,
      child: const Icon(Icons.add),
    );
  }
}
```

### Performance de Widgets

#### ✅ **BOM**: Obx granular e const

```dart
// Obx pequeno e focado
Obx(() => Text(controller.userName.value))

// Const quando possível
const Icon(Icons.home)
const SizedBox(height: 16)
const Divider()

// Evitar reconstrução desnecessária
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ItemCard(item: item);  // Widget separado
  },
)
```

#### ❌ **RUIM**: Obx amplo e sem const

```dart
// ❌ Obx muito amplo
Obx(() {
  return Scaffold(
    appBar: AppBar(...),
    body: Column(
      children: [
        // Tudo reconstrói quando QUALQUER observable muda!
      ],
    ),
  );
})

// ❌ Sem const
Icon(Icons.home)  // Pode ser const Icon(Icons.home)
SizedBox(height: 16)  // Pode ser const SizedBox(height: 16)
```

### Widgets Reutilizáveis

**Quando criar um widget reutilizável:**

```dart
// ✅ Widget com parâmetros claros
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
```

---

## Comentários e Documentação

### Regras Gerais

1. **Comente o "porquê", não o "o quê"**
2. **Código deve ser auto-explicativo**
3. **Comentários para lógica complexa**
4. **Documentação para APIs públicas**

### Bons Comentários

```dart
// ✅ Explica decisão de design
// Usa Timer ao invés de Stream para evitar memory leak
// quando o controller é descartado antes do stream completar
Timer.periodic(duration, callback);

// ✅ Explica limitação/workaround
// TODO: Remover quando API suportar paginação
final allData = await _api.fetchAll();

// ✅ Avisa sobre comportamento não-óbvio
// IMPORTANTE: Este método DEVE ser chamado antes de onReady()
// caso contrário, os dados não estarão disponíveis na UI
void initializeData() { }
```

### Maus Comentários

```dart
// ❌ Óbvio demais
// Incrementa contador
counter++;

// ❌ Comentário redundante
// Retorna o turno ativo
Turno getTurnoAtivo() { }

// ❌ Comentário desatualizado
// Retorna lista de turnos (código agora retorna apenas 1)
Turno? getTurnoAtivo() { }
```

### Documentação de Classes

````dart
/// Controlador responsável pela tela de home.
///
/// Gerencia o estado do turno ativo e permite
/// navegação para outras funcionalidades.
///
/// **Dependências:**
/// - [ITurnoRepository] - Acesso aos dados de turno
/// - [IAuthService] - Informações do usuário
///
/// **Exemplo de uso:**
/// ```dart
/// final controller = Get.find<HomeController>();
/// await controller.carregarTurno();
/// ```
class HomeController extends GetxController {
  // ...
}
````

### Documentação de Métodos

```dart
/// Carrega o turno ativo do banco de dados.
///
/// Este método atualiza o estado [turnoAtivo] e [isLoading].
/// Em caso de erro, exibe um snackbar para o usuário.
///
/// **Retorna:**
/// - `Future<void>` - Completa quando o carregamento termina
///
/// **Exceções:**
/// - Pode lançar [RepositoryException] em caso de erro de banco
Future<void> carregarTurno() async {
  // ...
}
```

### TODOs e FIXMEs

```dart
// TODO(xavier): Implementar cache para melhorar performance
// Prioridade: Média | Data: 2025-11-01

// FIXME(xavier): Memory leak ao descartar controller
// Bug: #123 | Crítico

// HACK: Workaround temporário até API ser corrigida
// Remove quando versão 2.0 da API estiver em produção
```

---

## Git e Versionamento

### Commits

**Padrão de mensagem:**

```git
<tipo>(<escopo>): <descrição curta>

<descrição detalhada opcional>

<referencias opcionais>
```

**Tipos:**

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação (sem mudança de lógica)
- `refactor`: Refatoração de código
- `perf`: Melhoria de performance
- `test`: Adição/correção de testes
- `chore`: Tarefas de build/config

**Exemplos:**

```bash
# ✅ BOM
git commit -m "feat(turno): adicionar abertura de turno com checklist"
git commit -m "fix(home): corrigir crash ao carregar turno null"
git commit -m "refactor(core): reorganizar estrutura de pastas"

# ❌ RUIM
git commit -m "updates"
git commit -m "fix bug"
git commit -m "mudanças gerais"
```

### Branches

**Padrão de nomenclatura:**

```html
<tipo>/<descrição-curta>
```

**Exemplos:**

```bash
feature/abrir-turno
bugfix/home-crash
refactor/nova-arquitetura
hotfix/login-error
```

---

## Performance

### Otimizações GetX

```dart
// ✅ BOM: Obx granular
Obx(() => Text(controller.title.value))

// ❌ RUIM: Obx amplo
Obx(() => EntirePageWidget())

// ✅ BOM: Workers para reações
ever(turnoAtivo, (_) {
  // Reage apenas quando turno muda
});

// ❌ RUIM: Polling manual
Timer.periodic(duration, () {
  // Verifica constantemente
});
```

### Listas

```dart
// ✅ BOM: ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ RUIM: ListView com map
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### Imagens

```dart
// ✅ BOM: Cached network image
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
)

// ❌ RUIM: Image.network sem cache
Image.network(url)
```

---

## Checklist de Code Review

Ao revisar código (PR), verificar:

### Arquitetura

- [ ] Código no módulo correto?
- [ ] Separação de responsabilidades OK?
- [ ] Dependências injetadas corretamente?

#### Performance

- [ ] Obx granulares?
- [ ] Const widgets onde possível?
- [ ] ListView.builder para listas longas?

### Qualidade

- [ ] Nomes descritivos?
- [ ] Métodos com responsabilidade única?
- [ ] Tratamento de erros adequado?
- [ ] Null safety respeitado?

### Documentação

- [ ] Código auto-explicativo?
- [ ] Comentários para lógica complexa?
- [ ] TODOs com contexto?

### Testes

- [ ] Lógica de negócio testada?
- [ ] Casos extremos cobertos?

---

## Ferramentas Úteis

### Análise de Código

```bash
# Análise estática
flutter analyze

# Verificar formatação
dart format --output=none --set-exit-if-changed .

# Métricas de código
dart pub global activate dart_code_metrics
metrics lib
```

### Geração de Código

```bash
# Drift (database)
dart run build_runner build --delete-conflicting-outputs

# Geração de assets
flutter pub run flutter_gen
```

---

## Recursos

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [GetX Best Practices](https://github.com/jonataslaw/getx#best-practices)
- [Clean Code - Robert C. Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)

---

**Última atualização:** Outubro 2025  
**Mantido por:** Equipe Nexa
