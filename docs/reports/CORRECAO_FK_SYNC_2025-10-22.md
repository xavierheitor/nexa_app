# 🔧 Correção Crítica: Foreign Key Durante Sincronização

**Data**: 22/10/2025  
**Tipo**: Bug Crítico  
**Severidade**: ALTA  
**Status**: ✅ CORRIGIDO

---

## 🚨 PROBLEMA

### Erro Encontrado
```
SqliteException(1811): FOREIGN KEY constraint failed
DELETE FROM "veiculo_table";
```

### Causa Raiz
Durante a sincronização, os repositories estavam fazendo:
```dart
await veiculoDao.deletarTodos();  // ❌ ERRO!
for (final veiculo in itens) {
  await veiculoDao.inserirOuAtualizar(veiculo.toCompanion());
}
```

**Problema**: `turno_table` tem FK para `veiculo_table(id)` com `ON DELETE RESTRICT`.  
Quando há turnos locais que referenciam veículos, o `deletarTodos()` falha!

---

## 🔍 ANÁLISE

### Tabelas com Foreign Keys

**Tabelas que SÃO REFERENCIADAS** (não podem ter deletarTodos):
1. ❌ `veiculo_table` → referenciada por `turno_table.veiculoId`
2. ❌ `equipe_table` → referenciada por `turno_table.equipeId`
3. ❌ `tipo_veiculo_table` → referenciada por `veiculo_table.tipoVeiculoId`
4. ❌ `tipo_equipe_table` → referenciada por `equipe_table.tipoEquipeId`

**Tabelas que PODEM ter deletarTodos** (não são referenciadas por FK local):
1. ✅ `eletricista_table` → turnos usam `eletricistaId` REMOTO (sem FK)
2. ✅ `checklist_modelo_table` → sem FKs locais
3. ✅ `checklist_pergunta_table` → sem FKs locais
4. ✅ `checklist_opcao_resposta_table` → sem FKs locais
5. ✅ Tabelas de relação → sem FKs locais

---

## ✅ SOLUÇÃO APLICADA

### Repositórios Corrigidos

**1. VeiculoRepo** ✅
```dart
Future<void> sincronizarComBanco(List<VeiculoTableDto> itens) async {
  await db.transaction(() async {
    // ⚠️ NÃO deleta tudo porque turno_table tem FK para veiculo_table
    // Usa apenas UPSERT para sincronizar
    for (final veiculo in itens) {
      await veiculoDao.inserirOuAtualizar(veiculo.toCompanion());
    }
  });
}
```

**2. TipoVeiculoRepo** ✅
```dart
Future<void> sincronizarComBanco(List<TipoVeiculoTableDto> itens) async {
  await db.transaction(() async {
    // ⚠️ NÃO deleta tudo porque veiculo_table tem FK para tipo_veiculo_table
    // Usa apenas UPSERT para sincronizar
    for (final tipoVeiculo in itens) {
      await tipoVeiculoDao.inserirOuAtualizar(tipoVeiculo.toCompanion());
    }
  });
}
```

**3. EquipeRepo** ✅
```dart
Future<void> sincronizarComBanco(List<EquipeTableDto> dtos) async {
  // ⚠️ NÃO deleta tudo porque turno_table tem FK para equipe_table
  // Usa apenas UPSERT para sincronizar
  for (final equipe in dtos) {
    await _dao.inserirOuAtualizar(equipe.toCompanion());
  }
}
```

**4. TipoEquipeRepo** ✅
```dart
Future<void> sincronizarComBanco(List<TipoEquipeTableDto> dtos) async {
  // ⚠️ NÃO deleta tudo porque equipe_table tem FK para tipo_equipe_table
  // Usa apenas UPSERT para sincronizar
  for (final tipoEquipe in dtos) {
    await _dao.inserirOuAtualizar(tipoEquipe.toCompanion());
  }
}
```

### Repositórios Mantidos (Podem Deletar)

**Eletricista** e outros sem FKs locais:
```dart
// ✅ OK - Nenhuma tabela tem FK para eletricista_table
await eletricistaDao.deletarTodos();
for (final eletricista in itens) {
  await eletricistaDao.inserirOuAtualizar(eletricista.toCompanion());
}
```

---

## 🎯 ESTRATÉGIA DE SINCRONIZAÇÃO

### Regra Geral

**Se a tabela É REFERENCIADA por FK local** → Usar apenas UPSERT:
```dart
// ❌ NÃO FAZER
await dao.deletarTodos();

// ✅ FAZER
for (final item in itens) {
  await dao.inserirOuAtualizar(item);
}
```

**Se a tabela NÃO é referenciada** → Pode usar deletarTodos + inserir:
```dart
// ✅ OK
await dao.deletarTodos();
for (final item in itens) {
  await dao.inserirOuAtualizar(item);
}
```

---

## 📊 RESUMO DAS CORREÇÕES

| Repository | Antes | Depois | Motivo |
|-----------|-------|--------|--------|
| VeiculoRepo | deletarTodos() | UPSERT apenas | FK de turno_table |
| EquipeRepo | deletarTodos() | UPSERT apenas | FK de turno_table |
| TipoVeiculoRepo | deletarTodos() | UPSERT apenas | FK de veiculo_table |
| TipoEquipeRepo | deletarTodos() | UPSERT apenas | FK de equipe_table |
| EletricistaRepo | deletarTodos() ✅ | deletarTodos() ✅ | Sem FKs locais |
| Outros | deletarTodos() ✅ | deletarTodos() ✅ | Sem FKs locais |

---

## ✅ VALIDAÇÃO

```bash
$ flutter analyze --no-pub
Result: No issues found! (ran in 1.8s)
```

**Status**: 🟢 Correção aplicada com sucesso!

---

## 💡 LIÇÃO APRENDIDA

### Problema
Ao implementar FKs, criamos constraints que impedem `DELETE` sem primeiro remover dados dependentes.

### Solução
Para tabelas sincronizadas que são referenciadas por FKs:
- **NÃO usar** `deletarTodos() + inserir()`
- **USAR** apenas `inserirOuAtualizar()` (UPSERT)

### Benefício
- ✅ Sincronização funciona mesmo com dados locais
- ✅ Preserva referências existentes
- ✅ Atualiza dados modificados
- ✅ Insere novos dados
- ✅ Mantém integridade referencial

---

*Correção aplicada em 22/10/2025*

