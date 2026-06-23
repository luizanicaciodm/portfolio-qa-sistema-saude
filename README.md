# 🏥 Portfólio QA — Sistema de Saúde

> Simulação de um ambiente corporativo real na área da saúde, cobrindo plano de saúde, laboratório clínico e análises clínicas com estratégias de QA de ponta a ponta.

![Cypress](https://img.shields.io/badge/Cypress-E2E-17202C?style=flat-square&logo=cypress&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-API-FF6C37?style=flat-square&logo=postman&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Validações-4479A1?style=flat-square&logo=mysql&logoColor=white)
![k6](https://img.shields.io/badge/k6-Performance-7D64FF?style=flat-square&logo=k6&logoColor=white)

---

## 📌 Sobre o Projeto

Este portfólio simula o ciclo completo de QA aplicado a um sistema de saúde: **gestão de plano de saúde, exclusão de beneficiários via API, fluxos de pacientes e validação de regras clínicas críticas**.

O diferencial está na combinação de conhecimento técnico em QA com experiência real em **análises clínicas e qualidade laboratorial** — as regras de negócio testadas (valores críticos, inconsistência sexo/exame) vêm da prática, não apenas da documentação do sistema.

---

## 🗂️ Estrutura do Projeto

```
portfolio-qa-sistema-saude/
│
├── 01-planejamento-de-testes/
│   ├── plano-de-teste.md
│   └── casos-de-teste.md
├── 02-gestao-de-defeitos/
│   └── bug-report.md                    # 3 defeitos documentados, com causa raiz
├── 03-validacoes-em-banco-de-dados/
│   └── queries-validacao.sql            # 7 queries de validação
├── 04-testes-de-api/
│   └── api-exclusao-beneficiarios/
│       ├── README.md
│       └── colecao-postman.json         # 8 cenários
├── 05-automacao-de-testes/
│   └── fluxo-do-paciente/
│       ├── README.md
│       └── fluxo-paciente.cy.js         # 4 casos E2E
├── 06-checklists-de-qualidade/
│   └── checklist-regressao.md
├── 07-testes-de-performance/
│   ├── plano-performance.md
│   └── script-k6.js
├── 08-testes-de-seguranca/
│   └── 08-testes-cenarios-seguranca.md
└── 09-casos-de-negocio-em-saude/
    └── regras-clinicas-laboratoriais.md  # fonte única dos valores críticos usados em todo o portfólio
```

---

## 🛠️ Stack de Ferramentas

| Ferramenta | Finalidade |
|---|---|
| Postman | Testes de contrato e fluxos REST da API de exclusão |
| Cypress | Testes E2E do fluxo do paciente |
| SQL | Validação de integridade de dados clínicos e regulatórios |
| k6 | Testes de carga no endpoint de exclusão |
| Git / GitHub | Versionamento e documentação |

---

## 🔬 Contexto Clínico

A área da saúde exige precisão que vai além do técnico — um dado errado pode impactar diretamente o diagnóstico e o tratamento do paciente. Os valores e regras abaixo são usados de forma consistente em todos os módulos do portfólio (SQL, automação, casos de teste):

- **Resultados críticos** com alertas obrigatórios — glicose, potássio, hemoglobina, plaquetas e creatinina fora da faixa de referência
- **Notificação ao médico** — todo alerta crítico deve gerar notificação, não apenas exibição em tela (ver BUG-003)
- **Inconsistências clínicas** — cruzamento entre sexo biológico e tipo de exame solicitado (PSA, Beta-HCG, Papanicolau, FSH/LH)
- **Regras regulatórias** — critérios de exclusão de beneficiários conforme ANS

---

## 👩‍💻 Sobre Mim

Sou Analista de QA com experiência em testes funcionais e não funcionais para sistemas web e mobile, atuando também com análise de requisitos e testes de integração.

Minha trajetória começou na área da saúde, onde trabalhei como **Biomédica no setor de Qualidade Laboratorial do Grupo Hermes Pardini** — experiência que moldou meu olhar para processos, senso crítico e compromisso com melhoria contínua. Hoje levo essa visão para o QA: qualidade não é só encontrar bugs, é garantir que o produto funcione da forma que realmente importa para quem usa.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Luiza%20Nicácio-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://linkedin.com/in/luizanicacio)
[![GitHub](https://img.shields.io/badge/GitHub-luizanicaciodm-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/luizanicaciodm)
