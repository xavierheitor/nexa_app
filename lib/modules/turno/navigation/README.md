# 🧭 Sistema Inteligente de Navegação de Turnos

## 📋 Visão Geral

Este módulo implementa um **sistema inteligente de navegação** para o fluxo de turnos, eliminando navegações desnecessárias e proporcionando uma experiência fluida ao usuário.

### ✅ Problemas Resolvidos

- ❌ **Antes**: Múltiplas telas sendo abertas para verificar checklists
- ❌ **Antes**: Usuário via flashes de telas durante verificações
- ❌ **Antes**: Lógica de navegação espalhada por vários controllers

- ✅ **Agora**: Uma única tela de loading durante análise
- ✅ **Agora**: Navegação direta para a tela correta
- ✅ **Agora**: Lógica centralizada e fácil de manter

---

## 🏗️ Arquitetura

### **Padrões Utilizados**

1. **Orchestrator Pattern** - Centraliza decisões complexas
2. **State Machine** - Estados bem definidos do fluxo
3. **Loading Screen Pattern** - Feedback visual durante processamento

### **Componentes**

```
lib/modules/turno/navigation/
├── turno_navigation_state.dart          # Estados e enums
├── turno_navigation_orchestrator.dart   # Lógica de decisão
├── turno_navigation_loading_page.dart   # UI de loading
├── turno_navigation_loading_controller.dart  # Controller da UI
├── turno_navigation_loading_binding.dart     # Injeção de dependências
└── README.md                            # Esta documentação
```

---

## 🔄 Fluxo de Navegação

### **Diagrama de Estados**

```
┌─────────────┐
│    HOME     │
│  (Clica em  │
│   Turno)    │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  LOADING PAGE   │
│  Verifica       │
│  estado...      │
└──────┬──────────┘
       │
       ├───► [NÃO EXISTE] ──────► ABRIR TURNO
       │
       ├───► [FECHADO] ──────────► ABRIR TURNO
       │
       ├───► [EM ABERTURA] ────┬─► Veicular pendente? → CHECKLIST VEICULAR
       │                       ├─► EPC pendente? → CHECKLIST EPC
       │                       ├─► EPI pendente? → LISTA ELETRICISTAS
       │                       └─► Todos OK? → ABRIR REMOTO
       │
       └───► [ABERTO] ───────────► SERVIÇOS
```

### **Decisões do Orchestrator**

```dart
1. Busca turno ativo no banco
   ↓
2. Verifica situação do turno
   ├─ Não existe → Rota: /turno/abrir
   ├─ Fechado → Rota: /turno/abrir
   ├─ Aberto → Rota: /turno/servicos
   └─ Em Abertura:
      ↓
      3. Verifica checklists em ordem:
         ├─ Veicular não preenchido? → Rota: /turno/checklist
         ├─ EPC não preenchido? → Rota: /turno/checklist/epc
         ├─ EPI pendente? → Rota: /turno/checklist/eletricistas
         └─ Todos OK → Rota: /turno/checklist/eletricistas (com flag)
```

---

## 💻 Como Usar

### **1. Navegação Simples (Recomendado)**

```dart
// No seu controller ou página
Get.toNamed(Routes.turnoNavigationLoading);

// Isso é tudo! O sistema decide automaticamente para onde ir.
```

### **2. Verificação de Estado (Sem Navegação)**

```dart
final orchestrator = Get.find<TurnoNavigationOrchestrator>();

// Apenas verifica o estado
final state = await orchestrator.verificarEstadoAtual();

// Verifica e obtém informações completas
final result = await orchestrator.determinarProximaRota();
print('Deve navegar para: ${result.route}');
print('Mensagem: ${result.message}');
```

---

## 🎯 Casos de Uso

### **Caso 1: Nenhum Turno Ativo**

```dart
// Usuário clica em "Turno" na home
Get.toNamed(Routes.turnoNavigationLoading);

// Sistema detecta: Nenhum turno
// Navega para: /turno/abrir
// Usuário vai direto para tela de abertura
```

