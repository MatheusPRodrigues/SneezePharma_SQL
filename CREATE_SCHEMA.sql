USE master;
GO


--ALTER DATABASE SneezePharma SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DROP DATABASE SneezePharma;
--GO


CREATE DATABASE SneezePharma;
GO

Use SneezePharma;
GO

-- CLIENTES --
CREATE TABLE Clientes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(255) NOT NULL,
	CPF CHAR(11) NOT NULL UNIQUE,
	DataNascimento DATE NOT NULL,
	DataUltimaCompra DATE,
	DataCadastro DATE NOT NULL,
	IdEndereco INT NOT NULL,
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE ClientesRestritos (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	IdCliente INT NOT NULL UNIQUE
);

CREATE TABLE EnderecosClientes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Logradouro VARCHAR(64) NOT NULL,
	Numero NUMERIC(5,0),
	Complemento VARCHAR(255),
	Bairro VARCHAR(64) NOT NULL,
	Cidade VARCHAR(64) NOT NULL,
	Estado CHAR(2) NOT NULL,
	CEP CHAR(8) NOT NULL
);

CREATE TABLE TelefonesClientes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CodPais INT NOT NULL,
	DDD INT NOT NULL,
	Numero CHAR(9) NOT NULL,
	IdCliente INT NOT NULL
);

CREATE TYPE Tipo_TelefonesClientes AS TABLE(
	CodPais INT NOT NULL,
	DDD INT NOT NULL,
	Numero VARCHAR(9) NOT NULL
);

CREATE TABLE EmailsClientes(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Email VARCHAR(64) NOT NULL,
	IdCliente INT NOT NULL
);

CREATE TYPE Tipo_EmailsClientes AS TABLE(
	Email VARCHAR(64) NOT NULL
);

-- FORNECEDORES --
CREATE TABLE Fornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	RazaoSocial VARCHAR(255) NOT NULL,
	CNPJ CHAR(14) NOT NULL UNIQUE,
	DataAbertura DATE NOT NULL,
	DataUltimoFornecimento DATE,
	DataCadastro DATE NOT NULL,
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE FornecedoresRestritos (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	IdFornecedor INT NOT NULL UNIQUE
);

CREATE TABLE EnderecosFornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Logradouro VARCHAR(64) NOT NULL,
	Numero NUMERIC(5,0),
	Complemento VARCHAR(255),
	Bairro VARCHAR(64) NOT NULL,
	Cidade VARCHAR(64) NOT NULL,
	Estado CHAR(2) NOT NULL,
	Pais VARCHAR(64) NOT NULL,
	CEP CHAR(8) NOT NULL,
	IdFornecedor INT NOT NULL
);

CREATE TYPE Tipo_EnderecosFornecedores AS TABLE (
	Logradouro VARCHAR(64) NOT NULL,
	Numero NUMERIC(5,0),
	Complemento VARCHAR(255),
	Bairro VARCHAR(64) NOT NULL,
	Cidade VARCHAR(64) NOT NULL,
	Estado CHAR(2) NOT NULL,
	Pais VARCHAR(64) NOT NULL,
	CEP CHAR(8) NOT NULL
);

CREATE TABLE TelefonesFornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CodPais INT,
	DDD INT,
	Numero VARCHAR(18) NOT NULL,
	IdFornecedor INT NOT NULL
);

CREATE TYPE Tipo_TelefonesFornecedores AS TABLE (
	CodPais INT,
	DDD INT,
	Numero VARCHAR(18) NOT NULL
);

CREATE TABLE EmailsFornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Email VARCHAR(64) NOT NULL,
	IdFornecedor INT NOT NULL
);

CREATE TYPE Tipo_EmailsFornecedores AS TABLE (
	Email VARCHAR(64) NOT NULL
);

-- VENDAS E MEDICAMENTOS -- 
CREATE TABLE VendasMedicamentos (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	DataVenda DATE NOT NULL,
	ValorTotal DECIMAL(10,2),
	IdCliente INT NOT NULL,
);

CREATE TABLE ItensVendas (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Quantidade INT NOT NULL,
	ValorTotal DECIMAL(10,2),
	IdVenda INT NOT NULL,
	CDBMedicamento CHAR(13) NOT NULL
);

CREATE TYPE Tipo_ItensVendas AS TABLE (
	Quantidade INT NOT NULL,
	CDBMedicamento CHAR(13) NOT NULL
);

CREATE TABLE Medicamentos (
	CDB CHAR(13) NOT NULL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL,
	ValorVenda DECIMAL(10,2) NOT NULL,
	DataCadastro DATE NOT NULL,
	DataUltimaVenda DATE,
	Situacao CHAR(1) NOT NULL,
	Categoria CHAR(1) NOT NULL
);

CREATE TABLE CategoriasMedicamentos (
	Id CHAR(1)NOT NULL PRIMARY KEY,
	NomeCategoria VARCHAR(24)
);

