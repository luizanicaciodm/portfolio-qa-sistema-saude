# 🤖 Automação E2E — Fluxo Completo do Paciente

> Suíte de testes automatizados cobrindo o ciclo do paciente no sistema de saúde: cadastro, geração de alertas para resultados críticos (alto e baixo) e bloqueio de exames incompatíveis com o sexo do paciente.

![Cypress](https://img.shields.io/badge/Cypress-13.x-17202C?style=flat-square&logo=cypress&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-ES6+-F7DF1E?style=flat-square&logo=javascript&logoColor=black)

---

## 🔁 Fluxo Automatizado

| Caso | Cenário | Verificação |
|---|---|---|
| CT-E2E-001 | Cadastro de novo paciente | Formulário salva com sucesso |
| CT-E2E-002 | Resultado crítico ALTO (Glicose > 500) | Alerta médico exibido |
| CT-E2E-003 | Resultado crítico BAIXO (Glicose < 40) | Alerta médico exibido |
| CT-E2E-004 | Exame incompatível com sexo do paciente | Bloqueio com mensagem de inconsistência |

> 📌 Os valores críticos usados nos testes seguem a tabela de referência documentada em [`regras-clinicas-laboratoriais.md`](../09-casos-de-negocio-em-saude/regras-clinicas-laboratoriais.md) — consulte esse arquivo para a lista completa de exames e limiares.

---

## ⚙️ Pré-requisitos

- Node.js 18+
- Acesso ao ambiente de homologação

## 🚀 Como Executar

```bash
npm install

# Interface visual — recomendado para desenvolvimento e debug
npx cypress open

# Modo headless — recomendado para CI/CD
npx cypress run
```

---

## 🎬 Evidências

Vídeos de cada execução são salvos automaticamente em `cypress/videos/`. Screenshots de falhas ficam em `cypress/screenshots/`.
