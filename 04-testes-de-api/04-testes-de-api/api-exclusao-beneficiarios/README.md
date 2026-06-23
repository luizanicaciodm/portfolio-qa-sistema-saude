# 🔌 Testes de API — Exclusão de Beneficiários

> Documentação e cenários de teste para o endpoint de exclusão de beneficiários, cobrindo fluxos válidos, regras de negócio e tratamento de erros.

---

## 📋 Endpoint

| Item | Detalhe |
|---|---|
| **Método** | `POST` |
| **Endpoint** | `/api/v1/beneficiarios/exclusao` |
| **Base URL** | `https://api.sistema-saude.com` |
| **Autenticação** | Bearer Token |

## 🔐 Headers

```http
Content-Type: application/json
Authorization: Bearer {token}
```

## 📦 Corpo da Requisição

```json
{
  "cpf": "string (obrigatório)",
  "motivo": "DEMISSAO | OBITO | APOSENTADORIA | TRANSFERENCIA",
  "data_exclusao": "YYYY-MM-DD (obrigatório)",
  "data_obito": "YYYY-MM-DD (obrigatório somente se motivo = OBITO)"
}
```
---

## 🧪 Cenários de Teste

| ID | Cenário | Dados de Entrada | Status Esperado | Resultado |
|---|---|---|---|---|
| API-001 | Exclusão válida — Demissão | `motivo=DEMISSAO`, `data_exclusao` preenchida | `200 OK` | ✅ PASSOU |
| API-002 | Exclusão válida — Óbito com data | `motivo=OBITO`, `data_obito` preenchida | `200 OK` | ✅ PASSOU |
| API-003 | Óbito sem `data_obito` | `motivo=OBITO`, campo ausente | `400 Bad Request` | ✅ PASSOU |
| API-004 | CPF inválido | `cpf=000.000.000-00` | `422 Unprocessable Entity` | ✅ PASSOU |
| API-005 | Beneficiário não encontrado | CPF inexistente na base | `404 Not Found` | ✅ PASSOU |
| API-006 | Body vazio | `{}` | `400 Bad Request` | ✅ PASSOU |
| API-007 | Token inválido | `Authorization: Bearer token_invalido` | `401 Unauthorized` | ✅ PASSOU |
| API-008 | Motivo inválido | `motivo=INVALIDO` | `422 Unprocessable Entity` | ✅ PASSOU |

**Cobertura:** 8/8 cenários documentados — todos presentes na coleção Postman.

---

## 📁 Coleção Postman

A coleção completa, com os **8 cenários acima já implementados**, está em [`colecao-postman.json`](./colecao-postman.json).

**Como importar:**
1. Abra o Postman → **Import** → selecione `colecao-postman.json`
2. Configure a variável `token` (canto superior direito → ícone de olho → editar) com um token válido do ambiente de homologação
3. Execute individualmente ou use o **Collection Runner** para rodar todos os 8 cenários em sequência

> ⚠️ **Atenção:** testes executados em ambiente de homologação. Não executar em produção sem validação prévia com o time responsável.
