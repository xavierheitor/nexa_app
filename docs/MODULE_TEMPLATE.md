# Template de Módulo - Nexa App

> **Guia de Referência Rápida**  
> **Use como template ao criar novos módulos**

---

## 📦 Estrutura de um Módulo Completo

```bash
presentation/[nome_modulo]/
├── [sub_feature]/
│   ├── [feature]_controller.dart
│   ├── [feature]_page.dart
│   ├── [feature]_binding.dart
│   ├── widgets/                    # Opcional
│   │   └── [componente].dart
│   ├── models/                     # Opcional
│   │   └── [model].dart
│   └── services/                   # Raro
│       └── [service].dart
└── README.md                       # Documentação do módulo
```

---

## 📄 Template: Controller

```dart
import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/domain/repositories/i_[nome]_repository.dart';

/// Controlador responsável por [descrição da feature].
///
/// **Responsabilidades:**
/// - Gerenciar estado da interface
/// - Coordenar chamadas ao repository
/// - Tratar erros e exibir feedback
///
/// **Dependências:**
/// - [I[Nome]Repository] - Acesso aos dados
class [Feature]Controller extends GetxController {
  // ========================================================================
  // DEPENDÊNCIAS
  // ========================================================================

  final I[Nome]Repository _repository;

  // ========================================================================
  // ESTADO OBSERVÁVEL
  // ========================================================================

  /// Indica se está carregando dados.
  final RxBool isLoading = false.obs;

  /// Dados principais da tela.
  final Rx<[Tipo]?> data = Rx(null);

  /// Mensagem de erro (se houver).
  final RxnString erro = RxnString();

  // ========================================================================
  // GETTERS
  // ========================================================================

  /// Verifica se tem dados carregados.
  bool get hasData => data.value != null;

  // ========================================================================
  // CONSTRUTOR
  // ========================================================================

  [Feature]Controller({
    required I[Nome]Repository repository,
  }) : _repository = repository;

  // ========================================================================
  // LIFECYCLE
  // ========================================================================

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('[Feature]Controller inicializado', tag: '[Feature]Controller');
    _carregarDadosIniciais();
  }

  @override
  void onReady() {
    super.onReady();
    // Executado quando a página está pronta
  }

  // ========================================================================
  // MÉTODOS PÚBLICOS
  // ========================================================================

  /// Carrega os dados iniciais da tela.
  Future<void> carregarDados() async {
    if (isLoading.value) return;

    isLoading.value = true;
    erro.value = null;

    try {
      AppLogger.d('Carregando dados...', tag: '[Feature]Controller');

      final resultado = await _repository.buscarDados();
      data.value = resultado;

      AppLogger.i('Dados carregados com sucesso', tag: '[Feature]Controller');
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao carregar dados',
        tag: '[Feature]Controller',
        error: e,
        stackTrace: stackTrace,
      );
      erro.value = 'Erro ao carregar dados. Tente novamente.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Ação do botão principal.
  Future<void> executarAcao() async {
    // Implementação
  }

  // ========================================================================
  // MÉTODOS PRIVADOS
  // ========================================================================

  Future<void> _carregarDadosIniciais() async {
    await carregarDados();
  }

  // ========================================================================
  // CLEANUP
  // ========================================================================

  @override
  void onClose() {
    // Limpar recursos (timers, streams, etc)
    AppLogger.d('[Feature]Controller finalizado', tag: '[Feature]Controller');
    super.onClose();
  }
}
```

---

## 📄 Template: Page

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_app/presentation/[modulo]/[feature]/[feature]_controller.dart';

/// Página de [descrição da feature].
///
/// **Responsabilidades:**
/// - Renderizar interface do usuário
/// - Reagir a mudanças de estado
/// - Capturar eventos do usuário
class [Feature]Page extends GetView<[Feature]Controller> {
  const [Feature]Page({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(colorScheme),
      body: _buildBody(theme, colorScheme),
      floatingActionButton: _buildFAB(colorScheme),
    );
  }

