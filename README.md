# Nexa App

Aplicativo Flutter organizado em módulos orientados a fluxo, com gerenciamento
reativo de estado via GetX e persistência local através do Drift. Este guia
resume as principais decisões arquiteturais, responsabilidades por camada e
boas práticas adotadas para manter o código reutilizável e sustentável.

## Sumário

- [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
  - [Camadas principais](#camadas-principais)
  - [Fluxo de dados](#fluxo-de-dados)
- [Estrutura de Pastas](#estrutura-de-pastas)
  - [Core](#core)
  - [Modules](#modules)
  - [Widgets Compartilhados](#widgets-compartilhados)
- [Serviços e Padrões de Reuso](#serviços-e-padrões-de-reuso)
  - [Abrir Turno](#abrir-turno)
  - [Checklist](#checklist)
- [Banco de Dados e Sincronização](#banco-de-dados-e-sincronização)
- [Orientações para Novos Módulos](#orientações-para-novos-módulos)
- [Boas Práticas Gerais](#boas-práticas-gerais)
- [Testes e Qualidade](#testes-e-qualidade)

## Visão Geral da Arquitetura

### Camadas principais

| Camada  | Responsabilidade                                                                 |
|---------|-----------------------------------------------------------------------------------|
| **UI**  | Widgets, páginas e controllers GetX focados em interação e estado da tela.       |
| **Services** | Orquestra lógica de negócio utilizando repositórios e coordenando controllers. |
| **Domain/Repositories** | Exposição de operações de dados (Drift + Dio) via contratos fortemente tipados. |
| **Infra** | Implementações de banco (`core/database`) e cliente HTTP (`core/utils/network`). |

### Fluxo de dados

1. A UI interage com **controllers** GetX (por exemplo `AbrirTurnoController`).
2. Controllers delegam lógica pesada para **services** (`AbrirTurnoService`,
   `ChecklistService`), que concentram orquestrações.
3. Services consomem **repositórios de domínio**, responsáveis por consultar o
   banco local (Drift) ou APIs via Dio.
4. Models de domínio são repassados à UI para renderização, mantendo as páginas
   desacopladas de detalhes de infraestrutura.

## Estrutura de Pastas

```
lib/
├── core/
│   ├── core_app/        # Bindings, controllers e serviços globais
│   ├── database/        # Definições do Drift e DAOs
│   ├── domain/          # DTOs, models e repositórios
│   ├── middlewares/     # Middlewares GetX
│   ├── sync/            # Serviços auxiliares de sincronização
│   └── utils/           # Helpers, loggers, formatadores
├── modules/
│   └── turno/           # Fluxos específicos do domínio de turnos
│       ├── abrir/       # Abertura de turno (UI + Service + Validators)
│       └── checklist/   # Checklist do turno ativo
├── routes/              # Definição central das rotas
└── widgets/             # Componentes reutilizáveis (ex.: dropdown pesquisável)
```

### Core

- **`core_app/bindings/initial_binding.dart`** registra dependências globais
  (Drift, Dio, repositórios compartilhados, `TurnoController`, etc.).
- **`core_app/controllers/`** concentra controladores acessíveis em todo o app.
- **`domain/`** define DTOs para persistência, models de domínio usados na UI e
  repositórios que encapsulam regras de acesso a dados.

### Modules

Cada módulo agrupa binding, controller, service, páginas e validadores de um
fluxo específico. O módulo `turno` possui submódulos:

- `abrir/`: fluxo de abertura de turno, com service especializado e validators.
- `checklist/`: montagem e exibição do checklist vinculado ao turno ativo.

### Widgets Compartilhados

Componentes genéricos ficam em `lib/widgets/`. O
`SearchableDropdownController` abstrai listas pesquisáveis com debounce e
suporte a consulta remota.

## Serviços e Padrões de Reuso

### Abrir Turno

O `AbrirTurnoService` recebeu injeção de dependências por construtor e um cache
em memória para evitar requisições duplicadas ao digitar nos dropdowns. O
service expõe métodos tipados e um value object (`AbrirTurnoDados`) que agrupa
veículos, equipes e eletricistas:

- `buscarVeiculos/Eletricistas/Equipes({forceRefresh})`: reaproveita a última
  consulta quando possível.
- `buscarDadosIniciais()`: retorna um pacote completo pronto para alimentar a
  UI, garantindo consistência entre listas.
- `limparCache()`: permite invalidar o cache em cenários de sincronização ou
  troca de usuário.

O `AbrirTurnoController` consome esse pacote e mantém um cache local para os
métodos de busca do dropdown, reduzindo acoplamento entre UI e serviço e
reforçando a reutilização de dados.

### Checklist

O `ChecklistService` continua responsável por montar checklists completos a
partir de repositórios de modelo, perguntas e opções. A lógica de montagem está
isolada do restante da aplicação, permitindo testes unitários com fakes e
facilitando a substituição dos repositórios no futuro.

## Banco de Dados e Sincronização

- O projeto utiliza **Drift** como camada de persistência. Os DTOs em
  `core/domain/dto` refletem as tabelas e são usados pelos repositórios.
- Repositórios implementam contratos de sincronização (`SyncableRepository`),
  viabilizando fluxos offline-first.
- O `SyncService` coordena sincronizações e pode ser extendido para consumir os
  caches expostos pelos services.

## Orientações para Novos Módulos

1. **Crie uma pasta em `lib/modules/<feature>`** com subpastas para `binding`,
   `controller`, `service`, `pages` e `validators`.
2. **Registre dependências no binding** usando injeção por construtor para
   facilitar testes.
3. **Mantenha controllers enxutos**, delegando lógica para services ou use-cases.
4. **Defina models/DTOs dedicados** caso seja necessário transitar dados entre
   camadas (sem usar mapas dinâmicos).
5. **Atualize as rotas** em `lib/routes/routes.dart` e utilize as constantes em
   toda a navegação.
6. **Documente o módulo** adicionando comentários de propósito e fluxos
   principais nos arquivos alterados.

## Boas Práticas Gerais

- Prefira **injeção por construtor** em services para viabilizar testes.
- Utilize **logs do `AppLogger`** para rastrear fluxos críticos e diagnósticos.
- Evite acoplamento da UI com DTOs crus; converta-os em models amigáveis quando
  necessário.
- Centralize validações em classes utilitárias (ex.: `TurnoValidator`).
- Reaproveite componentes reativos (`SearchableDropdownController`) para manter
  consistência na UX.

## Testes e Qualidade

- Utilize `flutter analyze` para garantir que o código segue as regras do
  projeto.
- Tests unitários podem ser adicionados em `test/`, seguindo o padrão usado
  para `ChecklistService`.
- Para validar fluxos manuais:
  1. Abra o app e autentique.
  2. No módulo de turno, confirme se os dropdowns carregam com agilidade graças
     ao cache do `AbrirTurnoService`.
  3. Abra um turno e verifique a navegação para o checklist.

> Em ambientes sem o SDK do Flutter instalado, foque em revisão estática e nos
> logs emitidos pelas camadas de serviço.
