-- Tabela faktów: jeden wiersz = jedna pozycja zamówienia.
-- Do każdej pozycji dobieramy tę wersję klienta, produktu i dostawcy,
-- która obowiązywała w dniu zamówienia. Kolumna miasto (miasto klienta) służy do RLS.
with zamowienia as (

    select *, cast(data_zamowienia as date) as data
    from {{ ref('trf_zamowienia_scd1') }}

)

select
    pz.zamowienie_id,
    pz.nr_pozycji,
    dd.data_sk,
    k.klient_sk,
    p.produkt_sk,
    d.dostawca_sk,
    z.status,
    pz.ilosc,
    p.cena                                              as cena_jednostkowa,
    pz.ilosc * p.cena                                   as wartosc,
    round(pz.ilosc * p.cena * d.prowizja_proc / 100, 2) as prowizja,
    k.miasto
from {{ ref('trf_pozycje_zamowienia_scd1') }} pz
join zamowienia z
    on z.id = pz.zamowienie_id
join {{ ref('dim_data') }} dd
    on dd.data = z.data
join {{ ref('dim_klienci') }} k
    on k.klient_id = z.klient_id
   and z.data between k.obowiazuje_od and k.obowiazuje_do
join {{ ref('dim_produkty') }} p
    on p.produkt_id = pz.produkt_id
   and z.data between p.obowiazuje_od and p.obowiazuje_do
join {{ ref('dim_dostawcy') }} d
    on d.dostawca_id = p.dostawca_id
   and z.data between d.obowiazuje_od and d.obowiazuje_do