  // ==========================================================================
  // APP BAR
  // ==========================================================================

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      title: const Text('[Título da Página]'),
      centerTitle: true,
    );
  }

  // ==========================================================================
  // BODY
  // ==========================================================================

  Widget _buildBody(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Loading state - Obx isolado
        Obx(() {
          if (controller.isLoading.value) {
            return Expanded(child: _buildLoading());
          }
          return const SizedBox.shrink();
        }),

        // Error state - Obx isolado
        Obx(() {
          final erro = controller.erro.value;
          if (erro != null && erro.isNotEmpty) {
            return Expanded(child: _buildError(erro, colorScheme));
          }
          return const SizedBox.shrink();
        }),

        // Content - Obx isolado
        Obx(() {
          if (!controller.isLoading.value &&
              controller.erro.value == null &&
              controller.hasData) {
            return Expanded(child: _buildContent(theme, colorScheme));
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // ==========================================================================
  // STATES
  // ==========================================================================

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando...'),
        ],
      ),
    );
  }

  Widget _buildError(String mensagem, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.carregarDados,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMainCard(theme, colorScheme),
        const SizedBox(height: 16),
        _buildActionButtons(colorScheme),
      ],
    );
  }

  // ==========================================================================
  // COMPONENTS
  // ==========================================================================

  Widget _buildMainCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final data = controller.data.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.titulo ?? 'Sem título',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                data?.descricao ?? '',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.executarAcao,
            child: const Text('Executar'),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // FAB
  // ==========================================================================

  Widget? _buildFAB(ColorScheme colorScheme) {
    return FloatingActionButton(
      onPressed: controller.executarAcao,
      child: const Icon(Icons.add),
    );
  }
}
```

---

## 📄 Template: Binding

```dart
import 'package:get/get.dart';
import 'package:nexa_app/data/datasources/local/[nome]_dao.dart';
import 'package:nexa_app/data/repositories/[nome]_repository_impl.dart';
import 'package:nexa_app/domain/repositories/i_[nome]_repository.dart';
import 'package:nexa_app/presentation/[modulo]/[feature]/[feature]_controller.dart';

/// Binding responsável por injetar dependências da feature [Feature].
///
/// **Dependências injetadas:**
/// - [I[Nome]Repository] - Acesso aos dados
/// - [[Feature]Controller] - Controlador da tela
class [Feature]Binding extends Bindings {
  @override
  void dependencies() {
    // Injetar Repository (se não for global)
    Get.lazyPut<I[Nome]Repository>(
      () => [Nome]RepositoryImpl(
        dao: Get.find<[Nome]Dao>(),
      ),
    );

    // Injetar Controller
    Get.lazyPut(
      () => [Feature]Controller(
        repository: Get.find<I[Nome]Repository>(),
      ),
    );
  }
}
```

---

## 📄 Template: Entity (Domain)

```dart
/// Entidade de domínio representando [descrição].
///
/// Esta é uma classe pura de domínio, sem dependências
/// de frameworks ou bibliotecas externas.
class [Nome] {
  // ==========================================================================
  // ATRIBUTOS
  // ==========================================================================

  final int id;
  final String nome;
  final DateTime dataCriacao;
  final [Enum] status;

  // ==========================================================================
  // CONSTRUTOR
  // ==========================================================================

  const [Nome]({
    required this.id,
    required this.nome,
    required this.dataCriacao,
    required this.status,
  });

  // ==========================================================================
  // LÓGICA DE NEGÓCIO (Business Rules)
  // ==========================================================================

  /// Verifica se está ativo.
  bool get estaAtivo => status == [Enum].ativo;

  /// Calcula tempo decorrido desde criação.
  Duration get tempoDecorrido {
    return DateTime.now().difference(dataCriacao);
  }

  /// Valida se pode ser editado.
  bool get podeSerEditado {
    return estaAtivo && tempoDecorrido.inHours < 24;
  }

  // ==========================================================================
  // MÉTODOS DE TRANSFORMAÇÃO
  // ==========================================================================

  /// Cria cópia com valores modificados.
  [Nome] copyWith({
    int? id,
    String? nome,
    DateTime? dataCriacao,
    [Enum]? status,
  }) {
    return [Nome](
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      status: status ?? this.status,
    );
  }

  // ==========================================================================
  // EQUALITY & HASHCODE
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is [Nome] && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '[Nome]{id: $id, nome: $nome, status: $status}';
  }
}
```

---

## 📄 Template: Repository Interface (Domain)

```dart
import 'package:nexa_app/domain/entities/[nome].dart';

/// Interface do repositório de [Nome].
///
/// Define o contrato para acesso aos dados de [Nome],
/// sem especificar a implementação (banco local, API, cache, etc).
abstract class I[Nome]Repository {
  /// Busca todos os registros.
  Future<List<[Nome]>> buscarTodos();

  /// Busca um registro por ID.
  ///
  /// **Retorna:**
  /// - [[Nome]] se encontrado
  /// - `null` se não encontrado
  Future<[Nome]?> buscarPorId(int id);

  /// Salva um novo registro.
  ///
  /// **Parâmetros:**
  /// - [data] - Dados a serem salvos
  ///
  /// **Retorna:**
  /// - ID do registro criado
  Future<int> salvar([Nome] data);

  /// Atualiza um registro existente.
  Future<void> atualizar([Nome] data);

  /// Remove um registro por ID.
  Future<void> deletar(int id);
}
```

---

## 📄 Template: DTO (Data)

```dart
import 'package:nexa_app/domain/entities/[nome].dart';

