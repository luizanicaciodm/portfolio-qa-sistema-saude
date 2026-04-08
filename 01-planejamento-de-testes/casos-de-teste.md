# Casos de Teste — Sistema de Saúde

---

## CT-001 — Cadastro de Beneficiário com Dados Válidos

| Campo | Valor |
|---|---|
| **Tipo** | Positivo — Fluxo Principal |
| **Prioridade** | Alta |
| **Pré-condição** | Usuário autenticado no sistema |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Acessar o formulário de cadastro de beneficiário | Formulário exibido corretamente com todos os campos |
| 2 | Preencher CPF válido: 123.456.789-09 | Campo aceita o valor e valida o formato |
| 3 | Preencher nome: Maria Teste da Silva | Campo aceita o valor |
| 4 | Selecionar plano: Plano Bronze | Plano selecionado com sucesso |
| 5 | Clicar em "Salvar" | Beneficiário cadastrado, ID gerado, mensagem de sucesso exibida |

**Resultado:** ✅ PASSOU

---

## CT-002 — Exclusão com Motivo ÓBITO e Data Preenchida

| Campo | Valor |
|---|---|
| **Tipo** | Positivo — Regra de Negócio |
| **Prioridade** | Alta |
| **Pré-condição** | Beneficiário ativo cadastrado com CPF 123.456.789-09 |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar POST /api/v1/beneficiarios/exclusao | Endpoint disponível |
| 2 | Body: { "cpf":"123.456.789-09", "motivo":"OBITO", "data_obito":"2025-06-01" } | API recebe o request |
| 3 | Verificar status HTTP | 200 OK |
| 4 | Verificar banco: campo status = EXCLUIDO | Registro atualizado corretamente |

**Resultado:** ✅ PASSOU

---

## CT-003 — Exclusão com Motivo ÓBITO SEM Data (Negativo)

| Campo | Valor |
|---|---|
| **Tipo** | Negativo — Validação de Regra de Negócio |
| **Prioridade** | Alta |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar POST /api/v1/beneficiarios/exclusao | Endpoint disponível |
| 2 | Body: { "cpf":"123.456.789-09", "motivo":"OBITO" } (sem data_obito) | API recebe o request |
| 3 | Verificar status HTTP | 400 Bad Request |
| 4 | Verificar mensagem de erro | "data_obito é obrigatória quando motivo = OBITO" |

**Resultado:** ✅ PASSOU

---

## CT-004 — CPF Inválido na Exclusão (Negativo)

| Campo | Valor |
|---|---|
| **Tipo** | Negativo — Validação de Dados |
| **Prioridade** | Alta |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar POST com cpf: "000.000.000-00" | API recebe o request |
| 2 | Verificar status HTTP | 422 Unprocessable Entity |
| 3 | Verificar mensagem | "CPF inválido ou inexistente" |

**Resultado:** ✅ PASSOU