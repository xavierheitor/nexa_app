# Bindings - Injeção de Dependências

> **Como funciona o sistema de DI (Dependency Injection) do Nexa App**

---

## 📋 Tipos de Binding

### 1. **InitialBinding** (Global)

**Arquivo:** `initial_binding.dart`

**Quando usar:** Dependências usadas em MÚLTIPLOS módulos ou que precisam persistir

**Registra:**
- ✅ Core (AppDatabase, DioClient) - `permanent: true`
- ✅ Repositories globais (UsuarioRepo, TurnoRepo) - `fenix: true`
- ✅ Services globais (AuthService, SyncService) - `fenix: true`
- ✅ Controllers globais (SessionManager, TurnoController) - `permanent: true`

**Não registra:**
- ❌ Repositories específicos de módulo
- ❌ Controllers de telas
- ❌ Services locais

---

### 2. **Feature Bindings** (Local)

**Exemplos:**
- `lib/presentation/login/login_binding.dart`
- `lib/presentation/turno/abrir/abrir_turno_binding.dart`
- `lib/presentation/turno/checklist/veicular/checklist_binding.dart`

**Quando usar:** Dependências usadas apenas NAQUELE módulo

**Registra:**
- ✅ Repositories específicos (VeiculoRepo, EquipeRepo, etc)
- ✅ Services específicos (AbrirTurnoService, ChecklistService)
- ✅ Controllers da tela

**Ciclo de vida:** Destruído ao sair da tela (sem `fenix`)

---

## 🎯 Regras de Ouro

### Regra 1: Global vs Local

```dart
// ✅ GLOBAL (InitialBinding):
- Usado em 3+ módulos diferentes
- Precisa sobreviver entre navegações
- Estado compartilhado

// ✅ LOCAL (FeatureBinding):
- Usado apenas em 1 módulo
- Pode ser destruído ao sair da tela
- Estado local
```

### Regra 2: Permanent vs Fenix vs Simples

```dart
// permanent: true → NUNCA destroi
Get.put<Type>(instance, permanent: true);
Exemplo: AppDatabase, SessionManager

// fenix: true → Recreável se deletado
Get.lazyPut<Type>(() => instance, fenix: true);
Exemplo: AuthService, TurnoRepo

// Simples → Destroi ao sair da tela
Get.lazyPut<Type>(() => instance);
Exemplo: LoginController, VeiculoRepo
```

### Regra 3: Tipos Explícitos

```dart
// ❌ ERRADO - Tipo inferido
Get.lazyPut(() => UsuarioRepo(...));

// ✅ CORRETO - Tipo explícito
Get.lazyPut<UsuarioRepo>(() => UsuarioRepo(...));
```

### Regra 4: Evitar Get.find() Repetido

```dart
// ❌ RUIM
Get.lazyPut(() => Repo1(dio: Get.find(), db: Get.find()));
Get.lazyPut(() => Repo2(dio: Get.find(), db: Get.find()));
Get.lazyPut(() => Repo3(dio: Get.find(), db: Get.find()));

// ✅ BOM
void _registerRepositories() {
  final dio = Get.find<DioClient>();  // Uma vez!
  final db = Get.find<AppDatabase>();  // Uma vez!
  
  Get.lazyPut<Repo1>(() => Repo1(dio: dio, db: db));
  Get.lazyPut<Repo2>(() => Repo2(dio: dio, db: db));
  Get.lazyPut<Repo3>(() => Repo3(dio: dio, db: db));
}
```

---

## 📊 Mapeamento de Dependências

### Globais (InitialBinding)

| Dependência | Tipo | Usado em | Justificativa |
|-------------|------|----------|---------------|
| AppDatabase | permanent | Todo o app | Infraestrutura |
| DioClient | permanent | Todo o app | Infraestrutura |
| UsuarioRepo | fenix | Auth, Session, Login | Autenticação global |
| TurnoRepo | fenix | TurnoCtrl, Home, Turno | Estado global |
| AuthService | fenix | Login, Session | Auth global |
| SyncService | fenix | Splash, Home | Sync global |
| ErrorMessageService | permanent | Múltiplos | Estado de erro |
| SessionManager | permanent | Todo o app | Sessão do usuário |
| TurnoController | permanent | Home, Turno, Serviços | Estado do turno |

