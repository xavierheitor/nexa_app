# 📚 Documentação do Nexa App

> **Central de documentação técnica do projeto**  
> **Última atualização:** Outubro 2025

---

## 🚀 Comece Aqui

Se você é novo no projeto, leia os documentos nesta ordem:

1. **[OVERVIEW.md](OVERVIEW.md)** - Visão geral do app e fluxos principais
2. **[GETTING_STARTED.md](GETTING_STARTED.md)** - Como configurar o ambiente e rodar o projeto
3. **[ARCHITECTURE.md](ARCHITECTURE.md)** - Arquitetura e organização do código
4. **[TECHNICAL_GUIDE.md](TECHNICAL_GUIDE.md)** - Guia técnico de componentes principais
5. **[STYLE_GUIDE.md](STYLE_GUIDE.md)** - Padrões de código e boas práticas

---

## 📖 Documentação Disponível

### 🎯 Essenciais

| Documento                                | Descrição                             | Para quem?    |
| ---------------------------------------- | ------------------------------------- | ------------- |
| [OVERVIEW.md](OVERVIEW.md)               | Visão geral, fluxos e funcionalidades | Todos         |
| [GETTING_STARTED.md](GETTING_STARTED.md) | Setup do ambiente e primeiros passos  | Novos devs    |
| [ARCHITECTURE.md](ARCHITECTURE.md)       | Arquitetura em camadas e organização  | Todos os devs |

### 🔧 Técnicos

| Documento                                                  | Descrição                                       | Para quem?   |
| ---------------------------------------------------------- | ----------------------------------------------- | ------------ |
| [TECHNICAL_GUIDE.md](TECHNICAL_GUIDE.md)                   | CacheManager, ConnectivityService, LoggingMixin | Backend devs |
| [DATABASE_SCHEMA_ANALYSIS.md](DATABASE_SCHEMA_ANALYSIS.md) | Schema do banco e relacionamentos               | Backend devs |

### 📝 Padrões

| Documento                                | Descrição                               | Para quem?    |
| ---------------------------------------- | --------------------------------------- | ------------- |
| [STYLE_GUIDE.md](STYLE_GUIDE.md)         | Convenções de código e nomenclatura     | Todos os devs |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Referência rápida de comandos e atalhos | Todos os devs |

---

## 🏗️ Estrutura do Projeto

```bash
lib/
├── app/                    # Configuração e rotas
├── core/                   # Núcleo (database, network, utils)
│   ├── cache/             # CacheManager
│   ├── database/          # Drift DB
│   ├── network/           # DioClient e interceptors
│   ├── security/          # TokenManager
│   └── utils/             # Logger, helpers
├── data/                   # Camada de dados
│   ├── datasources/       # DAOs e APIs
│   ├── models/            # DTOs
│   └── repositories/      # Implementações
├── domain/                 # Lógica de negócio
│   ├── entities/          # Entidades
│   ├── repositories/      # Interfaces
│   └── usecases/          # Casos de uso
├── presentation/           # UI e controllers
│   ├── home/
│   ├── turno/
│   ├── checklist/
│   └── ...
└── shared/                 # Componentes compartilhados
    ├── bindings/
    ├── middlewares/
    └── widgets/
```

---

## 🎯 Componentes Principais

### Cache Manager

Sistema de cache em memória com TTL para otimizar performance.  
📖 Veja: [TECHNICAL_GUIDE.md#cache-manager](TECHNICAL_GUIDE.md#cache-manager)

### Connectivity Service

Monitora conexão de internet em tempo real.  
📖 Veja: [TECHNICAL_GUIDE.md#connectivity-service](TECHNICAL_GUIDE.md#connectivity-service)

### Logging Mixin

Padroniza logs de operações em repositórios.  
📖 Veja: [TECHNICAL_GUIDE.md#logging-mixin](TECHNICAL_GUIDE.md#logging-mixin)

### Sync Service

Gerencia sincronização offline-first com a API.  
📖 Veja: [TECHNICAL_GUIDE.md#sync-service](TECHNICAL_GUIDE.md#sync-service)

### Token Manager

Armazenamento seguro de tokens de autenticação.  
📖 Veja: [TECHNICAL_GUIDE.md#token-manager](TECHNICAL_GUIDE.md#token-manager)

---

## 🔄 Fluxo de Dados

```bash
UI (Controller)
    ↓
Repository (com Cache + Logging)
    ↓
    ├─→ DAO (Banco Local)
    └─→ API Service (Backend)
```

---

## 🛠️ Desenvolvimento

### Padrões de Código

- ✅ **Clean Architecture** em camadas
- ✅ **Repository Pattern** para dados
- ✅ **GetX** para state management e DI
- ✅ **Drift** para banco de dados local
- ✅ **Dio** para requisições HTTP

### Boas Práticas

1. **Sempre use LoggingMixin** em repositórios
2. **Cache dados frequentes** com CacheManager
3. **Observe conectividade** para sincronização
4. **Logs estruturados** com AppLogger
5. **Segurança** com TokenManager e SecureStorage

---

## 📞 Contato

Dúvidas sobre a documentação? Entre em contato com a equipe de desenvolvimento.

---

## 📝 Atualização da Documentação

Esta documentação deve ser mantida atualizada conforme o projeto evolui:

- ✅ Sempre documente novos componentes
- ✅ Atualize exemplos quando mudar APIs
- ✅ Remova documentação obsoleta
- ✅ Mantenha o README.md como índice principal
