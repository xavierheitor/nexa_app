# 🚀 Roadmap Profissional - Launch em 2 Semanas

**Data Início**: 21/10/2025  
**Data Fim**: 04/11/2025 (14 dias)  
**Objetivo**: Launch em produção com qualidade enterprise  
**Status**: 📋 **PLANEJAMENTO**

---

## 📅 Visão Geral

```bash
SEMANA 1: Arquitetura + DRY (5 dias)
├─ Dia 1: BaseDao + SyncableDao
├─ Dia 2: Refatorar 17 DAOs
├─ Dia 3: LoggingMixin + Repositories
├─ Dia 4: ConnectivityService
└─ Dia 5: CacheManager + Validação

SEMANA 2: Testes + Qualidade (5 dias)
├─ Dia 6-7: Testes Core (Auth + Session)
├─ Dia 8-9: Testes Repositories + Controllers
├─ Dia 10: Retry Strategy + Polish
└─ BUFFER: 2 dias para ajustes
```

---

## 🎯 Objetivos Quantificáveis

| Métrica                 | Atual   | Meta    | Ganho      |
| ----------------------- | ------- | ------- | ---------- |
| **Linhas de código**    | 15.000  | 10.600  | -30%       |
| **Código duplicado**    | 29%     | 0%      | -100%      |
| **Cobertura de testes** | 0%      | 30%     | +30%       |
| **Queries com cache**   | 0%      | 80%     | +80%       |
| **UX offline**          | ❌      | ✅      | +100%      |
| **Retry automático**    | ❌      | ✅      | +100%      |
| **Flutter analyze**     | 0 erros | 0 erros | ✅ Mantido |

---

## 📆 SEMANA 1: Arquitetura + DRY

### 📅 Dia 1 (Seg): BaseDao + SyncableDao

**Tempo**: 6 horas  
**Objetivo**: Criar classes base para eliminar duplicação em DAOs

#### Tarefas

- [ ] **Task 1.1**: Criar `base_dao.dart` (1.5h)

  - Métodos genéricos: listar, buscarPorId, inserir, atualizar, deletar
  - Documentação completa
  - Testes unitários do BaseDao

- [ ] **Task 1.2**: Criar `syncable_dao.dart` (1.5h)

  - Herda BaseDao
  - Adiciona: buscarPorRemoteId, inserirOuAtualizar, sincronizar
  - Testes unitários

- [ ] **Task 1.3**: POC com VeiculoDao (1.5h)

  - Refatorar VeiculoDao usando SyncableDao
  - Validar todas as queries
  - Garantir 100% compatibilidade

- [ ] **Task 1.4**: POC com EquipeDao (1.5h)
  - Refatorar EquipeDao
  - Validar padrão
  - Documentar processo

**Entregáveis**:

- ✅ `lib/core/database/base_dao.dart`
- ✅ `lib/core/database/syncable_dao.dart`
- ✅ `test/core/database/base_dao_test.dart`
- ✅ 2 DAOs refatorados como POC

**Validação**: flutter test + flutter analyze

---

### 📅 Dia 2 (Ter): Refatorar Todos os DAOs

**Tempo**: 8 horas  
**Objetivo**: Aplicar BaseDao/SyncableDao nos 15 DAOs restantes

#### Tarefas

- [ ] **Task 2.1**: DAOs Syncable (4h)

  - Refatorar: tipo_veiculo, eletricista, turno
  - Refatorar: checklist_modelo, checklist_pergunta, checklist_opcao_resposta
  - Testar queries de cada um

- [ ] **Task 2.2**: DAOs de Relação (2h)

  - Refatorar: turno_eletricistas
  - Refatorar: checklist_preenchido, checklist_resposta
  - Refatorar: 4 tabelas de relação de checklist

- [ ] **Task 2.3**: DAOs Especiais (1h)

  - Refatorar: usuario_dao (não é syncable)
  - Validar métodos específicos

- [ ] **Task 2.4**: Validação Completa (1h)
  - Testar TODAS as queries críticas
  - Validar sincronização
  - Executar flutter analyze

**Entregáveis**:

- ✅ 17 DAOs refatorados
- ✅ -1.360 linhas de código duplicado
- ✅ Queries 100% funcionais

**Validação**: Testar abertura de turno completa

---

### 📅 Dia 3 (Qua): LoggingMixin + Repositories

**Tempo**: 8 horas  
**Objetivo**: Eliminar duplicação de error handling

#### Tarefas

