# Plano de Teste — Sistema de Saúde

> Documento formal de planejamento da estratégia de testes para o sistema de gestão de saúde.
> Versão: 1.0 | Elaborado por: Luiza Nicácio | Data: 2025-06

---

## 1. Objetivo

Validar as funcionalidades críticas do sistema de gestão de saúde, garantindo integridade dos dados, aplicação correta das regras de negócio e segurança das informações dos beneficiários.

---

## 2. Escopo

### ✅ Em escopo

- Cadastro e exclusão de beneficiários
- API de exclusão (endpoint `POST /api/v1/beneficiarios/exclusao`)
- Validações de banco de dados pós-operação
- Regras de negócio: campos obrigatórios e condicionais
- Testes de segurança: SQL Injection, LGPD e controle de acesso

### ❌ Fora de escopo

- Módulo financeiro / faturamento
- Integração com sistemas externos reais (TISS, ANS)
- Testes em ambiente de produção

---

## 3. Ambiente de Teste

| Item | Detalhe |
|---|---|
| **Ambiente** | Homologação |
| **URL Base** | `https://homolog.sistema-saude.com` |
| **Browser** | Google Chrome 124+ ou Firefox 125+ |
| **Sistema Operacional** | Windows 11 / macOS 13+ / Ubuntu 22.04 |
| **Versão do Sistema** | v2.4.1 |
| **Banco de Dados** | PostgreSQL 15 (acesso via CLI ou DBeaver) |
| **Massa de Dados** | CPFs válidos gerados especificamente para testes; dados fictícios sem relação com pessoas reais |

---

## 4. Tipos de Teste e Ferramentas

| Tipo | Ferramenta | Responsável | Prioridade |
|---|---|---|---|
| Funcional | Manual | QA | Alta |
| API | Postman | QA | Alta |
| Banco de Dados | SQL (DBeaver / psql) | QA | Alta |
| Segurança | Manual + Payloads | QA | Alta |
| E2E | Cypress | QA | Média |
| Performance | k6 | QA | Média |

---

## 5. Critérios de Entrada

- Ambiente de homologação configurado, acessível e com conexão de banco de dados validada
- Documentação de requisitos disponível e aprovada pelo PO
- Massa de dados de teste preparada (CPFs válidos, beneficiários de teste)
- Credenciais de acesso (usuário QA com perfil de operador e exclusão)
- Coleção Postman atualizada com endpoints vigentes

---

## 6. Critérios de Saída

- 100% dos casos de teste executados
- Zero defeitos de alta severidade em aberto
- Relatório de execução gerado com evidências (prints, queries executadas)
- Checklists de regressão preenchidos e validados

---

## 7. Critérios de Severidade de Defeitos

| Severidade | Descrição | Exemplos | Bloqueador? |
|---|---|---|---|
| **Crítico** | Funcionalidade principal quebrada; dados inconsistentes ou em risco | Exclusão de beneficiário sem validação; CPF exposto em log | Sim — bloqueia release |
| **Alto** | Funcionalidade importante com comportamento incorreto | Validação de campo condicional não dispara erro | Sim — deve corrigir |
| **Médio** | Funcionalidade afetada mas com workaround disponível | Mensagem de erro genérica; layout desalinhado | Não — pode ir para próxima versão |
| **Baixo** | Problema cosmético ou de melhor apresentação | Typo em rótulo; cor de botão não corresponde ao design | Não — baixa prioridade |

---

## 8. Riscos Identificados

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Exclusão indevida de beneficiário ativo | Alta | Crítico | Validação dupla na API + validação no banco pós-operação |
| Dados inconsistentes após operações | Média | Alto | Queries de validação estruturadas em cada caso de teste |
| CPF exposto em texto claro nos logs | Baixa | Crítico | Testes de segurança com verificação de mascaramento |
| Indisponibilidade do ambiente de homologação | Média | Alto | Comunicação antecipada com time de infra; agenda flexível |

---

## 9. Cronograma Estimado

| Fase | Atividade | Duração Estimada |
|---|---|---|
| **1** | Planejamento, escrita de casos e preparação de massa de dados | 2 dias |
| **2** | Execução de testes funcionais e de API | 3 dias |
| **3** | Execução de testes de banco de dados | 1 dia |
| **4** | Testes de segurança | 1 dia |
| **5** | Consolidação de evidências e relatório final | 1 dia |
| **Total** | | **8 dias úteis** |

> ⚠️ **Nota:** Cronograma é estimado com base em execução individual. Sujeito a ajuste conforme disponibilidade do ambiente e volume de defeitos encontrados.

---

## 10. Responsabilidades

- **QA (Luiza Nicácio):** Planejamento, execução, documentação e reporte de todos os testes
- **Dev:** Correção de defeitos encontrados
- **Infra:** Garantir disponibilidade e acesso ao ambiente de homologação
- **PO:** Esclarecimento de dúvidas sobre requisitos
