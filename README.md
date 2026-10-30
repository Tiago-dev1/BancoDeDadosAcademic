# Projeto de Banco de Dados: Academia FitPlus

**Integrantes do Trio:**
1. [Nome do Aluno 1]
2. [Nome do Aluno 2]
3. [Nome do Aluno 3]

## Problema de Negócio
A Academia FitPlus enfrenta dificuldades em gerenciar o status dos alunos, controlar a inadimplência de mensalidades e aplicar multas justas para pagamentos em atraso de forma automatizada. Além disso, a recepção tinha acesso irrestrito aos dados financeiros, gerando riscos de segurança. Este banco de dados resolve o problema ao centralizar planos, matrículas e pagamentos, automatizando o cálculo de juros e restringindo acessos via SGBD.

## Diagrama Entidade-Relacionamento (DER)
Abaixo está a representação em Mermaid da modelagem relacional, contendo 4 tabelas interligadas.

```mermaid
erDiagram
    PLANOS {
        int id PK
        varchar nome
        decimal valor_mensal
        int duracao_meses
    }
    ALUNOS {
        int id PK
        varchar nome
        varchar cpf UK
        date data_nascimento
        timestamp criado_em
    }
    MATRICULAS {
        int id PK
        int aluno_id FK
        int plano_id FK
        date data_inicio
        date data_fim
        enum status
    }
    PAGAMENTOS {
        int id PK
        int matricula_id FK
        date data_vencimento
        date data_pagamento
        decimal valor_original
        decimal valor_pago
        enum status
    }

    PLANOS ||--o{ MATRICULAS : "possui"
    ALUNOS ||--o{ MATRICULAS : "realiza"
    MATRICULAS ||--o{ PAGAMENTOS : "gera"