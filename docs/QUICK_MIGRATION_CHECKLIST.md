# Checklist Rápido de Migração

> **Use este documento durante a migração para não esquecer nenhum passo**

---

## ✅ PRÉ-MIGRAÇÃO

- [ ] Ler [ARCHITECTURE.md](ARCHITECTURE.md) completo
- [ ] Ler [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) completo
- [ ] Criar branch `refactor/nova-arquitetura`
- [ ] Build atual funcionando (`flutter run`)
- [ ] Testes passando (`flutter test`)
- [ ] Commit de todas as mudanças pendentes
- [ ] Backup do código atual

---

## 📁 FASE 1: CRIAR ESTRUTURA

```bash
mkdir -p lib/app/routes
mkdir -p lib/core/network
mkdir -p lib/core/security
mkdir -p lib/data/datasources/local
mkdir -p lib/data/datasources/remote
mkdir -p lib/data/models
mkdir -p lib/data/repositories
mkdir -p lib/domain/entities
mkdir -p lib/domain/repositories
mkdir -p lib/domain/usecases
mkdir -p lib/presentation
mkdir -p lib/shared/widgets
mkdir -p lib/shared/middlewares
mkdir -p lib/shared/bindings
```

**Checklist:**

- [ ] Pastas criadas
- [ ] Git add das novas pastas
- [ ] Commit: `chore: criar estrutura de pastas da nova arquitetura`

---

## 🔧 FASE 2: MIGRAR CORE

### 2.1 Network

```bash
mv lib/core/utils/network lib/core/network
```

- [ ] Arquivos movidos
- [ ] Build OK
- [ ] Commit: `refactor(core): mover network para core/network`

### 2.2 Security

```bash
mv lib/core/core_app/session lib/core/security
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(core): mover session para core/security`

---

## 💾 FASE 3: MIGRAR DATA

### 3.1 DAOs → datasources/local

```bash
mv lib/core/database/daos/* lib/data/datasources/local/
```

- [ ] Arquivos movidos
- [ ] Imports atualizados em repositórios
- [ ] Build OK
- [ ] Commit: `refactor(data): mover DAOs para data/datasources/local`

### 3.2 DTOs → models

```bash
mv lib/core/domain/dto/* lib/data/models/
```

