# Diagramas de Arquitetura - Nexa App

> **Diagramas visuais para entendimento rápido da arquitetura**

---

## 📊 Visão Geral das Camadas

```bash
┌─────────────────────────────────────────────────────────────────┐
│                         PRESENTATION                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Controllers │  │    Pages     │  │   Bindings   │          │
│  │    (GetX)    │  │  (Flutter)   │  │   (GetX DI)  │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                  │
└─────────┼──────────────────┼──────────────────┼──────────────────┘
          │                  │                  │
          ↓                  ↓                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                           DOMAIN                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Entities   │  │ Repository   │  │   UseCases   │          │
│  │ (Pure Dart)  │  │ Interfaces   │  │  (Optional)  │          │
│  └──────────────┘  └──────┬───────┘  └──────────────┘          │
│                            │                                     │
└────────────────────────────┼─────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                            DATA                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ DataSources  │  │     DTOs     │  │ Repository   │          │
│  │ (DAO + API)  │  │   (Models)   │  │     Impl     │          │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘          │
│         │                                     │                  │
└─────────┼─────────────────────────────────────┼──────────────────┘
          │                                     │
          ↓                                     ↓
┌─────────────────────────────────────────────────────────────────┐
│                            CORE                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Database   │  │    Network   │  │    Utils     │          │
│  │   (Drift)    │  │    (Dio)     │  │   (Logger)   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Fluxo de Dados Completo

### Exemplo: Abrir Turno

```bash
┌────────────┐
│   USER     │
│  (Toca no  │
│   botão)   │
└─────┬──────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ PRESENTATION: home_page.dart                                    │
│                                                                 │
│   onPressed: () => controller.abrirTurno()                      │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ PRESENTATION: home_controller.dart                              │
│                                                                 │
│   Future<void> abrirTurno() async {                             │
│     // Navega para tela de abertura                             │
│     Get.toNamed(Routes.turnoNavigationLoading);                 │
│   }                                                             │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ PRESENTATION: turno_navigation_orchestrator.dart                │
│                                                                 │
│   1. Verifica se tem turno ativo                                │
│   2. Verifica checklists pendentes                              │
│   3. Decide próxima rota                                        │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ DOMAIN: i_turno_repository.dart                                 │
│                                                                 │
│   abstract class ITurnoRepository {                             │
│     Future<Turno?> buscarTurnoAtivo();                          │
│   }                                                             │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ DATA: turno_repository_impl.dart                                │
│                                                                 │
│   Future<Turno?> buscarTurnoAtivo() async {                     │
│     final dto = await _dao.buscarTurnoAtivo();                  │
│     return dto?.toEntity();                                     │
│   }                                                             │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ DATA: turno_dao.dart                                            │
│                                                                 │
│   Future<TurnoDto?> buscarTurnoAtivo() async {                  │
│     return await (select(turnoTable)                            │
│       ..where((t) => t.situacao.equals('aberto')))              │
│       .getSingleOrNull();                                       │
│   }                                                             │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓
┌─────────────────────────────────────────────────────────────────┐
│ CORE: app_database.dart (Drift)                                 │
│                                                                 │
│   SELECT * FROM turno_table                                     │
│   WHERE situacao = 'aberto'                                     │
│   LIMIT 1;                                                      │
└─────┬───────────────────────────────────────────────────────────┘
      │
      ↓ (Retorna dados)
      │
┌─────────────────────────────────────────────────────────────────┐
│ RESPONSE: TurnoDto → Turno Entity → Controller → UI Update     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Organização de um Módulo

### Módulo Turno (Exemplo Completo)

