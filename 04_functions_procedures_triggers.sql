USE academia_db;

DELIMITER $$

-- 1. FUNCTION: Calcula valor da multa (2% base + 0.5% por dia de atraso)
CREATE FUNCTION fn_calcular_multa(valor_base DECIMAL(10,2), dias_atraso INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE valor_multa DECIMAL(10,2);
    IF dias_atraso <= 0 THEN
        SET valor_multa = 0;
    ELSE
        SET valor_multa = valor_base * (0.02 + (0.005 * dias_atraso));
    END IF;
    RETURN valor_multa;
END$$

-- 2. STORED PROCEDURE: Processar pagamento com condicional e validação
CREATE PROCEDURE sp_registrar_pagamento(
    IN p_pagamento_id INT,
    IN p_data_pgto DATE,
    OUT p_mensagem VARCHAR(100)
)
BEGIN
    DECLARE v_status_atual VARCHAR(20);
    DECLARE v_vencimento DATE;
    DECLARE v_valor_original DECIMAL(10,2);
    DECLARE v_dias_atraso INT;
    DECLARE v_valor_final DECIMAL(10,2);
    
    -- Busca dados do pagamento
    SELECT status, data_vencimento, valor_original 
    INTO v_status_atual, v_vencimento, v_valor_original
    FROM pagamentos WHERE id = p_pagamento_id;
    
    -- Validação: Se já estiver pago, recusa
    IF v_status_atual = 'Pago' THEN
        SET p_mensagem = 'Erro: Pagamento já foi realizado anteriormente.';
    ELSE
        -- Cálculo de atraso e valor final usando a Function
        SET v_dias_atraso = DATEDIFF(p_data_pgto, v_vencimento);
        SET v_valor_final = v_valor_original + fn_calcular_multa(v_valor_original, v_dias_atraso);
        
        -- Atualiza a tabela
        UPDATE pagamentos 
        SET data_pagamento = p_data_pgto, 
            valor_pago = v_valor_final, 
            status = 'Pago'
        WHERE id = p_pagamento_id;
        
        SET p_mensagem = CONCAT('Sucesso: Pagamento registrado. Valor cobrado: R$', v_valor_final);
    END IF;
END$$

-- 3. TRIGGER: Atualização automática de status da matrícula (Usando NEW e OLD)
-- Se um pagamento for quitado, garantir que a matrícula fique 'Ativa' caso estivesse 'Inativa'
CREATE TRIGGER trg_reativar_matricula 
AFTER UPDATE ON pagamentos
FOR EACH ROW
BEGIN
    IF NEW.status = 'Pago' AND OLD.status != 'Pago' THEN
        UPDATE matriculas 
        SET status = 'Ativa'
        WHERE id = NEW.matricula_id AND status = 'Inativa';
    END IF;
END$$

DELIMITER ;