- [ ] **Task 3.1**: Criar LoggingMixin (1.5h)

  - `lib/core/mixins/logging_mixin.dart`
  - Método executeWithLogging()
  - Testes unitários

- [ ] **Task 3.2**: POC com TurnoRepo (1.5h)

  - Aplicar LoggingMixin
  - Refatorar ~20 métodos
  - Validar logs

- [ ] **Task 3.3**: Refatorar Repositories Críticos (3h)

  - VeiculoRepo, EquipeRepo, EletricistaRepo
  - UsuarioRepo, ChecklistModeloRepo
  - Validar comportamento

- [ ] **Task 3.4**: Refatorar Repositories Restantes (2h)
  - 11 repositories restantes
  - Aplicar padrão
  - Testes de integração

**Entregáveis**:

- ✅ `lib/core/mixins/logging_mixin.dart`
- ✅ 16 repositories refatorados
- ✅ -3.000 linhas de código duplicado
- ✅ Logs 100% consistentes

**Validação**: Verificar logs durante abertura de turno

---

### 📅 Dia 4 (Qui): ConnectivityService

**Tempo**: 6 horas  
**Objetivo**: Feedback offline + Validação de conectividade

#### Tarefas

- [ ] **Task 4.1**: Criar ConnectivityService (2h)

  - `lib/core/network/connectivity_service.dart`
  - Detector de conectividade (connectivity_plus)
  - Observable isOnline
  - Banner automático quando ficar offline

- [ ] **Task 4.2**: Integrar com Interceptors (1.5h)

  - Verificar conectividade antes de requests
  - Falhar rápido se offline (sem timeout)
  - Logs de estado de conexão

- [ ] **Task 4.3**: Integrar com SyncService (1h)

  - Verificar online antes de sincronizar
  - Queue de operações offline (opcional)
  - Retry ao voltar online

- [ ] **Task 4.4**: UI de Feedback (1.5h)
  - Banner "Você está offline" persistente
  - Ícone de conectividade na AppBar
  - Testes de UX

**Entregáveis**:

- ✅ `lib/core/network/connectivity_service.dart`
- ✅ Banner offline automático
- ✅ Feedback imediato (sem timeout de 30s)
- ✅ UX profissional

**Validação**: Testar app em modo avião

---

### 📅 Dia 5 (Sex): CacheManager + Validação Semana 1

**Tempo**: 8 horas  
**Objetivo**: Sistema de cache + Validação completa

#### Tarefas

- [ ] **Task 5.1**: Criar CacheManager (2h)

  - `lib/core/cache/cache_manager.dart`
  - Cache com TTL configurável
  - Invalidação manual e automática
  - Testes unitários

- [ ] **Task 5.2**: Integrar com Repositories (2h)

  - Cache em VeiculoRepo, EquipeRepo, EletricistaRepo
  - Cache em ChecklistModeloRepo
  - TTL de 10 minutos para dados estáticos
  - Invalidação ao sincronizar

- [ ] **Task 5.3**: Otimização de Queries (2h)

  - Identificar queries mais chamadas
  - Adicionar cache estratégico
  - Medir impacto de performance

- [ ] **Task 5.4**: Validação Completa Semana 1 (2h)
  - Flutter analyze (0 erros)
  - Testar fluxo completo de abertura de turno
  - Testar sincronização
  - Validar logs
  - Code review interno

**Entregáveis**:

- ✅ `lib/core/cache/cache_manager.dart`
- ✅ Cache em 4+ repositories
- ✅ Performance melhorada
- ✅ Semana 1 validada

**Resultado Semana 1**:

- -4.360 linhas de código duplicado (-30%)
- UX offline profissional
- Cache implementado
- 0 erros

---

## 📆 SEMANA 2: Testes + Qualidade

### 📅 Dia 6 (Seg): Testes - Core (Auth + Session)

**Tempo**: 8 horas  
**Objetivo**: Testes do código mais crítico do app

#### Tarefas

- [ ] **Task 6.1**: Setup de Testes (1h)

  - Configurar mockito, test
  - Criar helpers de teste
  - Estrutura de pastas

- [ ] **Task 6.2**: AuthInterceptor Tests (3h)

  - Test: Token refresh automático (401)
  - Test: Retry após refresh
  - Test: Logout após max tentativas
  - Test: Concurrent requests durante refresh
  - Cobertura: 90%+

- [ ] **Task 6.3**: SessionManager Tests (2h)

  - Test: Login e save tokens
  - Test: Logout limpa tokens
  - Test: Token getter assíncrono
  - Test: Token sync (deprecated)
  - Cobertura: 85%+

