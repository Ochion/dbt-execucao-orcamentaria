-- Falha se a fato tiver mais ou menos linhas que a staging (perda ou duplicação em joins/transformações).
select
    s.total_staging,
    f.total_fato
from (select count(*) as total_staging from {{ ref('stg_execucao_orcamentaria') }}) as s
cross join (select count(*) as total_fato from {{ ref('fct_execucao') }}) as f
where s.total_staging != f.total_fato
