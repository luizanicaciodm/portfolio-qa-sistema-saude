// Automação E2E — Fluxo Completo do Paciente
// Ferramenta: Cypress | Portfólio QA — Luiza Nicácio

describe('Fluxo Completo do Paciente — Sistema de Saúde', () => {

  beforeEach(() => {
    cy.visit('/login')
    cy.get('[data-cy=email]').type('qa@sistemasaude.com')
    cy.get('[data-cy=senha]').type('Senha@123')
    cy.get('[data-cy=btn-entrar]').click()
    cy.url().should('include', '/dashboard')
  })

  it('CT-E2E-001: Cadastro de novo paciente com sucesso', () => {
    cy.get('[data-cy=menu-pacientes]').click()
    cy.get('[data-cy=btn-novo-paciente]').click()
    cy.get('[data-cy=campo-cpf]').type('123.456.789-09')
    cy.get('[data-cy=campo-nome]').type('Maria Teste Silva')
    cy.get('[data-cy=campo-nascimento]').type('1985-03-15')
    cy.get('[data-cy=campo-plano]').select('Plano Bronze')
    cy.get('[data-cy=btn-salvar]').click()
    cy.get('[data-cy=msg-sucesso]').should('be.visible')
    cy.contains('Paciente cadastrado com sucesso').should('exist')
  })

  it('CT-E2E-002: Resultado crítico deve gerar alerta médico', () => {
    cy.get('[data-cy=menu-resultados]').click()
    cy.get('[data-cy=btn-novo-resultado]').click()
    cy.get('[data-cy=campo-exame]').select('Glicose')
    cy.get('[data-cy=campo-valor]').type('550')  // Valor crítico > 500
    cy.get('[data-cy=btn-salvar-resultado]').click()
    cy.get('[data-cy=alerta-critico]').should('be.visible')
    cy.contains('VALOR CRÍTICO — Notificar médico imediatamente').should('exist')
  })

  it('CT-E2E-003: Impedir exame PSA para paciente feminina', () => {
    cy.get('[data-cy=campo-paciente]').type('Ana Clara Ferreira')
    cy.get('[data-cy=campo-exame]').select('PSA')
    cy.get('[data-cy=btn-salvar-resultado]').click()
    cy.get('[data-cy=erro-inconsistencia]').should('be.visible')
    cy.contains('Exame incompatível com o sexo do paciente').should('exist')
  })

})