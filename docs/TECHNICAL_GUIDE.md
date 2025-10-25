# Guia Técnico - Nexa App

> **Documentação técnica de componentes principais**  
> **Última atualização:** Outubro 2025

---

## 📑 Índice

1. [Cache Manager](#cache-manager)
2. [Connectivity Service](#connectivity-service)
3. [Logging Mixin](#logging-mixin)
4. [Sync Service](#sync-service)
5. [Token Manager](#token-manager)

---

## Cache Manager

### 📖 O que é?

O `CacheManager` é responsável por gerenciar cache em memória de dados frequentemente acessados, reduzindo consultas ao banco de dados e melhorando a performance do app.

### 🎯 Funcionalidades

- ✅ **Cache em memória** com TTL (Time To Live) configurável
- ✅ **Invalidação manual ou automática** de cache
- ✅ **Namespace** para organizar diferentes tipos de cache
- ✅ **Thread-safe** para acesso concorrente

### 🔧 Como usar

#### 1. Adicionar o Mixin no Repository

```dart
import 'package:nexa_app/core/cache/cache_mixin.dart';

class TurnoRepo with CacheMixin {
  @override
  String get cacheNamespace => 'turno';  // Nome do namespace

  @override
  Duration get cacheTTL => Duration(minutes: 5);  // TTL padrão

  Future<TurnoDto?> buscarTurnoAtivo() async {
    // Usa cache automático com key 'turno_ativo'
    return getCached(
      key: 'turno_ativo',
      fetcher: () => _dao.buscarTurnoAtivo(),
      ttl: Duration(minutes: 10),  // TTL específico (opcional)
    );
  }

  Future<void> salvarTurno(TurnoDto turno) async {
    await _dao.salvar(turno);
    // Invalida cache após salvar
    invalidateCache('turno_ativo');
  }
}
```

#### 2. Métodos Disponíveis

| Método                 | Descrição                            |
| ---------------------- | ------------------------------------ |
| `getCached()`          | Busca do cache ou executa fetcher    |
| `invalidateCache(key)` | Invalida cache de uma key específica |
| `invalidateAll()`      | Invalida todo o cache do namespace   |
| `clearExpiredCache()`  | Remove apenas caches expirados       |

### 📊 Boas Práticas

✅ **Use cache para dados que mudam pouco**: turno ativo, configurações, listas estáticas  
✅ **Invalide cache ao salvar/atualizar**: sempre que modificar dados  
✅ **Configure TTL apropriado**: dados que mudam frequentemente = TTL menor  
❌ **Não use cache para dados sensíveis**: senhas, tokens (use SecureStorage)  
❌ **Não use cache para listas grandes**: pode consumir muita memória

### 🔍 Exemplo Completo

```dart
class VeiculoRepo with CacheMixin {
  @override
  String get cacheNamespace => 'veiculo';

  @override
  Duration get cacheTTL => Duration(hours: 1);

  // Lista de veículos (cache por 1 hora)
  Future<List<VeiculoDto>> listar() async {
    return getCached(
      key: 'lista_veiculos',
      fetcher: () => _dao.listar(),
    );
  }

  // Busca veículo específico (cache por 30 min)
  Future<VeiculoDto?> buscarPorId(int id) async {
    return getCached(
      key: 'veiculo_$id',
      fetcher: () => _dao.buscarPorId(id),
      ttl: Duration(minutes: 30),
    );
  }

  // Salvar veículo (invalida cache)
  Future<void> salvar(VeiculoDto veiculo) async {
    await _dao.salvar(veiculo);
    invalidateAll();  // Invalida todo o cache de veículos
  }
}
```

---

## Connectivity Service

### 📖 O que é?

O `ConnectivityService` monitora o estado da conexão de internet do dispositivo em tempo real, permitindo que o app adapte seu comportamento (modo offline/online).

### 🎯 Funcionalidades

- ✅ **Monitoramento em tempo real** da conexão
- ✅ **Stream reativo** que notifica mudanças
- ✅ **Estados claros**: conectado/desconectado
- ✅ **Integração com GetX** para reatividade

### 🔧 Como usar

#### 1. Acessar o serviço (já injetado globalmente)

```dart
import 'package:get/get.dart';

class MeuController extends GetxController {
  final ConnectivityService _connectivity = Get.find();

  @override
  void onInit() {
    super.onInit();

    // Verifica se está conectado
    if (_connectivity.isConnected) {
      print('✅ Dispositivo online');
    } else {
      print('❌ Dispositivo offline');
    }
  }
}
```

#### 2. Observar mudanças de conectividade

```dart
class MeuController extends GetxController {
  final ConnectivityService _connectivity = Get.find();

  @override
  void onInit() {
    super.onInit();

    // Escuta mudanças na conectividade
    ever(_connectivity.isConnected, (bool isConnected) {
      if (isConnected) {
        print('✅ Conexão restaurada!');
        _sincronizarDados();
      } else {
        print('❌ Conexão perdida!');
        _mostrarModoOffline();
      }
    });
  }
}
```

#### 3. Indicador visual na AppBar

```dart
Obx(() {
  final bool isConnected = Get.find<ConnectivityService>().isConnected.value;

  return AppBar(
    title: Text('Meu App'),
    actions: [
      Icon(
        isConnected ? Icons.wifi : Icons.wifi_off,
        color: isConnected ? Colors.green : Colors.red,
      ),
    ],
  );
})
```

### 📊 Boas Práticas

✅ **Desabilite sync quando offline**: evita erros de rede  
✅ **Mostre indicador visual**: usuário sempre sabe o status  
✅ **Queue de ações offline**: salve operações para sincronizar depois  
✅ **Sincronize automaticamente ao reconectar**: melhora UX  
❌ **Não bloqueie o app quando offline**: funcione mesmo sem internet

### 🔍 Exemplo Completo

```dart
class TurnoController extends GetxController {
  final ConnectivityService _connectivity = Get.find();
  final SyncService _sync = Get.find();

  @override
  void onInit() {
    super.onInit();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    ever(_connectivity.isConnected, (bool isConnected) {
      if (isConnected) {
        AppLogger.i('✅ Conexão restaurada, sincronizando...',
            tag: 'TurnoController');
        _sync.sincronizarTudo();
      } else {
        AppLogger.w('❌ Modo offline ativado',
            tag: 'TurnoController');
      }
    });
  }

  Future<void> abrirTurno() async {
    // Salva localmente primeiro
    await _turnoRepo.salvar(turno);

    // Tenta sincronizar se estiver online
    if (_connectivity.isConnected.value) {
      try {
        await _sync.enviarTurno(turno);
      } catch (e) {
        AppLogger.w('Erro ao sincronizar, será tentado novamente',
            tag: 'TurnoController');
      }
    }
  }
}
```

---

## Logging Mixin

### 📖 O que é?

O `LoggingMixin` padroniza logs de operações em repositórios e serviços, automatizando logging de início, sucesso, erro e duração de operações.

### 🎯 Funcionalidades

- ✅ **Logs automáticos** de operações (início, sucesso, erro)
- ✅ **Medição de tempo** de execução
- ✅ **Rastreamento de exceções** com stack trace
- ✅ **Tags personalizadas** por repository

### 🔧 Como usar

#### 1. Adicionar o Mixin no Repository

```dart
import 'package:nexa_app/core/mixins/logging_mixin.dart';

class TurnoRepo with LoggingMixin {
  @override
  String get repositoryName => 'TurnoRepository';

  final TurnoDao _dao;

  TurnoRepo(this._dao);
}
```

#### 2. Usar `executeWithLogging` para operações com retorno

```dart
Future<List<TurnoDto>> listar() async {
  return await executeWithLogging(
    operationName: 'listar',
    operation: () async {
      return await _dao.listar();
    },
  );
}

// Logs automáticos:
// [DEBUG] [TurnoRepository] Iniciando operação: listar
// [INFO] [TurnoRepository] listar - ✅ Concluído (120ms)
```

#### 3. Usar `executeVoidWithLogging` para operações sem retorno

```dart
Future<void> salvar(TurnoDto turno) async {
  return await executeVoidWithLogging(
    operationName: 'salvar',
    operation: () async {
      await _dao.salvar(turno);
    },
  );
}

// Logs automáticos:
// [DEBUG] [TurnoRepository] Iniciando operação: salvar
// [INFO] [TurnoRepository] salvar - ✅ Concluído (45ms)
```

#### 4. Tratamento automático de erros

```dart
Future<TurnoDto?> buscarPorId(int id) async {
  return await executeWithLogging(
    operationName: 'buscarPorId',
    operation: () async {
      // Se houver erro, é automaticamente logado
      return await _dao.buscarPorId(id);
    },
  );
}

// Em caso de erro:
// [DEBUG] [TurnoRepository] Iniciando operação: buscarPorId
// [ERROR] [TurnoRepository] buscarPorId - ❌ Erro (150ms)
// [ERROR] Detalhes do erro + stack trace
```

### 📊 Boas Práticas

✅ **Use em todos os repositórios**: padronização e rastreabilidade  
✅ **Nomes de operação descritivos**: 'buscarTurnoAtivo' melhor que 'buscar'  
✅ **Repository name único**: facilita filtrar logs  
❌ **Não logue dados sensíveis**: evite logar senhas, tokens nos parâmetros

### 🔍 Exemplo Completo

```dart
class VeiculoRepo with LoggingMixin {
  @override
  String get repositoryName => 'VeiculoRepository';

  final VeiculoDao _dao;

  VeiculoRepo(this._dao);

  // Operação com retorno de lista
  Future<List<VeiculoDto>> listar() async {
    return await executeWithLogging(
      operationName: 'listar',
      operation: () async {
        final veiculos = await _dao.listar();
        AppLogger.d('${veiculos.length} veículos encontrados',
            tag: repositoryName);
        return veiculos;
      },
    );
  }

  // Operação com retorno nullable
  Future<VeiculoDto?> buscarPorPlaca(String placa) async {
    return await executeWithLogging(
      operationName: 'buscarPorPlaca',
      operation: () async {
        final veiculo = await _dao.buscarPorPlaca(placa);
        if (veiculo == null) {
          AppLogger.w('Veículo não encontrado: $placa',
              tag: repositoryName);
        }
        return veiculo;
      },
    );
  }

  // Operação sem retorno
  Future<void> atualizar(VeiculoDto veiculo) async {
    return await executeVoidWithLogging(
      operationName: 'atualizar',
      operation: () async {
        await _dao.atualizar(veiculo);
        AppLogger.i('Veículo ${veiculo.placa} atualizado',
            tag: repositoryName);
      },
    );
  }

  // Operação com múltiplas ações
  Future<int> sincronizarComAPI(List<VeiculoDto> veiculos) async {
    return await executeWithLogging(
      operationName: 'sincronizarComAPI',
      operation: () async {
        int sincronizados = 0;
        for (final veiculo in veiculos) {
          await _dao.salvar(veiculo);
          sincronizados++;
        }
        AppLogger.i('$sincronizados veículos sincronizados',
            tag: repositoryName);
        return sincronizados;
      },
    );
  }
}
```

### 📋 Formato dos Logs

#### Início da operação

```bash
[DEBUG] [VeiculoRepository] Iniciando operação: listar
```

#### Sucesso

```bash
[INFO] [VeiculoRepository] listar - ✅ Concluído (120ms)
```

#### Erro

```
[ERROR] [VeiculoRepository] buscarPorId - ❌ Erro (85ms)
[ERROR] Erro: Database connection failed
Stack trace: ...
```

---

## Sync Service

### 📖 O que é?

O `SyncService` gerencia a sincronização de dados entre o banco local e a API, garantindo consistência offline-first.

### 🎯 Funcionalidades

- ✅ **Sincronização automática** ao conectar
- ✅ **Queue de operações pendentes** quando offline
- ✅ **Retry automático** em caso de falha
- ✅ **Sincronização seletiva** por tipo de dado

### 📊 Fluxo de Sincronização

```bash
1. App abre → Verifica conexão
2. Se online → Busca dados atualizados da API
3. Salva no banco local
4. Se houver mudanças locais não sincronizadas → Envia para API
5. Marca como sincronizado
```

---

## Token Manager

### 📖 O que é?

O `TokenManager` gerencia tokens de autenticação de forma segura usando `flutter_secure_storage`.

### 🎯 Funcionalidades

- ✅ **Armazenamento seguro** de tokens
- ✅ **Refresh automático** quando token expira
- ✅ **Verificação de expiração** do token
- ✅ **Limpeza ao logout**

### 🔧 Uso Básico

```dart
final tokenManager = Get.find<TokenManager>();

// Salvar token
await tokenManager.saveToken('seu_token_aqui');

// Buscar token
final token = await tokenManager.getToken();

// Verificar se está válido
if (await tokenManager.isTokenValid()) {
  print('Token válido');
}

// Limpar token (logout)
await tokenManager.clearToken();
```

---

## 🎯 Resumo

| Componente              | Uso Principal      | Quando Usar                          |
| ----------------------- | ------------------ | ------------------------------------ |
| **CacheManager**        | Cache em memória   | Dados acessados frequentemente       |
| **ConnectivityService** | Monitor de conexão | Adaptar comportamento online/offline |
| **LoggingMixin**        | Logs padronizados  | Todos os repositories                |
| **SyncService**         | Sincronização      | Enviar/receber dados da API          |
| **TokenManager**        | Tokens seguros     | Autenticação e sessão                |

---

## 📚 Próximos Passos

- Leia [OVERVIEW.md](OVERVIEW.md) para entender a arquitetura geral
- Consulte [ARCHITECTURE.md](ARCHITECTURE.md) para detalhes técnicos
- Veja [STYLE_GUIDE.md](STYLE_GUIDE.md) para padrões de código
- Siga [GETTING_STARTED.md](GETTING_STARTED.md) para configurar o ambiente
