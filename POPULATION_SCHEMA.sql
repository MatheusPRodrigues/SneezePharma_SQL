USE SneezePharma;
GO

-- Enderecos Clientes --
INSERT INTO EnderecosClientes VALUES ('Av. Princesa Isabel', 505, NULL, 'Maria Luiza', 'Aracity', 'SP', 14820055);
INSERT INTO EnderecosClientes VALUES ('Rua Bananinha', 1023, 'Em frente a bananeira', 'Santana', 'Bananacity', 'MG', 31471844);
INSERT INTO EnderecosClientes VALUES ('Rua das Flores', 32, NULL, 'Jardim Primavera', 'Americo Brasiliense', 'SP', 14820000);

-- Situacoes --
INSERT INTO Situacoes VALUES
('A', 'Ativo'),
('I', 'Inativo');

-- Clientes --
INSERT INTO Clientes VALUES ('João', 43209614501, '1993-05-16', NULL, GETDATE(), 1, 'A');
INSERT INTO Clientes VALUES ('José', 85031531513, '2009-05-12', NULL, GETDATE(), 1, 'A');
INSERT INTO Clientes VALUES ('Juca', 38030851751, '1986-10-23', NULL, GETDATE(), 3, 'I');
INSERT INTO Clientes VALUES ('Roberta', 43145105632, '2001-05-06', NULL, GETDATE(), 2, 'A');

-- ClientesRestritos --
INSERT INTO ClientesRestritos VALUES (4);

-- EmailsClientes --
INSERT INTO EmailsClientes VALUES 
('joao@gmail.com', 1),
('josesito@gmail.com', 2),
('zebacana@outlook.com', 2),
('roberta@hotmail.com', 4);

-- TelefonesClientes --
INSERT INTO TelefonesClientes VALUES
(55, 16, 997525125, 1),
(55, 16, 995238537, 2),
(55, 31, 994355165, 3),
(55, 16, 997415312, 4);

-- CategoriasMedicamentos --
INSERT INTO CategoriasMedicamentos VALUES
('A', 'Analgésico'),
('B', 'Antibiotico'),
('I', 'Antiflamatório'),
('V', 'Vitamina');

-- Medicamentos --
INSERT INTO Medicamentos VALUES
('7891234567890', 'Tyfadol', 8.50, GETDATE(), NULL, 'A', 'A'),
('7891234567891', 'Dorax', 10.20, GETDATE(), NULL, 'A', 'A'),
('7891234567892', 'Amoxilina', 32, GETDATE(), NULL, 'A', 'B'),
('7891234567893', 'Ibuprofeno', 10.50, GETDATE(), NULL, 'I', 'I'),
('7891234567894', 'Vitamina C', 5.65, GETDATE(), NULL, 'A', 'V');

-- Producoes --
INSERT INTO Producoes VALUES 
(20, GETDATE(), '7891234567890'),
(40, GETDATE(), '7891234567891'),
(35, GETDATE(), '7891234567892'),
(20, GETDATE(), '7891234567894');

-- VendasMedicamentos --
INSERT INTO VendasMedicamentos VALUES (GETDATE(), NULL, 1);
INSERT INTO VendasMedicamentos VALUES (GETDATE(), NULL, 1);

-- ItensVendas --
INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento) VALUES (5, 1, '7891234567890');
INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento) VALUES (2, 1, '7891234567891');
INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento) VALUES (2, 1, '7891234567892');

INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento) VALUES (4, 2, '7891234567892');
INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento) VALUES (4, 2, '7891234567890');

-- Fornecedores --
-- Fornecedor 1: empresa antiga e ativa
INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
VALUES ('Farmácia Saúde Total LTDA', 12345678000199, '2015-03-12', '2025-10-25', '2017-03-12', 'A');

-- Fornecedor 2: empresa nova (menos de 2 anos)
INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
VALUES ('Drogaria Popular EIRELI', 98765432000188, '2024-09-05', NULL, '2024-09-05', 'A');

-- Fornecedor 3: empresa inativa
INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
VALUES ('Distribuidora Vida Mais LTDA', 45678912000177, '2012-05-20', '2023-12-10', '2015-05-20', 'I');

-- Fornecedor 4: empresa média, ativa
INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
VALUES ('Laboratório São Lucas S/A', 22334455000166, '2018-11-02', '2025-07-01', '2019-11-02', 'A');

