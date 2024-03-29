CREATE DATABASE IF NOT EXISTS teste_intuitive_care
    DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_general_ci;
USE teste_intuitive_care;

CREATE TABLE EMPRESAS (
    Registro_ANS VARCHAR(6) PRIMARY KEY,
    CNPJ VARCHAR(14),
    Razao_Social VARCHAR(255),
    Nome_Fantasia VARCHAR(255),
    Modalidade VARCHAR(255),
    Logradouro VARCHAR(255),
    Numero VARCHAR(255),
    Complemento VARCHAR(255),
    Bairro VARCHAR(255),
    Cidade VARCHAR(255),
    UF VARCHAR(2),
    CEP VARCHAR(8),
    DDD VARCHAR(2),
    Telefone VARCHAR(255),
    Fax VARCHAR(255),
    Endereco_eletronico VARCHAR(255),
    Representante VARCHAR(255),
    Cargo_Representante VARCHAR(255),
    Regiao_de_Comercializacao VARCHAR(255),
    Data_Registro_ANS DATE
);

CREATE TABLE ACOES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    DATA DATE,
    REG_ANS VARCHAR(6),
    CD_CONTA_CONTABIL VARCHAR(9),
    DESCRICAO VARCHAR(255),
    VL_SALDO_INICIAL DECIMAL(15,2),
    VL_SALDO_FINAL DECIMAL(15,2),    
    CONSTRAINT ACOES_EMPRESAS_FK FOREIGN KEY (REG_ANS)
        REFERENCES EMPRESAS (Registro_ANS)
);

select * from EMPRESAS;
SHOW VARIABLES LIKE "secure_file_priv";
LOAD LOCAL DATA INFILE '/home/ssdfhansen/Documentos/03_Dev/Estagio/teste-intuitive-care/Relatorio_cadop.csv' INTO TABLE EMPRESAS
CHARACTER SET utf8
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

WITH trimestre AS (
    SELECT
        REG_ANS,
        SUM(VL_SALDO_FINAL) AS total_despesas
    FROM
        ACOES
    WHERE
        DATA >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
        AND DATA < CURRENT_DATE
        AND CD_CONTA_CONTABIL = 'E00000002'
    GROUP BY
        REG_ANS
)
SELECT
    E.Registro_ANS,
    E.Razao_Social,
    E.Nome_Fantasia,
    T.total_despesas
FROM
    EMPRESAS E
    JOIN trimestre T ON E.Registro_ANS = T.REG_ANS
ORDER BY
    T.total_despesas DESC
LIMIT
    10;


WITH ano AS (
    SELECT
        REG_ANS,
        SUM(VL_SALDO_FINAL) AS total_despesas
    FROM
        ACOES
    WHERE
        DATA >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
        AND DATA < CURRENT_DATE
        AND CD_CONTA_CONTABIL = 'E00000002'
    GROUP BY
        REG_ANS
)
SELECT
    E.Registro_ANS,
    E.Razao_Social,
    E.Nome_Fantasia,
    A.total_despesas
FROM
    EMPRESAS E
    JOIN ano A ON E.Registro_ANS = A.REG_ANS
ORDER BY
    A.total_despesas DESC
LIMIT
    10;