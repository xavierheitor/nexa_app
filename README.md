# Nexa App

> **Sistema de Gerenciamento de Turnos e Serviços**  
> Flutter • GetX • Drift • Clean Architecture

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-Latest-purple.svg)](https://pub.dev/packages/get)
[![Drift](https://img.shields.io/badge/Drift-Latest-orange.svg)](https://drift.simonbinder.eu/)

---

## 🚀 Quick Start

```bash
# 1. Instalar dependências
flutter pub get

# 2. Gerar código (Drift)
dart run build_runner build --delete-conflicting-outputs

# 3. Executar
flutter run
```

---

## 📚 Documentação Completa

### 🎯 **Para Novos Desenvolvedores** (Comece aqui!)

| Ordem | Documento | Tempo | Descrição |
|-------|-----------|-------|-----------|
| 1️⃣ | **[OVERVIEW.md](docs/OVERVIEW.md)** | 10 min | **Visão geral do projeto** - O que é, como funciona |
| 2️⃣ | **[GETTING_STARTED.md](docs/GETTING_STARTED.md)** | 2h | **Seu primeiro dia** - Setup, primeira feature, primeiro commit |
| 3️⃣ | **[DIAGRAMS.md](docs/DIAGRAMS.md)** | 15 min | **Diagramas visuais** - Fluxos e arquitetura visual |

### 📐 **Para Desenvolvimento** (Consulta diária)

| Documento | Quando Usar |
|-----------|-------------|
| **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** | Entender estrutura, criar módulos |
| **[STYLE_GUIDE.md](docs/STYLE_GUIDE.md)** | Escrever código, code review |
| **[MODULE_TEMPLATE.md](docs/MODULE_TEMPLATE.md)** | Criar nova feature/módulo |

### 🔄 **Para Manutenção** (Referência)

| Documento | Quando Usar |
|-----------|-------------|
| **[MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md)** | Histórico e scripts de migração |
| **[QUICK_MIGRATION_CHECKLIST.md](docs/QUICK_MIGRATION_CHECKLIST.md)** | Executar refatorações |
| **[Code Review Report](docs/reports/flutter_code_review_2025-10-15.md)** | Análise de qualidade |

---

## 🏗️ Arquitetura

### Estrutura de Pastas

```
lib/
├── 📱 app/                    # Configuração e rotas
├── ⚙️ core/                   # Database, network, security, utils
├── 💾 data/                   # Datasources, models (DTOs), repositories
├── 🎯 domain/                 # Entities, interfaces, usecases (futuro)
├── 🎨 presentation/           # MÓDULOS (controller + page + binding)
│   ├── home/                 # Dashboard principal
│   ├── login/                # Autenticação
│   ├── splash/               # Inicialização
│   └── turno/                # Gestão de turnos (módulo principal)
│       ├── abrir/            # Abertura de turno
│       ├── checklist/        # Sistema de checklists
│       ├── servicos/         # Registro de serviços
│       └── navigation/       # Orchestração de navegação
└── 🔧 shared/                 # Widgets, middlewares, bindings globais
```

> 📖 **Detalhes:** [ARCHITECTURE.md](docs/ARCHITECTURE.md)

---

## 🎯 Princípios do Projeto

### 1. **Clean Architecture**
- Separação clara de responsabilidades
- Domain independente de frameworks
- Fácil de testar e manter

### 2. **Organização por Módulos**
- Código relacionado fica junto
- Módulos auto-contidos
- Fácil navegação no código

### 3. **Offline-First**
- Persistência local (Drift/SQLite)
- Sincronização quando online
- App funciona sem internet

### 4. **Performance**
- Obx granulares (rebuilds otimizados)
- Const widgets
- ListView.builder
- Cache inteligente

### 5. **Qualidade**
- Null safety 100%
- Logs detalhados
- Tratamento robusto de erros
- Documentação completa

---

## 🚗 Funcionalidades

### ✅ Implementadas

- **Autenticação**
  - Login com matrícula e senha
  - Sessão persistente (24h)
  - Refresh token automático
  
- **Gestão de Turnos**
  - Abertura com validações
  - Fechamento com KM final
  - Dashboard com status
  
- **Sistema de Checklists**
  - Checklist Veicular
  - Checklist EPC  
  - Checklist EPI (por eletricista)
  - Navegação inteligente
  
- **Registro de Serviços**
  - Adicionar/remover serviços
  - Tipos configuráveis
  - Sincronização

- **Sincronização**
  - Automática na abertura
  - Manual (pull-to-refresh)
  - Offline-first

### 🚧 Em Desenvolvimento

- Domain layer completo (entities, interfaces, usecases)
- Testes unitários e integração
- Módulo de relatórios
- Dashboard analytics

---

## 🛠️ Tecnologias

### Core

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^latest              # Estado, navegação, DI
  drift: ^latest            # ORM / SQLite
  dio: ^latest              # HTTP client
```

### UI

```yaml
  flutter_svg: ^latest      # Ícones SVG
  intl: ^latest             # Formatação de datas
  image_picker: ^latest     # Seleção de imagens
```

### Utilities

```yaml
  path_provider: ^latest    # Paths do sistema
  connectivity_plus: ^latest # Status de rede
  package_info_plus: ^latest # Info do app
```

> Veja `pubspec.yaml` para lista completa

---

## 🎨 UI/UX

### Design System

- **Material Design 3**
- **Tema customizado** com cores do Nexa
- **Componentes reutilizáveis**
- **Responsivo** (mobile first)

### Navegação

- **Bottom Navigation** (home)
- **Drawer** (menu lateral)
- **Stack Navigation** (fluxos lineares)
- **Orchestrador inteligente** (decide próxima tela)

---

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Com coverage
flutter test --coverage

# Teste específico
flutter test test/presentation/home/home_controller_test.dart
```

### Cobertura Atual

| Camada | Cobertura | Status |
|--------|-----------|--------|
| Presentation | 15% | 🔴 Baixa |
| Data | 25% | 🟡 Média |
| Core | 30% | 🟡 Média |
| **Total** | **20%** | 🔴 **A melhorar** |

**Meta:** 80% de cobertura

---

## 📊 Status do Projeto

| Aspecto | Status | Progresso |
|---------|--------|-----------|
| **Arquitetura** | ✅ Refatorada | 100% |
| **Documentação** | ✅ Completa | 100% |
| **Performance** | ✅ Otimizada | 95% |
| **Null Safety** | ✅ Completo | 100% |
| **Testes** | 🔴 Insuficientes | 20% |
| **Domain Layer** | 🟡 Planejado | 0% |

---

## 🗺️ Roadmap

### v1.0 (Atual)
- ✅ Gestão de turnos
- ✅ Sistema de checklists
- ✅ Registro de serviços
- ✅ Sincronização básica

### v1.1 (Próximo)
- [ ] Domain layer completo
- [ ] Testes (80% coverage)
- [ ] Sistema de relatórios
- [ ] Dashboard analytics

### v2.0 (Futuro)
- [ ] Módulo de manutenção
- [ ] Gestão de materiais
- [ ] Assinatura digital
- [ ] Fotos e anexos

---

## 👥 Time

### Papéis

- **Tech Lead:** [Nome]
- **Developers:** [Nomes]
- **QA:** [Nome]
- **DevOps:** [Nome]

### Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Siga os guias: [STYLE_GUIDE.md](docs/STYLE_GUIDE.md)
4. Commit (`git commit -m 'feat: adiciona feature'`)
5. Push (`git push origin feature/nova-feature`)
6. Abra Pull Request

> **Code Review:** Obrigatório para todos os PRs

---

## 📖 Guias Rápidos

### Como criar nova feature?

```bash
# 1. Leia o template
📖 docs/MODULE_TEMPLATE.md

# 2. Crie estrutura
mkdir lib/presentation/[modulo]/[feature]
touch controller.dart page.dart binding.dart

# 3. Copie templates e adapte

# 4. Registre rota

# 5. Teste

# 6. Commit e PR
```

### Como fazer code review?

```bash
# Checklist:
✅ Segue STYLE_GUIDE.md?
✅ Arquitetura OK?
✅ Performance OK?
✅ Documentado?
✅ Testado?
```

### Como debugar?

```bash
# 1. Logs
AppLogger.d('mensagem', tag: 'MinhaClasse');

# 2. DevTools
flutter pub global run devtools

# 3. Breakpoints
# Use o debugger do IDE
```

---

## 🔗 Links Úteis

### Documentação Interna
- 📚 [Índice Completo](docs/README.md)
- 📐 [Arquitetura](docs/ARCHITECTURE.md)
- 🎨 [Guia de Estilo](docs/STYLE_GUIDE.md)
- 📦 [Templates](docs/MODULE_TEMPLATE.md)
- 🚀 [Getting Started](docs/GETTING_STARTED.md)

### Recursos Externos
- [Flutter Docs](https://docs.flutter.dev/)
- [GetX Docs](https://github.com/jonataslaw/getx)
- [Drift Docs](https://drift.simonbinder.eu/)
- [Dart Docs](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)

---

## 📜 Licença

[Tipo de Licença] - Veja [LICENSE](LICENSE) para detalhes

---

## 📞 Contato

- **Email:** [email]
- **Slack:** [canal]
- **Jira:** [board]

---

<div align="center">

**Desenvolvido com ❤️ pela Equipe Nexa**

[Site](https://exemplo.com) • [Docs](docs/) • [Issues](issues/) • [Wiki](wiki/)

</div>
