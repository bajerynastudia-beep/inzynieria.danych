-- Wymiar: klienci z historią zmian (na bazie SCD 2).
-- Pierwsza wersja obowiązuje "od zawsze" (1900-01-01), a aktualna "do odwołania"
-- (9999-12-31), więc każde zamówienie trafi dokładnie w jedną wersję.
select
    klienci_sk as klient_sk,
    id        as klient_id,
    nazwa, miasto, adres,
    case when valid_from = min(valid_from) over (partition by id)
         then date '1900-01-01' else valid_from end as obowiazuje_od,
    coalesce(valid_to, date '9999-12-31')          as obowiazuje_do,
    is_active                                      as czy_aktualny
from {{ ref('trf_klienci_scd2') }}