```bash
presentation/turno/
│
├── 📁 abrir/                        # Sub-feature: Abrir turno
│   ├── 📄 abrir_turno_controller.dart
│   ├── 📄 abrir_turno_page.dart
│   ├── 📄 abrir_turno_binding.dart
│   ├── 📁 widgets/
│   │   ├── 📄 veiculo_selector.dart
│   │   ├── 📄 equipe_selector.dart
│   │   └── 📄 eletricista_card.dart
│   ├── 📁 models/
│   │   └── 📄 abrir_turno_form_data.dart
│   └── 📁 services/
│       └── 📄 abrir_turno_service.dart
│
├── 📁 checklist/                    # Sub-feature: Checklists
│   ├── 📁 veicular/
│   │   ├── 📄 checklist_veicular_controller.dart
│   │   ├── 📄 checklist_veicular_page.dart
│   │   └── 📄 checklist_veicular_binding.dart
│   ├── 📁 epc/
│   │   ├── 📄 checklist_epc_controller.dart
│   │   ├── 📄 checklist_epc_page.dart
│   │   └── 📄 checklist_epc_binding.dart
│   └── 📁 epi/
│       ├── 📄 checklist_epi_controller.dart
│       ├── 📄 checklist_epi_page.dart
│       ├── 📄 checklist_epi_binding.dart
│       └── 📁 widgets/
│           └── 📄 eletricista_list.dart
│
├── 📁 servicos/                     # Sub-feature: Serviços
│   ├── 📄 turno_servicos_controller.dart
│   ├── 📄 turno_servicos_page.dart
│   └── 📄 turno_servicos_binding.dart
│
├── 📁 navigation/                   # Lógica de navegação
│   ├── 📄 turno_navigation_orchestrator.dart
│   ├── 📄 turno_navigation_state.dart
│   └── 📄 turno_navigation_loading_controller.dart
│
└── 📄 README.md                     # Documentação do módulo
```

**Características:**

- ✅ Tudo relacionado ao turno está junto
- ✅ Sub-features claramente organizadas
- ✅ Fácil navegar e encontrar código
- ✅ Widgets/models locais no próprio módulo
- ✅ Services específicos agrupados

---

## 🔀 Fluxo de Navegação

```bash
┌─────────────┐
│   SPLASH    │
│  (loading)  │
└──────┬──────┘
       │
       ↓ (verifica auth)
       │
   ┌───┴────┐
   │        │
   NO      YES
   │        │
   ↓        ↓
┌──────┐ ┌──────┐
│LOGIN │ │ HOME │
└──┬───┘ └───┬──┘
   │         │
   └────┬────┘
        │
        ↓ (clica em Turno)
        │
┌───────────────────┐
│ NAVIGATION        │
│ LOADING           │
│ (orchestrator)    │
└────────┬──────────┘
         │
    ┌────┴─────┐
    │          │
  Abrir    Checklist
  Turno    Pendente
    │          │
    ↓          ↓
┌────────┐  ┌──────────┐
│ ABRIR  │  │CHECKLIST │
│ TURNO  │  │ VEICULAR │
└───┬────┘  └────┬─────┘
    │            │
    └─────┬──────┘
          ↓
    (todos checklists OK)
          │
          ↓
   ┌─────────────┐
   │ LISTA EPI   │
   │(eletricistas)│
   └──────┬──────┘
          │
          ↓ (preenche todos)
          │
   ┌─────────────┐
   │ ABERTURA    │
   │  REMOTA     │
   │   (API)     │
   └──────┬──────┘
          │
          ↓ (sucesso)
          │
   ┌─────────────┐
   │  SERVIÇOS   │
   │  DO TURNO   │
   └─────────────┘
```

---

## 🔄 Ciclo de Vida de um Controller

```bash
┌────────────────────────────────────────────┐
│           CONTROLLER LIFECYCLE             │
└────────────────────────────────────────────┘

    📦 Get.lazyPut(() => Controller())
            │
            ↓
    ┌───────────────┐
    │  CONSTRUCTOR  │
    │  (injeção de  │
    │ dependências) │
    └───────┬───────┘
            │
            ↓
    ┌───────────────┐
    │    onInit()   │
    │ - Carregar    │
    │   dados       │
    │ - Iniciar     │
    │   listeners   │
    └───────┬───────┘
            │
            ↓
    ┌───────────────┐
    │   onReady()   │
    │ - UI pronta   │
    │ - Animações   │
    └───────┬───────┘
            │
            ↓
    ┌───────────────────────────┐
    │   CONTROLLER ATIVO        │
    │                           │
    │  • Gerencia estado        │
    │  • Reage a eventos        │
    │  • Atualiza UI            │
    └───────┬───────────────────┘
            │
            ↓ (usuário sai da tela)
            │
    ┌───────────────┐
    │   onClose()   │
    │ - Cancelar    │
    │   timers      │
    │ - Limpar      │
    │   streams     │
    └───────┬───────┘
            │
            ↓
    🗑️ Garbage Collected
```

