-- Test własny: każda pozycja zamówienia musi trafić do tabeli faktów.
-- Zwraca pozycje, które "zgubiły się" przy łączeniu z wymiarami (test przechodzi, gdy wynik jest pusty).
select pz.zamowienie_id, pz.nr_pozycji
from {{ ref('trf_pozycje_zamowienia_scd1') }} pz
left join {{ ref('fakt_sprzedaz') }} f
    on f.zamowienie_id = pz.zamowienie_id
   and f.nr_pozycji = pz.nr_pozycji
where f.zamowienie_id is null
