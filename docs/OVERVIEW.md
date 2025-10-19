# Visão Geral do Nexa App

> **Documentação para novos desenvolvedores**  
> **Leia este documento primeiro para entender o projeto**

---

## 📱 O que é o Nexa App?

O **Nexa App** é um aplicativo móvel Flutter para **gerenciamento de turnos e serviços** de equipes de manutenção elétrica. O app permite:

- ✅ **Abertura e fechamento de turnos** com registro de veículos e equipes
- ✅ **Checklists obrigatórios** (Veicular, EPC e EPI) antes de iniciar trabalho
- ✅ **Registro de serviços** executados durante o turno
- ✅ **Sincronização offline-first** com API
- ✅ **Autenticação** e controle de sessão
- ✅ **Persistência local** para trabalho offline

---

## 🎯 Fluxo Principal do Usuário

```bash
1. LOGIN
   ↓
2. HOME (Dashboard)
   ↓
3. ABRIR TURNO
   • Selecionar veículo
   • Selecionar equipe
   • Selecionar eletricistas (mín. 2)
   • Definir motorista
   • Informar KM inicial
   ↓
4. CHECKLISTS OBRIGATÓRIOS
   • Checklist Veicular (N perguntas)
   • Checklist EPC (N perguntas)
   • Checklist EPI por eletricista (N perguntas)
   ↓
5. ABERTURA REMOTA
   • Envia todos os dados para API
   • Turno liberado para trabalho
   ↓
6. REGISTRO DE SERVIÇOS
   • Adicionar serviços executados
   • Descrição, local, observações
   ↓
7. FECHAR TURNO
   • Informar KM final
   • Finalizar turno
   • Sincronizar com API
```

---

## 🏗️ Arquitetura do Projeto

### Visão em Camadas

```bash
┌─────────────────────────────────────────┐
│         PRESENTATION                    │
│  Controllers, Pages, Bindings           │
│  (O que o usuário vê e interage)        │
└────────────┬────────────────────────────┘
             │
             ↓
┌─────────────────────────────────────────┐
│         DOMAIN (Futuro)                 │
│  Entities, Interfaces, UseCases         │
│  (Regras de negócio puras)              │
└────────────┬────────────────────────────┘
             │
             ↓
┌─────────────────────────────────────────┐
│         DATA                            │
│  Repositories, DTOs, DAOs               │
│  (Como os dados são acessados)          │
└────────────┬────────────────────────────┘
             │
             ↓
┌─────────────────────────────────────────┐
│         CORE                            │
│  Database, Network, Utils               │
│  (Infraestrutura base)                  │
└─────────────────────────────────────────┘
```

### Tecnologias Principais

| Tecnologia  | Uso                             | Versão |
| ----------- | ------------------------------- | ------ |
| **Flutter** | Framework de UI                 | 3.x    |
| **Dart**    | Linguagem                       | 3.x    |
| **GetX**    | Gerenciamento de estado e rotas | Latest |
| **Drift**   | ORM / Database local (SQLite)   | Latest |
| **Dio**     | Cliente HTTP                    | Latest |

---

## 📁 Estrutura de Pastas

