-- Wymiar: produkty z historią zmian (na bazie SCD 2).
-- Kolumna miasto (miasto dostawcy) jest dodana na potrzeby RLS.
select
    p.produkty_sk as produkt_sk,
    p.id          as produkt_id,
    p.dostawca_id, p.nazwa, p.kategoria, p.cena,
    d.miasto,
    case when p.valid_from = min(p.valid_from) over (partition by p.id)
         then date '1900-01-01' else p.valid_from end as obowiazuje_od,
    coalesce(p.valid_to, date '9999-12-31')          as obowiazuje_do,
    p.is_active                                      as czy_aktualny
from {{ ref('trf_produkty_scd2') }} p
left join {{ ref('trf_dostawcy_scd1') }} d
    on d.id = p.dostawca_id
