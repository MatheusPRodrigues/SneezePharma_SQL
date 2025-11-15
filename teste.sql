DECLARE @telefonesFornecedores Tipo_TelefonesFornecedores;
INSERT INTO @telefonesFornecedores VALUES
(NULL, NULL, '0800313131');

DECLARE @emailsFornecedores Tipo_EmailsFornecedores;
INSERT INTO @emailsFornecedores VALUES
('pira@gmail.com');

DECLARE @enderecosFornecedores Tipo_EnderecosFornecedores;
INSERT INTO @enderecosFornecedores VALUES 
('Rua jardim', 1004, NULL, 'Jardim Ipiranga', 'Mogi das Cruzes', 'SP', 'Brasil', '43304310');

EXEC sp_CadastrarFornecedor 'Piracanjuba',
							'19456798534552',
							'1984-07-04',
							'A',
							@emailsFornecedores,
							@telefonesFornecedores,
							@enderecosFornecedores;

SELECT * FROM Fornecedores;
