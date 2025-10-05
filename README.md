# nexa_app

## Checklist Service – Guia rápido

O módulo de checklist foi atualizado para utilizar injeção de dependências via
construtor (`ChecklistService`). Isso permite substituir os repositórios por
fakes em testes e torna explícitas as camadas acessadas para montar o
checklist.

### Dependências injetadas

O serviço agora recebe os seguintes repositórios (registrados via `Get.find`):

- `ChecklistModeloRepo`
- `ChecklistPerguntaRepo`
- `ChecklistOpcaoRespostaRepo`
- `TurnoRepo`
- `VeiculoRepo`

### Fluxo interno

1. Buscar modelos pelo tipo de veículo através do `ChecklistModeloRepo`.
2. Validar a existência do `remoteId` e registrar logs diagnósticos.
3. Consultar perguntas e opções relacionadas ao modelo pelos respectivos
   repositórios.
4. Montar `ChecklistCompletoModel` com as perguntas e opções convertidas.
5. (Para o fluxo do turno ativo) consultar o turno vigente e o veículo
   associado antes de delegar para `buscarChecklistPorTipoVeiculo`.

### Testes

Foram adicionados testes unitários em
`test/modules/turno/checklist/checklist_service_test.dart`, com fakes que
simulam os repositórios. Execute-os com:

```bash
flutter test
```

> **Observação:** caso o SDK do Flutter não esteja disponível no ambiente,
> utilize o script como referência para um fluxo manual de validação. Ele
> demonstra claramente como configurar os fakes e quais cenários são cobertos.
