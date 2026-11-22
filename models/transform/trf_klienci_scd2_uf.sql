-- użycie SCD typu 2 jako bazy
with base as (

    select * except (klienci_sk)
    from {{ ref('trf_klienci_scd2') }}

),

-- generowanie zakresu dat na podstawie minimalnej i maksymalnej wartości valid_from z SCD typu 2
dates as (

    SELECT day
    FROM UNNEST((
    SELECT GENERATE_DATE_ARRAY(MIN(valid_from), MAX(valid_from))
    FROM base
    )) AS day

)

select base.*, dates.day as reference_date
from base
    join dates on dates.day between base.valid_from and base.valid_to
