-- Calendário contínuo entre a menor e a maior data de emissão.

with limites as (

    select
        min(data_emissao) as data_min,
        max(data_emissao) as data_max
    from {{ ref('stg_execucao_orcamentaria') }}

),

calendario as (

    select data
    from limites,
        unnest(generate_date_array(data_min, data_max)) as data

)

select
    cast(format_date('%Y%m%d', data) as int64)        as data_key,
    data,
    extract(year from data)                           as ano,
    extract(month from data)                          as mes,
    extract(day from data)                            as dia,
    extract(dayofweek from data)                      as dia_semana,  -- 1 = domingo ... 7 = sábado
    extract(dayofweek from data) in (1, 7)            as eh_fim_de_semana
from calendario
