# Plano de Testes de Performance

## Objetivo
Validar o desempenho e a estabilidade da API de exclusão de beneficiários
sob diferentes condições de carga, simulando operações em massa.

## Cenários de Carga

| Cenário | Usuários Simultâneos | Duração | Meta P95 | Meta Erro |
|---|---|---|---|---|
| Carga Normal | 10 | 2 min | < 500ms | < 0.5% |
| Carga Alta | 100 | 5 min | < 1000ms | < 1% |
| Pico (1000 vidas) | 1000 | 5 min | < 3000ms | < 1% |

## Critérios de Aceite
- Taxa de erro abaixo de 1% em todos os cenários
- Tempo de resposta P95 dentro das metas da tabela acima
- Nenhuma falha crítica (500) durante o pico

## Ferramenta
k6 — https://k6.io