select distinct
    situacao_key,
    situacao_execucao
from {{ ref('stg_execucao_orcamentaria') }}
