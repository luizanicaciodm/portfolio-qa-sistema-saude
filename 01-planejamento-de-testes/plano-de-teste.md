# Plano de Teste — Sistema de Saúde

## 1. Objetivo
Validar as funcionalidades críticas do sistema de gestão de saúde,
garantindo integridade dos dados, aplicação das regras de negócio
e segurança das informações dos beneficiários.

## 2. Escopo

### ✅ Em escopo
- Cadastro e exclusão de beneficiários
- API de exclusão (endpoint `/api/v1/beneficiarios/exclusao`)
- Validações de banco de dados
- Regras clínicas: resultados laboratoriais críticos
- Testes de segurança: SQL Injection e dados sensíveis (CPF)

### ❌ Fora de escopo
- Módulo financeiro / faturamento
- Integração com sistemas externos reais (TISS, ANS)

## 3. Tipos de Teste e Ferramentas

| Tipo | Ferramenta | Responsável | Prioridade |
|---|---|---|---|
| Funcional | Manual | QA | Alta |
| API | Postman | QA | Alta |
| Banco de Dados | SQL | QA | Alta |
| E2E | Cypress | QA | Média |
| Performance | k6 | QA | Média |
| Segurança | Manual + Payloads | QA | Alta |

## 4. Critérios de Entrada
- Ambiente de teste configurado e acessível
- Documentação de requisitos disponível e aprovada
- Massa de dados de teste preparada
- Acesso ao banco de dados de homologação confirmado

## 5. Critérios de Saída
- 100% dos casos de teste críticos (alta prioridade) executados
- Zero defeitos críticos em aberto
- Relatório de testes gerado e aprovado
- Checklists de regressão preenchidos

## 6. Riscos Identificados

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Exclusão indevida de beneficiário | Alta | Crítico | Validação dupla na API + regras de negócio |
| Dados inconsistentes no banco | Média | Alto | Queries de validação pós-operação |
| CPF em texto claro nos logs | Baixa | Crítico | Testes de segurança e mascaramento |
| Resultado crítico sem alerta | Alta | Crítico | Validação automática de faixa de referência |

## 7. Cronograma Estimado

| Fase | Duração estimada |
|---|---|
| Planejamento e escrita de casos | 3 dias |
| Execução testes funcionais e API | 5 dias |
| Execução testes de banco | 2 dias |
| Testes de segurança e performance | 2 dias |
| Relatório e encerramento | 1 dia |