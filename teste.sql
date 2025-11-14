DECLARE @ItensProducoes Tipo_ItensProducoes;

INSERT INTO @ItensProducoes VALUES
(20, 'AI0001'),
(20, 'AI0002'),
(20, 'AI0003'),
(20, 'AI0004');

EXEC sp_Producoes 20, '7891234567892', @ItensProducoes;

SELECT * FROM Producoes;
SELECT * FROM ItensProducoes;

DELETE FROM ItensProducoes;
DELETE FROM Producoes;