# Referência Rápida - Nexa App

> **Cheat sheet para desenvolvimento diário**  
> **Mantenha este documento aberto enquanto desenvolve!**

---

## 📁 Onde Colocar Cada Tipo de Arquivo

| Eu criei um... | Vai em... | Exemplo |
|----------------|-----------|---------|
| **Controller** | `presentation/[modulo]/[feature]/` | `home_controller.dart` |
| **Page** | `presentation/[modulo]/[feature]/` | `home_page.dart` |
| **Binding** | `presentation/[modulo]/[feature]/` | `home_binding.dart` |
| **Widget local** | `presentation/[modulo]/[feature]/widgets/` | `turno_card.dart` |
| **Widget compartilhado** | `shared/widgets/` | `custom_button.dart` |
| **Repository** | `data/repositories/` | `turno_repo.dart` |
| **DTO** | `data/models/` | `turno_dto.dart` |
| **DAO** | `data/datasources/local/` | `turno_dao.dart` |
| **Entity (futuro)** | `domain/entities/` | `turno.dart` |
| **Interface (futuro)** | `domain/repositories/` | `i_turno_repository.dart` |
| **Middleware** | `shared/middlewares/` | `auth_middleware.dart` |
| **Constante** | `core/constants/` | `api_constants.dart` |
| **Util** | `core/utils/` | `date_formatter.dart` |

---

## 🎨 Templates Rápidos

### Novo Controller

```dart
import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

class [Nome]Controller extends GetxController {
  // Dependências
  final Repository _repository;
  
  // Estado
  final RxBool isLoading = false.obs;
  
  // Construtor
  [Nome]Controller({required Repository repository})
      : _repository = repository;
  
  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    AppLogger.i('Inicializado', tag: '[Nome]Controller');
  }
  
  // Métodos públicos
  Future<void> carregarDados() async {
    isLoading.value = true;
    try {
      // Lógica aqui
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cleanup
  @override
  void onClose() {
    super.onClose();
  }
}
```

### Nova Page

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class [Nome]Page extends GetView<[Nome]Controller> {
  const [Nome]Page({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('[Título]')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildContent();
      }),
    );
  }
  
  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Conteúdo aqui
      ],
    );
  }
}
```

### Novo Binding

```dart
import 'package:get/get.dart';

class [Nome]Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => [Nome]Controller());
  }
}
```

---

## 🚀 Comandos Úteis

### Flutter

```bash
# Executar app
flutter run

# Hot reload (rápido)
r

# Hot restart (completo)
R

# Quit
q

# Limpar build
flutter clean

# Analisar código
flutter analyze

# Formatar código
dart format lib/

# Testes
flutter test

# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release
```

### Drift (Database)

```bash
# Gerar código
dart run build_runner build --delete-conflicting-outputs

# Watch mode (regenera automaticamente)
dart run build_runner watch

# Limpar gerado
dart run build_runner clean
```

### Git

```bash
# Criar branch
git checkout -b feature/nome-feature

# Status
git status

# Adicionar arquivos
git add lib/presentation/meu_modulo/

# Commit
git commit -m "feat(modulo): descrição"

# Push
git push origin feature/nome-feature

# Voltar mudanças
git restore arquivo.dart
```

---

## 📝 Padrões de Commit

```bash
# Features
feat(home): adicionar botão de perfil
feat(turno): implementar checklist EPI

# Correções
fix(login): corrigir validação de senha
fix(home): corrigir crash ao carregar turno null

# Refatoração
refactor(core): reorganizar estrutura de pastas
refactor(turno): extrair lógica para service

# Performance
perf(home): otimizar rebuilds com Obx granulares
perf(list): usar ListView.builder

# Documentação
docs: adicionar guia de arquitetura
docs(turno): documentar fluxo de checklists

# Testes
test(home): adicionar testes do controller
test(turno): aumentar coverage para 80%

# Chores
chore: atualizar dependências
chore: configurar CI/CD
```

---

## 🎯 GetX Quick Reference

### Estado Reativo

```dart
// Criar observável
final RxInt count = 0.obs;
final RxBool isLoading = false.obs;
final RxString name = ''.obs;
final Rx<User?> user = Rx(null);
final RxList<Item> items = <Item>[].obs;

// Atualizar
count.value = 10;
count.value++;
items.add(newItem);
items.assignAll(newList);

// Observar
Obx(() => Text('${count.value}'))
```

### Navegação

```dart
// Navegar
Get.toNamed('/rota');
Get.toNamed('/rota', arguments: {'id': 123});

// Voltar
Get.back();
Get.back(result: true);

// Substituir
Get.offNamed('/rota');

// Limpar pilha
Get.offAllNamed('/home');

// Pegar argumentos
final args = Get.arguments as Map<String, dynamic>;
final id = args['id'];
```

### Dependency Injection

```dart
// Registrar (no Binding)
Get.put(Controller());          // Imediato
Get.lazyPut(() => Controller()); // Lazy
Get.putAsync(() async => Controller()); // Async

// Buscar
final ctrl = Get.find<Controller>();

// Verificar se existe
if (Get.isRegistered<Controller>()) { }

