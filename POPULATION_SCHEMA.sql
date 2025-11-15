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
DECLARE @emailsClientes Tipo_EmailsClientes;
INSERT INTO @emailsClientes VALUES
('joao@gmail.com')

DECLARE @telefonesClientes Tipo_TelefonesClientes;
INSERT INTO @telefonesClientes VALUES
(55, 16, 997525125);

exec sp_CadastrarCliente 'João', '43209614501', '1993-05-16', 1, 'A', @emailsClientes, @telefonesClientes;
GO

DECLARE @emailsClientes Tipo_EmailsClientes;
INSERT INTO @emailsClientes VALUES
('josesito@gmail.com'),
('zebacana@outlook.com');

DECLARE @telefonesClientes Tipo_TelefonesClientes;
INSERT INTO @telefonesClientes VALUES
(55, 16, 995238537);

exec sp_CadastrarCliente 'José', '85031531513', '2009-05-12', 1, 'A', @emailsClientes, @telefonesClientes;
GO

DECLARE @emailsClientes Tipo_EmailsClientes;
INSERT INTO @emailsClientes VALUES
('juca@gmail.com');

DECLARE @telefonesClientes Tipo_TelefonesClientes;
INSERT INTO @telefonesClientes VALUES
(55, 31, 994355165);

exec sp_CadastrarCliente 'Juca', '38030851751', '1986-10-23', 3, 'I', @emailsClientes, @telefonesClientes;
GO

DECLARE @emailsClientes Tipo_EmailsClientes;
INSERT INTO @emailsClientes VALUES
('roberta@hotmail.com');

DECLARE @telefonesClientes Tipo_TelefonesClientes;
INSERT INTO @telefonesClientes VALUES
(55, 16, 997415312);

exec sp_CadastrarCliente 'Roberta', '43145105632', '2001-05-06', 2, 'A', @emailsClientes, @telefonesClientes;
GO

INSERT INTO ClientesRestritos VALUES (4);

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

-- PrincipiosAtivos --
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

-- Producoes --

DECLARE @itensProducoes Tipo_ItensProducoes;
INSERT INTO @itensProducoes VALUES
(40, 'AI0002');

EXEC sp_Producoes 20, '7891234567890', @itensProducoes;
GO;

DECLARE @itensProducoes Tipo_ItensProducoes;
INSERT INTO @itensProducoes VALUES
(20, 'AI0001'),
(50, 'AI0003');


EXEC sp_Producoes 40, '7891234567891', @itensProducoes;
GO;

DECLARE @itensProducoes Tipo_ItensProducoes;
INSERT INTO @itensProducoes VALUES
(10, 'AI0004'),
(50, 'AI0003');


EXEC sp_Producoes 35, '7891234567892', @itensProducoes;
GO;

DECLARE @itensProducoes Tipo_ItensProducoes;
INSERT INTO @itensProducoes VALUES
(40, 'AI0002'),
(20, 'AI0001'),
(50, 'AI0003');


EXEC sp_Producoes 20, '7891234567894', @itensProducoes;
GO;

-- VendasMedicamentos --
DECLARE @itensVendas Tipo_ItensVendas;
INSERT INTO @itensVendas VALUES
(5, '7891234567890'),
(2, '7891234567891'),
(2, '7891234567892');

EXEC sp_VendasMedicamentos 1, @itensVendas;
GO

DECLARE @itensVendas Tipo_ItensVendas;
INSERT INTO @itensVendas VALUES
(4, '7891234567890'),
(4, '7891234567892');

EXEC sp_VendasMedicamentos 1, @itensVendas;
GO

-- Fornecedores --
DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('farmaciasaude@farmaciasaude.com');

DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(55, 11, '33402515');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES
('Rua das Flores', 120, 'Loja 1', 'Centro', 'São Paulo', 'SP', 'Brasil', '01020000');

EXEC sp_CadastrarFornecedor 'Farmácia Saúde Total LTDA',
							'12345678000199',
							'2015-03-12',
							'A',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;
GO;

DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('drogariapopular@outlook.com');

DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(55, 31, '32041538');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES
('Avenida Brasil', 502, NULL, 'Jardim América', 'Belo Horizonte', 'MG', 'Brasil', '30140000');

EXEC sp_CadastrarFornecedor 'Drogaria Popular EIRELI',
							'98765432000188',
							'2024-09-05',
							'A',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;
GO;

DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('vidamais@vidaltda.com');

DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(55, 41, '30451965');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES
('Rua do Comércio', 75, 'Sala 3', 'Centro', 'Curitiba', 'PR', 'Brasil', '80020000');

EXEC sp_CadastrarFornecedor 'Distribuidora Vida Mais LTDA',
							'45678912000177',
							'2012-05-20',
							'I',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;
GO;

DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('labsaolucas@labsl.com');

DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(NULL, NULL, '08001459835');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES
('Avenida Independência', 980, NULL, 'Cidade Baixa', 'Porto Alegre', 'RS', 'Brasil', '90035000');

EXEC sp_CadastrarFornecedor 'Laboratório São Lucas S/A',
							'22334455000166',
							'2018-11-02',
							'A',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;
GO;

DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('biomedic@gmail.com');

DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(55, 81, '40531552');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES
('Rua das Palmeiras', 240, 'Galpão 2', 'Boa Viagem', 'Recife', 'PE', 'Brasil', '51021000');

EXEC sp_CadastrarFornecedor 'BioMedic Distribuidora LTDA',
							'33445566000155',
							'2010-01-18',
							'A',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;
GO;

-- FornecedoresRestritos -- 
INSERT INTO FornecedoresRestritos(IdFornecedor) VALUES (4);

-- Compras --
DECLARE @itensCompras Tipo_ItensCompras;
INSERT INTO @itensCompras VALUES
(10, 5.50, 'AI0001'),
(5, 7.20, 'AI0002'),
(3, 15.10, 'AI0003');

EXEC sp_Compras 1, @itensCompras;
GO;

DECLARE @itensCompras Tipo_ItensCompras;
INSERT INTO @itensCompras VALUES
(10, 5.50, 'AI0001'),
(3, 4.50, 'AI0004');

EXEC sp_Compras 5, @itensCompras;
GO;