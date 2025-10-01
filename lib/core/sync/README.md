# Sistema de Sincronização - Nexa App

Este diretório contém a infraestrutura completa para sincronização de dados entre o servidor e o banco de dados local do aplicativo.

## 📁 Estrutura de Arquivos

```bash
lib/core/sync/
├── sync_manager.dart              # Gerenciador central de sincronização
├── sync_result.dart              # Resultado consolidado de sincronização
├── syncable_repository.dart      # Interface para repositórios sincronizáveis
├── exemplo_repositorio_sync.dart # Exemplo de implementação
└── README.md                     # Este arquivo
```

## 🚀 Como Usar

### 1. Implementar um Repositório Sincronizável

Crie um novo arquivo em `lib/core/domain/repositories/sync/` seguindo este padrão:

```dart
// usuario_sync_repo.dart
class UsuarioSyncRepo implements SyncableRepository<UsuarioDto> {
  final DioClient dio;
  final UsuarioDao usuarioDao;

  UsuarioSyncRepo({required this.dio, required this.usuarioDao});

  @override
  String get nomeEntidade => 'usuario';

  @override
  Future<List<UsuarioDto>> buscarDaApi() async {
    final response = await dio.get('/api/usuarios');
    return (response.data as List)
        .map((json) => UsuarioDto.fromJson(json))
        .toList();
  }

  @override
  Future<void> sincronizarComBanco(List<UsuarioDto> itens) async {
    await usuarioDao.transaction(() async {
      await usuarioDao.limparTabela();
      for (final usuario in itens) {
        await usuarioDao.inserir(usuario.toEntity());
      }
    });
  }

  @override
  Future<bool> estaVazio(String entidade) async {
    final count = await usuarioDao.contar();
    return count == 0;
  }
}
```

### 2. Registrar no SyncService

Edite o arquivo `lib/core/core_app/services/sync_service.dart` e adicione o registro no construtor:

```dart
SyncService() {
  _syncManager = SyncManager();

  // Registrar repositórios sincronizáveis
  _syncManager.registrar(UsuarioSyncRepo(dio: dio, dao: usuarioDao));
  _syncManager.registrar(ProdutoSyncRepo(dio: dio, dao: produtoDao));
  // ... outros repositórios
}
```

### 3. Usar a Sincronização

```dart
final syncService = SyncService();

// Sincronização completa
final sucesso = await syncService.sincronizar();

// Sincronização de módulo específico
await syncService.sincronizarModulo('usuario');

// Sincronização forçada
await syncService.sincronizarModulo('produto', force: true);

// Listar módulos disponíveis
final modulos = syncService.modulosDisponiveis;
```

## 🏗️ Arquitetura

### SyncManager

- **Responsabilidade**: Coordenar sincronização de todos os repositórios
- **Padrão**: Registry Pattern
- **Funcionalidades**: Sincronização completa, seletiva e verificação de estado

### SyncableRepository

- **Responsabilidade**: Interface para repositórios sincronizáveis
- **Padrão**: Strategy Pattern
- **Funcionalidades**: Busca na API, persistência local, verificação de estado

### SyncResult

- **Responsabilidade**: Encapsular resultado da sincronização
- **Funcionalidades**: Indicar sucesso e capacidade de continuar

### SyncService

- **Responsabilidade**: Serviço de alto nível para sincronização
- **Funcionalidades**: Coordenar SyncManager, logging, tratamento de erros

## 📋 Checklist para Novos Repositórios

- [ ] Criar arquivo em `lib/core/domain/repositories/sync/`
- [ ] Implementar interface `SyncableRepository<T>`
- [ ] Definir `nomeEntidade` único
- [ ] Implementar `buscarDaApi()`
- [ ] Implementar `sincronizarComBanco()`
- [ ] Implementar `estaVazio()`
- [ ] Adicionar tratamento de erros
- [ ] Adicionar logs detalhados
- [ ] Registrar no `SyncService`
- [ ] Testar sincronização individual
- [ ] Testar sincronização completa

## 🔧 Configuração Recomendada

### Estrutura de Diretórios

```bash
lib/core/domain/repositories/sync/
├── usuario_sync_repo.dart
├── produto_sync_repo.dart
├── categoria_sync_repo.dart
└── ...
```

### Nomes de Entidades

- Use nomes descritivos e únicos
- Evite espaços e caracteres especiais
- Exemplos: `'usuario'`, `'produto'`, `'categoria_produto'`

### Tratamento de Erros

- Implemente try-catch em todos os métodos
- Use `AppLogger` para logs detalhados
- Propague erros para camada superior
- Implemente fallback em `estaVazio()`

## 📊 Fluxo de Sincronização

```mermaid
graph TD
    A[SyncService.sincronizar()] --> B[SyncManager.sincronizarTudo()]
    B --> C{Verificar se vazio}
    C -->|Sim| D[buscarDaApi()]
    C -->|Não| E[Pular módulo]
    D --> F[sincronizarComBanco()]
    F --> G[SyncResult]
    E --> G
    G --> H[Retornar resultado]
```

## 🐛 Debugging

### Logs Disponíveis

- `SyncService`: Logs de alto nível
- `SyncManager`: Logs de coordenação
- `SyncableRepository`: Logs específicos do repositório

### Verificações Comuns

```dart
// Verificar módulos registrados
print('Módulos: ${syncService.modulosDisponiveis}');

// Verificar se está sincronizando
print('Sincronizando: ${syncService.isSyncing}');

// Testar módulo específico
await syncService.sincronizarModulo('usuario');
```

## ⚠️ Considerações Importantes

### Performance

- Use transações para operações de banco
- Implemente paginação para grandes volumes
- Evite carregar todos os dados na memória

### Concorrência

- O SyncService previne sincronização concorrente
- Use `force: true` para forçar sincronização
- Implemente timeout adequado para APIs

### Dados Locais

- Verifique se há dados antes de sincronizar
- Implemente estratégia de fallback
- Mantenha integridade referencial

## 📚 Exemplos

Consulte o arquivo `exemplo_repositorio_sync.dart` para um exemplo completo de implementação com comentários detalhados e guia passo a passo.

## 🔄 Atualizações Futuras

- [ ] Implementar sincronização incremental
- [ ] Adicionar retry automático
- [ ] Implementar sincronização em background
- [ ] Adicionar métricas de performance
- [ ] Implementar sincronização offline