/// DTO (Data Transfer Object) para [Nome].
///
/// Representa os dados como vêm do banco/API,
/// podendo ter tipos diferentes da entidade de domínio.
class [Nome]Dto {
  final int id;
  final String nome;
  final String dataCriacao;  // String vinda do banco
  final String status;

  const [Nome]Dto({
    required this.id,
    required this.nome,
    required this.dataCriacao,
    required this.status,
  });

  // ==========================================================================
  // CONVERSÕES
  // ==========================================================================

  /// Converte DTO para Entity de domínio.
  [Nome] toEntity() {
    return [Nome](
      id: id,
      nome: nome,
      dataCriacao: DateTime.parse(dataCriacao),
      status: [Enum].values.firstWhere(
        (e) => e.name == status,
        orElse: () => [Enum].padrao,
      ),
    );
  }

  /// Cria DTO a partir de Entity.
  factory [Nome]Dto.fromEntity([Nome] entity) {
    return [Nome]Dto(
      id: entity.id,
      nome: entity.nome,
      dataCriacao: entity.dataCriacao.toIso8601String(),
      status: entity.status.name,
    );
  }

  /// Cria DTO a partir de JSON.
  factory [Nome]Dto.fromJson(Map<String, dynamic> json) {
    return [Nome]Dto(
      id: json['id'] as int,
      nome: json['nome'] as String,
      dataCriacao: json['data_criacao'] as String,
      status: json['status'] as String,
    );
  }

  /// Converte DTO para JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'data_criacao': dataCriacao,
      'status': status,
    };
  }
}
```

---

## 📄 Template: Repository Implementation (Data)

```dart
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/data/datasources/local/[nome]_dao.dart';
import 'package:nexa_app/data/models/[nome]_dto.dart';
import 'package:nexa_app/domain/entities/[nome].dart';
import 'package:nexa_app/domain/repositories/i_[nome]_repository.dart';

/// Implementação do repositório de [Nome].
///
/// Coordena acesso entre fonte local (DAO) e remota (API),
/// convertendo entre DTOs e Entities.
class [Nome]RepositoryImpl implements I[Nome]Repository {
  // ==========================================================================
  // DEPENDÊNCIAS
  // ==========================================================================

  final [Nome]Dao _dao;

  // ==========================================================================
  // CONSTRUTOR
  // ==========================================================================

  [Nome]RepositoryImpl({
    required [Nome]Dao dao,
  }) : _dao = dao;

  // ==========================================================================
  // IMPLEMENTAÇÃO DA INTERFACE
  // ==========================================================================

