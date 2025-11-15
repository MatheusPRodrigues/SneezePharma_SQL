DECLARE @telefonesClientes Tipo_TelefonesClientes;
INSERT INTO @telefonesClientes VALUES
(55, 11, 995468543);

DECLARE @emailsClientes Tipo_EmailsClientes;
INSERT INTO @emailsClientes VALUES
('mathe@gmail.com');

EXEC sp_CadastrarCliente 'Matheus', 48309651241, '2001-12-30', 3, 'A', @emailsClientes, @telefonesClientes;
