WITH rateio_desconto as (
	select
	Vendas.nfe
	,CAST(left(Vendas.data, 10) as DATE) as data
	,coalesce(Vendas.cliente_id, 0) as cliente_id
	,coalesce(ClientesVendedores.vendedor_id, 0) as vendedor_id
	,coalesce(Vendas.valor_bruto, 0.00) as valorTotal_nota
	,coalesce(Vendas.nf_desconto, 0.00) as nf_desconto
	,coalesce(Vendas.valor_venda, 0.00) as valor_venda
	,coalesce(Itensvendas.produto_id, 0) as produto_id
	,coalesce(Itensvendas.valor_unitario, 0.00) as valor_unitario
	,coalesce(Itensvendas.item_quantidade, 0) as item_quantidade
	,coalesce(Itensvendas.valor_bruto, 0.00) as valor_bruto_item
	,ItensVendas.valor_bruto / vendas.valor_bruto as desconto_per
	,round(Vendas.nf_desconto * (ItensVendas.valor_bruto / vendas.valor_bruto), 2) as valorD_desconto
	from dbo.Vendas
	inner join dbo.ItensVendas
		on(vendas.id = ItensVendas.vendas_id)
	inner join dbo.ClientesVendedores
		on(Vendas.cliente_id = ClientesVendedores.cliente_id)

	--where nfe = 'SO43670' --'SO43847'
), arredondamento as (

	select 
	 nfe
	,data
	,cliente_id
	,vendedor_id
	,produto_id
	,valor_unitario
	,item_quantidade
	,valor_bruto_item as valor_bruto
	,valorD_desconto
	,ROW_NUMBER() over(partition by nfe order by valor_bruto_item desc) as _rank
	,valor_venda
	,round(valor_venda - sum(valor_bruto_item - valorD_desconto) over(partition by nfe), 2) as dif_final
	from rateio_desconto
)

select
 nfe
,vendedor_id
,cliente_id
,produto_id
,valor_unitario
,item_quantidade
,valor_bruto
,case
	when _rank = 1
	then valorD_desconto - dif_final
	else valorD_desconto
end as valorD_desconto
,
valor_bruto -
case
	when _rank = 1
	then valorD_desconto - dif_final
	else valorD_desconto
end as valor_liquido
,
data as data_venda
from arredondamento