```bash
lib/
│
├── 📱 app/                        # Configuração da aplicação
│   ├── app.dart                   # Widget raiz (MaterialApp)
│   └── routes/                    # Sistema de rotas
│       ├── app_pages.dart         # Definição de rotas GetX
│       └── routes.dart            # Constantes de rotas
│
├── ⚙️ core/                       # Núcleo da aplicação
│   ├── constants/                 # Constantes globais (API URLs, IDs)
│   ├── core_app/                  # Controllers e Services globais
│   │   ├── controllers/           # TurnoController (global)
│   │   └── services/              # AuthService, SyncService
│   ├── database/                  # Drift database
│   │   ├── app_database.dart      # Definição do banco
│   │   ├── tables/                # Definições de tabelas
│   │   └── converters/            # Conversores de tipos
│   ├── network/                   # ✨ Cliente HTTP
│   │   └── dio_client.dart        # Configuração do Dio
│   ├── security/                  # ✨ Segurança e sessão
│   │   └── session_manager.dart   # Gerenciamento de sessão
│   ├── sync/                      # Sistema de sincronização
│   └── utils/                     # Utilitários (Logger, etc)
│
├── 💾 data/                       # ✨ Camada de Dados
│   ├── datasources/
│   │   └── local/                 # DAOs do Drift
│   │       ├── turno_dao.dart
│   │       ├── checklist_dao.dart
│   │       └── ...
│   ├── models/                    # DTOs (Data Transfer Objects)
│   │   ├── turno_dto.dart
│   │   ├── checklist_dto.dart
│   │   └── ...
│   └── repositories/              # Implementações de repositórios
│       ├── turno_repo.dart
│       ├── checklist_modelo_repo.dart
│       └── ...
│
├── 🎯 domain/                     # Camada de Domínio (a implementar)
│   ├── entities/                  # Entidades puras de negócio
│   ├── repositories/              # Interfaces de repositórios
│   └── usecases/                  # Casos de uso (opcional)
│
├── 🎨 presentation/               # ✨ Interface com Usuário
│   │
│   ├── 🏠 home/                   # Módulo Home
│   │   ├── home_controller.dart
│   │   ├── home_page.dart
│   │   └── home_binding.dart
│   │
│   ├── 🔐 login/                  # Módulo Login
│   │   ├── login_controller.dart
│   │   ├── login_page.dart
│   │   └── login_binding.dart
│   │
│   ├── ⏳ splash/                 # Módulo Splash
│   │   ├── splash_controller.dart
│   │   ├── splash_page.dart
│   │   └── splash_binding.dart
│   │
│   └── 🚗 turno/                  # Módulo Turno (COMPLETO)
│       ├── abrir/                 # Abertura de turno
│       │   ├── abrir_turno_controller.dart
│       │   ├── abrir_turno_page.dart
│       │   ├── abrir_turno_binding.dart
│       │   ├── models/
│       │   └── services/
│       ├── abrindo/               # Loading de abertura
│       ├── checklist/             # Sistema de checklists
│       │   ├── veicular/
│       │   ├── epc/
│       │   └── epi/
│       ├── servicos/              # Gestão de serviços
│       └── navigation/            # Orchestrador de navegação
│
└── 🔧 shared/                     # ✨ Recursos Compartilhados
    ├── widgets/                   # Widgets reutilizáveis
    │   └── custom_searcheable_dropdown.dart
    ├── middlewares/               # Middlewares globais
    │   └── auth_middleware.dart
    └── bindings/                  # Dependency Injection global
        └── initial_binding.dart
```

**Legenda:**

- ✨ = Novo na refatoração
- 🏠🔐⏳🚗🔧 = Diferentes módulos

---

## 🔑 Conceitos Importantes

### 1. **Organização por Módulos**

Cada módulo é **auto-contido** e agrupa tudo relacionado:

```
presentation/turno/abrir/
├── controller (lógica de estado)
├── page (interface)
├── binding (injeção de dependências)
├── widgets/ (componentes locais)
├── models/ (dados de formulário)
└── services/ (lógica específica)
```

**Vantagem:** Para mexer em "Abrir Turno", tudo está em uma única pasta!

---

### 2. **GetX Pattern**

O app usa **GetX** para:

- **Estado Reativo**: `Rx` objects (`.obs`)
- **Navegação**: `Get.toNamed()`
- **Injeção de Dependências**: `Bindings`

**Exemplo:**

```dart
// Controller gerencia estado
class HomeController extends GetxController {
  final RxBool isLoading = false.obs;  // Observable

  Future<void> carregarDados() async {
    isLoading.value = true;  // UI atualiza automaticamente
    // ...
    isLoading.value = false;
  }
}

// Page observa o estado
class HomePage extends GetView<HomeController> {
  Widget build(BuildContext context) {
    return Obx(() {  // Reconstrói quando isLoading muda
      if (controller.isLoading.value) {
        return CircularProgressIndicator();
      }
      return Content();
    });
  }
}
```

