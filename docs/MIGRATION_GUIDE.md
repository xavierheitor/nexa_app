# Guia de Migração - Nova Arquitetura

> **Status:** 📋 Planejamento  
> **Prioridade:** Alta  
> **Estimativa:** 3-4 horas de trabalho  
> **Responsável:** Equipe Dev

---

## 📋 Visão Geral

Este documento detalha o processo de migração do código atual para a nova arquitetura em camadas, mantendo a organização por módulos.

---

## 🎯 Objetivos

1. ✅ Melhorar manutenibilidade
2. ✅ Facilitar testes
3. ✅ Reduzir acoplamento
4. ✅ Seguir Clean Architecture
5. ✅ Manter código funcionando durante toda a migração

---

## 📊 Estado Atual vs Desejado

### Estrutura Atual

```bash
lib/
├── core/
│   ├── core_app/          # Mix de tudo
│   ├── database/          # OK
│   ├── domain/            # Repositories + DTOs misturados
│   └── utils/             # Network + Utils
├── modules/               # Features
└── widgets/               # Widgets globais
```

### Estrutura Nova

```bash
lib/
├── app/                   # Config e rotas
├── core/                  # Database, network, utils (limpo)
├── data/                  # Datasources, DTOs, Repo implementations
├── domain/                # Entities, Interfaces, UseCases
├── presentation/          # Módulos completos (controller + page + binding)
└── shared/                # Widgets, middlewares, bindings globais
```

---

## 📅 Plano de Migração (Incremental)

### Fase 1: Preparação (30 min)

#### 1.1 Criar Estrutura de Pastas Vazia

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

#### 1.2 Criar Branch

```bash
git checkout -b refactor/nova-arquitetura
```

---

### Fase 2: Migrar Core (45 min)

**Objetivo:** Limpar e reorganizar `core/`

#### 2.1 Mover Network

```bash
# De:
lib/core/utils/network/
  ├── dio_client.dart
  └── interceptors/

# Para:
lib/core/network/
  ├── dio_client.dart
  └── interceptors/
```

**Atualizar imports:**

```dart
// Antes:
import 'package:nexa_app/core/utils/network/dio_client.dart';

// Depois:
import 'package:nexa_app/core/network/dio_client.dart';
```

#### 2.2 Mover Security

```bash
# De:
lib/core/core_app/session/
  └── session_manager.dart

# Para:
lib/core/security/
  └── session_manager.dart
```

#### 2.3 Manter em Core

```bash
lib/core/
├── database/         # ✅ JÁ ESTÁ BOM
├── constants/        # ✅ JÁ ESTÁ BOM
└── utils/
    └── logger/       # ✅ JÁ ESTÁ BOM
```

---

### Fase 3: Migrar Data Layer (1h)

**Objetivo:** Separar datasources, models e repositories

#### 3.1 Mover DAOs

```bash
# De:
lib/core/database/daos/
  ├── turno_dao.dart
  ├── checklist_dao.dart
  └── ...

# Para:
lib/data/datasources/local/
  ├── turno_dao.dart
  ├── checklist_dao.dart
  └── ...
```

**Atualizar imports:**

```dart
// Antes:
import 'package:nexa_app/core/database/daos/turno_dao.dart';

// Depois:
import 'package:nexa_app/data/datasources/local/turno_dao.dart';
```

#### 3.2 Mover DTOs

```bash
# De:
lib/core/domain/dto/
  ├── turno_table_dto.dart
  ├── checklist_modelo_dto.dart
  └── ...

# Para:
lib/data/models/
  ├── turno_dto.dart
  ├── checklist_modelo_dto.dart
  └── ...
```

**Renomear:**

- `turno_table_dto.dart` → `turno_dto.dart`
- Manter sufixo `Dto` nas classes

#### 3.3 Mover Repositories

```bash
# De:
lib/core/domain/repositories/
  ├── turno_repo.dart
  ├── checklist_modelo_repo.dart
  └── ...

# Para:
lib/data/repositories/
  ├── turno_repository_impl.dart
  ├── checklist_repository_impl.dart
  └── ...
```

**Renomear classes:**