---

## 🎯 Fluxo de Dados (Detalhado)

```bash
USER INTERACTION
      ↓
┌─────────────────────────────────────────────┐
│ PRESENTATION LAYER                          │
│                                             │
│  ┌──────────────────┐                       │
│  │   Page/Widget    │                       │
│  │  - Captura evento │                       │
│  │  - onPressed()    │                       │
│  └────────┬─────────┘                       │
│           │                                  │
│           ↓                                  │
│  ┌──────────────────┐                       │
│  │   Controller     │                       │
│  │  - Valida input  │                       │
│  │  - Atualiza UI   │                       │
│  │  - Chama UseCase │                       │
│  └────────┬─────────┘                       │
└───────────┼──────────────────────────────────┘
            │
            ↓
┌─────────────────────────────────────────────┐
│ DOMAIN LAYER                                │
│                                             │
│  ┌──────────────────┐                       │
│  │   UseCase        │  (Opcional)           │
│  │  - Business      │                       │
│  │    Logic         │                       │
│  └────────┬─────────┘                       │
│           │                                  │
│           ↓                                  │
│  ┌──────────────────┐                       │
│  │   Repository     │                       │
│  │   Interface      │                       │
│  │  - Contrato      │                       │
│  └────────┬─────────┘                       │
└───────────┼──────────────────────────────────┘
            │
            ↓
┌─────────────────────────────────────────────┐
│ DATA LAYER                                  │
│                                             │
│  ┌──────────────────┐                       │
│  │   Repository     │                       │
│  │   Implementation │                       │
│  │  - Orquestra     │                       │
│  │    fontes        │                       │
│  └────────┬─────────┘                       │
│           │                                  │
│     ┌─────┴─────┐                           │
│     │           │                            │
│     ↓           ↓                            │
│  ┌─────┐   ┌──────┐                         │
│  │ DAO │   │ API  │                          │
│  └──┬──┘   └───┬──┘                          │
└─────┼──────────┼───────────────────────────────┘
      │          │
      ↓          ↓
┌─────────────────────────────────────────────┐
│ CORE LAYER                                  │
│                                             │
│  ┌──────────┐     ┌──────────┐             │
│  │ Database │     │  Network │             │
│  │ (Drift)  │     │  (Dio)   │             │
│  └────┬─────┘     └────┬─────┘             │
└───────┼────────────────┼──────────────────────┘
        │                │
        ↓                ↓
    [SQLite]        [HTTP API]
```

---

## 🔌 Injeção de Dependências

```bash
┌──────────────────────────────────────────────────────┐
│              INITIAL BINDING                         │
│        (app startup - registra globais)              │
└────────────┬─────────────────────────────────────────┘
             │
    ┌────────┼────────┐
    │        │        │
    ↓        ↓        ↓
┌────────┐ ┌────────┐ ┌────────┐
│Database│ │  Dio   │ │ Logger │
│(Drift) │ │(Http)  │ │        │
└────────┘ └────────┘ └────────┘
    │          │          │
    └──────────┼──────────┘
               │
               ↓
      ┌────────────────┐
      │   DAOs         │
      │  - TurnoDao    │
      │  - UserDao     │
      └────────┬───────┘
               │
               ↓
      ┌────────────────┐
      │  Repositories  │
      │  - TurnoRepo   │
      │  - UserRepo    │
      └────────┬───────┘
               │
               ↓
      ┌────────────────┐
      │   Services     │
      │  - AuthService │
      │  - SyncService │
      └────────────────┘

┌──────────────────────────────────────────────────────┐
│           FEATURE BINDING (lazy)                     │
│     (quando navega para tela específica)             │
└────────────┬─────────────────────────────────────────┘
             │
             ↓
      ┌────────────────┐
      │  Controllers   │
      │  - HomeCtrl    │
      │  - LoginCtrl   │
      └────────────────┘
```

---

## 📦 Organização por Módulo

### Princípio: Tudo Junto