### **Caso 2: Turno em Abertura - Checklist Pendente**

```dart
// Usuário clica em "Turno" na home
Get.toNamed(Routes.turnoNavigationLoading);

// Sistema detecta: Turno em abertura
// Verifica: Checklist veicular OK
// Verifica: Checklist EPC pendente
// Navega para: /turno/checklist/epc
// Usuário vai direto para o próximo checklist
```

### **Caso 3: Turno Aberto**

```dart
// Usuário clica em "Turno" na home
Get.toNamed(Routes.turnoNavigationLoading);

// Sistema detecta: Turno aberto
// Navega para: /turno/servicos
// Usuário vai direto para lista de serviços
```

---

## 🔧 Extensibilidade

### **Adicionar Novo Estado**

1. Adicione o enum em `turno_navigation_state.dart`:

```dart
enum TurnoNavigationState {
  // ... estados existentes
  novoEstado, // Adicione aqui
}
```

2. Implemente a lógica em `turno_navigation_orchestrator.dart`:

```dart
// Adicione no método determinarProximaRota()
if (condicao) {
  return TurnoNavigationResult(
    state: TurnoNavigationState.novoEstado,
    route: Routes.novaRota,
    message: 'Mensagem descritiva',
  );
}
```

### **Adicionar Nova Verificação**

```dart
// No método _verificarChecklistsPendentes()

// 4. Verificar Novo Checklist
final novoChecklistCompleto = await _verificarNovoChecklist();
if (!novoChecklistCompleto) {
  return TurnoNavigationResult(
    state: TurnoNavigationState.aguardandoNovoChecklist,
    route: Routes.novoChecklist,
    message: 'Novo checklist pendente.',
  );
}
```

---

## 🧪 Testabilidade

### **Exemplo de Teste Unitário**

```dart
test('Deve navegar para abrir turno quando não há turno ativo', () async {
  // Arrange
  when(mockTurnoRepo.buscarTurnoAtivo()).thenAnswer((_) async => null);
  
  final orchestrator = TurnoNavigationOrchestrator(
    turnoRepo: mockTurnoRepo,
    checklistService: mockChecklistService,
  );
  
  // Act
  final result = await orchestrator.determinarProximaRota();
  
  // Assert
  expect(result.state, TurnoNavigationState.naoExiste);
  expect(result.route, Routes.turnoAbrir);
});
```

---

## 📊 Performance

- **Verificações**: Otimizadas com early return
- **Caching**: Não mantém cache (sempre busca dados frescos)
- **Loading**: Mínimo de 800ms para evitar flash
- **Async**: Todas as verificações são assíncronas e não bloqueantes

---

## 🐛 Tratamento de Erros

```dart
// Todos os erros são capturados e retornados como TurnoNavigationResult
if (erro) {
  return TurnoNavigationResult.erro('Mensagem amigável');
}

// A tela de loading mostra UI de erro com botão de retry
```

---

## 📝 Logs e Debugging

O sistema usa logging extensivo com a tag `TurnoNavigationOrchestrator`:

```dart
AppLogger.d('🧭 [NAV] Iniciando determinação de rota');
AppLogger.d('🧭 [NAV] Turno encontrado: ID=1, Situação=emAbertura');
AppLogger.d('✅ [NAV] Checklist Veicular OK');
AppLogger.d('🧭 [NAV] Checklist EPC pendente → Rota: CHECKLIST EPC');
```

---

## 🚀 Próximos Passos

- [ ] Adicionar cache inteligente (com TTL)
- [ ] Implementar analytics de navegação
- [ ] Adicionar testes de integração
- [ ] Otimizar verificações paralelas
- [ ] Adicionar preload de próximas telas

---

## 👥 Manutenção

**Responsável**: Time de Desenvolvimento  
**Última Atualização**: 15/10/2025  
**Versão**: 1.0.0

Para dúvidas ou sugestões, consulte a documentação do projeto ou abra uma issue.

