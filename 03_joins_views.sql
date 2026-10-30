USE academia_db;

-- 1. INNER JOIN (3 tabelas + agregação): Receita total efetivamente paga agrupada por plano
SELECT 
    p.nome AS plano,
    COUNT(pg.id) AS qtd_pagamentos_recebidos,
    SUM(pg.valor_pago) AS receita_total
FROM planos p
INNER JOIN matriculas m ON p.id = m.plano_id
INNER JOIN pagamentos pg ON m.id = pg.matricula_id
WHERE pg.status = 'Pago'
GROUP BY p.nome;

-- 2. INNER JOIN (3 tabelas): Relatório completo do histórico de faturamento dos alunos
SELECT 
    a.nome AS aluno,
    p.nome AS plano,
    pg.data_vencimento,
    pg.status
FROM alunos a
INNER JOIN matriculas m ON a.id = m.aluno_id
INNER JOIN planos p ON m.plano_id = p.id
INNER JOIN pagamentos pg ON m.id = pg.matricula_id
ORDER BY pg.data_vencimento DESC;

-- 3. LEFT JOIN (Questão Gerencial): Identificar prospects ou alunos sem nenhuma matrícula registrada
SELECT 
    a.nome AS aluno, 
    a.cpf 
FROM alunos a
LEFT JOIN matriculas m ON a.id = m.aluno_id
WHERE m.id IS NULL;

-- 4. VIEW Consolidada Estratégica: Visão de Inadimplência
CREATE OR REPLACE VIEW vw_inadimplencia AS
SELECT 
    a.nome AS aluno,
    a.cpf,
    m.status AS status_matricula,
    pg.id AS pagamento_id,
    pg.data_vencimento,
    pg.valor_original,
    DATEDIFF(CURRENT_DATE, pg.data_vencimento) AS dias_atraso
FROM alunos a
INNER JOIN matriculas m ON a.id = m.aluno_id
INNER JOIN pagamentos pg ON m.id = pg.matricula_id
WHERE pg.status IN ('Pendente', 'Atrasado') 
  AND pg.data_vencimento < CURRENT_DATE;