```bash
❌ ERRADO (Separado por Tipo):

presentation/
├── controllers/
│   ├── home_controller.dart
│   ├── login_controller.dart
│   └── turno_controller.dart
├── pages/
│   ├── home_page.dart
│   ├── login_page.dart
│   └── turno_page.dart
└── bindings/
    ├── home_binding.dart
    ├── login_binding.dart
    └── turno_binding.dart

Problema: Para mexer em Home, precisa abrir 3 pastas diferentes!


✅ CORRETO (Por Módulo):

presentation/
├── home/
│   ├── home_controller.dart    ← Tudo junto!
│   ├── home_page.dart
│   └── home_binding.dart
├── login/
│   ├── login_controller.dart
│   ├── login_page.dart
│   └── login_binding.dart
└── turno/
    ├── abrir/
    │   ├── abrir_turno_controller.dart
    │   ├── abrir_turno_page.dart
    │   └── abrir_turno_binding.dart
    └── checklist/
        └── ...

Vantagem: Módulo completo em uma pasta!
```

---

## 🔄 Comunicação Entre Módulos

```bash
┌─────────────────────────────────────────────────────┐
│            MÓDULO A (Home)                          │
│  ┌──────────────┐                                   │
│  │ Controller   │                                   │
│  │              │                                   │
│  │ abrirTurno() │                                   │
│  └──────┬───────┘                                   │
└─────────┼───────────────────────────────────────────┘
          │
          │ Get.toNamed(Routes.turnoAbrir)
          │
          ↓
┌─────────────────────────────────────────────────────┐
│            MÓDULO B (Turno/Abrir)                   │
│  ┌──────────────┐                                   │
│  │   Binding    │ ← Injeta dependências             │
│  └──────┬───────┘                                   │
│         │                                            │
│         ↓                                            │
│  ┌──────────────┐                                   │
│  │ Controller   │ ← Criado pelo GetX                │
│  └──────┬───────┘                                   │
│         │                                            │
│         ↓                                            │
│  ┌──────────────┐                                   │
│  │    Page      │ ← Renderizada                     │
│  └──────────────┘                                   │
└─────────────────────────────────────────────────────┘

REGRA:
• Módulos NÃO se conhecem diretamente
• Comunicação via Navegação (Routes)
• Compartilhamento via Shared/Domain
• Estado global via Controllers permanentes
```

---

## 📊 Responsabilidades das Camadas

```bash
┌──────────────────────────────────────────────────────────────┐
│  PRESENTATION                                                │
│                                                              │
│  ✅ Gerenciar estado da UI                                   │
│  ✅ Reagir a eventos do usuário                              │
│  ✅ Exibir dados formatados                                  │
│  ✅ Navegação entre telas                                    │
│                                                              │
│  ❌ Lógica de negócio                                        │
│  ❌ Acesso direto ao banco                                   │
│  ❌ Transformação de dados complexa                          │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  DOMAIN                                                      │
│                                                              │
│  ✅ Regras de negócio puras                                  │
│  ✅ Validações de domínio                                    │
│  ✅ Definir contratos (interfaces)                           │
│  ✅ Entidades sem dependências                               │
│                                                              │
│  ❌ Conhecer frameworks (Flutter, GetX)                      │
│  ❌ Saber de onde vêm os dados                               │
│  ❌ Lógica de UI                                             │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  DATA                                                        │
│                                                              │
│  ✅ Implementar acesso a dados                               │
│  ✅ Converter DTO ↔ Entity                                   │
│  ✅ Cache e otimizações                                      │
│  ✅ Coordenar local + remoto                                 │
│                                                              │
│  ❌ Regras de negócio                                        │
│  ❌ Lógica de UI                                             │
│  ❌ Conhecer detalhes da apresentação                        │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  CORE                                                        │
│                                                              │
│  ✅ Ferramentas de infraestrutura                            │
│  ✅ Configurações globais                                    │
│  ✅ Utilitários genéricos                                    │
│  ✅ Database e Network                                       │
│                                                              │
│  ❌ Conhecer features específicas                            │
│  ❌ Lógica de negócio                                        │
│  ❌ Lógica de apresentação                                   │
└──────────────────────────────────────────────────────────────┘
```

---

## 🎨 Estados de UI (Pattern)

