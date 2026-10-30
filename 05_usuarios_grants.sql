USE academia_db;

-- 1. Criação dos Usuários
CREATE USER IF NOT EXISTS 'gerente'@'localhost' IDENTIFIED BY 'gerente123';
CREATE USER IF NOT EXISTS 'recepcao'@'localhost' IDENTIFIED BY 'recepcao123';

-- 2. Concessão de Permissões (GRANT)
-- Gerente: Acesso total às tabelas do banco da academia
GRANT ALL PRIVILEGES ON academia_db.* TO 'gerente'@'localhost';

-- Recepção: Princípio do Menor Privilégio
GRANT SELECT ON academia_db.vw_inadimplencia TO 'recepcao'@'localhost';
GRANT EXECUTE ON PROCEDURE academia_db.sp_registrar_pagamento TO 'recepcao'@'localhost';

-- 3. Demonstração Prática de REVOKE
-- Para demonstrar o REVOKE: concedemos o DELETE e revogamo-lo logo a seguir
GRANT DELETE ON academia_db.* TO 'recepcao'@'localhost';
REVOKE DELETE ON academia_db.* FROM 'recepcao'@'localhost';

FLUSH PRIVILEGES;