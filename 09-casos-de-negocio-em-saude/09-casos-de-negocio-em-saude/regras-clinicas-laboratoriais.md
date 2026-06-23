# Casos de Negócio — Saúde e Análises Clínicas

> 💡 Este módulo aplica conhecimento prático em análises clínicas e
> garantia da qualidade laboratorial para definir cenários de teste
> que vão além da validação técnica.

---

## 🩸 1. Valores de Referência e Resultados Críticos

**Regra de negócio:** Todo resultado laboratorial fora da faixa crítica deve gerar alerta imediato e bloquear a liberação automática.

| Exame | Unidade | Crítico Baixo | Normal (Adulto) | Crítico Alto | Ação Obrigatória |
|---|---|---|---|---|---|
| Glicose | mg/dL | < 40 | 70 — 99 | > 500 | Alerta + notif. médico |
| Potássio | mEq/L | < 2,5 | 3,5 — 5,0 | > 6,5 | Alerta + notif. médico |
| Hemoglobina (F) | g/dL | < 5,0 | 12,0 — 16,0 | > 20,0 | Alerta urgente |
| Hemoglobina (M) | g/dL | < 5,0 | 13,5 — 17,5 | > 20,0 | Alerta urgente |
| Plaquetas | /mm³ | < 20.000 | 150.000 — 400.000 | > 1.000.000 | Alerta urgente |
| Creatinina | mg/dL | < 0,4 | 0,6 — 1,2 | > 10,0 | Alerta + revisão |

### Cenários de Teste Derivados

| ID | Cenário | Resultado Esperado |
|---|---|---|
| CL-001 | Glicose = 35 mg/dL cadastrada | Sistema gera alerta CRÍTICO BAIXO |
| CL-002 | Glicose = 550 mg/dL cadastrada | Sistema gera alerta CRÍTICO ALTO |
| CL-003 | Glicose = 90 mg/dL (normal) | Nenhum alerta, liberação automática |
| CL-004 | Plaquetas = 15.000 /mm³ | Alerta URGENTE + bloqueio de liberação |
| CL-005 | Potássio = 7,0 mEq/L | Alerta + notificação médica obrigatória |

---

## 🔬 2. Inconsistência Sexo x Tipo de Exame

**Regra de negócio:** Exames específicos por sexo devem ser sinalizados ou bloqueados quando incompatíveis com o paciente cadastrado.

| Exame | Sexo Esperado | Comportamento no Sistema |
|---|---|---|
| PSA (Antígeno Prostático) | Masculino | Bloquear + exibir alerta de inconsistência |
| Beta-HCG (Gravidez) | Feminino | Sinalizar para revisão com alerta |
| Papanicolau (Colo do útero) | Feminino | Bloquear + exibir alerta |
| FSH / LH (hormônios ciclo) | Feminino | Sinalizar para revisão |

### Cenários de Teste Derivados

| ID | Cenário | Resultado Esperado |
|---|---|---|
| CL-006 | PSA solicitado para paciente do sexo feminino | Sistema bloqueia com alerta de inconsistência |
| CL-007 | Beta-HCG solicitado para paciente do sexo masculino | Sistema sinaliza para revisão |
| CL-008 | Papanicolau solicitado para paciente do sexo masculino | Sistema bloqueia com alerta de inconsistência |
| CL-009 | FSH solicitado para paciente do sexo masculino | Sistema sinaliza para revisão |

---

## 🏥 3. Regras de Exclusão de Beneficiários

**Contexto:** As operadoras de plano de saúde devem seguir regras da ANS (Agência Nacional de Saúde Suplementar) para exclusão de vidas.

| Motivo | Documentação Obrigatória | Validação no Sistema | Prazo |
|---|---|---|---|
| OBITO | Data de óbito (obrigatória) | Campo data_obito required | Imediato |
| DEMISSAO | Data de demissão | Campo data_demissao required | 30 dias |
| APOSENTADORIA | Comprovante de aposentadoria | Upload de documento | 30 dias |
| TRANSFERENCIA | Código do plano de destino | Campo plano_destino required | 15 dias |

---

## ⚗️ 4. Garantia da Qualidade Laboratorial

**Contexto:** Baseado nas boas práticas de GQL (Garantia da Qualidade Laboratorial) e nas normas ANVISA/NBR ISO 15189.

| Verificação | Critério de Qualidade | Impacto se Falhar |
|---|---|---|
| Rastreabilidade de amostras | Cada amostra possui ID único e imutável | Impossível auditar resultado |
| Prazo de validade de amostras | Sistema bloqueia uso de amostras vencidas | Resultado inválido / risco clínico |
| Controle de qualidade interno | Resultados de QC dentro de ±2 desvios padrão | Lote inválido, reprocessamento |
| Liberação autorizada | Apenas biomédico habilitado libera resultados críticos | Risco regulatório |
