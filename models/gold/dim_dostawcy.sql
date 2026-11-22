-- Wymiar: dostawcy z historią zmian (na bazie SCD 2).
-- Pierwsza wersja obowiązuje "od zawsze" (1900-01-01), a aktualna "do odwołania"
-- (9999-12-31), więc każde zamówienie trafi dokładnie w jedną wersję.
select
    dostawcy_sk as dostawca_sk,
    id        as dostawca_id,
    nazwa, miasto, prowizja_proc,
    case when valid_from = min(valid_from) over (partition by id)
         then date '1900-01-01' else valid_from end as obowiazuje_od,
    coalesce(valid_to, date '9999-12-31')          as obowiazuje_do,
    is_active                                      as czy_aktualny
from {{ ref('trf_dostawcy_scd2') }}
