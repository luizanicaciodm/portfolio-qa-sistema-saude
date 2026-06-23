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
| **Caso de Teste Relacionado** | CT-004 |

### Descrição
A API de exclusão de beneficiários aceita e processa a requisição mesmo quando o CPF enviado é inválido (ex: `000.000.000-00`), retornando `200 OK`.

### Passos para Reproduzir
1. Abrir o Postman
2. Fazer requisição `POST` para `{{base_url}}/api/v1/beneficiarios/exclusao`
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

### Causa Raiz Provável
A validação de formato e existência do CPF parece ocorrer apenas no cadastro, não sendo reaplicada no endpoint de exclusão.

### Sugestão de Correção
Aplicar a mesma camada de validação de CPF (formato + existência em base) usada no cadastro também no fluxo de exclusão, antes de processar a alteração de status.

### Impacto no Negócio
Risco de exclusão de beneficiários indevidos por erro de digitação, podendo gerar problemas regulatórios com a ANS.

### Evidência
- Screenshot da requisição no Postman: `evidencia-bug001.png`

---

## BUG-002 — Campo data_obito não é validado quando motivo = OBITO

| Campo | Informação |
|---|---|
| **ID** | BUG-002 |
| **Data** | 2025-07-02 |
| **Severidade** | Crítica |
| **Prioridade** | Urgente |
| **Status** | Em Correção |
| **Ambiente** | Homologação |
| **Versão** | 1.2.0 |
| **Reportado por** | Luiza Nicácio (QA) |
| **Caso de Teste Relacionado** | CT-003 |

### Descrição
Quando o motivo de exclusão é `OBITO`, o campo `data_obito` deveria ser obrigatório. O sistema, porém, processa a exclusão sem esse campo.

### Passos para Reproduzir
1. Fazer requisição `POST` para `{{base_url}}/api/v1/beneficiarios/exclusao`
2. Enviar body:
```json
{
  "cpf": "123.456.789-09",
  "motivo": "OBITO"
}
```
3. Observar a resposta (campo `data_obito` ausente)

### Resultado Atual
```json
{
  "status": 200,
  "mensagem": "Beneficiário excluído com sucesso"
}
```

### Resultado Esperado
```json
{
  "status": 400,
  "erro": "data_obito é obrigatória quando motivo = OBITO"
}
```

### Causa Raiz Provável
A regra condicional (`data_obito` obrigatória apenas quando `motivo = OBITO`) provavelmente não foi implementada na camada de validação do backend — apenas os campos sempre-obrigatórios (`cpf`, `motivo`, `data_exclusao`) estão sendo checados.

### Sugestão de Correção
Adicionar validação condicional no schema de entrada da API: se `motivo == "OBITO"`, então `data_obito` passa a ser obrigatório.

### Impacto no Negócio
Registros de óbito sem data comprometem a auditoria e os relatórios regulatórios enviados à ANS.

### Evidência
- Resposta da API capturada no Postman: `evidencia-bug002.png`

---

## BUG-003 — Resultado crítico de Potássio não gera notificação ao médico

| Campo | Informação |
|---|---|
| **ID** | BUG-003 |
| **Data** | 2025-07-03 |
| **Severidade** | Crítica |
| **Prioridade** | Urgente |
| **Status** | Aberto |
| **Ambiente** | Homologação |
| **Versão** | 1.2.0 |
| **Reportado por** | Luiza Nicácio (QA) |
| **Caso de Teste Relacionado** | CL-005 (ver `regras-clinicas-laboratoriais.md`) |

### Descrição
Um resultado de Potássio com valor `7,0 mEq/L` (crítico alto, acima de 6,5 mEq/L conforme regra clínica documentada) gera o alerta visual na tela do paciente, mas **nenhuma notificação é enviada ao médico solicitante** — que é uma ação obrigatória para esse tipo de resultado.

### Passos para Reproduzir
1. Cadastrar resultado laboratorial: `exame = POTASSIO`, `valor_resultado = 7.0`
2. Verificar alerta na tela do paciente
3. Verificar tabela de notificações no banco

### Resultado Atual
- Alerta visual exibido na tela (`alerta_gerado = 'SIM'`)
- Nenhum registro correspondente na tabela `notificacoes_medicas`

### Resultado Esperado
- Alerta visual exibido na tela
- Registro criado em `notificacoes_medicas` com o médico solicitante como destinatário, em até 1 minuto após o resultado ser salvo

### Causa Raiz Provável
A lógica de exibição do alerta na interface foi implementada, mas o disparo da notificação assíncrona (e-mail ou push) ao médico responsável não foi conectado ao evento de alerta crítico.

### Sugestão de Correção
Implementar um listener/trigger que, ao marcar `alerta_gerado = 'SIM'`, dispare a criação do registro de notificação e o envio ao médico solicitante.

### Impacto no Negócio
Risco clínico direto — um valor crítico de potássio pode indicar risco de arritmia cardíaca grave. A ausência de notificação ao médico pode retardar uma intervenção necessária.

### Evidência
- Esta falha **não é capturada** pela query de validação existente (consulta 4 de `queries-validacao.sql`), que verifica apenas se o alerta foi gerado — não se a notificação foi enviada. Por isso, uma nova query (consulta 7) foi adicionada ao arquivo de validações para cobrir esse cenário.
