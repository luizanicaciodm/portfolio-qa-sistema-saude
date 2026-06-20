# Testes de Segurança — Sistema de Saúde

> ⚠️ Todos os testes foram executados exclusivamente em ambiente de homologação controlado.
> **Nunca executar em produção sem autorização formal do time responsável.**

---

## 📊 Resumo de Cobertura

| Categoria | Casos | Status | Resultado |
|---|---|---|---|
| SQL Injection | 3 | ✅ Todos testados | Conforme |
| Dados Sensíveis (LGPD) | 4 | ✅ Todos testados | Conforme |
| Controle de Acesso | 4 | ✅ Todos testados | Conforme |
| **Total** | **11** | **✅ 11/11** | **100% Conforme** |

---

## 1. SQL Injection

> **Objetivo:** Garantir que entradas maliciosas no campo `cpf` sejam sanitizadas e não manipulem o banco de dados.

| ID | Payload Testado | Campo | Resultado Esperado | Resultado Obtido |
|---|---|---|---|---|
| SEC-001 | `' OR '1'='1` | cpf | `422 Unprocessable Entity` | ✅ 422 |
| SEC-002 | `'; DROP TABLE beneficiarios;--` | cpf | `422 Unprocessable Entity` | ✅ 422 |
| SEC-003 | `' UNION SELECT * FROM usuarios--` | cpf | `422 Unprocessable Entity` | ✅ 422 |

**Validação adicional:** Após SEC-002, confirmar que a tabela `beneficiarios` permanece íntegra via `SELECT COUNT(*) FROM beneficiarios`.

---

## 2. Dados Sensíveis e LGPD

> **Objetivo:** Garantir que dados pessoais sensíveis (CPF, dados clínicos) sejam protegidos conforme a Lei Geral de Proteção de Dados Pessoais (LGPD).

| ID | Verificação | Resultado Esperado | Resultado Obtido |
|---|---|---|---|
| SEC-010 | CPF mascarado na resposta da API | Formato `***.***.***-**` — apenas estrutura visível | ✅ Conforme |
| SEC-011 | CPF não aparece em texto claro nos logs da aplicação | CPF ausente ou mascarado em todos os logs | ✅ Conforme |
| SEC-012 | Token de acesso expira após inatividade | Resposta `401 Unauthorized` após expiração (1 hora) | ✅ Conforme |
| SEC-013 | Dados pessoais não retornados em mensagens de erro | Mensagens de erro contêm apenas código e texto genérico | ✅ Conforme |

---

## 3. Controle de Acesso

> **Objetivo:** Garantir que apenas usuários autenticados e com perfil adequado conseguem executar operações sensíveis.

| ID | Cenário | Status Esperado | Status Obtido |
|---|---|---|---|
| SEC-020 | Requisição sem token no header `Authorization` | `401 Unauthorized` | ✅ 401 |
| SEC-021 | Token de outro usuário com nível de acesso inferior | `403 Forbidden` | ✅ 403 |
| SEC-022 | Token expirado (após 1 hora de inatividade) | `401 Unauthorized` | ✅ 401 |
| SEC-023 | Usuário sem perfil de exclusão tenta excluir beneficiário | `403 Forbidden` | ✅ 403 |

---

## Referências de Segurança

- OWASP Top 10 2023
- Lei Geral de Proteção de Dados Pessoais (LGPD) — Lei 13.709/2018
- ISO/IEC 27001 — Information Security Management