```dart
// Antes:
class TurnoRepo { }

// Depois:
class TurnoRepositoryImpl implements ITurnoRepository { }
```

---

### Fase 4: Criar Domain Layer (45 min)

**Objetivo:** Criar entidades puras e interfaces

#### 4.1 Criar Entities

```bash
lib/domain/entities/
├── turno.dart
├── checklist.dart
├── veiculo.dart
└── ...
```

**Exemplo:**

```dart
// domain/entities/turno.dart
class Turno {
  final int id;
  final int? remoteId;
  final DateTime horaInicio;
  final DateTime? horaFim;
  final SituacaoTurno situacao;

  const Turno({
    required this.id,
    this.remoteId,
    required this.horaInicio,
    this.horaFim,
    required this.situacao,
  });

  // Lógica de negócio
  bool get estaAberto => situacao == SituacaoTurno.aberto;

  Duration get duracao {
    final fim = horaFim ?? DateTime.now();
    return fim.difference(horaInicio);
  }

  bool get podeSerFechado {
    return estaAberto && duracao.inHours >= 1;
  }
}
```

#### 4.2 Criar Repository Interfaces

```bash
lib/domain/repositories/
├── i_turno_repository.dart
├── i_checklist_repository.dart
└── ...
```

**Exemplo:**

```dart
// domain/repositories/i_turno_repository.dart
abstract class ITurnoRepository {
  Future<Turno?> buscarTurnoAtivo();
  Future<List<Turno>> buscarTodos();
  Future<Turno> buscarPorId(int id);
  Future<void> abrirTurno(AbrirTurnoParams params);
  Future<void> fecharTurno(int turnoId);
  Future<void> adicionarServico(int turnoId, ServicoParams params);
}
```

#### 4.3 Implementar nos Repositories

```dart
// data/repositories/turno_repository_impl.dart
class TurnoRepositoryImpl implements ITurnoRepository {
  final TurnoDao _dao;
  final TurnoApi _api;

  TurnoRepositoryImpl({
    required TurnoDao dao,
    required TurnoApi api,
  })  : _dao = dao,
        _api = api;

  @override
  Future<Turno?> buscarTurnoAtivo() async {
    final dto = await _dao.buscarTurnoAtivo();
    return dto?.toEntity();
  }

  // ... outros métodos
}
```

---

### Fase 5: Migrar Presentation (1h 30min)

**Objetivo:** Reorganizar por módulos mantendo tudo junto

#### 5.1 Migrar Módulo Splash (15 min)

```bash
# De:
lib/modules/splash/
  ├── splash_controller.dart
  ├── splash_page.dart
  └── splash_binding.dart

# Para:
lib/presentation/splash/
  ├── splash_controller.dart
  ├── splash_page.dart
  └── splash_binding.dart

# Comando:
mv lib/modules/splash lib/presentation/splash
```

**Atualizar imports e testar build:**

```bash
flutter analyze
flutter run
```

#### 5.2 Migrar Módulo Login (15 min)

```bash
# De:
lib/modules/login/

# Para:
lib/presentation/login/

# Comando:
mv lib/modules/login lib/presentation/login
```

#### 5.3 Migrar Módulo Home (20 min)

```bash
# De:
lib/modules/home/

# Para:
lib/presentation/home/

# Comando:
mv lib/modules/home lib/presentation/home
```

#### 5.4 Migrar Módulo Turno (40 min)

**Este é o mais complexo!**

```bash
# De:
lib/modules/turno/
  ├── abrir/
  ├── abrindo/
  ├── checklist/
  ├── servicos/
  └── navigation/

# Para:
lib/presentation/turno/
  ├── abrir/
  │   ├── abrir_turno_controller.dart
  │   ├── abrir_turno_page.dart
  │   ├── abrir_turno_binding.dart
  │   └── models/
  ├── abrindo/
  ├── checklist/
  │   ├── veicular/
  │   ├── epc/
  │   └── epi/
  ├── servicos/
  └── navigation/

# Comando:
mv lib/modules/turno lib/presentation/turno
```

---

### Fase 6: Migrar Shared (30 min)

#### 6.1 Widgets Globais

