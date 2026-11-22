select *
from {{ source("lunchlink", "pozycje_zamowienia") }}
qualify row_number() over (partition by zamowienie_id, nr_pozycji order by updated_at desc) = 1
