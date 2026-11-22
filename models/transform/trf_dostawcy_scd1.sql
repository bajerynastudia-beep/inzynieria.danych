select *
from {{ source("lunchlink", "dostawcy") }}
qualify row_number() over (partition by id order by updated_at desc) = 1