```bash
# De:
lib/widgets/
  └── custom_searcheable_dropdown.dart

# Para:
lib/shared/widgets/
  └── custom_searcheable_dropdown.dart
```

#### 6.2 Middlewares

```bash
# De:
lib/core/middlewares/
  └── auth_middleware.dart

# Para:
lib/shared/middlewares/
  └── auth_middleware.dart
```

#### 6.3 Bindings Globais

```bash
# De:
lib/core/core_app/bindings/
  └── initial_binding.dart

# Para:
lib/shared/bindings/
  └── initial_binding.dart
```

---

### Fase 7: Migrar App Config (20 min)

#### 7.1 Criar app/

```bash
# Mover:
lib/app.dart → lib/app/app.dart
lib/main.dart → lib/main.dart (mantém na raiz)

# Mover rotas:
lib/routes/ → lib/app/routes/
```

#### 7.2 Atualizar main.dart

```dart
// Antes:
import 'package:nexa_app/app.dart';
import 'package:nexa_app/routes/app_pages.dart';

// Depois:
import 'package:nexa_app/app/app.dart';
import 'package:nexa_app/app/routes/app_pages.dart';
```

---

### Fase 8: Atualizar Imports (Automático - 30 min)

Use ferramentas para atualizar imports automaticamente:

#### Opção 1: Find & Replace no IDE

```bash
Buscar: package:nexa_app/core/core_app/
Substituir: package:nexa_app/core/security/

Buscar: package:nexa_app/modules/
Substituir: package:nexa_app/presentation/

Buscar: package:nexa_app/core/domain/repositories/
Substituir: package:nexa_app/data/repositories/

Buscar: package:nexa_app/core/domain/dto/
Substituir: package:nexa_app/data/models/
```

#### Opção 2: Script Bash

```bash
#!/bin/bash
# scripts/update_imports.sh

# Atualizar imports de modules para presentation
find lib -name "*.dart" -exec sed -i '' 's|package:nexa_app/modules/|package:nexa_app/presentation/|g' {} \;

# Atualizar imports de repositories
find lib -name "*.dart" -exec sed -i '' 's|package:nexa_app/core/domain/repositories/|package:nexa_app/data/repositories/|g' {} \;

# Atualizar imports de DTOs
find lib -name "*.dart" -exec sed -i '' 's|package:nexa_app/core/domain/dto/|package:nexa_app/data/models/|g' {} \;

echo "✅ Imports atualizados!"
```

---

### Fase 9: Validação e Testes (30 min)

#### 9.1 Verificar Build

```bash
# Limpar cache
flutter clean

# Baixar dependências
flutter pub get

# Analisar código
flutter analyze

# Tentar build
flutter build apk --debug
```

#### 9.2 Executar Testes

```bash
# Rodar todos os testes
flutter test

# Verificar coverage
flutter test --coverage
```

#### 9.3 Testar App

1. ✅ Login
2. ✅ Home
3. ✅ Abrir Turno
4. ✅ Checklists (Veicular, EPC, EPI)
5. ✅ Serviços
6. ✅ Navegação completa

---

## 🚨 Problemas Comuns e Soluções

### Problema 1: Imports Circulares

**Sintoma:**

```bash
Error: Import of 'file1.dart' creates a circular dependency.
```

**Solução:**

- Extrair código comum para um terceiro arquivo
- Revisar arquitetura de dependências
- Usar interfaces ao invés de implementações

### Problema 2: Get.find() Não Encontra Dependência

**Sintoma:**

```bash
[GET] Instance "SomeClass" is not registered.
```

**Solução:**

```dart
// Verificar se está registrado no binding
class SomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SomeClass());  // ✅ Registrar aqui
  }
}
```

### Problema 3: Build Quebrado Após Mover Arquivos

**Sintoma:**

```bash
Error: Could not resolve the package 'nexa_app' in 'package:nexa_app/old/path.dart'.
```

**Solução:**

```bash
# 1. Limpar build
flutter clean

# 2. Deletar gerado
rm -rf build/
rm -rf .dart_tool/

# 3. Reinstalar
flutter pub get

# 4. Regenerar código (Drift)
dart run build_runner build --delete-conflicting-outputs
```

---