  @override
  Future<List<[Nome]>> buscarTodos() async {
    try {
      AppLogger.d('Buscando todos os registros', tag: '[Nome]Repository');

      final dtos = await _dao.listarTodos();
      final entities = dtos.map((dto) => dto.toEntity()).toList();

      AppLogger.i('${entities.length} registros encontrados',
          tag: '[Nome]Repository');

      return entities;
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao buscar registros',
        tag: '[Nome]Repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<[Nome]?> buscarPorId(int id) async {
    try {
      AppLogger.d('Buscando registro $id', tag: '[Nome]Repository');

      final dto = await _dao.buscarPorId(id);

      if (dto == null) {
        AppLogger.w('Registro $id não encontrado', tag: '[Nome]Repository');
        return null;
      }

      return dto.toEntity();
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao buscar registro $id',
        tag: '[Nome]Repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<int> salvar([Nome] entity) async {
    try {
      AppLogger.d('Salvando registro: ${entity.nome}', tag: '[Nome]Repository');

      final dto = [Nome]Dto.fromEntity(entity);
      final id = await _dao.inserir(dto);

      AppLogger.i('Registro salvo com ID $id', tag: '[Nome]Repository');

      return id;
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao salvar registro',
        tag: '[Nome]Repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> atualizar([Nome] entity) async {
    try {
      AppLogger.d('Atualizando registro ${entity.id}', tag: '[Nome]Repository');

      final dto = [Nome]Dto.fromEntity(entity);
      await _dao.atualizar(dto);

      AppLogger.i('Registro atualizado', tag: '[Nome]Repository');
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao atualizar registro',
        tag: '[Nome]Repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deletar(int id) async {
    try {
      AppLogger.d('Deletando registro $id', tag: '[Nome]Repository');

      await _dao.deletar(id);

      AppLogger.i('Registro deletado', tag: '[Nome]Repository');
    } catch (e, stackTrace) {
      AppLogger.e(
        'Erro ao deletar registro',
        tag: '[Nome]Repository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
```

---

## 📄 Template: README do Módulo

````markdown
# Módulo [Nome]

> **Responsável:** [Nome do Dev]  
> **Status:** ✅ Em Produção / 🚧 Em Desenvolvimento  
> **Última atualização:** [Data]

---

## 📝 Descrição

[Descrição breve do que o módulo faz]

## 🎯 Funcionalidades

- ✅ [Funcionalidade 1]
- ✅ [Funcionalidade 2]
- 🚧 [Funcionalidade 3] (em desenvolvimento)

## 📁 Estrutura

\```
[modulo]/
├── [sub_feature]/
│ ├── [feature]\_controller.dart
│ ├── [feature]\_page.dart
│ └── [feature]\_binding.dart
\```

## 🔗 Dependências

- `domain/entities/[nome].dart` - Entidade de domínio
- `domain/repositories/i_[nome]_repository.dart` - Interface
- `data/repositories/[nome]_repository_impl.dart` - Implementação

## 🚀 Como Usar

\```dart
// Navegar para a tela
Get.toNamed(Routes.[moduloFeature]);

// Obter controller
final controller = Get.find<[Feature]Controller>();

// Executar ação
await controller.carregarDados();
\```

## 🧪 Testes

\```bash

# Rodar testes do módulo

flutter test test/modules/[modulo]/

# Coverage

flutter test --coverage test/modules/[modulo]/
\```

## 📊 Métricas

- **Linhas de código:** ~XXX
- **Cobertura de testes:** XX%
- **Complexidade ciclomática:** X.X

## 🐛 Issues Conhecidos

- [ ] [Issue #123] - [Descrição]

## 📚 Referências

- [Link para spec]
- [Link para design]
- [Link para API docs]
````

---

## 🎨 Exemplo Completo: Módulo Relatórios

### Estrutura

```bash
presentation/relatorios/
├── listar/
│   ├── relatorios_controller.dart
│   ├── relatorios_page.dart
│   ├── relatorios_binding.dart
│   └── widgets/
│       └── relatorio_card.dart
├── detalhes/
│   ├── relatorio_detalhes_controller.dart
│   ├── relatorio_detalhes_page.dart
│   └── relatorio_detalhes_binding.dart
└── README.md
```

### Rota

```dart
// app/routes/app_routes.dart
class Routes {
  static const relatorios = '/relatorios';
  static const relatorioDetalhes = '/relatorios/detalhes';
}

// app/routes/app_pages.dart
GetPage(
  name: Routes.relatorios,
  page: () => const RelatoriosPage(),
  binding: RelatoriosBinding(),
  middlewares: [AuthMiddleware()],
),
GetPage(
  name: Routes.relatorioDetalhes,
  page: () => const RelatorioDetalhesPage(),
  binding: RelatorioDetalhesBinding(),
),
```

### Navegação

```dart
// De qualquer lugar da app
Get.toNamed(Routes.relatorios);

// Com parâmetros
Get.toNamed(
  Routes.relatorioDetalhes,
  arguments: {'id': 123},
);

// No controller de destino
final args = Get.arguments as Map<String, dynamic>;
final id = args['id'] as int;
```

---

## ✅ Checklist de Criação de Módulo

Ao criar um novo módulo, siga esta ordem:

### 1. Domain Layer

- [ ] Criar entity em `domain/entities/[nome].dart`
- [ ] Criar interface em `domain/repositories/i_[nome]_repository.dart`
- [ ] (Opcional) Criar usecase em `domain/usecases/`

### 2. Data Layer

- [ ] Criar DTO em `data/models/[nome]_dto.dart`
- [ ] Criar DAO em `data/datasources/local/[nome]_dao.dart`
- [ ] Implementar repository em `data/repositories/[nome]_repository_impl.dart`

### 3. Presentation Layer

- [ ] Criar controller em `presentation/[modulo]/[feature]_controller.dart`
- [ ] Criar page em `presentation/[modulo]/[feature]_page.dart`
- [ ] Criar binding em `presentation/[modulo]/[feature]_binding.dart`
- [ ] (Opcional) Criar widgets em `widgets/`

### 4. Routes

- [ ] Adicionar constante em `app/routes/app_routes.dart`
- [ ] Registrar rota em `app/routes/app_pages.dart`

### 5. Documentation

- [ ] Criar README.md do módulo
- [ ] Documentar controller
- [ ] Documentar métodos públicos

### 6. Tests

- [ ] Criar testes do controller
- [ ] Criar testes do repository
- [ ] Criar testes da entity (se tiver lógica)

---

## 🎓 Exemplos do Projeto

Módulos bem estruturados para usar como referência:

1. **`presentation/turno/checklist/veicular/`**

   - Controller bem organizado
   - Page com Obx otimizados
   - Binding limpo

2. **`presentation/home/`**

   - Widgets bem divididos
   - Estados isolados
   - Performance otimizada

3. **`presentation/login/`**
   - Módulo simples e direto
   - Bom exemplo para iniciantes

---

**Use este template como base para todos os novos módulos!**  
**Mantido por:** Equipe Nexa