### Locais (Feature Bindings)

| Repository | Usado em | Binding | Tipo |
|------------|----------|---------|------|
| VeiculoRepo | Abrir Turno | AbrirTurnoBinding | lazyPut |
| EquipeRepo | Abrir Turno | AbrirTurnoBinding | lazyPut |
| EletricistaRepo | Abrir Turno | AbrirTurnoBinding | lazyPut |
| TipoVeiculoRepo | Abrir Turno | AbrirTurnoBinding | lazyPut |
| TipoEquipeRepo | Abrir Turno | AbrirTurnoBinding | lazyPut |
| ChecklistModeloRepo | Checklists | ChecklistBinding | lazyPut |
| ChecklistPerguntaRepo | Checklists | ChecklistBinding | lazyPut |
| ChecklistOpcaoRespostaRepo | Checklists | ChecklistBinding | lazyPut |
| ChecklistPreenchidoRepo | Checklists | ChecklistBinding | lazyPut |
| ChecklistRespostaRepo | Checklists | ChecklistBinding | lazyPut |

---

## 📝 Templates

### Template: InitialBinding (Global)

```dart
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _registerCore();
    _registerRepositories();
    _registerServices();
    _registerGlobalControllers();
  }

  void _registerCore() {
    final dio = Get.find<DioClient>();
    final db = Get.find<AppDatabase>();
    
    // Registrar dependências core
  }
  
  // ... outros métodos
}
```

### Template: Feature Binding (Local)

```dart
class [Feature]Binding extends Bindings {
  @override
  void dependencies() {
    _registerRepositories();
    _registerServices();
    _registerControllers();
  }
  
  void _registerRepositories() {
    final dio = Get.find<DioClient>();
    final db = Get.find<AppDatabase>();
    
    // Repositories específicos desta feature
    Get.lazyPut<VeiculoRepo>(
      () => VeiculoRepo(dio: dio, db: db),
    );  // SEM fenix - será deletado
  }
  
  void _registerServices() {
    // Services específicos
    Get.lazyPut<[Feature]Service>(
      () => [Feature]Service(),
    );
  }
  
  void _registerControllers() {
    // Controller da tela
    Get.lazyPut<[Feature]Controller>(
      () => [Feature]Controller(),
    );
  }
}
```

---

## 🔍 Como Decidir Onde Registrar?

### Perguntas-Chave:

**1. Quantos módulos usam esta dependência?**
- 1 módulo → Binding local
- 2+ módulos → InitialBinding

**2. Precisa sobreviver ao fechar a tela?**
- Sim → InitialBinding com `fenix: true`
- Não → Binding local sem `fenix`

**3. Mantém estado crítico global?**
- Sim → InitialBinding com `permanent: true`
- Não → Considerar `fenix` ou binding local

### Fluxograma:

```
Criar nova dependência
        ↓
    Usada em quantos módulos?
        ↓
    ┌───┴───┐
    │       │
   1-2     3+
    │       │
    ↓       ↓
  LOCAL   GLOBAL
    ↓       ↓
 Binding  Initial
  Local   Binding
    ↓       ↓
  Sem    fenix ou
 fenix   permanent
```

---

## ✅ Checklist

Ao criar nova dependência:

- [ ] Definir escopo (global ou local)
- [ ] Definir ciclo de vida (permanent/fenix/simples)
- [ ] Registrar no binding correto
- [ ] Usar tipo explícito (`Get.lazyPut<Type>`)
- [ ] Documentar dependências
- [ ] Testar se Get.find() funciona

---

**Mantenha este padrão para código limpo e organizado!** ✨

