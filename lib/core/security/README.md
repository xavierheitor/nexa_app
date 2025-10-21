# 🔒 Módulo de Segurança - Nexa App

## 📋 Visão Geral

Este módulo implementa armazenamento seguro de tokens de autenticação usando criptografia nativa do sistema operacional.

---

## 🏗️ Arquitetura

```bash
┌─────────────────────────────────────────────────────────────┐
│                     SECURITY LAYER                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────┐      ┌──────────────────────┐       │
│  │  SessionManager    │      │  TokenStorageService │       │
│  │                    │◄─────│  (Secure Storage)    │       │
│  │  • Gerencia sessão │      │  • Access Token      │       │
│  │  • Valida tokens   │      │  • Refresh Token     │       │
│  │  • Estado global   │      │  • Criptografado     │       │
│  └────────┬───────────┘      └──────────────────────┘       │
│           │                                                  │
│           ↓                                                  │
│  ┌────────────────────┐                                     │
│  │   AuthService      │                                     │
│  │  • Login           │                                     │
│  │  • Logout          │                                     │
│  │  │  • Refresh       │                                     │
│  └────────┬───────────┘                                     │
│           │                                                  │
└───────────┼──────────────────────────────────────────────────┘
            │
            ↓
   ┌────────────────────┐
   │   UsuarioRepo      │
   │  • Banco Local     │
   │  • (sem tokens)    │
   └────────────────────┘
```

---

## 🔐 Armazenamento de Tokens

### Antes (INSEGURO ❌)

```dart
// Tokens em texto plano no SQLite
class UsuarioTable extends Table {
  TextColumn get token => text()();           // ❌ Texto plano
  TextColumn get refreshToken => text()();    // ❌ Texto plano
}
```

**Problema**: Qualquer app com acesso root pode ler os tokens

---

### Depois (SEGURO ✅)

```dart
// Tokens criptografados no armazenamento nativo

┌─────────────────────────────────────────────────────┐
│  iOS: Keychain (criptografia de sistema)            │
│  • Tokens protegidos por hardware                   │
│  • Inacessível para outros apps                     │
│  • Backup automático criptografado                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│  Android: EncryptedSharedPreferences (AES-256)      │
│  • Tokens criptografados com chave única do device  │
│  • Protegido por Android Keystore                   │
│  • Inacessível sem root + decrypt                   │
└─────────────────────────────────────────────────────┘
```

---

## 📁 Arquivos do Módulo

```bash
lib/core/security/
├── session_manager.dart           # Gerenciador de sessão global
├── token_storage_service.dart     # Armazenamento seguro de tokens (NOVO)
└── README.md                       # Esta documentação
```

---

## 🔄 Fluxo de Autenticação

### Login

```bash
1. Usuário → LoginController
        ↓
2. LoginController → AuthService.login()
        ↓
3. AuthService → UsuarioRepo.login() (API)
        ↓
4. API retorna: { token, refreshToken, userData }
        ↓
5. AuthService → Salva usuário no banco (SEM tokens)
        ↓
6. SessionManager.setUsuario() ← Salva tokens no SecureStorage
        ↓
7. ✅ Login completo e seguro!
```

### Acesso a Recursos

```bash
1. Interceptor precisa de token
        ↓
2. SessionManager.token (async)
        ↓
3. TokenStorageService.getAccessToken()
        ↓
4. Token descriptografado do Keychain/EncryptedPreferences
        ↓
5. ✅ Token usado na requisição
```

### Logout

```bash
1. Usuário clica em Logout
        ↓
2. HomeController → SessionManager.logout()
        ↓
3. TokenStorageService.clearAll() ← Tokens DELETADOS
        ↓
4. AuthService.logout() → Remove do banco
        ↓
5. ✅ Dados completamente removidos!
```

---

## 🎯 Uso dos Serviços

### TokenStorageService

```dart
final storage = TokenStorageService();

// Salvar tokens (após login)
await storage.saveAccessToken('eyJhbG...');
await storage.saveRefreshToken('refresh_123');

// Ler tokens (para requisições)
final token = await storage.getAccessToken();

// Limpar tudo (logout)
await storage.clearAll();
```

---

### SessionManager