---

### 3. **Persistência Local (Drift)**

O app funciona **offline-first** usando Drift (ORM para SQLite):

```dart
// 1. Tabela definida
class TurnoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get veiculoId => integer()();
  DateTimeColumn get horaInicio => dateTime()();
}

// 2. DAO acessa dados
class TurnoDao extends DatabaseAccessor<AppDatabase> {
  Future<TurnoTableData?> buscarTurnoAtivo() async {
    return await (select(turnoTable)
      ..where((t) => t.situacao.equals('aberto')))
      .getSingleOrNull();
  }
}

// 3. Repository usa DAO
class TurnoRepo {
  final TurnoDao _dao;

  Future<TurnoDto?> buscarTurnoAtivo() async {
    final data = await _dao.buscarTurnoAtivo();
    return data != null ? TurnoDto.fromTable(data) : null;
  }
}
```

---

### 4. **Sistema de Navegação Inteligente**

O app tem um **orchestrador de navegação** que decide automaticamente qual tela mostrar:

```
Clica em "Turno"
      ↓
TurnoNavigationOrchestrator
      ↓
  Verifica:
  • Tem turno ativo?
  • Checklist veicular OK?
  • Checklist EPC OK?
  • Checklists EPI OK?
      ↓
  Navega para próxima pendência!
```

**Benefício:** Usuário sempre vai para a tela certa automaticamente!

---

## 🚀 Funcionalidades Implementadas

### ✅ **Autenticação**

- Login com matrícula e senha
- Sessão persistente (24h)
- Refresh token automático
- Logout seguro

### ✅ **Gestão de Turnos**

- Abertura de turno com validações
- Seleção de veículo, equipe e eletricistas
- Definição de motorista obrigatório
- KM inicial e final
- Fechamento de turno

### ✅ **Sistema de Checklists**

- **Checklist Veicular** (condições do veículo)
- **Checklist EPC** (equipamentos de proteção coletiva)
- **Checklist EPI** (individual por eletricista)
- Perguntas dinâmicas do banco
- Opções de resposta configuráveis
- Detecção de pendências

### ✅ **Registro de Serviços**

- Adicionar serviços ao turno
- Tipo, descrição e localização
- Listagem e remoção
- Sincronização com API

### ✅ **Sincronização**

- Offline-first (trabalha sem internet)
- Sync automático na abertura do app
- Sync manual via pull-to-refresh
- Tratamento de conflitos

### ✅ **Performance**

- Obx granulares (rebuilds otimizados)
- ListView.builder para listas
- Cache de dados
- Const widgets

---

## 🔐 Segurança

### Autenticação e Sessão

- Tokens JWT armazenados localmente
- Validação de expiração (24h)
- Refresh token automático
- Middleware de autenticação em rotas protegidas

### Validação de Dados

- Null safety completo
- Validações de formulário
- DTOs com validações
- Tratamento de erros robusto

---

## 📊 Dados do Projeto

### Métricas

| Métrica                 | Valor                                               |
| ----------------------- | --------------------------------------------------- |
| **Módulos**             | 4 (home, login, splash, turno)                      |
| **Sub-módulos (turno)** | 5 (abrir, checklist, servicos, navigation, abrindo) |
| **Telas**               | 15+                                                 |
| **Tabelas no banco**    | 20+                                                 |
| **Repositórios**        | 15+                                                 |
| **Controllers**         | 10+                                                 |
| **Linhas de código**    | ~15.000+                                            |

### Cobertura

| Aspecto          | Status  | Nota       |
| ---------------- | ------- | ---------- |
| **Null Safety**  | ✅ 100% | Completo   |
| **Documentação** | ✅ 95%  | Excelente  |
| **Testes**       | 🟡 20%  | A melhorar |
| **Performance**  | ✅ 90%  | Otimizado  |

