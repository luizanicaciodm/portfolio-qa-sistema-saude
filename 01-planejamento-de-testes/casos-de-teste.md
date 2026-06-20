# Casos de Teste — Sistema de Saúde

> Documento de casos de teste funcionais e de regras de negócio para o sistema de gestão de saúde.
> Ambiente: Homologação | Status: ✅ Todos executados | Total: 4 casos

---

## CT-001 — Cadastro de Beneficiário com Dados Válidos

| Campo | Valor |
|---|---|
| **Tipo** | Positivo — Fluxo Principal |
| **Prioridade** | Alta |
| **Pré-condição** | Usuário autenticado no sistema com perfil de operador |
| **Pós-condição** | Beneficiário registrado no banco com `status = ATIVO` |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Acessar o formulário de cadastro de beneficiário | Formulário exibido corretamente com todos os campos obrigatórios |
| 2 | Preencher CPF válido: `123.456.789-09` | Campo aceita o valor e valida o formato |
| 3 | Preencher nome: `Maria Teste da Silva` | Campo aceita o valor sem restrições |
| 4 | Selecionar plano: `Plano Bronze` | Plano selecionado com sucesso |
| 5 | Clicar em "Salvar" | Beneficiário cadastrado, ID gerado, mensagem de sucesso exibida |
| 6 | Validar no banco | `SELECT status, id FROM beneficiarios WHERE cpf = '12345678909'` retorna `status = ATIVO` e `id` não nulo |

**Resultado:** ✅ PASSOU

---

## CT-002 — Exclusão com Motivo ÓBITO e Data Preenchida

| Campo | Valor |
|---|---|
| **Tipo** | Positivo — Regra de Negócio |
| **Prioridade** | Alta |
| **Pré-condição** | Beneficiário ativo cadastrado com CPF `123.456.789-09`; usuário autenticado com perfil de exclusão |
| **Pós-condição** | Registro atualizado no banco com `status = EXCLUIDO` e `data_obito` preenchida |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar `POST /api/v1/beneficiarios/exclusao` | Endpoint disponível e acessível |
| 2 | Body: `{ "cpf": "123.456.789-09", "motivo": "OBITO", "data_exclusao": "2025-06-01", "data_obito": "2025-06-01" }` | API recebe o request |
| 3 | Verificar status HTTP da resposta | `200 OK` |
| 4 | Verificar mensagem de retorno | JSON com campo `"mensagem": "Beneficiário excluído com sucesso"` |
| 5 | Validar no banco | `SELECT status, data_obito FROM beneficiarios WHERE cpf = '12345678909'` retorna `status = EXCLUIDO` e `data_obito = 2025-06-01` |

**Resultado:** ✅ PASSOU

---

## CT-003 — Exclusão com Motivo ÓBITO Sem Data de Óbito (Negativo)

| Campo | Valor |
|---|---|
| **Tipo** | Negativo — Validação de Regra de Negócio |
| **Prioridade** | Alta |
| **Pré-condição** | Beneficiário ativo cadastrado com CPF `123.456.789-09`; usuário autenticado com perfil de exclusão |
| **Pós-condição** | Nenhuma alteração no banco — beneficiário permanece com `status = ATIVO` |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar `POST /api/v1/beneficiarios/exclusao` | Endpoint disponível e acessível |
| 2 | Body: `{ "cpf": "123.456.789-09", "motivo": "OBITO", "data_exclusao": "2025-06-01" }` (sem `data_obito`) | API recebe o request |
| 3 | Verificar status HTTP da resposta | `400 Bad Request` |
| 4 | Verificar mensagem de erro | JSON contém: `"data_obito é obrigatória quando motivo = OBITO"` |
| 5 | Validar que banco não foi alterado | `SELECT status FROM beneficiarios WHERE cpf = '12345678909'` retorna `status = ATIVO` (sem alteração) |

**Resultado:** ✅ PASSOU

---

## CT-004 — CPF Inválido na Exclusão (Negativo)

| Campo | Valor |
|---|---|
| **Tipo** | Negativo — Validação de Dados |
| **Prioridade** | Alta |
| **Pré-condição** | Usuário autenticado com perfil de exclusão; CPF inválido `000.000.000-00` não existe no banco |
| **Pós-condição** | Nenhuma alteração no banco — nenhum registro é afetado |

| Passo | Ação | Resultado Esperado |
|---|---|---|
| 1 | Enviar `POST /api/v1/beneficiarios/exclusao` com `cpf: "000.000.000-00"` | API recebe o request |
| 2 | Verificar status HTTP da resposta | `422 Unprocessable Entity` |
| 3 | Verificar mensagem de erro | JSON contém: `"CPF inválido ou inexistente"` |
| 4 | Validar que nenhum registro foi afetado | `SELECT COUNT(*) FROM beneficiarios WHERE status_changed_at > NOW() - INTERVAL 1 minute` retorna `0` |

**Resultado:** ✅ PASSOU

---

## Resumo de Cobertura

| Tipo | Total | Passaram | Taxa |
|---|---|---|---|
| Positivos | 2 | 2 | 100% |
| Negativos | 2 | 2 | 100% |
| **Total** | **4** | **4** | **100%** |

**Áreas cobertas:**
- ✅ Cadastro de beneficiário
- ✅ Exclusão com óbito (fluxo válido)
- ✅ Validação de campo obrigatório condicional
- ✅ Validação de formato de CPF