// Deletar
Get.delete<Controller>();
```

### Dialogs e Snackbars

```dart
// Snackbar
Get.snackbar(
  'Título',
  'Mensagem',
  snackPosition: SnackPosition.BOTTOM,
);

// Dialog
Get.defaultDialog(
  title: 'Título',
  middleText: 'Mensagem',
  confirm: ElevatedButton(...),
);

// Bottom Sheet
Get.bottomSheet(Widget());
```

---

## 💾 Drift Quick Reference

### Query

```dart
// Select all
final items = await select(table).get();

// Select with where
final item = await (select(table)
  ..where((t) => t.id.equals(1)))
  .getSingleOrNull();

// Select with join
final query = select(table).join([
  leftOuterJoin(otherTable, otherTable.id.equalsExp(table.foreignId)),
]);

// Ordenar
select(table)..orderBy([(t) => OrderingTerm.desc(t.date)]);
```

### Insert

```dart
// Insert simples
await into(table).insert(data);

// Insert retornando ID
final id = await into(table).insert(data);

// Insert or replace
await into(table).insertOnConflictUpdate(data);
```

### Update

```dart
// Update por ID
await (update(table)..where((t) => t.id.equals(1)))
  .write(data);

// Replace (UPDATE completo)
await update(table).replace(data);
```

### Delete

```dart
// Delete por ID
await (delete(table)..where((t) => t.id.equals(1))).go();

// Delete all
await delete(table).go();
```

---

## 🎨 UI Quick Reference

### Cores do Tema

```dart
// Acessar cores
final colorScheme = Theme.of(context).colorScheme;

colorScheme.primary         // Azul principal
colorScheme.secondary       // Cor secundária
colorScheme.error           // Vermelho (erros)
colorScheme.surface         // Background
colorScheme.onPrimary       // Texto sobre primary
```

### Widgets Comuns

```dart
// Loading
const CircularProgressIndicator()

// Espaçamento
const SizedBox(height: 16)
const SizedBox(width: 8)

// Card
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ...,
)

// Botão
ElevatedButton(
  onPressed: () {},
  child: const Text('Botão'),
)

// Campo de texto
TextFormField(
  decoration: const InputDecoration(
    labelText: 'Label',
    hintText: 'Hint',
  ),
)
```

---

## 🔧 Troubleshooting Rápido

| Problema | Solução |
|----------|---------|
| Build falha | `flutter clean && flutter pub get` |
| Hot reload não funciona | Pressione `R` (restart) |
| Get.find() falha | Verificar binding |
| Drift erro | `dart run build_runner build --delete-conflicting-outputs` |
| Import não resolve | Verificar caminho (use absoluto) |
| Obx não atualiza | Verificar se é `.value` |
| Performance ruim | Obx granulares, const widgets |

---

## 📊 Análise de Código

### Antes de Commitar

```bash
# Verificar
flutter analyze              # Erros e warnings
dart format lib/             # Formatar código
flutter test                 # Rodar testes

# Tudo OK?
git commit
```

### Métricas Aceitáveis

| Métrica | Máximo Aceitável |
|---------|------------------|
| **Complexidade ciclomática** | 10 por método |
| **Linhas por arquivo** | 500 |
| **Linhas por método** | 50 |
| **Parâmetros por método** | 5 |
| **Nível de aninhamento** | 4 |

---

## 🎯 Checklist de PR

Antes de abrir Pull Request:

### Código
- [ ] `flutter analyze` sem erros
- [ ] `dart format` aplicado
- [ ] Segue STYLE_GUIDE.md
- [ ] Imports organizados
- [ ] Sem código comentado
- [ ] Sem console.log / prints

### Funcionalidade
- [ ] Feature funciona
- [ ] Casos extremos tratados
- [ ] Loading states
- [ ] Error states
- [ ] Empty states

### Performance
- [ ] Obx granulares
- [ ] Const widgets
- [ ] Sem memory leaks
- [ ] ListView.builder para listas

### Testes
- [ ] Testado manualmente
- [ ] Testes automatizados (se aplicável)

### Git
- [ ] Branch com nome semântico
- [ ] Commits pequenos e descritivos
- [ ] PR com descrição clara
- [ ] Screenshots (se UI)

---

## 📞 Contatos Rápidos

| Preciso de... | Falar com... |
|---------------|--------------|
| Aprovação de PR | Tech Lead |
| Dúvida de arquitetura | Arquiteto |
| Ajuda com bug | Senior Dev |
| Acesso a ambiente | DevOps |
| Dúvida de negócio | PO/PM |

---

## 🔗 Links Importantes

### Documentação
- 📚 [Índice Completo](README.md)
- 🌟 [Overview](OVERVIEW.md)
- 💻 [Getting Started](GETTING_STARTED.md)
- 📐 [Arquitetura](ARCHITECTURE.md)
- 🎨 [Style Guide](STYLE_GUIDE.md)

### Ferramentas
- [Flutter Docs](https://docs.flutter.dev/)
- [GetX Docs](https://github.com/jonataslaw/getx)
- [Drift Docs](https://drift.simonbinder.eu/)
- [Material Design 3](https://m3.material.io/)

### Projeto
- [Repositório](link)
- [Board Jira](link)
- [Wiki](link)
- [CI/CD](link)

---

**Imprima e cole na parede! 📌**

