-- Camada staging: limpa, tipa e cria as chaves das dimensões.
-- As chaves são calculadas aqui para que fato e dimensões usem exatamente a mesma regra.

with source as (

    select * from {{ source('gastos_publicos', 'execucao_orcamentaria') }}

),

limpo as (

    select
        cast(codigo_empenho as string)                                    as codigo_empenho,
        safe_cast(data_emissao as date)                                   as data_emissao,

        coalesce(nullif(trim(orgao_superior), ''), 'Não informado')       as orgao_superior,
        coalesce(nullif(trim(orgao), ''), 'Não informado')                as orgao,
        coalesce(nullif(trim(favorecido), ''), 'Não informado')           as favorecido,
        coalesce(nullif(trim(categoria_despesa), ''), 'Não informado')    as categoria_despesa,
        coalesce(nullif(trim(elemento_despesa), ''), 'Não informado')     as elemento_despesa,
        coalesce(nullif(trim(funcao), ''), 'Não informado')               as funcao,
        coalesce(nullif(trim(situacao_execucao), ''), 'Não informado')    as situacao_execucao,

        estorno_cancelamento,

        coalesce(safe_cast(valor_original_empenho as numeric), 0)         as valor_original_empenho,
        coalesce(safe_cast(valor_liquidado as numeric), 0)                as valor_liquidado,
        coalesce(safe_cast(valor_pago as numeric), 0)                     as valor_pago,
        safe_cast(percentual_liquidado as float64)                        as percentual_liquidado,
        safe_cast(percentual_pago as float64)                             as percentual_pago

    from source

),

com_chaves as (

    select
        *,
        to_hex(md5(concat(orgao_superior, '|', orgao)))                              as orgao_key,
        to_hex(md5(favorecido))                                                      as favorecido_key,
        to_hex(md5(concat(categoria_despesa, '|', elemento_despesa, '|', funcao)))   as despesa_key,
        to_hex(md5(situacao_execucao))                                               as situacao_key,
        cast(format_date('%Y%m%d', data_emissao) as int64)                           as data_key
    from limpo

)

select * from com_chaves