- [ ] **Task 6.4**: TokenStorageService Tests (2h)
  - Test: Save/get access token
  - Test: Save/get refresh token
  - Test: Clear all
  - Test: Null handling
  - Cobertura: 95%+

**Entregáveis**:

- ✅ `test/core/network/interceptors/auth_interceptor_test.dart`
- ✅ `test/core/security/session_manager_test.dart`
- ✅ `test/core/security/token_storage_service_test.dart`
- ✅ Cobertura: ~10%

**Validação**: flutter test --coverage

---

### 📅 Dia 7 (Ter): Testes - Repositories

**Tempo**: 8 horas  
**Objetivo**: Testes dos repositories críticos

#### Tarefas

- [ ] **Task 7.1**: TurnoRepo Tests (3h)

  - Test: abrirTurno() salva corretamente
  - Test: buscarTurnoAtivo() retorna turno correto
  - Test: adicionarEletricistasAoTurno()
  - Test: enviarAberturaTurno() para API
  - Test: Error handling (TurnoAberturaException)
  - Cobertura: 70%+

- [ ] **Task 7.2**: VeiculoRepo Tests (2h)

  - Test: listar() com cache
  - Test: buscarPorId()
  - Test: sincronizar()
  - Cobertura: 60%+

- [ ] **Task 7.3**: ChecklistPreenchidoRepo Tests (2h)

  - Test: salvarChecklistPreenchido()
  - Test: buscarPorTurno()
  - Test: Constraints únicos
  - Cobertura: 60%+

- [ ] **Task 7.4**: BaseDao Tests (1h)
  - Validar métodos genéricos
  - Test: inserirOuAtualizar()
  - Test: sincronizar()

**Entregáveis**:

- ✅ `test/data/repositories/turno_repo_test.dart`
- ✅ `test/data/repositories/veiculo_repo_test.dart`
- ✅ `test/data/repositories/checklist_preenchido_repo_test.dart`
- ✅ `test/core/database/base_dao_test.dart`
- ✅ Cobertura: ~20%

---

### 📅 Dia 8 (Qua): Testes - Controllers

**Tempo**: 8 horas  
**Objetivo**: Testes dos controllers principais

#### Tarefas

- [ ] **Task 8.1**: TurnoController Tests (3h)

  - Test: carregarTurnoAtivo()
  - Test: determinarProximaRota() para cada situação
  - Test: Getters (hasTurnoAberto, etc)
  - Cobertura: 70%+

- [ ] **Task 8.2**: AbrirTurnoController Tests (3h)

  - Test: Validações de formulário
  - Test: iniciarTurno()
  - Test: Reactive flags (veiculoSelecionado, etc)
  - Cobertura: 60%+

- [ ] **Task 8.3**: HomeController Tests (2h)
  - Test: Buscar nome da equipe
  - Test: Buscar placa do veículo
  - Test: Pull-to-refresh
  - Cobertura: 60%+

**Entregáveis**:

- ✅ `test/core/core_app/controllers/turno_controller_test.dart`
- ✅ `test/presentation/turno/abrir/abrir_turno_controller_test.dart`
- ✅ `test/presentation/home/home_controller_test.dart`
- ✅ Cobertura: ~28%

---

### 📅 Dia 9 (Qui): Retry Strategy + Error Recovery

**Tempo**: 6 horas  
**Objetivo**: Resiliência a falhas de rede

#### Tarefas

- [ ] **Task 9.1**: Criar RetryService (2h)

  - `lib/core/network/retry_service.dart`
  - Exponential backoff
  - Configuração de max attempts
  - Circuit breaker pattern

- [ ] **Task 9.2**: Integrar com DioClient (1.5h)

  - Retry automático em requests
  - Configuração por endpoint
  - Logs de tentativas

- [ ] **Task 9.3**: Queue de Operações Offline (2h)

  - `lib/core/sync/offline_queue.dart`
  - Armazena operações quando offline
  - Executa ao voltar online
  - Persistência no banco

- [ ] **Task 9.4**: Testes de Retry (30min)
  - Test: Retry com backoff
  - Test: Max attempts
  - Test: Circuit breaker

**Entregáveis**:

- ✅ `lib/core/network/retry_service.dart`
- ✅ `lib/core/sync/offline_queue.dart`
- ✅ Retry automático em 401, 5xx
- ✅ Queue persistente

---

### 📅 Dia 10 (Sex): Polish + Documentação + Validação Final

