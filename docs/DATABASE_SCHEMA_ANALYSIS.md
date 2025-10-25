# 📊 Schema do Banco de Dados - Nexa App

> **Guia de referência do schema Drift**  
> **Última atualização:** Outubro 2025

---

## 🔍 Conceitos Importantes

### ID Local vs Remote ID

```bash
┌──────────────────────────────────────────────────┐
│  ID LOCAL (id)                                    │
│  • Autoincrement do SQLite                        │
│  • Usado para FKs internas                        │
│  • Único no dispositivo                           │
└──────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│  REMOTE ID (remote_id)                            │
│  • ID do servidor/API                             │
│  • Usado para sincronização                       │
│  • Pode ser null se não sincronizado              │
└──────────────────────────────────────────────────┘
```

**REGRA DE OURO**:

- ✅ **Foreign Keys** sempre referenciam **ID LOCAL** (`id`)
- ❌ **Nunca** criar FK para `remote_id`
- ✅ Use `remote_id` apenas para sincronização com API

---

## 📋 Principais Tabelas

### Turno e Relacionados

| Tabela                    | Descrição             | FKs Principais               |
| ------------------------- | --------------------- | ---------------------------- |
| `turno_table`             | Turnos de trabalho    | `veiculo_id`, `equipe_id`    |
| `turno_eletricista_table` | Eletricistas no turno | `turno_id`, `eletricista_id` |
| `veiculo_table`           | Veículos              | `tipo_veiculo_id`            |
| `equipe_table`            | Equipes               | `tipo_equipe_id`             |
| `eletricista_table`       | Eletricistas          | -                            |

### Checklist

| Tabela                             | Descrição                 | FKs Principais                             |
| ---------------------------------- | ------------------------- | ------------------------------------------ |
| `checklist_modelo_table`           | Modelos de checklist      | -                                          |
| `checklist_pergunta_table`         | Perguntas                 | -                                          |
| `checklist_pergunta_relacao_table` | Relação modelo ↔ pergunta | `checklistModeloId`, `checklistPerguntaId` |
| `checklist_opcao_resposta_table`   | Opções de resposta        | -                                          |
| `checklist_preenchido_table`       | Checklist preenchido      | `turno_id`                                 |
| `checklist_resposta_table`         | Respostas                 | `checklist_preenchido_id`                  |

> ⚠️ **Nota**: `checklist_preenchido_table` armazena `checklistModeloId` como **remote ID** (sem FK), e `eletricistaRemoteId` também como **remote ID**.

### Autenticação

| Tabela          | Descrição | FKs Principais |
| --------------- | --------- | -------------- |
| `usuario_table` | Usuários  | -              |

---

## 🔗 Relacionamentos Importantes

### Turno

```bash
turno_table
    ├─→ veiculo_table (FK: veiculo_id)
    ├─→ equipe_table (FK: equipe_id)
    └─→ turno_eletricista_table (1:N)
          └─→ eletricista_table (FK: eletricista_id)
```

### Checklist2

```bash
checklist_modelo_table
    └─→ checklist_pergunta_relacao_table (N:N)
          ├─→ checklist_pergunta_table (checklistPerguntaId = remoteId)
          └─→ checklist_opcao_resposta_table (associado por remoteId)

turno_table
    └─→ checklist_preenchido_table (FK: turno_id)
          └─→ checklist_resposta_table (FK: checklist_preenchido_id)
                ├─→ perguntaId (REMOTE ID da pergunta)
                └─→ opcaoRespostaId (REMOTE ID da opção)
```

---

## 🎯 Tipos de Checklist

Definidos em `ApiConstants`:

| Tipo     | ID  | Descrição                            |
| -------- | --- | ------------------------------------ |
| Veicular | 1   | Checklist do veículo (1 por turno)   |
| EPC      | 2   | Checklist de EPC (1 por turno)       |
| EPI      | 3   | Checklist de EPI (1 por eletricista) |

---

## 📊 Tabelas Syncable

Tabelas que herdam de `SyncableTable` (têm `remote_id`, `created_at`, `updated_at`, `sincronizado`):

- ✅ `tipo_veiculo_table`
- ✅ `veiculo_table`
- ✅ `tipo_equipe_table`
- ✅ `equipe_table`
- ✅ `eletricista_table`
- ✅ `checklist_modelo_table`
- ✅ `checklist_pergunta_table`
- ✅ `checklist_opcao_resposta_table`
- ✅ `checklist_pergunta_relacao_table`

### Como funciona a sincronização

1. **Download da API**:

   - Busca dados com `remoteId` do servidor
   - Salva localmente com `id` (autoincrement) e `remoteId` (do servidor)
   - Marca `sincronizado = true`

2. **Upload para API**:
   - Busca registros com `sincronizado = false`
   - Envia para API
   - Recebe `remoteId` de volta
   - Atualiza registro com `remoteId` e `sincronizado = true`

---

## 🔍 Consultas Importantes

### Buscar turno ativo com eletricistas

```dart
final turno = await turnoDao.buscarTurnoAtivo();
final eletricistas = await turnoEletricistaDao.buscarPorTurno(turno.id);
```

### Buscar perguntas de um modelo de checklist

```dart
// Usa remoteId do modelo
final perguntas = await checklistPerguntaDao.buscarPorModelo(modeloRemoteId);
```

### Buscar checklists preenchidos de um turno

```dart
final checklists = await checklistPreenchidoDao.buscarPorTurno(turnoId);
```

---

## ⚠️ Pontos de Atenção

### ❌ Não Fazer

```dart
// ❌ ERRADO: FK para remote_id
checklistModeloId.references(checklistModeloTable, #remote_id)

// ❌ ERRADO: Buscar por ID local quando deveria ser remoteId
final modelo = await checklistModeloRepo.buscarPorId(checklist.checklistModeloId);
```

### ✅ Fazer

```dart
// ✅ CORRETO: FK para id local
turnoId.references(turnoTable, #id)

// ✅ CORRETO: Buscar por remoteId
final modelo = await checklistModeloRepo.buscarPorRemoteId(checklist.checklistModeloId);
```

---

## 📚 Referências

- [Drift Documentation](https://drift.simonbinder.eu/)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitetura do projeto
- [TECHNICAL_GUIDE.md](TECHNICAL_GUIDE.md) - Guia técnico de componentes

---

## 🔄 Migração de Schema

Quando adicionar/modificar tabelas:

1. Atualize a tabela em `lib/core/database/models/`
2. Rode `flutter pub run build_runner build --delete-conflicting-outputs`
3. Incremente `schemaVersion` em `app_database.dart`
4. Implemente migração em `migration` (se necessário)

```dart
@DriftDatabase(
  tables: [/* suas tabelas */],
  daos: [/* seus DAOs */],
  schemaVersion: 2,  // Incremente aqui
)
```
