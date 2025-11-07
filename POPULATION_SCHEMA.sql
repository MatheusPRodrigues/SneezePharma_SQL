-- Enderecos Clientes --
INSERT INTO EnderecosClientes VALUES ('Av. Princesa Isabel', 505, NULL, 'Maria Luiza', 'Aracity', 'SP', 14820055);
INSERT INTO EnderecosClientes VALUES ('Rua Bananinha', 1023, 'Em frente a bananeira', 'Santana', 'Bananacity', 'MG', 31471844);
INSERT INTO EnderecosClientes VALUES ('Rua das Flores', 32, NULL, 'Jardim Primavera', 'Americo Brasiliense', 'SP', 14820000);

SELECT * FROM EnderecosClientes;

-- Situacoes --
INSERT INTO Situacoes VALUES
('A', 'Ativo'),
('I', 'Inativo');

SELECT * FROM Situacoes;

-- Clientes --
INSERT INTO Clientes VALUES ('João', 43209614501, '1993-05-16', NULL, GETDATE(), 1, 'A');
INSERT INTO Clientes VALUES ('José', 85031531513, '2009-05-12', NULL, GETDATE(), 1, 'A');
INSERT INTO Clientes VALUES ('Juca', 38030851751, '1986-10-23', NULL, GETDATE(), 3, 'I');
INSERT INTO Clientes VALUES ('Roberta', 43145105632, '2001-05-06', NULL, GETDATE(), 2, 'A');

SELECT * FROM Clientes;

-- ClientesRestritos --
INSERT INTO ClientesRestritos VALUES (4);

-- VendasMedicamentos --
INSERT INTO VendasMedicamentos VALUES (GETDATE(), NULL, 3);

SELECT * FROM VendasMedicamentos;

