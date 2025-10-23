# 🗺️ Roadmap: Padronização de Mensagens de Erro da API

**Data**: 22/10/2025  
**Status**: 📋 **ROADMAP**  
**Objetivo**: Padronizar mensagens de erro da API, especialmente para fechamento de turno

---

## 🎯 **Situação Atual**

### **Problema Identificado:**
- API está enviando `message` como **array** no fechamento de turno
- App espera `message` como **string**
- Causa erro: `type 'List<dynamic>' is not a subtype of type 'String'`

### **Log do Erro:**
```json
{
  "statusCode": 400,
  "message": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}
```

---

## 📋 **ROADMAP PARA PADRONIZAÇÃO**

### **FASE 1: Análise do Padrão Atual** ✅

**✅ JÁ FEITO:**
- Identificado padrão de erro no `TurnoRepo._extrairMensagemErro()`
- Mapeado como o app trata diferentes estruturas de erro
- Identificado que o app suporta múltiplos formatos

### **FASE 2: Definição do Padrão Padrão** 📋

**🎯 OBJETIVO:** Definir estrutura única para todas as mensagens de erro

#### **2.1 Estrutura Padrão Recomendada:**

```json
{
  "statusCode": 400,
  "timestamp": "2025-10-23T00:50:31.182Z",
  "path": "/api/turno/fechar",
  "message": "Dados inválidos fornecidos",
  "details": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}
```

#### **2.2 Campos Obrigatórios:**
- `statusCode`: Código HTTP (number)
- `message`: Mensagem principal (string)
- `timestamp`: Timestamp da requisição (string)
- `path`: Caminho da requisição (string)

#### **2.3 Campos Opcionais:**
- `details`: Lista de detalhes específicos (array de strings)
- `error`: Código de erro específico (string)
- `data`: Dados adicionais (object)

### **FASE 3: Implementação no Servidor** 🔧

#### **3.1 Endpoint `/api/turno/fechar`:**

**ANTES (Problemático):**
```json
{
  "statusCode": 400,
  "message": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}
```

**DEPOIS (Padronizado):**
```json
{
  "statusCode": 400,
  "timestamp": "2025-10-23T00:50:31.182Z",
  "path": "/api/turno/fechar",
  "message": "Dados inválidos fornecidos",
  "details": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}
```

#### **3.2 Outros Endpoints de Turno:**

**Abertura de Turno (`/api/turno/abrir`):**
```json
{
  "statusCode": 409,
  "timestamp": "2025-10-23T00:50:31.182Z",
  "path": "/api/turno/abrir",
  "message": "Já existe um turno aberto para este usuário"
}
```

**Listagem de Turnos (`/api/turno/listar`):**
```json
{
  "statusCode": 500,
  "timestamp": "2025-10-23T00:50:31.182Z",
  "path": "/api/turno/listar",
  "message": "Erro interno do servidor"
}
```

### **FASE 4: Atualização do App** 📱

#### **4.1 ErrorHandler - Suporte a Listas:**

**✅ JÁ IMPLEMENTADO:**
```dart
} else if (messageField is List) {
  /// Message é uma lista de strings (erros de validação).
  message = messageField.join(', ');
}
```

#### **4.2 TurnoRepo - Tratamento de Fechamento:**

**✅ JÁ IMPLEMENTADO:**
- Tratamento de erro no fechamento
- Mensagens amigáveis para o usuário
- Não fechamento local se API falhar

### **FASE 5: Testes e Validação** 🧪

#### **5.1 Cenários de Teste:**

**Teste 1: Erro de Validação (400)**
```json
{
  "statusCode": 400,
  "message": "Dados inválidos fornecidos",
  "details": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}
```

**Teste 2: Endpoint Não Encontrado (404)**
```json
{
  "statusCode": 404,
  "message": "Endpoint de fechamento de turno não está disponível"
}
```