## 📋 Checklist de Migração

### Antes de Começar

- [ ] Branch criada (`refactor/nova-arquitetura`)
- [ ] Backup do código atual
- [ ] Build funcionando
- [ ] Testes passando
- [ ] Commit de tudo pendente

### Durante Migração

#### Módulo por Módulo

**Splash:**

- [ ] Estrutura criada
- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit

**Login:**

- [ ] Estrutura criada
- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit

**Home:**

- [ ] Estrutura criada
- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit

**Turno:**

- [ ] Estrutura criada
- [ ] Submodulos organizados (abrir, checklist, servicos)
- [ ] Arquivos movidos
- [ ] Imports atualizados
- [ ] Build OK
- [ ] Commit

### Depois da Migração

- [ ] `flutter analyze` sem erros
- [ ] `flutter test` passando
- [ ] App executando sem crashes
- [ ] Todas as features testadas manualmente
- [ ] Documentação atualizada
- [ ] PR criado para review

---

## 🎯 Ordem Recomendada de Migração

### 1º - Core (Fundação)

- Network
- Security
- Utils

### 2º - Data (Acesso a Dados)

- DAOs → `data/datasources/local/`
- DTOs → `data/models/`
- Repositories → `data/repositories/`

### 3º - Domain (Lógica de Negócio)

- Criar entities
- Criar interfaces de repositories
- (Opcional) Criar usecases

### 4º - Presentation (Módulos Pequenos Primeiro)

1. Splash (mais simples)
2. Login
3. Home
4. Turno (mais complexo)

### 5º - Shared (Recursos Globais)

- Widgets
- Middlewares
- Bindings

### 6º - App (Configuração)

- Routes
- App widget

---

## 📝 Scripts Úteis

### Script de Migração Automática

```bash
#!/bin/bash
# scripts/migrate.sh

echo "🚀 Iniciando migração..."

# 1. Criar estrutura
echo "📁 Criando estrutura de pastas..."
mkdir -p lib/app/routes
mkdir -p lib/core/network
mkdir -p lib/core/security
mkdir -p lib/data/{datasources/{local,remote},models,repositories}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/presentation
mkdir -p lib/shared/{widgets,middlewares,bindings}

echo "✅ Estrutura criada!"

# 2. Mover core/network
echo "📦 Movendo network..."
if [ -d "lib/core/utils/network" ]; then
  mv lib/core/utils/network/* lib/core/network/
  rm -rf lib/core/utils/network
fi

# 3. Mover core/security
echo "🔐 Movendo security..."
if [ -d "lib/core/core_app/session" ]; then
  mv lib/core/core_app/session/* lib/core/security/
fi

# 4. Mover DAOs
echo "💾 Movendo DAOs..."
if [ -d "lib/core/database/daos" ]; then
  mv lib/core/database/daos/* lib/data/datasources/local/
  rm -rf lib/core/database/daos
fi

# 5. Mover DTOs
echo "📋 Movendo DTOs..."
if [ -d "lib/core/domain/dto" ]; then
  mv lib/core/domain/dto/* lib/data/models/
  rm -rf lib/core/domain/dto
fi

# 6. Mover Repositories
echo "📚 Movendo Repositories..."
if [ -d "lib/core/domain/repositories" ]; then
  mv lib/core/domain/repositories/* lib/data/repositories/
  rm -rf lib/core/domain/repositories
fi

# 7. Mover Modules → Presentation
echo "🎨 Movendo Modules..."
if [ -d "lib/modules" ]; then
  mv lib/modules/* lib/presentation/
  rm -rf lib/modules
fi

# 8. Mover Widgets → Shared
echo "🧩 Movendo Widgets..."
if [ -d "lib/widgets" ]; then
  mv lib/widgets/* lib/shared/widgets/
  rm -rf lib/widgets
fi

# 9. Mover Middlewares → Shared
echo "🛡️ Movendo Middlewares..."
if [ -d "lib/core/middlewares" ]; then
  mv lib/core/middlewares/* lib/shared/middlewares/
  rm -rf lib/core/middlewares
fi

# 10. Mover Routes → App
echo "🗺️ Movendo Routes..."
if [ -d "lib/routes" ]; then
  mv lib/routes lib/app/routes
fi

# 11. Mover app.dart
echo "📱 Movendo app.dart..."
if [ -f "lib/app.dart" ]; then
  mkdir -p lib/app
  mv lib/app.dart lib/app/app.dart
fi

echo "✅ Migração de arquivos completa!"
echo "⚠️ PRÓXIMO PASSO: Atualizar imports!"
```

