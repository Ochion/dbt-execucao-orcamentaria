select distinct
    orgao_key,
    orgao_superior,
    orgao
from {{ ref('stg_execucao_orcamentaria') }}
