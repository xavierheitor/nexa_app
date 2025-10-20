# Arquitetura do Cliente HTTP

## 📐 Visão Geral

Esta documentação descreve a arquitetura refatorada do cliente HTTP, organizada seguindo princípios SOLID e Clean Architecture.

## 🏗️ Estrutura

```
lib/core/network/
├── dio_client.dart                    # Cliente HTTP principal (simplificado)
├── interceptors/
│   ├── auth_interceptor.dart          # Autenticação e refresh de tokens
│   ├── logging_interceptor.dart       # Logging detalhado
│   ├── headers_interceptor.dart       # Headers padrão
│   ├── error_handler_interceptor.dart # Tratamento de erros
│   └── README.md                      # Documentação dos interceptors
└── ARCHITECTURE.md                    # Esta documentação
```

## 🎯 Princípios Aplicados

### 1. Single Responsibility Principle (SRP)
Cada interceptor tem **uma única responsabilidade**:
- `AuthInterceptor` → Autenticação
- `LoggingInterceptor` → Logging
- `HeadersInterceptor` → Headers padrão
- `ErrorHandlerInterceptor` → Tratamento de erros

### 2. Open/Closed Principle (OCP)
- **Aberto para extensão**: Novos interceptors podem ser adicionados facilmente
- **Fechado para modificação**: Interceptors existentes não precisam ser modificados

### 3. Dependency Inversion Principle (DIP)
- `DioClient` depende da abstração `Interceptor` do Dio
- Cada interceptor implementa a interface `Interceptor`

### 4. Separation of Concerns
- Lógica de autenticação isolada do logging
- Tratamento de erros separado da autenticação
- Headers padrão configurados independentemente

## 📊 Diagrama de Fluxo

```
┌─────────────────────────────────────────────────────────────────┐
│                         REQUEST FLOW                             │
└─────────────────────────────────────────────────────────────────┘

   Application Code
         │
         ↓
   ┌────────────────┐
   │   DioClient    │  ← Cliente HTTP simplificado
   └────────┬───────┘
            │
            ↓
   ┌────────────────┐
   │  Interceptors  │  ← Cadeia de interceptors
   └────────┬───────┘
            │
            ├──→ [1] HeadersInterceptor
            │         ├─ Content-Type: application/json
            │         ├─ Accept: application/json
            │         └─ App-Version: X.Y.Z
            │
            ↓
            ├──→ [2] AuthInterceptor
            │         └─ Authorization: Bearer <token>
            │
            ↓
            ├──→ [3] LoggingInterceptor
            │         └─ Log: Method, URL, Headers, Body
            │
            ↓
         HTTP Request
            │
            ↓
       ┌──────────┐
       │   API    │
       └────┬─────┘
            │
            ↓
       HTTP Response
            │
            ↓
   ┌────────────────┐
   │  Interceptors  │  ← Ordem inversa
   └────────┬───────┘
            │
            ├──→ [3] LoggingInterceptor
            │         └─ Log: Status, Data
            │
            ↓
            ├──→ [2] AuthInterceptor
            │         └─ (não processa response)
            │
            ↓
            ├──→ [1] HeadersInterceptor
            │         └─ (não processa response)
            │
            ↓
   ┌────────────────┐
   │ Application    │
   └────────────────┘
```

## 🔄 Fluxo de Erro 401 (Refresh Token)

```
┌─────────────────────────────────────────────────────────────────┐
│                      ERROR 401 FLOW                              │
└─────────────────────────────────────────────────────────────────┘

   HTTP Response 401
         │
         ↓
   ┌──────────────────┐
   │ AuthInterceptor  │
   └────────┬─────────┘
            │
            ├─ Já está refreshing?
            │     │
            │     ├─ SIM → Aguarda refresh em andamento
            │     │          │
            │     │          ↓
            │     │     Refresh concluído?
            │     │          │
            │     │          ├─ SIM → Retry Request
            │     │          └─ NÃO → Retorna erro
            │     │
            │     └─ NÃO → Continua
            │
            ↓
   Tem refresh token?
            │
            ├─ NÃO → Retorna erro (deixa controller tratar)
            │
            └─ SIM
                 │
                 ↓
   Tenta refresh via AuthService
                 │
                 ├─ SUCESSO → Retry Request com novo token
                 │                    │
                 │                    ↓
                 │              Request bem-sucedido
                 │
                 └─ FALHA → Logout + Redirect Login
```