```bash
┌─────────────────────────────────────────────┐
│           UI STATE MANAGEMENT               │
└─────────────────────────────────────────────┘

build() {
  return Column(
    children: [
      // ┌─────────────────────────────────┐
      // │  LOADING STATE (isolado)        │
      // └─────────────────────────────────┘
      Obx(() {
        if (isLoading) return LoadingWidget();
        return SizedBox.shrink();
      }),

      // ┌─────────────────────────────────┐
      // │  ERROR STATE (isolado)          │
      // └─────────────────────────────────┘
      Obx(() {
        if (hasError) return ErrorWidget();
        return SizedBox.shrink();
      }),

      // ┌─────────────────────────────────┐
      // │  EMPTY STATE (isolado)          │
      // └─────────────────────────────────┘
      Obx(() {
        if (isEmpty) return EmptyWidget();
        return SizedBox.shrink();
      }),

      // ┌─────────────────────────────────┐
      // │  CONTENT STATE (isolado)        │
      // └─────────────────────────────────┘
      Obx(() {
        if (hasData) return ContentWidget();
        return SizedBox.shrink();
      }),
    ],
  );
}

VANTAGENS:
✅ Cada estado é independente
✅ Mudança em loading não afeta content
✅ Performance otimizada
✅ Fácil debugar
```

---

## 🗺️ Mapa de Navegação do App

```bash
                    ┌─────────────┐
                    │   SPLASH    │
                    └──────┬──────┘
                           │
                      (auth check)
                           │
                    ┌──────┴──────┐
                    │             │
                  (no)          (yes)
                    │             │
                    ↓             ↓
              ┌──────────┐  ┌──────────┐
              │  LOGIN   │  │   HOME   │
              └────┬─────┘  └────┬─────┘
                   │             │
                   └─────┬───────┘
                         │
              ┌──────────┼──────────┐
              │          │          │
              ↓          ↓          ↓
         ┌────────┐ ┌────────┐ ┌────────┐
         │ TURNO  │ │RELATÓ- │ │CONFI-  │
         │        │ │  RIOS  │ │  GURA- │
         │        │ │        │ │  ÇÕES  │
         └───┬────┘ └────────┘ └────────┘
             │
    ┌────────┼────────┐
    │        │        │
    ↓        ↓        ↓
┌────────┐┌────────┐┌────────┐
│ Abrir  ││Check-  ││Servi-  │
│ Turno  ││lists   ││ços     │
└────────┘└───┬────┘└────────┘
              │
       ┌──────┼──────┐
       │      │      │
       ↓      ↓      ↓
   ┌──────┐┌────┐┌────┐
   │Veicu-││EPC ││EPI │
   │ lar  │└────┘└────┘
   └──────┘
```

---

## 💾 Fluxo de Persistência

### Salvar Dados

```bash
Controller.salvar()
      ↓
Repository.salvar(entity)
      ↓
DTO.fromEntity(entity)
      ↓
DAO.inserir(dto)
      ↓
Drift.insert(table, data)
      ↓
SQLite INSERT INTO ...
```

### Buscar Dados

```bash
SQLite SELECT * FROM ...
      ↓
Drift.select().get()
      ↓
DAO.buscar() → List<TableData>
      ↓
DTO.fromTable(tableData)
      ↓
Repository.buscar() → dto.toEntity()
      ↓
Controller.data.value = entity
      ↓
UI rebuilds (Obx)
```

---

## 🔐 Fluxo de Autenticação

```bash
App Start
    ↓
SessionManager.init()
    ↓
Verifica token local
    │
    ├─ Token válido?
    │   │
    │   YES → Auto-login
    │   │       ↓
    │   │   SessionManager.usuario
    │   │       ↓
    │   │   Navigate → HOME
    │   │
    │   NO → Navigate → LOGIN
    │           ↓
    │       User preenche
    │           ↓
    │       LoginController.login()
    │           ↓
    │       AuthService.autenticar()
    │           ↓
    │       API POST /login
    │           ↓
    │       Salva token
    │           ↓
    │       SessionManager.salvarSessao()
    │           ↓
    │       Navigate → HOME
    │
    └─ Em todas as rotas:
            ↓
        AuthMiddleware
            ↓
        Verifica sessão
            │
            ├─ Válida → Allow
            └─ Inválida → Redirect LOGIN
```

---

## 🔄 Pattern: Repository + DAO + DTO

