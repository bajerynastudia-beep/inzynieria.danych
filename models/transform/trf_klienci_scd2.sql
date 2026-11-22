{{
    config(
        materialized = 'table'
    )
}}

-- ekstrakcja daty z timestampu dla kolumny updated_at
with base as (

    select *, 
        CAST(DATE(updated_at) AS DATE) as reference_date
    from {{ source("lunchlink", "klienci") }}

),

-- ustalenie ostatniej wersji każdego rekordu dla danego dnia
last_version_per_day as (

    select *
    from base
    qualify row_number() over (partition by id, reference_date order by updated_at desc) = 1

),

-- dodanie kolumn valid_from i valid_to, typowych dla SCD typu 2
version_bounds as (

    select
        id,
        nazwa, miasto, adres,
        reference_date,
        reference_date as valid_from,
        lead(reference_date) over (partition by id order by reference_date) - 1 as valid_to
    from last_version_per_day

)

-- dodanie klucza zastępczego (ang. surrogate key) i flagi aktywnej wersji
select
    md5(id || reference_date) as klienci_sk,
    id,
    nazwa, miasto, adres,
    valid_from,
    valid_to,
    case when valid_to is null then true else false end as is_active
from version_bounds
