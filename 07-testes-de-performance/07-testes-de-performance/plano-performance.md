# Plano de Testes de Performance

## Objetivo
Validar o desempenho e a estabilidade da API de exclusão de beneficiários sob diferentes condições de carga, simulando operações em massa.

## Ambiente de Teste

| Item | Detalhe |
|---|---|
| **Ambiente** | Homologação |
| **Endpoint testado** | `POST /api/v1/beneficiarios/exclusao` |
| **Ferramenta** | k6 ([k6.io](https://k6.io)) |
| **Massa de dados** | 1.000 CPFs sintéticos dedicados a teste de carga, isolados dos dados usados em testes funcionais (ver `script-k6.js`) |

## Cenários de Carga

| Cenário | Usuários Simultâneos | Duração | Meta P95 | Meta Erro |
|---|---|---|---|---|
| Carga Normal | 10 | 2 min | < 500ms | < 0.5% |
| Carga Alta | 100 | 5 min | < 1000ms | < 1% |
| Pico (1000 vidas) | 1000 | 5 min | < 3000ms | < 1% |

> "Vidas" é o termo do setor de saúde suplementar para beneficiários cobertos por um plano — o cenário de pico simula a exclusão simultânea de 1.000 vidas, um volume realista em uma operação de reajuste de carteira ou migração de plano.

## Critérios de Aceite
- Taxa de erro abaixo de 1% em todos os cenários
- Tempo de resposta P95 dentro das metas da tabela acima
- Nenhuma falha crítica (500) durante o pico
- Cada requisição usa um beneficiário distinto (sem contenção por reuso de CPF)

## Riscos Identificados

| Risco | Mitigação |
|---|---|
| Reuso do mesmo registro entre requisições simultâneas distorce a taxa de erro | Massa de dados dedicada com 1.000 CPFs únicos (ver `script-k6.js`) |
| Ambiente de homologação com recursos limitados comparado à produção | Resultados tratados como indicativos, não absolutos; recomenda-se repetir em ambiente de pré-produção antes do go-live |
| Dados de teste poluindo a base de homologação após a execução | Rotina de limpeza (`DELETE`/rollback) executada após cada rodada de teste |

## Observações Pós-Execução
Após cada rodada, registrar nesta seção: data da execução, versão testada, resultados obtidos (P95 real, taxa de erro real) e decisão (aprovado / aprovado com ressalvas / reprovado).
