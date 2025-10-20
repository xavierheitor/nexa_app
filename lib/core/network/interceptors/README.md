# Interceptors HTTP

Esta pasta contém interceptors especializados para o cliente HTTP Dio, seguindo o princípio de **Single Responsibility** (cada interceptor tem uma responsabilidade específica).

## 📋 Estrutura

```
interceptors/
├── auth_interceptor.dart           # Autenticação e refresh de tokens
├── logging_interceptor.dart        # Logs de requisições/respostas
├── headers_interceptor.dart        # Headers padrão (versão, content-type)
├── error_handler_interceptor.dart  # Tratamento de erros HTTP
└── README.md                       # Esta documentação
```

## 🔄 Ordem de Execução

A ordem em que os interceptors são adicionados ao Dio determina a ordem de execução:

### Request (ordem de adição)
1. **HeadersInterceptor** → Adiciona headers padrão
2. **AuthInterceptor** → Adiciona token de autenticação
3. **LoggingInterceptor** → Registra a requisição

### Response (ordem inversa)
1. **LoggingInterceptor** → Registra a resposta
2. **AuthInterceptor** → (não processa response)
3. **HeadersInterceptor** → (não processa response)

### Error (ordem inversa)
1. **LoggingInterceptor** → Registra o erro
2. **AuthInterceptor** → Trata 401 e faz refresh de token
3. **ErrorHandlerInterceptor** → Traduz erros para mensagens amigáveis

## 📦 Interceptors

### 1. AuthInterceptor

**Responsabilidade**: Gerenciamento de autenticação e tokens

**Funcionalidades**:
- ✅ Anexa automaticamente Bearer token nas requisições
- ✅ Detecta erro 401 (Unauthorized)
- ✅ Executa refresh automático de token
- ✅ Controla concorrência (evita múltiplos refresh simultâneos)
- ✅ Reexecuta requisições após refresh bem-sucedido
- ✅ Força logout após falha de refresh

**Fluxo**:
```
Request → Token anexado
   ↓
401 Unauthorized?
   ↓ Sim
Refresh Token → Retry Request
   ↓ (falha)
Logout → Redirect Login
```

**Dependências**:
- `SessionManager` (via GetX)
- `AuthService` (via SessionManager)
- Instância do `Dio` (para retry)

---

### 2. LoggingInterceptor

**Responsabilidade**: Logging detalhado de operações HTTP

**Funcionalidades**:
- ✅ Registra todas as requisições (método, URL, headers, body)
- ✅ Registra todas as respostas (status, data)
- ✅ Registra todos os erros (status, tipo, mensagem)
- ✅ Mascara informações sensíveis (tokens, senhas)
- ✅ Limita tamanho dos logs (previne logs gigantes)

**Níveis de Log**:
- `VERBOSE`: Detalhes completos (headers, body, data)
- `INFO`: Respostas bem-sucedidas
- `ERROR`: Erros HTTP
- `DEBUG`: Informações auxiliares

**Segurança**:
- Tokens são mascarados (`Bearer ***`)
- Senhas são mascaradas (`***`)
- Outras informações sensíveis são protegidas

---

### 3. HeadersInterceptor

**Responsabilidade**: Configuração de headers padrão

**Funcionalidades**:
- ✅ `Content-Type: application/json`
- ✅ `Accept: application/json`
- ✅ `App-Version: X.Y.Z` (versionamento automático)

**Benefícios**:
- Consistência em todas as requisições
- Tracking de versão no backend
- Código mais limpo (não precisa definir headers repetidamente)

---

### 4. ErrorHandlerInterceptor

**Responsabilidade**: Tradução de erros técnicos em mensagens amigáveis

**Funcionalidades**:
- ✅ Traduz `DioExceptionType` em mensagens claras
- ✅ Extrai mensagens do backend quando disponíveis
- ✅ Fornece mensagens padrão por status code
- ✅ Não interfere no tratamento de 401 (deixa para AuthInterceptor)

**Tipos de Erro Tratados**:
| Tipo | Mensagem |
|------|----------|
| Connection Timeout | "Tempo de conexão esgotado. Verifique sua internet." |
| Connection Error | "Falha de conexão. Verifique sua internet." |
| 400 Bad Request | "Requisição inválida. Verifique os dados enviados." |
| 403 Forbidden | "Acesso negado. Você não tem permissão para esta ação." |
| 404 Not Found | "Recurso não encontrado." |
| 500 Server Error | "Erro interno no servidor. Tente novamente mais tarde." |
| Bad Certificate | "Certificado SSL inválido." |

---

## 🎯 Boas Práticas

### ✅ Faça
- Mantenha cada interceptor focado em uma única responsabilidade
- Use tags de logging para facilitar filtros
- Documente novas funcionalidades adicionadas
- Teste interceptors de forma isolada quando possível

### ❌ Evite
- Misturar responsabilidades em um único interceptor
- Expor informações sensíveis nos logs
- Criar loops infinitos de retry
- Modificar a ordem dos interceptors sem entender o impacto

## 🔧 Adicionando Novo Interceptor

1. **Crie o arquivo** na pasta `interceptors/`
2. **Estenda `Interceptor`** do Dio
3. **Implemente os métodos** necessários:
   - `onRequest()` - Antes da requisição
   - `onResponse()` - Após resposta bem-sucedida
   - `onError()` - Quando ocorrer erro
4. **Adicione ao `DioClient`** na ordem apropriada
5. **Documente** no README (este arquivo)
6. **Teste** isoladamente

### Exemplo

```dart
import 'package:dio/dio.dart';

class MyCustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Sua lógica aqui
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Sua lógica aqui
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Sua lógica aqui
    handler.next(err);
  }
}
```

## 📚 Referências

- [Documentação do Dio](https://pub.dev/packages/dio)
- [Interceptors Pattern](https://refactoring.guru/design-patterns/chain-of-responsibility)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Última atualização**: 2025-10-20  
**Versão**: 1.0.0

