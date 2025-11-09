-- QUERY DE CONSULTA DA TABELA Clientes --
SELECT
	c.Id, c.Nome, c.CPF, c.DataNascimento, c.DataUltimaCompra, c.DataCadastro,
	s.NomeSituacao'Situacao',
	ec.Logradouro, ec.Numero, ec.Complemento, ec.Bairro, ec.Cidade, ec.Estado, ec.CEP,
	tc.CodPais, tc.DDD, tc.Numero,
	e.Email
FROM Clientes c
LEFT JOIN Situacoes s
ON c.Situacao = s.Id
JOIN EnderecosClientes ec
ON c.IdEndereco = ec.Id
JOIN TelefonesClientes tc
ON tc.IdCliente = c.Id
JOIN EmailsClientes e
ON e.IdCliente = c.Id;

-- QUERY DE CONSULTA DA TABELA Fornecedores --
SELECT
	f.Id, f.RazaoSocial, f.CNPJ, f.DataAbertura, f.DataCadastro, f.DataUltimoFornecimento,
	s.NomeSituacao'Situacao',
	ef.Logradouro, ef.Numero, ef.Complemento, ef.Bairro, ef.Cidade, ef.Estado, ef.Pais, ef.CEP,
	tf.CodPais, tf.DDD, tf.Numero,
	e.Email
FROM Fornecedores f
LEFT JOIN Situacoes s
ON f.Situacao = s.Id
JOIN EnderecosFornecedores ef
ON ef.IdFornecedor = f.Id
JOIN TelefonesFornecedores tf
ON tf.IdFornecedor = f.Id
JOIN EmailsFornecedores e
ON e.IdFornecedor = f.Id;

-- QUERY DE CONSULTA DA TABELA Vendas e ItensVendas --
SELECT
    v.Id'Código da Venda', v.DataVenda 'Data da Venda', v.ValorTotal'Valor Total da Venda',
	c.CPF, c.Nome,
    iv.Id'Código do Item',iv.CDBMedicamento'CDB do Medicamento', m.Nome'Medicamento', iv.Quantidade, iv.ValorTotal'Valor Total do Item'
FROM VendasMedicamentos v
JOIN Clientes c
ON c.Id = v.IdCliente
JOIN ItensVendas iv
ON v.Id = iv.IdVenda
JOIN Medicamentos m
ON m.CDB = iv.CDBMedicamento
ORDER BY v.Id, iv.Id;

-- QUERY DE CONSULTA DA TABELA Compras e ItensCompras --
SELECT
    c.Id AS 'Código da Compra', c.DataCompra AS 'Data da Compra',c.ValorTotal AS 'Valor Total da Compra',
	f.CNPJ AS 'CNPJ', f.RazaoSocial AS 'Razão Social',
    i.Id AS 'Código do Item',i.IdPrincipioAtivo AS 'Princípio Ativo', i.Quantidade AS 'Quantidade', i.ValorUnitario AS 'Valor Unitário', i.ValorTotal AS 'Valor Total do Item'
FROM Compras c
INNER JOIN Fornecedores f
ON f.Id = c.IdFornecedor
INNER JOIN ItensCompras i 
ON c.Id = i.IdCompra
ORDER BY c.Id, i.Id;

-- QUERY DE CONSULTA DA TABELA Producoes e ItensProducoes --
SELECT
	p.Id, p.Quantidade 'Quantidade produzida', p.DataProducao'Data de Produção',
	m.CDB, m.Nome,
	i.Id 'Código do Item', i.IdPrincipioAtivo 'Princípio Ativo', pa.Nome, i.QuantidadePrincipio 'Quantidade de Princípio Ativo'
FROM Producoes p
JOIN Medicamentos m
ON p.CDBMedicamento = m.CDB
JOIN ItensProducoes i
ON i.IdProducao = p.Id
JOIN PrincipiosAtivos pa
ON pa.Id = i.IdPrincipioAtivo

-- QUERY DE CONSULTA DA TABELA Medicamentos --
SELECT
	m.CDB, m.Nome, m.ValorVenda'Valor de Venda', m.DataCadastro'Data de Cadastro', m.DataUltimaVenda'Data última venda',
	s.NomeSituacao'Situação',
	cm.NomeCategoria'Categoria'
FROM Medicamentos m
JOIN Situacoes s
ON s.Id = m.Situacao
JOIN CategoriasMedicamentos cm
ON cm.Id = m.Categoria

-- QUERY DE CONSULTA DA TABELA PrincipiosAtivos --
SELECT
	p.Id, p.Nome, p.DataCadastro'Data de Cadastro', p.UltimaCompra'Data última compra',
	s.NomeSituacao'Situação'
FROM PrincipiosAtivos p 
JOIN Situacoes s
ON s.Id = p.Situacao

-- QUERY DE CONSULTA DA TABELA ClientesRestritos --
SELECT 
	cr.Id'Id Restrito',
	c.Id'Id Cliente', c.CPF, c.Nome
FROM ClientesRestritos cr
JOIN Clientes c
ON c.Id = cr.IdCliente

-- QUERY DE CONSULTA DA TABELA FornecedoresRestritos --
SELECT 
	fr.Id'Id Restrito',
	f.Id'Id Fornecedor', f.CNPJ, f.RazaoSocial'Razão Social'
FROM FornecedoresRestritos fr
JOIN Fornecedores f
ON f.Id = fr.IdFornecedor

-- Relatório de vendas por período --
SELECT
    v.Id'Código da Venda', v.DataVenda 'Data da Venda', v.ValorTotal'Valor Total da Venda',
	c.CPF, c.Nome,
    iv.Id'Código do Item',iv.CDBMedicamento'CDB do Medicamento', m.Nome'Medicamento', iv.Quantidade, iv.ValorTotal'Valor Total do Item'
FROM VendasMedicamentos v
JOIN Clientes c
ON c.Id = v.IdCliente
JOIN ItensVendas iv
ON v.Id = iv.IdVenda
JOIN Medicamentos m
ON m.CDB = iv.CDBMedicamento
WHERE v.DataVenda BETWEEN '2025-10-20' AND '2025-11-30'
ORDER BY v.Id, iv.Id;

-- Relatório de medicamentos mais vendidos --
SELECT 
	m.CDB, m.Nome,
	cm.NomeCategoria'Categoria',
	SUM(iv.Quantidade)'Total Vendido'
FROM Medicamentos m
JOIN CategoriasMedicamentos cm
ON cm.Id = m.Categoria
JOIN ItensVendas iv
ON iv.CDBMedicamento = m.CDB
GROUP BY 
	m.CDB, m.Nome, cm.NomeCategoria
ORDER BY 
	'Total Vendido' 
DESC;

-- Relatório de compras por fornecedor --
SELECT
    c.Id AS 'Código da Compra', c.DataCompra AS 'Data da Compra',c.ValorTotal AS 'Valor Total da Compra',
	f.CNPJ AS 'CNPJ', f.RazaoSocial AS 'Razão Social',
    i.Id AS 'Código do Item',i.IdPrincipioAtivo AS 'Princípio Ativo', i.Quantidade AS 'Quantidade', i.ValorUnitario AS 'Valor Unitário', i.ValorTotal AS 'Valor Total do Item'
FROM Compras c
INNER JOIN Fornecedores f
ON f.Id = c.IdFornecedor
INNER JOIN ItensCompras i 
ON c.Id = i.IdCompra
WHERE f.CNPJ = '12345678000199'
ORDER BY c.Id, i.Id;