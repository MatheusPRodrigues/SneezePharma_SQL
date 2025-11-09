USE SneezePharma;
GO

GO
CREATE TRIGGER ValidarVendaMedicamento
ON VendasMedicamentos
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Clientes c
		ON i.IdCliente = c.Id
		WHERE c.DataNascimento > DATEADD(YEAR, -18, GETDATE())
	)
	BEGIN
		THROW 50001, 'Cliente deve ter mínimo de 18 anos para realizar compra!', 16;
	END

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Clientes c
		ON i.IdCliente = c.Id
		LEFT JOIN ClientesRestritos cr
		ON c.Id = cr.IdCliente
		WHERE c.Situacao = 'I' OR cr.IdCliente IS NOT NULL
	)
	BEGIN 
		THROW 50002, 'Cliente inativo ou restringido!', 16;
	END

	INSERT INTO VendasMedicamentos (DataVenda, ValorTotal, IdCliente)
	SELECT DataVenda, NULL, IdCliente
	FROM inserted;

	UPDATE c
	SET c.DataUltimaCompra = GETDATE()
	FROM Clientes c
	JOIN inserted i
	ON c.Id = i.IdCliente;
END;
GO

GO
CREATE TRIGGER ValidarItensVendas
ON ItensVendas
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Medicamentos m
		ON i.CDBMedicamento = m.CDB
		LEFT JOIN Producoes p
		ON p.CDBMedicamento = m.CDB
		WHERE m.Situacao = 'I' OR p.CDBMedicamento IS NULL
	)
	BEGIN
		THROW 50017, 'Medicamento está inativo ou ainda não foi produzido!', 16;
	END
	
	IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE (SELECT COUNT(*) 
               FROM ItensVendas iv
               WHERE i.IdVenda = iv.IdVenda) >= 3
    )
    BEGIN
        THROW 50020, 'Cada venda só pode ter até 3 registros de medicamentos!', 16;
	END
	
	-- insere na tabela ItensVendas
	INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento)
	SELECT Quantidade, IdVenda, CDBMedicamento
	FROM inserted;

	-- atualiza ValorTotal do ItensVendas
	UPDATE iv
	SET iv.ValorTotal = m.ValorVenda * iv.Quantidade
	FROM ItensVendas iv
	INNER JOIN inserted i 
    ON iv.IdVenda = i.IdVenda
	AND iv.CDBMedicamento = i.CDBMedicamento
	INNER JOIN Medicamentos m 
    ON m.CDB = iv.CDBMedicamento;

	-- atualiza UltimaVenda na tabela Medicamentos
	UPDATE m 
    SET m.DataUltimaVenda = GETDATE()
    FROM Medicamentos m
    INNER JOIN inserted i 
	ON m.CDB = i.CDBMedicamento;

	-- atualiza ValorTotal na tabela Vendas
	UPDATE vm
	SET vm.ValorTotal = (SELECT SUM(ValorTotal) 
                        FROM ItensVendas iv 
                        WHERE iv.IdVenda = vm.Id)
	FROM VendasMedicamentos vm
	INNER JOIN inserted i 
	ON vm.Id = i.IdVenda;
END;
GO

-- Verifica se o Fornecedor possuí mais de dois anos de fundação, se ele está ativo e se ele não está restrito. Se acontecer o insert,
-- atualiza a data do último fornecimento do Fornecedor
GO
CREATE TRIGGER ValidarCompraIngrediente
ON Compras
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Fornecedores f
		ON i.IdFornecedor = f.Id
		WHERE f.DataAbertura > DATEADD(YEAR, -2, GETDATE())
	)
	BEGIN
		THROW 50001, 'Fornecedor precisa ter no mínimo dois anos de fundação para poder realizar uma venda!', 16;
	END
	
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Fornecedores f
		ON i.IdFornecedor = f.Id
		LEFT JOIN FornecedoresRestritos fr
		ON f.Id = fr.IdFornecedor
		WHERE f.Situacao = 'I' OR fr.IdFornecedor IS NOT NULL
	)
	BEGIN 
		THROW 50002, 'Fornecedor inativo ou restringido!', 16;
	END
	
	-- insere na tabela Compras
	INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor)
	SELECT DataCompra, NULL, IdFornecedor
	FROM inserted;

	-- atualiza DataUltimoFornecimento na tabela Fornecedores
	UPDATE f
    SET f.DataUltimoFornecimento = GETDATE()
    FROM Fornecedores f
    INNER JOIN inserted i 
	ON f.Id = i.IdFornecedor;