---

## 🎨 Design e UX

### Princípios de Design

1. **Minimalista** - Interface limpa e focada
2. **Responsivo** - Adapta a diferentes telas
3. **Acessível** - Bom contraste e feedback visual
4. **Intuitivo** - Fluxo claro e previsível
5. **Moderno** - Material Design 3

### Cores e Tema

- **Primária:** Azul (turnos ativos)
- **Secundária:** Laranja (turnos em abertura)
- **Verde:** Sucesso, checklists OK
- **Vermelho:** Erros e alertas
- **Amarelo/Laranja:** Avisos e pendências

---

## 🗺️ Estrutura de Navegação

### Telas Principais

```
SPLASH → LOGIN → HOME
                  ↓
         ┌────────┼────────┐
         ↓        ↓        ↓
      TURNO   RELATÓRIOS  CONFIGS
         ↓
    ┌────┼────┐
    ↓    ↓    ↓
  ABRIR CHECK SERV
        ↓
    ┌───┼───┐
    ↓   ↓   ↓
  VEI EPC EPI
```

### Rotas Definidas

| Rota                            | Tela                | Auth? |
| ------------------------------- | ------------------- | ----- |
| `/splash`                       | Splash (loading)    | Não   |
| `/login`                        | Login               | Não   |
| `/home`                         | Home (dashboard)    | Sim   |
| `/turno/abrir`                  | Abrir Turno         | Sim   |
| `/turno/checklist`              | Checklist Veicular  | Sim   |
| `/turno/checklist/epc`          | Checklist EPC       | Sim   |
| `/turno/checklist/epi`          | Checklist EPI       | Sim   |
| `/turno/checklist/eletricistas` | Lista Eletricistas  | Sim   |
| `/turno/servicos`               | Serviços do Turno   | Sim   |
| `/turno/navigation/loading`     | Decisão inteligente | Sim   |

---

## 💾 Modelo de Dados

### Principais Entidades

**Turno:**

- ID, remote_id
- Veículo, Equipe
- Hora início/fim
- KM inicial/final
- Situação (emAbertura, aberto, fechado)

**Checklist Preenchido:**

- ID do turno
- Modelo de checklist
- Respostas às perguntas
- Data de preenchimento

**Eletricista:**

- Nome, matrícula
- Remote ID
- Relação com turno (motorista?)

**Serviço:**

- ID do turno
- Tipo, descrição
- Local, observações
- Data execução

### Relacionamentos

```
TURNO 1-──> N ELETRICISTAS
  │
  ├──> 1 VEICULO
  ├──> 1 EQUIPE
  ├──> N CHECKLISTS_PREENCHIDOS
  └──> N SERVICOS

CHECKLIST_PREENCHIDO 1-──> N RESPOSTAS
  └──> 1 MODELO_CHECKLIST

MODELO_CHECKLIST 1-──> N PERGUNTAS

PERGUNTA 1-──> N OPCOES_RESPOSTA
```

---

## 🔄 Fluxo de Sincronização

### Offline-First

O app **funciona completamente offline**:

- Dados salvos localmente primeiro
- Sincronização com API quando possível
- Fila de sincronização para dados pendentes

### Momento de Sync

1. **Ao abrir o app** (splash)
2. **Ao fazer login**
3. **Pull-to-refresh** na home
4. **Ao abrir turno remotamente**
5. **Ao fechar turno**

### Dados Sincronizados

- ✅ Usuários
- ✅ Veículos e tipos
- ✅ Equipes e tipos
- ✅ Eletricistas
- ✅ Modelos de checklist
- ✅ Perguntas e opções de resposta
- ✅ Relações (tipo equipe, tipo veículo)

---

## 🛠️ Setup do Ambiente

### Pré-requisitos

```bash
# Flutter SDK 3.x+
flutter --version

# Dart SDK 3.x+
dart --version

# Android Studio / Xcode (para builds nativos)
```

