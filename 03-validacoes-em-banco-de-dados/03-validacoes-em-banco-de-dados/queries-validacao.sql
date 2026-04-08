-- ============================================================
-- VALIDAÇÕES EM BANCO DE DADOS — SISTEMA DE SAÚDE
-- QA: Luiza Nicácio | github.com/luizanicaciodm
-- ============================================================


-- ──────────────────────────────────────────────────────────
-- 1. Verificar beneficiários com status EXCLUIDO sem data
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    id_beneficiario,
    nome,
    cpf,
    status,
    data_exclusao
FROM beneficiarios
WHERE status = 'EXCLUIDO'
  AND data_exclusao IS NULL;


-- ──────────────────────────────────────────────────────────
-- 2. Verificar exclusões OBITO sem data_obito
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    id_exclusao,
    id_beneficiario,
    motivo,
    data_obito
FROM exclusoes_beneficiarios
WHERE motivo = 'OBITO'
  AND data_obito IS NULL;


-- ──────────────────────────────────────────────────────────
-- 3. Verificar CPFs duplicados em beneficiários ATIVOS
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    cpf,
    COUNT(*) AS total_registros
FROM beneficiarios
WHERE status = 'ATIVO'
GROUP BY cpf
HAVING COUNT(*) > 1;


-- ──────────────────────────────────────────────────────────
-- 4. Verificar resultados laboratoriais CRÍTICOS sem alerta
-- Regra clínica: valor < 50% do mínimo ou > 150% do máximo
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    rl.id_resultado,
    rl.id_paciente,
    p.nome AS nome_paciente,
    rl.exame,
    rl.valor_resultado,
    rl.valor_referencia_min,
    rl.valor_referencia_max,
    rl.alerta_gerado
FROM resultados_laboratoriais rl
JOIN pacientes p ON rl.id_paciente = p.id_paciente
WHERE (rl.valor_resultado < rl.valor_referencia_min * 0.5
   OR  rl.valor_resultado > rl.valor_referencia_max * 1.5)
  AND rl.alerta_gerado = 'NAO';


-- ──────────────────────────────────────────────────────────
-- 5. Inconsistência sexo x exame: PSA em paciente feminina
-- PSA é exame exclusivo do sexo masculino (próstata)
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    p.id_paciente,
    p.nome,
    p.sexo,
    rl.exame,
    rl.data_resultado
FROM pacientes p
JOIN resultados_laboratoriais rl ON p.id_paciente = rl.id_paciente
WHERE rl.exame = 'PSA'
  AND p.sexo = 'F';


-- ──────────────────────────────────────────────────────────
-- 6. Verificar integridade: exclusão registrada no banco
-- Valida que após exclusão via API o banco foi atualizado
-- ──────────────────────────────────────────────────────────
SELECT
    b.cpf,
    b.nome,
    b.status,
    e.motivo,
    e.data_exclusao
FROM beneficiarios b
JOIN exclusoes_beneficiarios e ON b.id_beneficiario = e.id_beneficiario
WHERE b.cpf = '123.456.789-09';