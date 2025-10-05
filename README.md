# nexa_app

A new Flutter project.

## Notas de manutenção recentes

- 2025-10-05: O serviço de checklist passou a reutilizar em memória as opções
  de resposta buscadas por modelo, evitando consultas repetidas ao banco durante
  a montagem das perguntas. Essa estratégia mantém a compatibilidade com futuros
  cenários onde cada pergunta possua subconjuntos específicos, pois o cache é
  distribuído via mapa antes do loop principal.
