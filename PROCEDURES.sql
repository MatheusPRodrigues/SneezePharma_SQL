USE SneezePharma;
GO

CREATE OR ALTER PROCEDURE sp_ItensVendas
@idVenda INT,
@itens Tipo_ItensVendas READONLY
AS
BEGIN
	INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento)
	SELECT Quantidade, @idVenda, CDBMedicamento
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_VendasMedicamentos
@idCliente INT,
@itens Tipo_ItensVendas READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idVenda INT;

		INSERT INTO VendasMedicamentos (DataVenda, IdCliente) VALUES
		(GETDATE(), @idCliente);

		SET @idVenda = SCOPE_IDENTITY();

		EXEC sp_ItensVendas @idVenda, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_ItensCompras
@idCompra INT,
@itens Tipo_ItensCompras READONLY
AS
BEGIN
	INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
	SELECT Quantidade, ValorUnitario, @idCompra, IdPrincipioAtivo 
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_Compras
@idFornecedor INT,
@itens Tipo_ItensCompras READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idCompra INT;

		INSERT INTO Compras (DataCompra, IdFornecedor) VALUES
		(GETDATE(), @idFornecedor);

		SET @idCompra = SCOPE_IDENTITY();

		EXEC sp_ItensCompras @idCompra, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_ItensProducoes
@idProducao INT,
@itens Tipo_ItensProducoes READONLY
AS
BEGIN
	INSERT INTO ItensProducoes(QuantidadePrincipio, IdPrincipioAtivo, IdProducao)
	SELECT QuantidadePrincipio, IdPrincipioAtivo, @idProducao
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_Producoes
@quantidade INT,
@cdbMedicamento CHAR(13),
@itens Tipo_ItensProducoes READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idProducao INT;

		INSERT INTO Producoes(Quantidade, DataProducao, CDBMedicamento) VALUES
		(@quantidade, GETDATE(), @cdbMedicamento);

		SET @idProducao = SCOPE_IDENTITY();

		EXEC sp_ItensProducoes @idProducao, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_EmailsClientes
@idCliente INT,
@emailsClientes Tipo_EmailsClientes READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @emailsClientes) < 1)
	BEGIN
		THROW 50031, 'É necessário cadastrar pelo menos um email para o cliente!', 16;
	END;

	INSERT INTO EmailsClientes (Email, IdCliente)
	SELECT Email, @idCliente FROM @emailsClientes;
END;
GO

CREATE OR ALTER PROCEDURE sp_TelefonesClientes
@idCliente INT,
@telefonesClientes Tipo_TelefonesClientes READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @telefonesClientes) < 1)
	BEGIN
		THROW 50031, 'É necessário cadastrar pelo menos um telefone para o cliente!', 16;
	END;

	INSERT INTO TelefonesClientes (CodPais, DDD, Numero, IdCliente)
	SELECT CodPais, DDD, Numero, @idCliente
	FROM @telefonesClientes;
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarCliente
@nome VARCHAR(255),
@cpf CHAR(11),
@dataNascimento DATE,
@idEndereco INT,
@situacao CHAR(1),
@emailsClientes Tipo_EmailsClientes READONLY,
@telefonesClientes Tipo_TelefonesClientes READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idCliente INT;

		INSERT INTO Clientes (Nome, CPF, DataNascimento, DataCadastro, IdEndereco, Situacao) VALUES 
		(@nome, @cpf, @dataNascimento, GETDATE(), @idEndereco, @situacao);

		SET @idCliente = SCOPE_IDENTITY();

		EXEC sp_EmailsClientes @idCliente, @emailsClientes;
		EXEC sp_TelefonesClientes @idCliente, @telefonesClientes;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_EmailsFornecedores
@idFornecedor INT,
@emailsFornecedores Tipo_EmailsFornecedores READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @emailsFornecedores) < 1)
	BEGIN
		THROW 50051, 'É necessário cadastrar pelo menos um email para o fornecedor!', 16;
	END;

	INSERT INTO EmailsFornecedores (Email, IdFornecedor)
	SELECT Email, @idFornecedor FROM @emailsFornecedores;
END;
GO

CREATE OR ALTER PROCEDURE sp_TelefonesFornecedores
@idFornecedor INT,
@telefonesFornecedores Tipo_TelefonesFornecedores READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @telefonesFornecedores) < 1)
	BEGIN
		THROW 50051, 'É necessário cadastrar pelo menos um telefone para o fornecedor!', 16;
	END;

	INSERT INTO TelefonesFornecedores (CodPais, DDD, Numero, IdFornecedor)
	SELECT CodPais, DDD, Numero, @idFornecedor
	FROM @telefonesFornecedores;
END;
GO

CREATE OR ALTER PROCEDURE sp_EnderecosFornecedores
@idFornecedor INT,
@enderecosFornecedores Tipo_EnderecosFornecedores READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @enderecosFornecedores) < 1)
	BEGIN
		THROW 50051, 'É necessário cadastrar pelo menos um endereço para o fornecedor!', 16;
	END;

	INSERT INTO EnderecosFornecedores (Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor)
	SELECT Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, @idFornecedor 
	FROM @enderecosFornecedores;
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarFornecedor
@razaoSocial VARCHAR(255),
@cnpj CHAR(14),
@dataAbertura DATE,
@situacao CHAR(1),
@emailsFornecedores Tipo_EmailsFornecedores READONLY,
@telefonesFornecedores Tipo_TelefonesFornecedores READONLY,
@enderecosFornecedores Tipo_EnderecosFornecedores READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idFornecedor INT;

		INSERT INTO Fornecedores (RazaoSocial, CNPJ, DataAbertura, DataCadastro, Situacao) VALUES
		(@razaoSocial, @cnpj, @dataAbertura, GETDATE(), @situacao);

		SET @idFornecedor = SCOPE_IDENTITY();

		EXEC sp_EmailsFornecedores @idFornecedor, @emailsFornecedores;
		EXEC sp_TelefonesFornecedores @idFornecedor, @telefonesFornecedores;
		EXEC sp_EnderecosFornecedores @idFornecedor, @enderecosFornecedores;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO