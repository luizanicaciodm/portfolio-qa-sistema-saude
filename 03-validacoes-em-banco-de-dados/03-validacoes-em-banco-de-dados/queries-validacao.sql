-- ============================================================
-- VALIDAÇÕES EM BANCO DE DADOS — SISTEMA DE SAÚDE
-- QA: Luiza Nicácio | linkedin.com/in/luizanicacio
-- Referência de regras clínicas: regras-clinicas-laboratoriais.md
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
-- Regra clínica: valores críticos específicos por exame,
-- conforme tabela documentada em regras-clinicas-laboratoriais.md
-- (substitui a regra genérica de 50%/150% usada anteriormente,
-- que não correspondia aos limiares reais de cada exame)
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    rl.id_resultado,
    rl.id_paciente,
    p.nome AS nome_paciente,
    rl.exame,
    rl.valor_resultado,
    rl.alerta_gerado
FROM resultados_laboratoriais rl
JOIN pacientes p ON rl.id_paciente = p.id_paciente
WHERE rl.alerta_gerado = 'NAO'
  AND (
       (rl.exame = 'GLICOSE'     AND (rl.valor_resultado < 40   OR rl.valor_resultado > 500))
    OR (rl.exame = 'POTASSIO'    AND (rl.valor_resultado < 2.5  OR rl.valor_resultado > 6.5))
    OR (rl.exame = 'HEMOGLOBINA' AND (rl.valor_resultado < 5.0  OR rl.valor_resultado > 20.0))
    OR (rl.exame = 'PLAQUETAS'   AND (rl.valor_resultado < 20000 OR rl.valor_resultado > 1000000))
    OR (rl.exame = 'CREATININA'  AND (rl.valor_resultado < 0.4  OR rl.valor_resultado > 10.0))
  );


-- ──────────────────────────────────────────────────────────
-- 5. Inconsistência sexo x exame
-- Cobre as 4 combinações documentadas em
-- regras-clinicas-laboratoriais.md (seção 2)
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
WHERE (rl.exame = 'PSA'         AND p.sexo = 'F')   -- PSA é exclusivo do sexo masculino
   OR (rl.exame = 'BETA_HCG'    AND p.sexo = 'M')   -- Beta-HCG é exclusivo do sexo feminino
   OR (rl.exame = 'PAPANICOLAU' AND p.sexo = 'M')   -- Papanicolau é exclusivo do sexo feminino
   OR (rl.exame IN ('FSH', 'LH') AND p.sexo = 'M');  -- FSH/LH (ciclo) é exclusivo do sexo feminino


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


-- ──────────────────────────────────────────────────────────
-- 7. Verificar alertas críticos sem notificação ao médico
-- Regra clínica: todo alerta crítico gerado (alerta_gerado = 'SIM')
-- deve ter uma notificação correspondente registrada para o
-- médico solicitante (ver BUG-003 em bug-report.md)
-- Resultado esperado: 0 linhas
-- ──────────────────────────────────────────────────────────
SELECT
    rl.id_resultado,
    rl.id_paciente,
    p.nome AS nome_paciente,
    rl.exame,
    rl.valor_resultado,
    rl.alerta_gerado
FROM resultados_laboratoriais rl
JOIN pacientes p ON rl.id_paciente = p.id_paciente
LEFT JOIN notificacoes_medicas nm ON nm.id_resultado = rl.id_resultado
WHERE rl.alerta_gerado = 'SIM'
  AND nm.id_notificacao IS NULL;
