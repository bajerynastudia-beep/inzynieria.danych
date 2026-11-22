-- Wymiar daty: jeden wiersz na każdy dzień z okresu zamówień
with dni as (

    select day
    from unnest((
        select generate_date_array(min(cast(data_zamowienia as date)), max(cast(data_zamowienia as date)))
        from {{ ref('trf_zamowienia_scd1') }}
    )) as day

)

select
    cast(format_date('%Y%m%d', day) as int64) as data_sk,
    day                                       as data,
    extract(year from day)                    as rok,
    extract(month from day)                   as miesiac,
    format_date('%Y-%m', day)                 as rok_miesiac,
    extract(dayofweek from day) in (1, 7)     as czy_weekend
from dni
