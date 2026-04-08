# Testes de Segurança — Sistema de Saúde

> ⚠️ Testes executados em ambiente de homologação controlado.
> Nunca realizar em produção sem autorização.

---

## 1. SQL Injection

| ID | Payload Testado | Campo | Resultado Esperado | Resultado Obtido |
|---|---|---|---|---|
| SEC-001 | `' OR '1'='1` | cpf | 422 — Input inválido | ✅ 422 |
| SEC-002 | `'; DROP TABLE beneficiarios;--` | cpf | 422 — Input inválido | ✅ 422 |
| SEC-003 | `' UNION SELECT * FROM usuarios--` | cpf | 422 — Input inválido | ✅ 422 |

---

## 2. Dados Sensíveis e LGPD

| ID | Verificação | Resultado Esperado | Resultado Obtido |
|---|---|---|---|
| SEC-010 | CPF mascarado na resposta da API (ex: ***456***) | Mascarado | ✅ Conforme |
| SEC-011 | CPF não aparece em texto claro nos logs do sistema | Não aparece | ✅ Conforme |
| SEC-012 | Token de acesso expira em 1 hora | Expira em 1h | ✅ Conforme |
| SEC-013 | Dados pessoais não retornados em mensagens de erro | Não retornados | ✅ Conforme |

---

## 3. Controle de Acesso

| ID | Cenário | Status Esperado | Status Obtido |
|---|---|---|---|
| SEC-020 | Requisição sem token no header | 401 Unauthorized | ✅ 401 |
| SEC-021 | Token de outro usuário (diferente nível de acesso) | 403 Forbidden | ✅ 403 |
| SEC-022 | Token expirado | 401 Unauthorized | ✅ 401 |
| SEC-023 | Usuário sem perfil de exclusão tenta excluir beneficiário | 403 Forbidden | ✅ 403 |