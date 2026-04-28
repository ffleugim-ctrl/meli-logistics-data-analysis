-- Criando a tabela de teste "suja" para o novo projeto
CREATE TABLE Base_Loss_Operacional_Suja (
    ID_Operacao INT IDENTITY(1,1),
    Data_Evento VARCHAR(50), -- Propositadamente texto para limparmos
    Setor_Processo VARCHAR(100),
    Tipo_Ocorrencia VARCHAR(100),
    Valor_Declarado_BR VARCHAR(100), -- Com "sujeira"
    Nome_Seller VARCHAR(100),
    Impacto_Rezago VARCHAR(10), -- 'Sim' ou 'Não'
    Cotacao_Dolar_Dia DECIMAL(10,2)
);

-- Inserindo dados "poluídos" para o desafio
INSERT INTO Base_Loss_Operacional_Suja (Data_Evento, Setor_Processo, Tipo_Ocorrencia, Valor_Declarado_BR, Nome_Seller, Impacto_Rezago, Cotacao_Dolar_Dia)
VALUES 
('2026-04-20', 'Triagem', 'Avaria', 'R$ 1.500,50', 'Eletronicos_Vip', 'Sim', 5.10),
('20/04/2026', 'Prowey', 'Caixa Violada', 'R$ 2.300.00', 'Moda_Meli', 'Nao', 5.10),
('2026-04-21', 'Putway', 'Extravio', '450,00', 'Casa_Conforto', 'Sim', 5.12),
('21-04-2026', 'Picking', 'Avaria', 'R$ 89,90', 'Gamer_Store', 'Nao', 5.12),
('22/04/26', 'Packing', 'Caixa Violada', 'R$ 10.000,00', 'Eletronicos_Vip', 'Sim', 5.08),
('2026-04-22', 'Packin', 'Extravio', '1200.50', 'Pet_Amigo', 'Sim', 5.08),
('2026-04-23', 'Carregamento', 'Avaria', 'R$ 5.400,00', 'Moda_Meli', 'Nao', 5.15),
('error_date', 'Triagem', 'Avaria', '0', 'Unknown', 'Nao', 5.15),
('2026-04-24', 'Picking', 'Caixa Violada', 'R$ 350.50', 'Gamer_Store', 'Sim', 5.10);
SELECT 
    -- 1. Tratando a Data
    TRY_CAST(Data_Evento AS DATE) AS Data_Limpa,

    -- 2. Corrigindo os nomes dos setores (Prowey/Putway -> Putaway)
    CASE 
        WHEN Setor_Processo IN ('Prowey', 'Putway') THEN 'Putaway'
        WHEN Setor_Processo = 'Packin' THEN 'Packing'
        ELSE Setor_Processo 
    END AS Setor_Corrigido,

    Tipo_Ocorrencia,

    -- 3. Limpando o valor em Reais (Tirando R$, ponto e trocando vírgula por ponto)
    TRY_CAST(REPLACE(REPLACE(REPLACE(Valor_Declarado_BR, 'R$', ''), '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_BRL_Limpo,

    -- 4. Calculando o Valor em Dólar
    ROUND(
        TRY_CAST(REPLACE(REPLACE(REPLACE(Valor_Declarado_BR, 'R$', ''), '.', ''), ',', '.') AS DECIMAL(18,2)) / Cotacao_Dolar_Dia, 
    2) AS Valor_USD,

    Nome_Seller,
    Impacto_Rezago

FROM Base_Loss_Operacional_Suja
WHERE TRY_CAST(Data_Evento AS DATE) IS NOT NULL;