### Script de Atualização de Imports

```bash
#!/bin/bash
# scripts/update_imports.sh

echo "🔄 Atualizando imports..."

# Modules → Presentation
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/modules/|nexa_app/presentation/|g' {} \;

# Core (network)
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/utils/network/|nexa_app/core/network/|g' {} \;

# Core (security)
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/core_app/session/|nexa_app/core/security/|g' {} \;

# DAOs
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/database/daos/|nexa_app/data/datasources/local/|g' {} \;

# DTOs
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/domain/dto/|nexa_app/data/models/|g' {} \;

# Repositories
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/domain/repositories/|nexa_app/data/repositories/|g' {} \;

# Widgets
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/widgets/|nexa_app/shared/widgets/|g' {} \;

# Middlewares
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/core/middlewares/|nexa_app/shared/middlewares/|g' {} \;

# Routes
find lib -name "*.dart" -exec sed -i '' 's|nexa_app/routes/|nexa_app/app/routes/|g' {} \;

# App
find lib -name "*.dart" -exec sed -i '' 's|import '\''package:nexa_app/app.dart|import '\''package:nexa_app/app/app.dart|g' {} \;

echo "✅ Imports atualizados!"
echo "🧪 Execute: flutter analyze"
```

---

## ⏱️ Timeline Estimado

| Fase | Descrição    | Tempo    | Acumulado |
| ---- | ------------ | -------- | --------- |
| 1    | Preparação   | 30 min   | 30 min    |
| 2    | Core         | 45 min   | 1h 15min  |
| 3    | Data Layer   | 1h       | 2h 15min  |
| 4    | Domain Layer | 45 min   | 3h        |
| 5    | Presentation | 1h 30min | 4h 30min  |
| 6    | Shared       | 30 min   | 5h        |
| 7    | App Config   | 20 min   | 5h 20min  |
| 8    | Imports      | 30 min   | 5h 50min  |
| 9    | Validação    | 30 min   | 6h 20min  |

**Total:** ~6 horas (pode ser dividido em 2-3 sessões)

---

## 🎯 Estratégia de Execução

### Opção A: Big Bang (NÃO Recomendado)

- Migrar tudo de uma vez
- Build quebrado por horas
- Difícil reverter

### Opção B: Incremental (✅ RECOMENDADO)

- Migrar módulo por módulo
- Build sempre funcionando
- Commits pequenos
- Fácil reverter

### Opção C: Feature Flag (Avançado)

- Código novo segue nova estrutura
- Código antigo mantém estrutura atual
- Migração gradual ao tocar no código

---

## ✅ Critérios de Sucesso

A migração está completa quando:

- [ ] ✅ Estrutura de pastas segue novo padrão
- [ ] ✅ `flutter analyze` sem erros
- [ ] ✅ `flutter test` passando
- [ ] ✅ App executa sem crashes
- [ ] ✅ Todas as features funcionando
- [ ] ✅ Performance mantida ou melhorada
- [ ] ✅ Documentação atualizada
- [ ] ✅ Time familiarizado com nova estrutura

---

## 📚 Próximos Passos (Após Migração)

1. **Code Review**

   - Revisar PRs de migração
   - Validar padrões aplicados
   - Aprovar merge

2. **Documentação**

   - Atualizar README
   - Criar tutoriais internos
   - Documentar decisões técnicas

3. **Treinamento**

   - Apresentar nova estrutura para o time
   - Pair programming com novos desenvolvedores
   - Criar guia de onboarding

4. **Melhorias Contínuas**
   - Implementar UseCases onde fizer sentido
   - Aumentar cobertura de testes
   - Adicionar CI/CD checks

---

**Mantido por:** Equipe Nexa  
**Última atualização:** Outubro 2025