```bash
┌─────────────────────────────────────────────────────┐
│                   REPOSITORY                        │
│  (Orquestra acesso, converte DTO ↔ Entity)          │
└──────────────┬──────────────────────────────────────┘
               │
        ┌──────┴──────┐
        │             │
        ↓             ↓
┌─────────────┐ ┌─────────────┐
│     DAO     │ │     API     │
│  (Local)    │ │  (Remote)   │
└──────┬──────┘ └──────┬──────┘
       │                │
       ↓                ↓
┌──────────────────────────────┐
│          DTO                 │
│  (Data Transfer Object)      │
│                              │
│  • fromTable(TableData)      │
│  • fromJson(Map)             │
│  • toEntity() → Entity       │
│  • fromEntity(Entity)        │
└──────────────────────────────┘
```

**Fluxo de Conversão:**

```bash
Database → TableData → DTO → Entity → UI
   ↑                              ↓
   └──────── DTO ← Entity ────────┘
```

---

## 🧪 Arquitetura de Testes

```bash
┌─────────────────────────────────────────────────────┐
│                UNIT TESTS                           │
│  • Entities (lógica de negócio)                     │
│  • UseCases (regras de domínio)                     │
│  • Controllers (estado e reações)                   │
│  • Repositories (com mocks de DAO/API)              │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│             INTEGRATION TESTS                       │
│  • Fluxos completos (login → home → turno)          │
│  • Navegação entre telas                            │
│  • Persistência real (database em memória)          │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│              WIDGET TESTS                           │
│  • Componentes de UI isolados                       │
│  • Interações do usuário                            │
│  • Estados visuais                                  │
└─────────────────────────────────────────────────────┘
```

---

## 📱 Ciclo de Vida do App

```bash
┌──────────────┐
│  main.dart   │
└──────┬───────┘
       │
       ↓
┌─────────────────────────────┐
│  runApp(MyApp())            │
│  • ErrorWidget.builder      │
│  • FlutterError.onError     │
└──────┬──────────────────────┘
       │
       ↓
┌─────────────────────────────┐
│  InitialBinding.dependencies │
│  • Database                  │
│  • Network                   │
│  • Repositories              │
│  • Global Controllers        │
└──────┬──────────────────────┘
       │
       ↓
┌─────────────────────────────┐
│  GetMaterialApp              │
│  • Routes                    │
│  • Theme                     │
│  • Middlewares               │
└──────┬──────────────────────┘
       │
       ↓
┌─────────────────────────────┐
│  SplashPage                  │
│  • SessionCheck              │
│  • Sync                      │
└──────┬──────────────────────┘
       │
       ↓
┌─────────────────────────────┐
│  LoginPage / HomePage        │
│  (baseado em auth)           │
└──────────────────────────────┘
```

---

## 🎯 Decisões de Design

### Por que módulos ao invés de tipos?

```bash
ORGANIZAÇÃO POR TIPO (RUIM):
• Controller do Turno em controllers/
• Page do Turno em pages/
• Binding do Turno em bindings/
→ Para mexer em Turno, abre 3 pastas diferentes!
→ Difícil ver o módulo completo
→ Imports longos e confusos

ORGANIZAÇÃO POR MÓDULO (BOM):
• Turno/ contém tudo relacionado a turno
• Login/ contém tudo relacionado a login
• Home/ contém tudo relacionado a home
→ Tudo junto, fácil de encontrar
→ Módulo independente e portável
→ Imports mais limpos
```

### Por que Clean Architecture?

```bash
SEM CLEAN ARCH:
Page → DAO direto
→ Page acoplada ao banco
→ Difícil testar
→ Difícil trocar fonte de dados

COM CLEAN ARCH:
Page → Controller → UseCase → Repository → DAO
→ Cada camada testável
→ Fácil trocar implementação
→ Código desacoplado
→ Regras de negócio isoladas
```

---

## 🚀 Próximos Passos

1. ✅ Documentação completa criada
2. 📋 Migração planejada (ver MIGRATION_GUIDE.md)
3. 🔄 Executar migração incremental
4. 🧪 Aumentar cobertura de testes
5. 📈 Monitorar performance

---

**Criado em:** Outubro 2025  
**Mantido por:** Equipe Nexa