- [ ] Arquivos movidos
- [ ] Renomear: `*_table_dto.dart` → `*_dto.dart`
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(data): mover DTOs para data/models`

### 3.3 Repositories → data/repositories

```bash
mv lib/core/domain/repositories/* lib/data/repositories/
```

- [ ] Arquivos movidos
- [ ] Renomear classes: `TurnoRepo` → `TurnoRepositoryImpl`
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(data): mover repositories para data/repositories`

---

## 🎯 FASE 4: CRIAR DOMAIN

### 4.1 Criar Entities

- [ ] Criar `domain/entities/turno.dart`
- [ ] Criar `domain/entities/checklist.dart`
- [ ] Criar `domain/entities/veiculo.dart`
- [ ] Criar `domain/entities/equipe.dart`
- [ ] Criar `domain/entities/eletricista.dart`
- [ ] Commit: `feat(domain): criar entities de domínio`

### 4.2 Criar Repository Interfaces

- [ ] Criar `domain/repositories/i_turno_repository.dart`
- [ ] Criar `domain/repositories/i_checklist_repository.dart`
- [ ] Criar outras interfaces necessárias
- [ ] Commit: `feat(domain): criar interfaces de repositories`

### 4.3 Implementar Interfaces nos Repositories

- [ ] `TurnoRepositoryImpl implements ITurnoRepository`
- [ ] `ChecklistRepositoryImpl implements IChecklistRepository`
- [ ] Atualizar imports
- [ ] Build OK
- [ ] Commit: `refactor(data): implementar interfaces de domain`

---

## 🎨 FASE 5: MIGRAR PRESENTATION

### 5.1 Módulo Splash (15 min)

```bash
mv lib/modules/splash lib/presentation/splash
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Testar tela de splash
- [ ] Commit: `refactor(presentation): migrar módulo splash`

### 5.2 Módulo Login (15 min)

```bash
mv lib/modules/login lib/presentation/login
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Testar login
- [ ] Commit: `refactor(presentation): migrar módulo login`

### 5.3 Módulo Home (20 min)

```bash
mv lib/modules/home lib/presentation/home
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Testar home completa
- [ ] Commit: `refactor(presentation): migrar módulo home`

### 5.4 Módulo Turno (40 min)

```bash
mv lib/modules/turno lib/presentation/turno
```

**Verificar subpastas:**

- [ ] `abrir/` - OK
- [ ] `abrindo/` - OK
- [ ] `checklist/veicular/` - OK
- [ ] `checklist/epc/` - OK
- [ ] `checklist/epi/` - OK
- [ ] `servicos/` - OK
- [ ] `navigation/` - OK

**Validação:**

- [ ] Imports atualizados
- [ ] Build OK
- [ ] Testar fluxo completo:
  - [ ] Abrir turno
  - [ ] Checklist veicular
  - [ ] Checklist EPC
  - [ ] Checklist EPI
  - [ ] Serviços
- [ ] Commit: `refactor(presentation): migrar módulo turno`

---

## 🧩 FASE 6: MIGRAR SHARED

### 6.1 Widgets

```bash
mv lib/widgets/* lib/shared/widgets/
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(shared): migrar widgets globais`

### 6.2 Middlewares

```bash
mv lib/core/middlewares/* lib/shared/middlewares/
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(shared): migrar middlewares`

### 6.3 Bindings Globais

```bash
mv lib/core/core_app/bindings/* lib/shared/bindings/
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(shared): migrar bindings globais`

---

## 📱 FASE 7: MIGRAR APP CONFIG

### 7.1 Routes

```bash
mv lib/routes lib/app/routes
```

- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit: `refactor(app): mover routes para app/routes`

### 7.2 App Widget

```bash
mv lib/app.dart lib/app/app.dart
```

- [ ] Arquivo movido
- [ ] Atualizar import em `main.dart`
- [ ] Build OK
- [ ] Commit: `refactor(app): mover app.dart para app/`

---

## 🔄 FASE 8: SCRIPT DE IMPORTS

Execute o script de atualização de imports:

```bash
# Atualizar todos os imports de uma vez
bash scripts/update_imports.sh
```

**OU atualizar manualmente no IDE:**

- [ ] `modules/` → `presentation/`
- [ ] `core/utils/network/` → `core/network/`
- [ ] `core/core_app/session/` → `core/security/`
- [ ] `core/database/daos/` → `data/datasources/local/`
- [ ] `core/domain/dto/` → `data/models/`
- [ ] `core/domain/repositories/` → `data/repositories/`
- [ ] `widgets/` → `shared/widgets/`
- [ ] `core/middlewares/` → `shared/middlewares/`
- [ ] `routes/` → `app/routes/`

**Validação:**

- [ ] `flutter analyze` sem erros
- [ ] Build OK
- [ ] Commit: `refactor: atualizar todos os imports`

---

## 🧪 FASE 9: VALIDAÇÃO FINAL

### 9.1 Build

- [ ] `flutter clean`
- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] `flutter analyze` (0 issues)
- [ ] `flutter build apk --debug` (sucesso)

### 9.2 Testes Automatizados

- [ ] `flutter test` (todos passando)
- [ ] `flutter test --coverage` (coverage mantido)

### 9.3 Testes Manuais

- [ ] Login
  - [ ] Login com sucesso
  - [ ] Erro de credenciais
  - [ ] Navegação para home
- [ ] Home
  - [ ] Banner de turno exibido corretamente
  - [ ] Botões funcionando
  - [ ] Sincronização OK
- [ ] Turno - Abrir
  - [ ] Dropdown de veículos
  - [ ] Dropdown de equipes
  - [ ] Seleção de eletricistas
  - [ ] Abertura de turno
- [ ] Turno - Checklists
  - [ ] Checklist veicular
  - [ ] Checklist EPC
  - [ ] Checklist EPI (todos eletricistas)
  - [ ] Navegação entre checklists
- [ ] Turno - Serviços
  - [ ] Adicionar serviço
  - [ ] Remover serviço
  - [ ] Fechar turno

### 9.4 Performance

- [ ] Flutter DevTools: Sem rebuilds excessivos
- [ ] Tempo de navegação aceitável
- [ ] Sem memory leaks
- [ ] Consumo de CPU normal

---

## 📝 FASE 10: DOCUMENTAÇÃO E PR

- [ ] Atualizar README.md se necessário
- [ ] Atualizar CHANGELOG.md
- [ ] Criar PR com descrição detalhada
- [ ] Solicitar code review
- [ ] Mergear após aprovação

---

## 🔄 SCRIPT DE ROLLBACK (Se Necessário)

```bash
# Voltar para antes da migração
git checkout main
git branch -D refactor/nova-arquitetura

# Ou reverter commits específicos
git revert <commit-hash>
```

---

## 📊 TEMPO ESTIMADO

| Fase                   | Tempo    | Acumulado |
| ---------------------- | -------- | --------- |
| 1. Criar estrutura     | 5 min    | 5 min     |
| 2. Migrar Core         | 30 min   | 35 min    |
| 3. Migrar Data         | 45 min   | 1h 20min  |
| 4. Criar Domain        | 40 min   | 2h        |
| 5. Migrar Presentation | 1h 20min | 3h 20min  |
| 6. Migrar Shared       | 25 min   | 3h 45min  |
| 7. Migrar App          | 15 min   | 4h        |
| 8. Atualizar Imports   | 30 min   | 4h 30min  |
| 9. Validação           | 45 min   | 5h 15min  |
| 10. Doc e PR           | 15 min   | 5h 30min  |

**Total:** ~5h 30min

---

## 💡 DICAS

1. **Faça commits pequenos** - Facilita reverter se necessário
2. **Teste a cada fase** - Não avance se build estiver quebrado
3. **Use IDE** - Refactoring automático ajuda muito
4. **Peça ajuda** - Se travar, consulte a documentação ou time
5. **Não tenha pressa** - Melhor devagar e correto

---

## ⚠️ PROBLEMAS COMUNS

### Build Quebrado

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Imports Errados

```bash
# Use find & replace no IDE
Ctrl+Shift+H (VS Code/Cursor)
Buscar: package:nexa_app/modules/
Substituir: package:nexa_app/presentation/
```

### Get.find() Falha

Verifique se a dependência está registrada no binding:

```dart
Get.lazyPut(() => SuaClasse());
```

---

**Boa sorte na migração! 🚀***
