select
Vendedor.id
,Vendedor.descricao as descricao_vendedor
,Supervisor.descricao as descricao_supervisor
,Supervisor.gerente_id as gerente_id
, Supervisor.gerente_descricao as descricao_gerente
from dbo.Vendedor
join dbo.Supervisor
	on (Vendedor.supervisor_id = Supervisor.id)
