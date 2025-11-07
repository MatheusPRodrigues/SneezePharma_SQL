USE master;
GO

-- DROP DATABASE SneezePharma;

CREATE DATABASE SneezePharma;
GO

Use SneezePharma;
GO

-- CLIENTES --
CREATE TABLE Clientes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(255) NOT NULL,
	CPF NUMERIC(11,0) NOT NULL UNIQUE,
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
	CEP NUMERIC(8,0) NOT NULL
);

CREATE TABLE TelefonesClientes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CodPais INT NOT NULL,
	DDD INT NOT NULL,
	Numero NUMERIC(9,0) NOT NULL,
	IdCliente INT NOT NULL
);

CREATE TABLE EmailsClientes(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Email VARCHAR(64) NOT NULL,
	IdCliente INT NOT NULL
);


-- FORNECEDORES --
CREATE TABLE Fornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	RazaoSocial VARCHAR(255) NOT NULL,
	CNPJ NUMERIC(14,0) NOT NULL UNIQUE,
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
	CEP NUMERIC(8,0) NOT NULL,
	IdFornecedor INT NOT NULL
);

CREATE TABLE TelefonesFornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CodPais INT,
	DDD INT,
	Numero NUMERIC NOT NULL,
	IdFornecedor INT NOT NULL
);

CREATE TABLE EmailsFornecedores (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Email VARCHAR(64) NOT NULL,
	IdFornecedor INT NOT NULL
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
	ValorTotal DECIMAL(10,2) NOT NULL,
	IdVenda INT NOT NULL,
	CDBMedicamento NUMERIC(13,0) NOT NULL
);

CREATE TABLE Medicamentos (
	CDB NUMERIC(13,0) NOT NULL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL,
	ValorVenda DECIMAL(4,2) NOT NULL,
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
	CDBMedicamento NUMERIC(13,0) NOT NULL
);

CREATE TABLE ItensProducoes (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	QuantidadePrincipio INT NOT NULL,
	IdPrincipioAtivo CHAR(6) NOT NULL,
	IdProducao INT NOT NULL
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
	ValorUnitario DECIMAL(4,2) NOT NULL,
	ValorTotal DECIMAL(10,2) NOT NULL,
	IdCompra INT NOT NULL,
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

-- Medicamentos --
ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Categoria) REFERENCES CategoriasMedicamentos (Id);

-- PrincipiosAtivos --
ALTER TABLE PrincipiosAtivos
ADD FOREIGN KEY (Situacao) REFERENCES Situacoes (Id);

-- Producoes --
ALTER TABLE Producoes
ADD FOREIGN KEY (CDBMedicamento) REFERENCES Medicamentos (CDB);

-- ItensProducoes --
ALTER TABLE ItensProducoes
ADD FOREIGN KEY (IdPrincipioAtivo) REFERENCES PrincipiosAtivos (Id);

ALTER TABLE ItensProducoes
ADD FOREIGN KEY (IdProducao) REFERENCES Producoes (Id);

-- Compras --
ALTER TABLE Compras
ADD FOREIGN KEY (IdFornecedor) REFERENCES Fornecedores (Id);

-- ItensCompras --
ALTER TABLE ItensCompras
ADD FOREIGN KEY (IdCompra) REFERENCES Compras (Id);

ALTER TABLE ItensCompras
ADD FOREIGN KEY (IdPrincipioAtivo) REFERENCES PrincipiosAtivos (Id);