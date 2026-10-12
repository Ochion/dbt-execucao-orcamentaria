select distinct
    despesa_key,
    categoria_despesa,
    elemento_despesa,
    funcao
from {{ ref('stg_execucao_orcamentaria') }}