-- Fornecedor 5: empresa antiga, com fornecimento recente
INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
VALUES ('BioMedic Distribuidora LTDA', 33445566000155, '2010-01-18', '2025-10-10', '2010-01-18', 'A');

-- EnderecosFornecedores -- 
-- Endereço do Fornecedor 1: Farmácia Saúde Total LTDA
INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
VALUES ('Rua das Flores', 120, 'Loja 1', 'Centro', 'São Paulo', 'SP', 'Brasil', 01020000, 1);

-- Endereço do Fornecedor 2: Drogaria Popular EIRELI
INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
VALUES ('Avenida Brasil', 502, NULL, 'Jardim América', 'Belo Horizonte', 'MG', 'Brasil', 30140000, 2);

-- Endereço do Fornecedor 3: Distribuidora Vida Mais LTDA
INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
VALUES ('Rua do Comércio', 75, 'Sala 3', 'Centro', 'Curitiba', 'PR', 'Brasil', 80020000, 3);

-- Endereço do Fornecedor 4: Laboratório São Lucas S/A
INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
VALUES ('Avenida Independência', 980, NULL, 'Cidade Baixa', 'Porto Alegre', 'RS', 'Brasil', 90035000, 4);

-- Endereço do Fornecedor 5: BioMedic Distribuidora LTDA
INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
VALUES ('Rua das Palmeiras', 240, 'Galpão 2', 'Boa Viagem', 'Recife', 'PE', 'Brasil', 51021000, 5);

-- FornecedoresRestritos -- 
INSERT INTO FornecedoresRestritos(IdFornecedor) VALUES (4);

-- EmailsFornecedores --
INSERT INTO EmailsFornecedores VALUES
('farmaciasaude@farmaciasaude.com', 1),
('drogariapopular@outlook.com', 2),
('vidamais@vidaltda.com', 3),
('labsaolucas@labsl.com', 4),
('biomedic@gmail.com', 5);


-- TelefonesFornecedores --
INSERT INTO TelefonesFornecedores VALUES 
(55, 11, '33402515', 1),
(55, 31, '32041538', 2),
(55, 41, '30451965', 3),
(NULL, NULL, '08001459835', 4),
(55, 81, '40531552', 5);

-- Compras --
-- Compra do Fornecedor 1: empresa antiga e ativa - Sucesso
INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor) VALUES (GETDATE(), NULL, 1);

-- Compra do Fornecedor 2: empresa nova (menos de 2 anos) - dá erro
--INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor) VALUES (GETDATE(), NULL, 2);

-- Compra do Fornecedor 3: empresa inativa - dá erro
--INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor) VALUES (GETDATE(), NULL, 3);

-- Compra do Fornecedor 4: empresa média, ativa - dá erro porque está restrita 
--INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor) VALUES (GETDATE(), NULL, 4);

-- Compra do Fornecedor 5: empresa antiga, com fornecimento recente 
INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor) VALUES (GETDATE(), NULL, 5);

-- Principios Ativos -- 

-- Paracetamol - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0001', 'Paracetamol', '2015-05-10', '2025-09-22', 'A');

-- Ibuprofeno - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0002', 'Ibuprofeno', '2016-11-03', '2025-10-10', 'A');

-- Amoxicilina - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0003', 'Amoxicilina', '2018-07-20', '2025-06-18', 'A');

-- Dipirona Sódica - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0004', 'Dipirona Sódica', '2014-03-12', '2024-12-30', 'A');

-- Cloroquina (inativo, uso restrito)
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0005', 'Cloroquina', '2010-01-05', '2020-05-15', 'I');

-- ItensCompras

-- Compra 1 com AI0001 - sucesso
INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
VALUES (10, 5.50, 1, 'AI0001');

-- com AI0002 - sucesso
INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
VALUES (5, 7.20, 1, 'AI0002');

-- com AI0003 - sucesso
INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
VALUES (3, 15.10, 1, 'AI0003');

-- com AI0004 - erro (só é permitido 3 itens por compra)
--INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
--VALUES (1, 3.40, 1, 'AI0004');


-- Compra 2 com AI0001 - erro (não permite compra de principio inativo)
--INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
--VALUES (8, 6.00, 5, 'AI0005');

-- ItensProducoes --
INSERT INTO ItensProducoes VALUES
(40, 'AI0002', 1),
(20, 'AI0001', 2),
(50, 'AI0003', 3);
