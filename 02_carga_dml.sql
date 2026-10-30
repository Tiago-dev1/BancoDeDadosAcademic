USE academia_db;

-- Inserindo Planos
INSERT INTO planos (nome, valor_mensal, duracao_meses) VALUES
('Mensal', 120.00, 1),
('Trimestral', 100.00, 3),
('Anual', 80.00, 12);

-- Inserindo Alunos
INSERT INTO alunos (nome, cpf, data_nascimento) VALUES
('Ana Silva', '11111111111', '1995-04-15'),
('Bruno Souza', '22222222222', '1990-10-20'),
('Carlos Dias', '33333333333', '2001-02-10'),
('Diana Luz', '44444444444', '1985-08-05');

-- Inserindo Matriculas
INSERT INTO matriculas (aluno_id, plano_id, data_inicio, data_fim, status) VALUES
(1, 3, '2026-01-01', '2026-12-31', 'Ativa'),
(2, 1, '2026-09-01', '2026-10-01', 'Inativa'),
(3, 2, '2026-08-15', '2026-11-15', 'Ativa');
-- Diana Luz é cadastrada, mas ainda não tem matrícula (útil para o LEFT JOIN)

-- Inserindo Pagamentos (Cenários: Pagos, Pendentes e Atrasados)
INSERT INTO pagamentos (matricula_id, data_vencimento, data_pagamento, valor_original, valor_pago, status) VALUES
(1, '2026-09-01', '2026-08-30', 80.00, 80.00, 'Pago'),
(1, '2026-10-01', NULL, 80.00, NULL, 'Pendente'),
(2, '2026-09-01', '2026-09-10', 120.00, 130.00, 'Pago'),
(3, '2026-09-15', NULL, 100.00, NULL, 'Atrasado');