CREATE TABLE Situacoes (
	Id CHAR(1) NOT NULL PRIMARY KEY,
	NomeSituacao VARCHAR(12)
);


-- PRINCIPIO ATIVO E PRODUCOES --
CREATE TABLE PrincipiosAtivos (
	Id CHAR(6) NOT NULL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL,
	DataCadastro DATE NOT NULL,
	UltimaCompra DATE,
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE Producoes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Quantidade INT NOT NULL,
	DataProducao DATE NOT NULL,
	CDBMedicamento CHAR(13) NOT NULL
);

CREATE TABLE ItensProducoes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	QuantidadePrincipio INT NOT NULL,
	IdPrincipioAtivo CHAR(6) NOT NULL,
	IdProducao INT NOT NULL
);

CREATE TYPE Tipo_ItensProducoes AS TABLE(
	QuantidadePrincipio INT NOT NULL,
	IdPrincipioAtivo CHAR(6) NOT NULL
);

-- COMPRAS --
CREATE TABLE Compras (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	DataCompra DATE NOT NULL,
	ValorTotal DECIMAL(10,2),
	IdFornecedor INT NOT NULL
);

CREATE TABLE ItensCompras (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Quantidade INT NOT NULL,
	ValorUnitario DECIMAL(10,2) NOT NULL,
	ValorTotal AS (Quantidade * ValorUnitario),
	IdCompra INT NOT NULL,
	IdPrincipioAtivo CHAR(6) NOT NULL
);

CREATE TYPE Tipo_ItensCompras AS TABLE (
	Quantidade INT NOT NULL,
	ValorUnitario DECIMAL(10,2) NOT NULL,
	IdPrincipioAtivo CHAR(6) NOT NULL
);

---- CHAVES ESTRANGEIRAS ----

-- Clientes --
ALTER TABLE Clientes
ADD FOREIGN KEY (IdEndereco) REFERENCES EnderecosClientes (Id);

ALTER TABLE Clientes
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

-- ClientesRestritos --
ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (IdCliente) REFERENCES Clientes (Id);

-- TelefonesClientes --
ALTER TABLE TelefonesClientes
ADD FOREIGN KEY (IdCliente) REFERENCES Clientes (Id);

-- EmailsClientes --
ALTER TABLE EmailsClientes
ADD FOREIGN KEY (IdCliente) REFERENCES Clientes (Id);

-- Fornecedores --
ALTER TABLE Fornecedores
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

-- FornecedoresRestritos --
ALTER TABLE FornecedoresRestritos
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- EnderecosFornecedores --
ALTER TABLE EnderecosFornecedores
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- TelefonesFornecedores --
ALTER TABLE TelefonesFornecedores
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- EmailsFornecedores --
ALTER TABLE EmailsFornecedores
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- VendasMedicamentos --
ALTER TABLE VendasMedicamentos
ADD FOREIGN KEY (IdCliente) REFERENCES Clientes (Id);

-- ItensVendas --
ALTER TABLE ItensVendas
ADD FOREIGN KEY (IdVenda) REFERENCES VendasMedicamentos (Id);

ALTER TABLE ItensVendas
ADD FOREIGN KEY (CDBMedicamento) REFERENCES Medicamentos (CDB);

ALTER TABLE ItensVendas
ADD UNIQUE (IdVenda, CDBMedicamento);

ALTER TABLE ItensVendas
ADD CHECK (Quantidade > 0 AND Quantidade <= 999);

-- Medicamentos --
ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Categoria) REFERENCES CategoriasMedicamentos (Id);

ALTER TABLE Medicamentos
ADD CHECK (ValorVenda > 0);

-- PrincipiosAtivos --
ALTER TABLE PrincipiosAtivos
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

-- Producoes --
ALTER TABLE Producoes
ADD FOREIGN KEY (CDBMedicamento) REFERENCES Medicamentos (CDB);

ALTER TABLE Producoes
ADD CHECK (Quantidade > 0 AND Quantidade <= 999);

-- ItensProducoes --
ALTER TABLE ItensProducoes
ADD FOREIGN KEY (IdPrincipioAtivo) REFERENCES PrincipiosAtivos (Id);

ALTER TABLE ItensProducoes
ADD FOREIGN KEY (IdProducao) REFERENCES Producoes (Id);

ALTER TABLE ItensProducoes
ADD CHECK (QuantidadePrincipio > 0 AND QuantidadePrincipio <= 9999);

-- Compras --
ALTER TABLE Compras
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- ItensCompras --
ALTER TABLE ItensCompras
ADD FOREIGN KEY (IdCompra) REFERENCES Compras (Id);

ALTER TABLE ItensCompras
ADD FOREIGN KEY (IdPrincipioAtivo) REFERENCES PrincipiosAtivos (Id);

ALTER TABLE ItensCompras
ADD CHECK (Quantidade > 0 AND Quantidade <= 999);

ALTER TABLE ItensCompras
ADD CHECK (ValorUnitario > 0);