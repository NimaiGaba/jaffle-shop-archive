-- Store performance and revenue contribution analysis
with store_sales as (
    select
        loc.location_name,
        loc.opened_at,
        loc.tax_rate,
        count(distinct ord.order_id) as total_orders,
        sum(ord.order_total) as gross_revenue,
        sum(ord.subtotal) as net_revenue,
        round(avg(ord.order_total), 2) as avg_ticket_size
    from {{ ref('orders') }} as ord
    inner join {{ ref('locations') }} as loc
        on ord.location_id = loc.location_id
    group by 1, 2, 3
),

ranked_stores as (
    select
        location_name,
        opened_at,
        tax_rate,
        total_orders,
        gross_revenue,
        net_revenue,
        avg_ticket_size,
        sum(gross_revenue) over () as total_network_revenue,
        round(100.0 * gross_revenue / nullif(sum(gross_revenue) over (), 0), 2) as revenue_share_pct
    from store_sales
)

select
    location_name,
    opened_at,
    total_orders,
    gross_revenue,
    net_revenue,
    avg_ticket_size,
    revenue_share_pct
from ranked_stores
order by gross_revenue desc