**Tempo**: 8 horas  
**Objetivo**: Ajustes finais e validação completa

#### Tarefas

- [ ] **Task 10.1**: Code Review Interno (2h)

  - Revisar TODOS os arquivos modificados
  - Verificar consistência
  - Checar documentação

- [ ] **Task 10.2**: Performance Profiling (2h)

  - Medir tempo de queries (com/sem cache)
  - Medir tempo de abertura de turno
  - Otimizar gargalos

- [ ] **Task 10.3**: Atualizar Documentação (2h)

  - Atualizar code_review_progress
  - Atualizar SESSAO_RESUMO
  - Criar LAUNCH_CHECKLIST.md

- [ ] **Task 10.4**: Testes E2E Manuais (2h)
  - Fluxo completo: Login → Abertura → Checklists → Serviços
  - Teste offline/online
  - Teste com dados reais
  - Validar performance

**Entregáveis**:

- ✅ Code review 100%
- ✅ Performance validada
- ✅ Documentação atualizada
- ✅ `docs/LAUNCH_CHECKLIST.md`

---

## 📊 Milestones e Entregas

### Milestone 1: Arquitetura DRY (Dia 1-3)

**Entregas**:

- ✅ BaseDao + SyncableDao
- ✅ 17 DAOs refatorados
- ✅ LoggingMixin implementado
- ✅ 16 Repositories refatorados

**Resultado**:

- -4.360 linhas de código
- 0% duplicação
- Código enterprise-grade

---

### Milestone 2: UX Profissional (Dia 4-5)

**Entregas**:

- ✅ ConnectivityService
- ✅ CacheManager
- ✅ Banner offline
- ✅ Cache em queries

**Resultado**:

- UX offline excelente
- Performance 2-3x melhor
- Economia de bateria

---

### Milestone 3: Testes (Dia 6-8)

**Entregas**:

- ✅ Testes Auth (90% cobertura)
- ✅ Testes Repositories (60% cobertura)
- ✅ Testes Controllers (60% cobertura)

**Resultado**:

- 30% cobertura total
- Bugs críticos prevenidos
- Documentação via testes

---

### Milestone 4: Resiliência (Dia 9-10)

**Entregas**:

- ✅ Retry automático
- ✅ Offline queue
- ✅ Circuit breaker
- ✅ Performance validada

**Resultado**:

- App resiliente a falhas
- UX suave mesmo com problemas de rede
- Pronto para produção

---

## 🎯 Critérios de Sucesso

### Código

- [ ] 0 erros no flutter analyze
- [ ] 0 warnings críticos
- [ ] 0% código duplicado
- [ ] 30%+ cobertura de testes
- [ ] Documentação completa

### Performance

- [ ] Queries < 10ms (com cache)
- [ ] Abertura de turno < 2s
- [ ] Sincronização < 5s
- [ ] Feedback offline < 100ms

### Qualidade

- [ ] SOLID respeitado
- [ ] DRY respeitado
- [ ] Clean Architecture mantida
- [ ] Null safety 100%
- [ ] Security 100%

---

## 📋 Checklist de Validação

### Semana 1 (Arquitetura)

- [ ] BaseDao implementado e testado
- [ ] 17 DAOs refatorados
- [ ] LoggingMixin implementado
- [ ] 16 Repositories refatorados
- [ ] ConnectivityService funcionando
- [ ] CacheManager implementado
- [ ] -4.360 linhas removidas
- [ ] 0 erros no flutter analyze
- [ ] Fluxo completo testado

### Semana 2 (Testes)

- [ ] Testes Auth: 90%+ cobertura
- [ ] Testes Repositories: 60%+ cobertura
- [ ] Testes Controllers: 60%+ cobertura
- [ ] Cobertura total: 30%+
- [ ] RetryService implementado
- [ ] Offline queue funcionando
- [ ] Performance validada
- [ ] Documentação atualizada

---

## 🚀 Arquivos que Serão Criados (15)

### Core (8 arquivos)

1. `lib/core/database/base_dao.dart`
2. `lib/core/database/syncable_dao.dart`
3. `lib/core/mixins/logging_mixin.dart`
4. `lib/core/network/connectivity_service.dart`
5. `lib/core/cache/cache_manager.dart`
6. `lib/core/network/retry_service.dart`
7. `lib/core/sync/offline_queue.dart`
8. `lib/core/sync/offline_operation.dart`

### Testes (6 arquivos base + ~20 testes)

