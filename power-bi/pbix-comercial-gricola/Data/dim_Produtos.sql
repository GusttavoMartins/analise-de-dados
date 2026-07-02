select
Produto.id
,Produto.descricao as descricao_produto
,Produto.tamanho
,Produto.custoUnitario
,CategoriaProduto.id as categoria_id
,CategoriaProduto.descricao as descricao_categoria
,FotosProdutos.url as url_imagem
from dbo.Produto
join dbo.CategoriaProduto
	on (Produto.categoria_id = CategoriaProduto.id)
left join dbo.FotosProdutos
	on (Produto.descricao = FotosProdutos.Produto)