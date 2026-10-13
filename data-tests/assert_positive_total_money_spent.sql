-- Singular test to verify orders have positive subtotal and order totals
select
    order_id,
    subtotal,
    order_total
from {{ ref('orders') }}
where subtotal < 0 or order_total < 0