## 📈 Antes vs Depois

### Antes da Refatoração

```dart
class DioClient {
  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 100+ linhas de código
          // - Adiciona token
          // - Adiciona headers
          // - Faz logging
          // - Mistura responsabilidades
        },
        onResponse: (response, handler) {
          // Logging misturado
        },
        onError: (error, handler) async {
          // 150+ linhas de código
          // - Tratamento de 401
          // - Refresh de token
          // - Logging de erros
          // - Tradução de erros
          // - Tudo misturado!
        },
      ),
    );
  }
}
```

**Problemas**:
- ❌ Mais de 470 linhas em um único arquivo
- ❌ Múltiplas responsabilidades misturadas
- ❌ Difícil de testar individualmente
- ❌ Difícil de manter e evoluir
- ❌ Violação do SRP
- ❌ Alto acoplamento

### Depois da Refatoração

```dart
class DioClient {
  DioClient() : _dio = Dio(BaseOptions(...)) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(HeadersInterceptor());
    _dio.interceptors.add(AuthInterceptor(_dio));
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorHandlerInterceptor());
  }

  // Métodos HTTP simples
  Future<Response> get(String path, {...}) => _dio.get(path, ...);
  Future<Response> post(String path, {...}) => _dio.post(path, ...);
  // ...
}
```

**Benefícios**:
- ✅ DioClient com ~260 linhas (simplificado)
- ✅ 4 interceptors especializados (~250 linhas cada)
- ✅ Cada classe tem uma responsabilidade
- ✅ Fácil de testar individualmente
- ✅ Fácil de manter e evoluir
- ✅ Segue princípios SOLID
- ✅ Baixo acoplamento

## 🧪 Testabilidade

### Antes
```dart
// Impossível testar apenas autenticação sem toda a lógica
// Impossível testar apenas logging sem autenticação
// Testes complexos e acoplados
```

### Depois
```dart
// Teste isolado do AuthInterceptor
test('should add token to request', () {
  final interceptor = AuthInterceptor(mockDio);
  // Testa apenas autenticação
});

// Teste isolado do LoggingInterceptor
test('should mask sensitive headers', () {
  final interceptor = LoggingInterceptor();
  // Testa apenas logging
});

// Cada interceptor testado independentemente!
```

## 📦 Distribuição de Código

| Arquivo | Linhas | Responsabilidade |
|---------|--------|------------------|
| **dio_client.dart** | ~260 | Configuração e delegação |
| **auth_interceptor.dart** | ~245 | Autenticação e refresh |
| **logging_interceptor.dart** | ~165 | Logging detalhado |
| **headers_interceptor.dart** | ~40 | Headers padrão |
| **error_handler_interceptor.dart** | ~140 | Tratamento de erros |
| **TOTAL** | ~850 | (antes: ~470 em 1 arquivo) |

## 🎨 Padrões de Design Aplicados

### 1. Interceptor Pattern
Permite adicionar comportamentos antes/depois de operações sem modificar o código principal.

### 2. Chain of Responsibility
Cada interceptor pode processar a requisição ou passar para o próximo na cadeia.

### 3. Strategy Pattern
Diferentes estratégias de tratamento (auth, logging, errors) encapsuladas em classes separadas.

### 4. Single Responsibility
Cada classe tem uma única razão para mudar.

## 🚀 Extensibilidade

### Adicionando Novo Interceptor

1. **Crie o arquivo**:
```dart
// lib/core/network/interceptors/custom_interceptor.dart
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Sua lógica
    handler.next(options);
  }
}
```

2. **Adicione ao DioClient**:
```dart
void _setupInterceptors() {
  _dio.interceptors.add(HeadersInterceptor());
  _dio.interceptors.add(CustomInterceptor()); // ← Novo interceptor
  _dio.interceptors.add(AuthInterceptor(_dio));
  _dio.interceptors.add(LoggingInterceptor());
  _dio.interceptors.add(ErrorHandlerInterceptor());
}
```

3. **Documente no README.md**

## 📚 Referências

- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Interceptor Pattern](https://refactoring.guru/design-patterns/chain-of-responsibility)
- [Dio Documentation](https://pub.dev/packages/dio)

---

**Última atualização**: 2025-10-20  
**Versão**: 1.0.0  
**Refatoração por**: Clean Architecture & SOLID Principles

