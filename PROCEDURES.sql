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
@cdbMedicamento NUMERIC(13,0),
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
@cpf NUMERIC(11,0),
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