# Checklist de Regressão — Sistema de Saúde

**Data de execução:** ___/___/___
**Responsável QA:** _________________________
**Versão testada:** _________________________

---

## Módulo: Exclusão de Beneficiários

| # | Item de Verificação | OK | NOK | N/A | Observação |
|---|---|:---:|:---:|:---:|---|
| 1 | API retorna 200 para exclusão com dados válidos | | | | |
| 2 | Motivo OBITO sem data_obito retorna 400 | | | | |
| 3 | CPF inválido é rejeitado com 422 | | | | |
| 4 | Beneficiário inexistente retorna 404 | | | | |
| 5 | Token inválido retorna 401 | | | | |
| 6 | Registro de exclusão salvo no banco de dados | | | | |
| 7 | Status do beneficiário alterado para EXCLUIDO | | | | |
| 8 | Log de auditoria gerado com data e operador | | | | |

---

## Módulo: Resultados Laboratoriais

| # | Item de Verificação | OK | NOK | N/A | Observação |
|---|---|:---:|:---:|:---:|---|
| 1 | Resultado crítico gera alerta visível na tela | | | | |
| 2 | Alerta notifica o médico responsável | | | | |
| 3 | Exame PSA bloqueado para paciente do sexo feminino | | | | |
| 4 | Resultados são persistidos corretamente no banco | | | | |
| 5 | Glicose > 500 classificada como valor crítico | | | | |
| 6 | Glicose < 40 classificada como valor crítico | | | | |

---

**Resultado geral:** ⬜ APROVADO  ⬜ REPROVADO  ⬜ APROVADO COM RESSALVAS

**Assinatura QA:** _________________________  |  **Data:** ___/___/___