```dart
final sessionManager = Get.find<SessionManager>();

// Verificar se logado
if (sessionManager.estaLogado) {
  // Usuário autenticado
}

// Obter token (NOVO - assíncrono)
final token = await sessionManager.token;

// ❌ DEPRECATED (manter por compatibilidade)
final tokenSync = sessionManager.tokenSync;

// Definir usuário após login
await sessionManager.setUsuario(usuarioLogado);

// Logout
await sessionManager.logout(); // Limpa tudo!
```

---

## 🔄 Migração

### Passo 1: Instalação

```bash
flutter pub get
```

### Passo 2: Configuração Android (Opcional)

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest ...>
  <application ...>
    <!-- Configuração automática, não precisa alterar -->
  </application>
</manifest>
```

### Passo 3: Configuração iOS (Opcional)

```bash
Nenhuma configuração necessária.
Keychain é configurado automaticamente.
```

### Passo 4: Código

**Atualizar controllers que usam tokenSync**:

```dart
// ANTES ❌
final token = sessionManager.tokenSync;

// DEPOIS ✅
final token = await sessionManager.token;
```

---

## ⚠️ Compatibilidade

### tokenSync (Deprecated)

O getter `tokenSync` ainda existe por compatibilidade, mas:

- ⚠️ Retorna token do cache em memória (pode estar desatualizado)
- ✅ Usar `await sessionManager.token` para token atualizado
- 📅 Será removido em versão futura

---

## 🛡️ Benefícios de Segurança

| Aspecto            | Antes                    | Depois                                |
| ------------------ | ------------------------ | ------------------------------------- |
| **Criptografia**   | ❌ Nenhuma               | ✅ AES-256 (Android) / Keychain (iOS) |
| **Acesso**         | ❌ Qualquer app com root | ✅ Apenas este app                    |
| **Backup**         | ❌ Texto plano           | ✅ Criptografado                      |
| **Compliance**     | ❌ Não seguro            | ✅ Seguro (LGPD, GDPR)                |
| **Roubo de Dados** | ❌ Fácil                 | ✅ Praticamente impossível            |

---

## 🧪 Como Testar

### Teste 1: Login e Token Seguro

```dart
1. Fazer login
2. Verificar logs: "🔐 Access token salvo com segurança"
3. Fechar e reabrir app
4. Token deve estar disponível
```

### Teste 2: Logout Completo

```dart
1. Fazer logout
2. Verificar logs: "🗑️ Todos os tokens removidos"
3. Tentar acessar API
4. Deve falhar (sem token)
```

### Teste 3: Refresh de Token

```dart
1. Aguardar token expirar
2. Fazer requisição
3. Verificar logs de refresh automático
4. Novo token salvo no secure storage
```

---

## 📊 Impacto de Performance

| Operação          | Tempo    | Nota                |
| ----------------- | -------- | ------------------- |
| **Salvar token**  | ~10-50ms | Criptografia nativa |
| **Ler token**     | ~5-20ms  | Leitura otimizada   |
| **Limpar tokens** | ~10-30ms | Operação rápida     |

**Conclusão**: Impacto mínimo na UX ✅

---

## 🔍 Debugging

### Ver chaves armazenadas (apenas debug!)

```dart
final storage = TokenStorageService();
final keys = await storage.getAllKeys();
print('Chaves: $keys'); // Não mostra valores!
```

### Logs importantes

```bash
🔐 Access token salvo com segurança
🔐 Refresh token salvo com segurança
🔐 Access token recuperado
🗑️ Todos os tokens removidos com segurança
```

---

## ⚡ Troubleshooting

### Token não sendo salvo

**Sintoma**: `getAccessToken()` retorna null após login

**Solução**:

1. Verificar se `SessionManager.setUsuario()` foi chamado
2. Checar logs para erros de armazenamento
3. Verificar permissões do app

---

### Erro no Android "EncryptedSharedPreferences"

**Sintoma**: Exception ao salvar/ler token no Android

**Solução**:

```dart
// Limpar secure storage e tentar novamente
await storage.clearAll();
```

---

## 📚 Referências

- [FlutterSecureStorage](https://pub.dev/packages/flutter_secure_storage)
- [iOS Keychain](https://developer.apple.com/documentation/security/keychain_services)
- [Android EncryptedSharedPreferences](https://developer.android.com/reference/androidx/security/crypto/EncryptedSharedPreferences)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)

---

**Última atualização**: 2025-10-21  
**Versão**: 2.0.0 (Secure Storage implementado)  
**Status**: ✅ Produção
