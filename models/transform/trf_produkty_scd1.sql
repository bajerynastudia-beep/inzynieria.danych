select *
from {{ source("lunchlink", "produkty") }}
qualify row_number() over (partition by id order by updated_at desc) = 1
