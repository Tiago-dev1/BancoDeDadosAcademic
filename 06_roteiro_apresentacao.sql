-- ESTE SCRIPT DEVE SER EXECUTADO PELO ALUNO 3 (DEMONSTRAÇÃO PRÁTICA)

USE academia_db;

-- Passo 1: JOIN & View (Exibir estado inicial)
-- Demonstra quem está devendo hoje na academia
SELECT * FROM vw_inadimplencia;

-- Passo 2: Function (Cálculo em tempo real)
-- Mostrando como o sistema calcula multa de R$ 100,00 com 10 dias de atraso (2% + 5% = R$ 7,00)
SELECT fn_calcular_multa(100.00, 10) AS demonstracao_multa;

-- Passo 3: Procedure (Processar operação)
-- Chamando a procedure para pagar a mensalidade pendente do pagamento_id 4
CALL sp_registrar_pagamento(4, '2026-10-30', @msg_resultado);
SELECT @msg_resultado AS retorno_sistema;

-- Passo 4: Trigger (Provar efeito reflexo)
-- Como o pagamento 4 era do aluno 3, vamos verificar se o pagamento foi quitado e a multa registrada
SELECT id, valor_original, valor_pago, status FROM pagamentos WHERE id = 4;
-- A matrícula desse aluno caso estivesse 'Inativa' agora está 'Ativa' devido ao Trigger
SELECT id, status FROM matriculas WHERE id = 3;

-- Passo 5: GRANT (Testar usuário restrito)
-- Copie as duas linhas abaixo e execute em uma nova aba de conexão logada como 'recepcao' / 'recepcao123'
/*
  SELECT * FROM academia_db.vw_inadimplencia; -- Funciona!
  DELETE FROM academia_db.alunos WHERE id = 1; -- Access Denied! (Prova do princípio de segurança)
*/