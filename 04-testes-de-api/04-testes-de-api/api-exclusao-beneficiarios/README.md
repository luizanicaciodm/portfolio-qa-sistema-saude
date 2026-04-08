# Testes de API — Exclusão de Beneficiários

## Endpoint
```
POST /api/v1/beneficiarios/exclusao
Base URL: https://api.sistema-saude.com
```

## Headers
```
Content-Type: application/json
Authorization: Bearer {token}
```

## Corpo da Requisição
```json
{
  "cpf": "string (obrigatório)",
  "motivo": "DEMISSAO | OBITO | APOSENTADORIA | TRANSFERENCIA",
  "data_exclusao": "YYYY-MM-DD (obrigatório)",
  "data_obito": "YYYY-MM-DD (obrigatório se motivo = OBITO)"
}
```

## Cenários de Teste

| ID | Cenário | Dados de Entrada | Status Esperado | Resultado |
|---|---|---|---|---|
| API-001 | Exclusão válida — DEMISSAO | motivo=DEMISSAO, data_exclusao preenchida | 200 OK | ✅ PASSOU |
| API-002 | Exclusão válida — OBITO com data | motivo=OBITO, data_obito preenchida | 200 OK | ✅ PASSOU |
| API-003 | OBITO sem data_obito | motivo=OBITO, sem data_obito | 400 Bad Request | ✅ PASSOU |
| API-004 | CPF inválido | cpf=000.000.000-00 | 422 Unprocessable | ✅ PASSOU |
| API-005 | Beneficiário não encontrado | cpf inexistente | 404 Not Found | ✅ PASSOU |
| API-006 | Body vazio | {} | 400 Bad Request | ✅ PASSOU |
| API-007 | Token inválido | Authorization: Bearer token_errado | 401 Unauthorized | ✅ PASSOU |
| API-008 | Motivo inválido | motivo=INVALIDO | 422 Unprocessable | ✅ PASSOU |

## Arquivo de Coleção
A coleção completa do Postman está no arquivo `colecao-postman.json`.
Para importar: Postman → Import → selecione o arquivo.