**Teste 3: Erro de Servidor (500)**
```json
{
  "statusCode": 500,
  "message": "Erro interno do servidor"
}
```

---

## 🎯 **AÇÕES IMEDIATAS PARA A API**

### **1. Corrigir Endpoint `/api/turno/fechar`:**

**Mudança Necessária:**
```javascript
// ANTES
res.status(400).json({
  message: [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
});

// DEPOIS
res.status(400).json({
  statusCode: 400,
  timestamp: new Date().toISOString(),
  path: req.path,
  message: "Dados inválidos fornecidos",
  details: [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
});
```

### **2. Padronizar Todos os Endpoints de Turno:**

**Estrutura Base:**
```javascript
const errorResponse = (statusCode, message, details = null) => {
  return {
    statusCode,
    timestamp: new Date().toISOString(),
    path: req.path,
    message,
    ...(details && { details })
  };
};

// Uso:
res.status(400).json(errorResponse(400, "Dados inválidos", ["campo1", "campo2"]));
res.status(404).json(errorResponse(404, "Endpoint não encontrado"));
res.status(500).json(errorResponse(500, "Erro interno do servidor"));
```

---

## 📊 **BENEFÍCIOS DA PADRONIZAÇÃO**

### **1. Consistência:**
- Todas as APIs seguem o mesmo padrão
- Facilita manutenção e debug
- Reduz erros de parsing

### **2. Compatibilidade:**
- App já suporta o padrão proposto
- Não quebra funcionalidades existentes
- Melhora tratamento de erros

### **3. Debugging:**
- Logs mais claros e estruturados
- Facilita identificação de problemas
- Melhora experiência do desenvolvedor

---

## ✅ **CHECKLIST DE IMPLEMENTAÇÃO**

### **No Servidor (API):**
- [ ] Corrigir endpoint `/api/turno/fechar`
- [ ] Padronizar endpoint `/api/turno/abrir`
- [ ] Padronizar endpoint `/api/turno/listar`
- [ ] Implementar função `errorResponse()`
- [ ] Testar todos os cenários de erro

### **No App (Já Implementado):**
- [x] ErrorHandler suporta listas
- [x] TurnoRepo trata erros de fechamento
- [x] Mensagens amigáveis para usuário
- [x] Não fechamento local se API falhar

---

## 🚀 **PRÓXIMOS PASSOS**

### **Imediato (Hoje):**
1. **Corrigir endpoint `/api/turno/fechar`** para usar `message` como string
2. **Testar fechamento de turno** com dados válidos e inválidos

### **Curto Prazo (Esta Semana):**
1. **Padronizar todos os endpoints de turno**
2. **Implementar função `errorResponse()`**
3. **Testar todos os cenários de erro**

### **Médio Prazo (Próxima Semana):**
1. **Padronizar outros endpoints da API**
2. **Implementar logs estruturados**
3. **Documentar padrão de erro**

---

## 📝 **COMANDO PARA IA DA API**

```
Preciso padronizar as mensagens de erro da API, especialmente o endpoint /api/turno/fechar.

PROBLEMA ATUAL:
- API está enviando message como array: ["erro1", "erro2"]
- App espera message como string

PADRÃO DESEJADO:
{
  "statusCode": 400,
  "timestamp": "2025-10-23T00:50:31.182Z",
  "path": "/api/turno/fechar",
  "message": "Dados inválidos fornecidos",
  "details": [
    "latitude must be a number conforming to the specified constraints",
    "longitude must be a number conforming to the specified constraints"
  ]
}

AÇÕES:
1. Corrigir endpoint /api/turno/fechar para usar message como string
2. Implementar função errorResponse() para padronizar
3. Aplicar padrão em todos os endpoints de turno

OBJETIVO: Eliminar erro "type 'List<dynamic>' is not a subtype of type 'String'"
```

---

*Gerado automaticamente em 22/10/2025 - Roadmap de Padronização de Erro da API*