9. `test/helpers/test_helpers.dart`
10. `test/mocks/mock_repositories.dart`
11. `test/core/database/base_dao_test.dart`
12. `test/core/network/interceptors/auth_interceptor_test.dart`
13. `test/core/security/session_manager_test.dart`
14. `test/core/security/token_storage_service_test.dart`

- ~20 arquivos de teste para repos e controllers

### Documentação (1 arquivo)

15. `docs/LAUNCH_CHECKLIST.md`

---

## 📁 Arquivos que Serão Modificados (~40)

### DAOs (17)

- Todos herdarão de BaseDao/SyncableDao
- Apenas métodos específicos mantidos
- -1.360 linhas no total

### Repositories (16)

- Todos usarão LoggingMixin
- Refatoração de error handling
- -3.000 linhas no total

### Services (5)

- SyncService: integração com connectivity
- Interceptors: retry automático
- InitialBinding: registrar novos services

### Controllers (2)

- Uso de CacheManager
- Feedback de conectividade

---

## 🎯 Riscos e Mitigações

### Risco 1: Quebrar Queries Existentes

**Probabilidade**: Média  
**Impacto**: Alto

**Mitigação**:

- POC com 2 DAOs primeiro
- Testes unitários de cada query
- Validação manual do fluxo completo

---

### Risco 2: Prazo Estourar

**Probabilidade**: Baixa  
**Impacto**: Médio

**Mitigação**:

- Buffer de 2 dias na semana 2
- Priorizar tarefas críticas
- Cortar features opcionais se necessário

---

### Risco 3: Cobertura de Testes Não Atingir 30%

**Probabilidade**: Baixa  
**Impacto**: Médio

**Mitigação**:

- Focar em código crítico (maior ROI)
- Usar test coverage report
- Priorizar Auth + Repositories + Controllers

---

## 📊 Métricas de Progresso

### Daily Tracking

| Dia | Tarefas            | Linhas Removidas | Linhas Adicionadas | Cobertura |
| --- | ------------------ | ---------------- | ------------------ | --------- |
| 1   | BaseDao POC        | -160             | +100               | 2%        |
| 2   | DAOs refatorados   | -1.360           | +50                | 5%        |
| 3   | LoggingMixin       | -3.000           | +80                | 8%        |
| 4   | Connectivity       | -50              | +200               | 10%       |
| 5   | Cache              | -100             | +150               | 12%       |
| 6   | Testes Core        | 0                | +400               | 18%       |
| 7   | Testes Repos       | 0                | +500               | 25%       |
| 8   | Testes Controllers | 0                | +400               | 32%       |
| 9   | Retry + Queue      | -200             | +300               | 33%       |
| 10  | Polish             | -50              | +100               | 34%       |

**Total Esperado**:

- Linhas removidas: **-4.920**
- Linhas adicionadas: **+2.280** (testes + infra)
- Linhas finais: **~12.360** (-17%)
- Cobertura: **34%**

---

## 🎉 Resultado Final Esperado

### Código

```
Linhas totais:        15.000 → 12.360 (-17%)
Código duplicado:     29% → 0% (-100%)
Complexidade:         Alta → Média (-30%)
Manutenibilidade:     6/10 → 9/10 (+50%)
```

### Qualidade

```
Testes:               0% → 34% (+34%)
SOLID:                70% → 95% (+25%)
DRY:                  71% → 100% (+29%)
Security:             85% → 95% (+10%)
Performance:          70% → 90% (+20%)
```

### UX

```
Feedback offline:     ❌ → ✅ (+100%)
Cache hit rate:       0% → 80% (+80%)
Retry automático:     ❌ → ✅ (+100%)
Loading states:       ✅ → ✅ (mantido)
Error messages:       ✅ → ✅ (mantido)
```

---

## 🚀 Início Imediato

### Primeira Tarefa: BaseDao

Vou começar agora criando o `BaseDao` e `SyncableDao`!

**Sequência**:

1. ✅ Criar base_dao.dart
2. ✅ Criar syncable_dao.dart
3. ✅ Criar testes
4. ✅ Refatorar VeiculoDao (POC)
5. ✅ Validar queries

**Próximos passos**: Seguir o roadmap dia a dia.

---

## 📞 Check-ins Diários

Ao final de cada dia, vou:

- ✅ Atualizar este documento
- ✅ Reportar progresso
- ✅ Ajustar plano se necessário
- ✅ Validar entregas

---

**Pronto para começar! Vamos ao Dia 1?** 🚀

**Tarefa**: Criar BaseDao + SyncableDao (6 horas)
