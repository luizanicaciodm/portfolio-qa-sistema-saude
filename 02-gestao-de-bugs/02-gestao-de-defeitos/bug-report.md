# Relatório de Defeitos — Sistema de Saúde

---

## BUG-001 — API aceita exclusão com CPF em formato inválido

| Campo | Informação |
|---|---|
| **ID** | BUG-001 |
| **Data** | 2025-07-01 |
| **Severidade** | Alta |
| **Prioridade** | Alta |
| **Status** | Aberto |
| **Ambiente** | Homologação |
| **Versão** | 1.2.0 |
| **Reportado por** | Luiza Nicácio (QA) |

### Descrição
A API de exclusão de beneficiários aceita e processa a requisição mesmo
quando o CPF enviado é inválido (ex: 000.000.000-00), retornando 200 OK.

### Passos para Reproduzir
1. Abrir o Postman
2. Fazer requisição POST para: `{{base_url}}/api/v1/beneficiarios/exclusao`
3. Adicionar header: `Content-Type: application/json`
4. Enviar body:
```json
{
  "cpf": "000.000.000-00",
  "motivo": "DEMISSAO",
  "data_exclusao": "2025-07-01"
}
```
5. Observar a resposta

### Resultado Atual
```json
{
  "status": 200,
  "mensagem": "Beneficiário excluído com sucesso",
  "id_exclusao": "EXC-9981"
}
```

### Resultado Esperado
```json
{
  "status": 422,
  "erro": "CPF inválido ou inexistente"
}
```

### Impacto no Negócio
Risco de exclusão de beneficiários indevidos por erro de digitação,
podendo gerar problemas regulatórios com a ANS.

### Evidência
- Screenshot da requisição no Postman: [evidencia-bug001.png]

---

## BUG-002 — Campo data_obito não é validado quando motivo = OBITO

| Campo | Informação |
|---|---|
| **ID** | BUG-002 |
| **Data** | 2025-07-02 |
| **Severidade** | Crítica |
| **Prioridade** | Urgente |
| **Status** | Em Correção |

### Descrição
Quando o motivo de exclusão é "OBITO", o campo data_obito deveria ser
obrigatório. O sistema, porém, processa a exclusão sem esse campo.

### Passos para Reproduzir
1. POST /api/v1/beneficiarios/exclusao
2. Body: { "cpf": "123.456.789-09", "motivo": "OBITO" }
3. Não incluir o campo data_obito

### Resultado Atual
HTTP 200 OK — exclusão processada sem data_obito

### Resultado Esperado
HTTP 400 Bad Request — "data_obito é obrigatória quando motivo = OBITO"

### Impacto
Registros de óbito sem data comprometem a auditoria e os relatórios
regulatórios enviados à ANS.