### Instalação

```bash
# 1. Clonar repositório
git clone <repo-url>
cd nexa_app

# 2. Instalar dependências
flutter pub get

# 3. Gerar código do Drift
dart run build_runner build --delete-conflicting-outputs

# 4. Executar app
flutter run
```

### Configuração

**API Endpoint:**

```dart
// lib/core/constants/api_constants.dart
static const String baseUrl = 'https://api.exemplo.com';
```

**Database:**

```dart
// lib/core/database/app_database.dart
// Configuração automática do Drift
```

---

## 📚 Documentação Disponível

| Documento                                       | O que você vai aprender      |
| ----------------------------------------------- | ---------------------------- |
| **[OVERVIEW.md](OVERVIEW.md)** ← Você está aqui | Visão geral do projeto       |
| **[GETTING_STARTED.md](GETTING_STARTED.md)**    | Como começar a desenvolver   |
| **[ARCHITECTURE.md](ARCHITECTURE.md)**          | Arquitetura detalhada        |
| **[STYLE_GUIDE.md](STYLE_GUIDE.md)**            | Padrões de código            |
| **[MODULE_TEMPLATE.md](MODULE_TEMPLATE.md)**    | Templates para novos módulos |
| **[DIAGRAMS.md](DIAGRAMS.md)**                  | Diagramas visuais            |

---

## 🎓 Próximos Passos

### Para Novos Desenvolvedores:

1. ✅ **Leu este overview** - Você está aqui!
2. 📖 **Leia:** [GETTING_STARTED.md](GETTING_STARTED.md) - Como começar
3. 📖 **Leia:** [ARCHITECTURE.md](ARCHITECTURE.md) - Entender estrutura
4. 💻 **Configure** o ambiente de desenvolvimento
5. 🧪 **Execute** o app e explore as funcionalidades
6. 📦 **Crie** sua primeira feature seguindo [MODULE_TEMPLATE.md](MODULE_TEMPLATE.md)

### Para Desenvolvedores Experientes:

1. ✅ Leu este overview
2. 📖 [ARCHITECTURE.md](ARCHITECTURE.md) - Estrutura
3. 📖 [STYLE_GUIDE.md](STYLE_GUIDE.md) - Padrões
4. 💻 Comece a desenvolver!

---

## 🐛 Troubleshooting Comum

### Build Falha

```bash
# Limpar cache
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Erro de Get.find()

```
[GET] Instance "SomeClass" is not registered.
```

**Solução:** Verificar se classe está registrada no `Binding` correto.

### Erro de Database

```bash
# Regenerar código do Drift
dart run build_runner build --delete-conflicting-outputs
```

---

## 📞 Suporte

- **Documentação:** [`docs/`](.)
- **Code Review:** Consulte [STYLE_GUIDE.md](STYLE_GUIDE.md)
- **Arquitetura:** Consulte [ARCHITECTURE.md](ARCHITECTURE.md)
- **Dúvidas:** Entre em contato com a equipe

---

## 🎯 Glossário

| Termo          | Significado                                                      |
| -------------- | ---------------------------------------------------------------- |
| **DTO**        | Data Transfer Object - Objeto que representa dados da tabela/API |
| **Entity**     | Entidade de domínio - Objeto de negócio puro                     |
| **DAO**        | Data Access Object - Classe que acessa o banco                   |
| **Repository** | Camada que orquestra acesso a dados (DAO + API)                  |
| **Controller** | Gerencia estado da UI (GetX)                                     |
| **Binding**    | Injeta dependências (GetX)                                       |
| **UseCase**    | Caso de uso - Lógica de negócio isolada                          |
| **Obx**        | Widget reativo do GetX                                           |
| **Rx**         | Observable do GetX (.obs)                                        |

---

**Bem-vindo ao Nexa App! 🚀**  
**Continue para:** [GETTING_STARTED.md](GETTING_STARTED.md)
