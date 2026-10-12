select distinct
    favorecido_key,
    favorecido
from {{ ref('stg_execucao_orcamentaria') }}
