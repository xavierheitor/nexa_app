# Arquitetura do Nexa App

> **Data:** Outubro 2025  
> **Versão:** 2.0  
> **Status:** ✅ Documentação Oficial

---

## 📑 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura de Pastas](#estrutura-de-pastas)
3. [Camadas da Aplicação](#camadas-da-aplicação)
4. [Organização por Módulos](#organização-por-módulos)
5. [Fluxo de Dados](#fluxo-de-dados)
6. [Padrões e Convenções](#padrões-e-convenções)
7. [Exemplos Práticos](#exemplos-práticos)

---

## Visão Geral

O Nexa App segue uma **arquitetura em camadas limpa (Clean Architecture)** adaptada para Flutter com GetX, organizando o código em módulos independentes e reutilizáveis.

### Princípios Fundamentais

- ✅ **Separação de Responsabilidades**: Cada camada tem um papel específico
- ✅ **Independência de Frameworks**: Lógica de negócio isolada
- ✅ **Testabilidade**: Código facilmente testável
- ✅ **Organização por Módulos**: Features completas agrupadas
- ✅ **Reusabilidade**: Componentes compartilhados centralizados

---

## Estrutura de Pastas

```bash
lib/
├── app/                          # Configuração da aplicação
│   ├── app.dart                  # Widget raiz (MaterialApp)
│   └── routes/
│       ├── app_pages.dart        # Definição de rotas
│       └── app_routes.dart       # Constantes de rotas
│
├── core/                         # Núcleo da aplicação
│   ├── database/                 # Drift database
│   │   ├── app_database.dart
│   │   └── tables/
│   ├── network/                  # Cliente HTTP
│   │   ├── dio_client.dart
│   │   └── interceptors/
│   ├── security/                 # Segurança
│   │   ├── token_manager.dart
│   │   └── encryption/
│   ├── constants/                # Constantes globais
│   │   └── api_constants.dart
│   └── utils/                    # Utilitários
│       └── logger/
│
├── data/                         # Camada de Dados
│   ├── datasources/              # Fontes de dados
│   │   ├── local/                # Dados locais (DAOs)
│   │   │   ├── turno_dao.dart
│   │   │   ├── checklist_dao.dart
│   │   │   └── ...
│   │   └── remote/               # API (Services)
│   │       ├── turno_api.dart
│   │       └── ...
│   ├── models/                   # DTOs (Data Transfer Objects)
│   │   ├── turno_dto.dart
│   │   ├── checklist_dto.dart
│   │   └── ...
│   └── repositories/             # Implementações de Repositórios
│       ├── turno_repository_impl.dart
│       ├── checklist_repository_impl.dart
│       └── ...
│
├── domain/                       # Camada de Domínio (Business Logic)
│   ├── entities/                 # Entidades de domínio
│   │   ├── turno.dart
│   │   ├── checklist.dart
│   │   └── ...
│   ├── repositories/             # Interfaces de Repositórios
│   │   ├── i_turno_repository.dart
│   │   ├── i_checklist_repository.dart
│   │   └── ...
│   └── usecases/                 # Casos de uso (opcional)
│       ├── abrir_turno_usecase.dart
│       └── ...
│
├── presentation/                 # Camada de Apresentação
│   │
│   ├── turno/                    # 📦 MÓDULO TURNO (COMPLETO)
│   │   ├── abrir/
│   │   │   ├── abrir_turno_controller.dart
│   │   │   ├── abrir_turno_page.dart
│   │   │   ├── abrir_turno_binding.dart
│   │   │   ├── widgets/
│   │   │   │   └── step_indicator.dart
│   │   │   └── models/
│   │   │       └── abrir_turno_form_data.dart
│   │   ├── checklist/
│   │   │   ├── veicular/
│   │   │   │   ├── checklist_controller.dart
│   │   │   │   ├── checklist_page.dart
│   │   │   │   └── checklist_binding.dart
│   │   │   ├── epc/
│   │   │   └── epi/
│   │   ├── servicos/
│   │   │   ├── turno_servicos_controller.dart
│   │   │   ├── turno_servicos_page.dart
│   │   │   └── turno_servicos_binding.dart
│   │   └── navigation/
│   │       └── turno_navigation_orchestrator.dart
│   │
│   ├── home/                     # 📦 MÓDULO HOME
│   │   ├── home_controller.dart
│   │   ├── home_page.dart
│   │   ├── home_binding.dart
│   │   └── widgets/
│   │       └── turno_card.dart
│   │
│   ├── login/                    # 📦 MÓDULO LOGIN
│   │   ├── login_controller.dart
│   │   ├── login_page.dart
│   │   └── login_binding.dart
│   │
│   └── splash/                   # 📦 MÓDULO SPLASH
│       ├── splash_controller.dart
│       ├── splash_page.dart
│       └── splash_binding.dart
│
└── shared/                       # Recursos Compartilhados
    ├── widgets/                  # Widgets reutilizáveis
    │   ├── custom_button.dart
    │   ├── custom_text_field.dart
    │   └── custom_dropdown.dart
    ├── middlewares/              # Middlewares globais
    │   └── auth_middleware.dart
    └── bindings/                 # Bindings globais
        └── initial_binding.dart
```

---

## Camadas da Aplicação

### 1. **App Layer** (Configuração)

Responsável pela configuração inicial do aplicativo.

**Responsabilidades:**

- Configurar MaterialApp
- Definir rotas
- Configurar tema
- Inicializar dependências globais

**Arquivos principais:**

- `app.dart` - Widget raiz
- `routes/app_pages.dart` - Definição de rotas
- `routes/app_routes.dart` - Constantes de rotas

---

### 2. **Core Layer** (Núcleo)

Componentes fundamentais usados em toda a aplicação.

**Responsabilidades:**

- Database (Drift)
- Cliente HTTP (Dio)
- Segurança e criptografia
- Constantes globais
- Utilitários (Logger, formatters)

**Características:**

- ✅ Sem dependências de UI
- ✅ Reutilizável em qualquer camada
- ✅ Altamente testável

---

### 3. **Data Layer** (Dados)

Gerencia a origem e persistência dos dados.

**Responsabilidades:**

- Acesso ao banco local (DAOs)
- Chamadas à API (Services)
- Transformação de dados (DTOs)
- Implementação de repositórios

**Fluxo:**

```bash
API/Database → DAO/Service → DTO → Repository Implementation → Domain
```

**Exemplo:**

```dart
// datasources/local/turno_dao.dart
class TurnoDao {
  Future<TurnoTableData?> buscarTurnoAtivo() async { ... }
}

// models/turno_dto.dart
class TurnoDto {
  final int id;
  final DateTime horaInicio;
  // ...
}

// repositories/turno_repository_impl.dart
class TurnoRepositoryImpl implements ITurnoRepository {
  final TurnoDao _dao;

  @override
  Future<Turno?> buscarTurnoAtivo() async {
    final dto = await _dao.buscarTurnoAtivo();
    return dto?.toEntity();
  }
}
```

---

### 4. **Domain Layer** (Domínio)

Contém a lógica de negócio pura, independente de frameworks.

**Responsabilidades:**

- Definir entidades de domínio
- Interfaces de repositórios
- Casos de uso (opcional)
- Regras de negócio

**Características:**

- ✅ Sem dependências externas
- ✅ 100% testável
- ✅ Centro da arquitetura

**Exemplo:**

```dart
// entities/turno.dart
class Turno {
  final int id;
  final DateTime horaInicio;
  final SituacaoTurno situacao;

  bool get estaAberto => situacao == SituacaoTurno.aberto;

  Duration get duracao => DateTime.now().difference(horaInicio);
}

// repositories/i_turno_repository.dart
abstract class ITurnoRepository {
  Future<Turno?> buscarTurnoAtivo();
  Future<void> abrirTurno(TurnoParams params);
  Future<void> fecharTurno(int turnoId);
}

// usecases/abrir_turno_usecase.dart (opcional)
class AbrirTurnoUseCase {
  final ITurnoRepository _repository;

  Future<Either<Failure, Turno>> execute(TurnoParams params) async {
    // Validações e regras de negócio
    if (!params.isValid) return Left(ValidationFailure());

    try {
      await _repository.abrirTurno(params);
      return Right(turno);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

---

### 5. **Presentation Layer** (Apresentação)

Interface com o usuário, organizada por **módulos funcionais**.

**Responsabilidades:**

- Controllers (GetX)
- Pages (UI)
- Bindings (DI)
- Widgets específicos do módulo
- Models de formulário

**Estrutura de um Módulo Completo:**

```bash
presentation/turno/
├── abrir/
│   ├── abrir_turno_controller.dart    # Lógica de estado
│   ├── abrir_turno_page.dart          # UI
│   ├── abrir_turno_binding.dart       # Injeção de dependências
│   ├── widgets/                       # Widgets específicos
│   │   ├── veiculo_selector.dart
│   │   └── equipe_selector.dart
│   └── models/                        # Models locais
│       └── abrir_turno_form.dart
├── checklist/
├── servicos/
└── navigation/
```

**Princípios:**

- ✅ Um módulo = uma feature completa
- ✅ Tudo relacionado fica junto
- ✅ Fácil de encontrar e manter
- ✅ Reaproveitamento interno ao módulo

---

### 6. **Shared Layer** (Compartilhado)

Recursos usados por múltiplos módulos.

**Responsabilidades:**

- Widgets reutilizáveis
- Middlewares globais
- Bindings globais
- Extensões e helpers

**Quando usar:**

- ✅ Widget usado em 2+ módulos diferentes
- ✅ Lógica global (autenticação)
- ✅ Componentes de UI padronizados

**Exemplo:**

```dart
// shared/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  // Widget reutilizável em toda a app
}

// shared/middlewares/auth_middleware.dart
class AuthMiddleware extends GetMiddleware {
  // Validação global de autenticação
}
```

---

## Organização por Módulos

### Conceito

Cada **módulo** representa uma **feature completa** da aplicação, com todos os seus componentes agrupados.

### Vantagens

✅ **Coesão**: Tudo relacionado está junto  
✅ **Manutenibilidade**: Fácil encontrar e modificar  
✅ **Escalabilidade**: Adicionar features sem conflitos  
✅ **Reusabilidade**: Componentes internos bem organizados  
✅ **Time Efficiency**: Desenvolvedores trabalham isolados

### Estrutura Padrão de um Módulo

```bash
presentation/[modulo]/
├── [sub-feature]/
│   ├── [feature]_controller.dart      # Estado e lógica
│   ├── [feature]_page.dart            # Interface
│   ├── [feature]_binding.dart         # DI
│   ├── widgets/                       # Widgets específicos
│   │   └── [componente]_widget.dart
│   ├── models/                        # Models locais
│   │   └── [model].dart
│   └── services/                      # Services específicos (opcional)
│       └── [service].dart
```

### Exemplo: Módulo Turno

```bash
presentation/turno/
│
├── abrir/                              # Sub-feature: Abrir Turno
│   ├── abrir_turno_controller.dart
│   ├── abrir_turno_page.dart
│   ├── abrir_turno_binding.dart
│   ├── widgets/
│   │   ├── veiculo_selector.dart
│   │   └── eletricista_card.dart
│   └── models/
│       └── abrir_turno_form_data.dart
│
├── checklist/                          # Sub-feature: Checklists
│   ├── veicular/
│   │   ├── checklist_veicular_controller.dart
│   │   ├── checklist_veicular_page.dart
│   │   └── checklist_veicular_binding.dart
│   ├── epc/
│   └── epi/
│
├── servicos/                           # Sub-feature: Serviços
│   ├── turno_servicos_controller.dart
│   ├── turno_servicos_page.dart
│   └── turno_servicos_binding.dart
│
└── navigation/                         # Lógica de navegação
    ├── turno_navigation_orchestrator.dart
    └── turno_navigation_state.dart
```

### Diretrizes

1. **Nomenclatura**: Use o nome da feature seguido do tipo

   - ✅ `abrir_turno_controller.dart`
   - ❌ `controller.dart`

2. **Widgets**: Se usado APENAS neste módulo → `widgets/`

   - Se usado em 2+ módulos → `shared/widgets/`

3. **Models**: Models de formulário/UI ficam no módulo

   - Entidades de domínio ficam em `domain/entities/`

4. **Services**: Services específicos do módulo podem ficar aqui
   - Services reutilizáveis ficam em `data/datasources/`

---

## Fluxo de Dados

### Arquitetura em Camadas

```bash
┌─────────────────────────────────────────────────┐
│                 PRESENTATION                     │
│  (Controllers, Pages, Bindings)                  │
│  - Gerencia estado da UI                         │
│  - Reage a eventos do usuário                    │
└────────────────┬────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────┐
│                   DOMAIN                         │
│  (Entities, Repository Interfaces, UseCases)     │
│  - Lógica de negócio pura                        │
│  - Independente de frameworks                    │
└────────────────┬────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────┐
│                    DATA                          │
│  (Repository Impl, DTOs, DataSources)            │
│  - Implementa acesso a dados                     │
│  - Transforma DTOs em Entities                   │
└────────────────┬────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────┐
│                   CORE                           │
│  (Database, Network, Utils)                      │
│  - Infraestrutura básica                         │
│  - Ferramentas compartilhadas                    │
└─────────────────────────────────────────────────┘
```

### Exemplo de Fluxo Completo

**Cenário**: Usuário abre um turno

```bash
1. USER ACTION (Presentation)
   ↓
   home_page.dart → onTap()

2. CONTROLLER (Presentation)
   ↓
   home_controller.dart → abrirTurno()

3. USE CASE (Domain - opcional)
   ↓
   abrir_turno_usecase.dart → execute()

4. REPOSITORY INTERFACE (Domain)
   ↓
   i_turno_repository.dart → abrirTurno()

5. REPOSITORY IMPLEMENTATION (Data)
   ↓
   turno_repository_impl.dart → abrirTurno()

6. DATA SOURCE (Data)
   ↓
   turno_dao.dart → inserir()

7. DATABASE (Core)
   ↓
   app_database.dart → SQL INSERT

8. RESPONSE FLOW (volta)
   ↓
   DTO → Entity → Controller → UI Update
```

### Regras de Dependência

```bash
Presentation → Domain → Data → Core
     ↓           ↓       ↓       ↓
  GetX      Pure Dart  Repos   Drift
  Flutter              DTOs    Dio
```

**Importante:**

- ✅ Camadas externas podem depender de internas
- ❌ Camadas internas NÃO podem depender de externas
- ✅ Domain é independente de tudo
- ✅ Core não conhece ninguém

---

## Padrões e Convenções

### Nomenclatura de Arquivos

```dart
// Controllers
[feature]_controller.dart          // home_controller.dart

// Pages
[feature]_page.dart                // login_page.dart

// Bindings
[feature]_binding.dart             // splash_binding.dart

// Repositories
[nome]_repository.dart             // turno_repository.dart
i_[nome]_repository.dart           // i_turno_repository.dart (interface)

// DTOs
[nome]_dto.dart                    // turno_dto.dart

// Entities
[nome].dart                        // turno.dart (entidade pura)

// DAOs
[nome]_dao.dart                    // turno_dao.dart

// Widgets
[nome]_widget.dart                 // custom_button.dart
```

### Nomenclatura de Classes

```dart
// Controllers
class HomeController extends GetxController { }

// Pages
class LoginPage extends StatelessWidget { }

// Repositories (Interface)
abstract class ITurnoRepository { }

// Repositories (Implementation)
class TurnoRepositoryImpl implements ITurnoRepository { }

// DTOs
class TurnoDto { }

// Entities
class Turno { }

// DAOs
class TurnoDao { }
```

### Imports

**Ordem de imports:**

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Packages externos
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 3. Arquivos do projeto (absolutos)
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/domain/entities/turno.dart';
import 'package:nexa_app/presentation/home/home_controller.dart';
```

### Organização de Código

**Ordem dentro de uma classe:**

```dart
class ExampleController extends GetxController {
  // 1. Dependências (final)
  final Repository _repository;

  // 2. Estado observável (Rx)
  final RxBool isLoading = false.obs;
  final Rx<Data?> data = Rx(null);

  // 3. Getters
  bool get hasData => data.value != null;

  // 4. Construtor
  ExampleController({required Repository repository})
      : _repository = repository;

  // 5. Lifecycle methods
  @override
  void onInit() {
    super.onInit();
  }

  // 6. Métodos públicos
  Future<void> loadData() async { }

  // 7. Métodos privados
  Future<void> _fetchData() async { }

  // 8. onClose
  @override
  void onClose() {
    super.onClose();
  }
}
```

---

## Exemplos Práticos

### Exemplo 1: Criar um Novo Módulo

**Objetivo**: Criar módulo "Relatórios"

**Passo 1**: Criar estrutura de pastas

```bash
presentation/relatorios/
├── listar/
│   ├── relatorios_controller.dart
│   ├── relatorios_page.dart
│   └── relatorios_binding.dart
└── detalhes/
    ├── relatorio_detalhes_controller.dart
    ├── relatorio_detalhes_page.dart
    └── relatorio_detalhes_binding.dart
```

**Passo 2**: Criar Entity (Domain)

```dart
// domain/entities/relatorio.dart
class Relatorio {
  final int id;
  final String titulo;
  final DateTime dataCriacao;

  const Relatorio({
    required this.id,
    required this.titulo,
    required this.dataCriacao,
  });
}
```

**Passo 3**: Criar Repository Interface (Domain)

```dart
// domain/repositories/i_relatorio_repository.dart
abstract class IRelatorioRepository {
  Future<List<Relatorio>> buscarTodos();
  Future<Relatorio?> buscarPorId(int id);
}
```

**Passo 4**: Criar DTO (Data)

```dart
// data/models/relatorio_dto.dart
class RelatorioDto {
  final int id;
  final String titulo;
  final String dataCriacao;

  Relatorio toEntity() {
    return Relatorio(
      id: id,
      titulo: titulo,
      dataCriacao: DateTime.parse(dataCriacao),
    );
  }
}
```

**Passo 5**: Implementar Repository (Data)

```dart
// data/repositories/relatorio_repository_impl.dart
class RelatorioRepositoryImpl implements IRelatorioRepository {
  final RelatorioDao _dao;

  @override
  Future<List<Relatorio>> buscarTodos() async {
    final dtos = await _dao.listarTodos();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
```

**Passo 6**: Criar Controller (Presentation)

```dart
// presentation/relatorios/listar/relatorios_controller.dart
class RelatoriosController extends GetxController {
  final IRelatorioRepository _repository;

  final RxList<Relatorio> relatorios = <Relatorio>[].obs;
  final RxBool isLoading = false.obs;

  RelatoriosController({required IRelatorioRepository repository})
      : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    carregarRelatorios();
  }

  Future<void> carregarRelatorios() async {
    isLoading.value = true;
    try {
      final lista = await _repository.buscarTodos();
      relatorios.assignAll(lista);
    } finally {
      isLoading.value = false;
    }
  }
}
```

**Passo 7**: Criar Page (Presentation)

```dart
// presentation/relatorios/listar/relatorios_page.dart
class RelatoriosPage extends GetView<RelatoriosController> {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.relatorios.length,
          itemBuilder: (context, index) {
            final relatorio = controller.relatorios[index];
            return ListTile(
              title: Text(relatorio.titulo),
              subtitle: Text(relatorio.dataCriacao.toString()),
            );
          },
        );
      }),
    );
  }
}
```

**Passo 8**: Criar Binding (Presentation)

```dart
// presentation/relatorios/listar/relatorios_binding.dart
class RelatoriosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRelatorioRepository>(
      () => RelatorioRepositoryImpl(dao: Get.find()),
    );
    Get.lazyPut(
      () => RelatoriosController(repository: Get.find()),
    );
  }
}
```

**Passo 9**: Registrar Rota

```dart
// app/routes/app_pages.dart
GetPage(
  name: Routes.relatorios,
  page: () => const RelatoriosPage(),
  binding: RelatoriosBinding(),
),
```

---

### Exemplo 2: Widget Compartilhado

**Quando criar em `shared/widgets/`:**

- Widget usado em 2+ módulos diferentes
- Componente de UI padronizado
- Elemento reutilizável

**Exemplo:**

```dart
// shared/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(label),
    );
  }
}
```

**Uso em qualquer módulo:**

```dart
// presentation/home/home_page.dart
import 'package:nexa_app/shared/widgets/custom_button.dart';

// ...
CustomButton(
  label: 'Abrir Turno',
  onPressed: controller.abrirTurno,
  isLoading: controller.isLoading.value,
)
```

---

## Checklist de Migração

Ao migrar código existente ou criar novo:

### Para Novo Código

- [ ] Entity criada em `domain/entities/`
- [ ] Repository interface em `domain/repositories/`
- [ ] DTO criado em `data/models/`
- [ ] Repository impl em `data/repositories/`
- [ ] DAO em `data/datasources/local/`
- [ ] Controller em `presentation/[modulo]/[feature]/`
- [ ] Page em `presentation/[modulo]/[feature]/`
- [ ] Binding em `presentation/[modulo]/[feature]/`
- [ ] Widgets específicos em `presentation/[modulo]/[feature]/widgets/`
- [ ] Widgets compartilhados em `shared/widgets/`
- [ ] Rota registrada em `app/routes/app_pages.dart`

### Para Código Existente (Migração Gradual)

- [ ] Identificar módulo/feature
- [ ] Criar estrutura de pastas
- [ ] Mover arquivos mantendo funcionalidade
- [ ] Atualizar imports
- [ ] Testar build
- [ ] Commit e push

---

## Referências

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetX Pattern](https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Drift Documentation](https://drift.simonbinder.eu/)

---

## Changelog

| Data    | Versão | Descrição                               |
| ------- | ------ | --------------------------------------- |
| 2025-10 | 2.0    | Nova arquitetura em camadas com módulos |
| 2025-10 | 1.0    | Estrutura inicial do projeto            |

---

**Documentação mantida por:** Equipe Nexa  
**Última atualização:** Outubro 2025
