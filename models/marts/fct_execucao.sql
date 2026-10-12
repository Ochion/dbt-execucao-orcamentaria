-- Fato: um registro por empenho (grão = codigo_empenho).

select
    codigo_empenho,

    data_key,
    orgao_key,
    favorecido_key,
    despesa_key,
    situacao_key,

    estorno_cancelamento,

    valor_original_empenho,
    valor_liquidado,
    valor_pago,
    percentual_liquidado,
    percentual_pago

from {{ ref('stg_execucao_orcamentaria') }}
