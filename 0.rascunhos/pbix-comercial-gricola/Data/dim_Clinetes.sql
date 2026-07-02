-- USE DB_DashbComercialPk

SELECT 
Cliente.id
,Cliente.descricao as descricao_cliente
,Geografia.cidade
,Geografia.uf
,Geografia.estado
,RegioesBrasil.Regiao
FROM dbo.Cliente
JOIN dbo.Geografia 
	on (Cliente.geografia_id = Geografia.id)
JOIN dbo.RegioesBrasil
	on (Geografia.uf = RegioesBrasil.UF)