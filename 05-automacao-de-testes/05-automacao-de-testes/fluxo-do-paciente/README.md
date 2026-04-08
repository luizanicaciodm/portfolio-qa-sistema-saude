# Automação — Fluxo Completo do Paciente

## Tecnologia
- **Cypress 13.x** — framework de testes E2E
- **JavaScript**

## Fluxo Automatizado
1. Login no sistema
2. Cadastro de novo paciente
3. Solicitação de exame laboratorial
4. Verificação do resultado no sistema
5. Validação do alerta gerado para resultado crítico

## Como Executar (requer Node.js instalado)
```bash
npm install
npx cypress open    # Interface visual
npx cypress run     # Modo headless (CI/CD)
```