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
END;
 
DROP TRIGGER ValidarVendaMedicamento;