-- Criação da Base de Dados
CREATE DATABASE IF NOT EXISTS academia_db;
USE academia_db;

-- 1. Tabela de Planos
CREATE TABLE planos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    valor_mensal DECIMAL(10,2) NOT NULL CHECK (valor_mensal > 0),
    duracao_meses INT NOT NULL DEFAULT 1
);

-- 2. Tabela de Alunos
CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabela de Matrículas
CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT NOT NULL,
    plano_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status ENUM('Ativa', 'Inativa', 'Cancelada') DEFAULT 'Ativa',
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (plano_id) REFERENCES planos(id)
);

-- 4. Tabela de Pagamentos
CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula_id INT NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    valor_original DECIMAL(10,2) NOT NULL,
    valor_pago DECIMAL(10,2),
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente',
    FOREIGN KEY (matricula_id) REFERENCES matriculas(id)
);