END;
GO

-- verifica se já não existe três registro na tabela ItensCompras relacionado ao IdCompra da inserçao; verifica se o principio ativo
-- informado pa a inserçao está ativo; se a inserção der certo, atualiza a data da ultima compra na tabela PrincipiosAtivos 
-- e atualiza ValorTotal na tabela Compras
GO
CREATE TRIGGER ValidarItensCompras
ON ItensCompras
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN PrincipiosAtivos pa
		ON i.IdPrincipioAtivo = pa.Id
		WHERE pa.Situacao = 'I'
	)
	BEGIN
		THROW 50001, 'Princípio Ativo está inativo!', 16;
	END

	IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE (SELECT COUNT(*) 
               FROM ItensCompras 
               WHERE IdCompra = i.IdCompra) >= 3
    )
    BEGIN
        THROW 50020, 'Cada compra só pode ter até 3 registros de princípios ativos!', 16;
	END
	
	-- insere na tabela ItensCompra
	INSERT INTO ItensCompras (Quantidade, ValorUnitario, ValorTotal, IdCompra, IdPrincipioAtivo)
	SELECT Quantidade, ValorUnitario, (Quantidade * ValorUnitario), IdCompra, IdPrincipioAtivo
	FROM inserted;

	-- atualiza UltimaCompra na tabela PrincipiosAtivos
	UPDATE pa 
    SET pa.UltimaCompra = GETDATE()
    FROM PrincipiosAtivos pa
    INNER JOIN inserted i 
	ON pa.Id = i.IdPrincipioAtivo;

	-- atualiza ValorTotal na tabela Compras
	UPDATE c
	SET c.ValorTotal = (SELECT SUM(ValorTotal) 
                        FROM ItensCompras ic 
                        WHERE ic.IdCompra = c.Id)
	FROM Compras c
	INNER JOIN inserted i 
	ON c.Id = i.IdCompra;
END; 
GO

-- Producoes --
GO
CREATE TRIGGER ValidarProducoes
ON Producoes
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Medicamentos m
		ON i.CDBMedicamento = m.CDB
		WHERE m.Situacao = 'I'
	)
	BEGIN
		THROW 50041, 'O medicamento informado não pode ser produzido, pois está inativo!', 16;
	END

	INSERT INTO Producoes (Quantidade, DataProducao, CDBMedicamento)
	SELECT Quantidade, DataProducao, CDBMedicamento
	FROM inserted;
END;
GO

-- ItensDeProducao --
GO
CREATE TRIGGER ValidarItensProducoes
ON ItensProducoes
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN PrincipiosAtivos pa
		ON i.IdPrincipioAtivo = pa.Id
		WHERE pa.Situacao = 'I'
	)
	BEGIN
		THROW 50041, 'Princípio Ativo está inativo!', 16;
	END

	INSERT INTO ItensProducoes (QuantidadePrincipio, IdPrincipioAtivo, IdProducao)
	SELECT QuantidadePrincipio, IdPrincipioAtivo, IdProducao
	FROM inserted;
END;
GO

-- // TRIGGERS DE DELETE \\ --

-- Clientes --
GO
CREATE TRIGGER DeletarCliente
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
	THROW 50020, 'Operação DELETE não autorizada na tabela Clientes', 16;	
END;
GO

-- Fornecedores --
GO
CREATE TRIGGER DeletarFornecedor
ON Fornecedores
INSTEAD OF DELETE
AS
BEGIN
	THROW 50021, 'Operação DELETE não autorizada na tabela Fornecedores', 16;	
END;
GO

-- PrincipioAtivo --
GO
CREATE TRIGGER DeletarPrincipioAtivo
ON PrincipiosAtivos
INSTEAD OF DELETE
AS
BEGIN
	THROW 50022, 'Operação DELETE não autorizada na tabela PrincipiosAtivos', 16;	
END;
GO

-- Medicamentos --
GO
CREATE TRIGGER DeletarMedicamento
ON Medicamentos
INSTEAD OF DELETE
AS
BEGIN
	THROW 50023, 'Operação DELETE não autorizada na tabela Medicamentos', 16;	
END;
GO