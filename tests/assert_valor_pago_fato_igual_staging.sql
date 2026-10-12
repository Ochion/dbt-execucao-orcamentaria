-- Falha se o total pago da fato divergir do total pago da staging.
select
    s.total_staging,
    f.total_fato
from (select sum(valor_pago) as total_staging from {{ ref('stg_execucao_orcamentaria') }}) as s
cross join (select sum(valor_pago) as total_fato from {{ ref('fct_execucao') }}) as f
where s.total_staging != f.total_fato
