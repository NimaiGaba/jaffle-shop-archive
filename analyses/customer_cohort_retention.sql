-- Customer monthly cohort retention and spend analysis
with customer_orders as (
    select
        customer_id,
        first_ordered_at,
        most_recent_order_at,
        lifetime_spend_pretax,
        count_lifetime_orders
    from {{ ref('customers') }}
),

cohort_summary as (
    select
        date_trunc('month', first_ordered_at) as cohort_month,
        count(customer_id) as total_customers,
        sum(count_lifetime_orders) as total_cohort_orders,
        avg(count_lifetime_orders) as avg_orders_per_customer,
        sum(lifetime_spend_pretax) as total_cohort_spend,
        round(avg(lifetime_spend_pretax), 2) as avg_customer_ltv
    from customer_orders
    group by 1
)

select
    cohort_month,
    total_customers,
    total_cohort_orders,
    avg_orders_per_customer,
    total_cohort_spend,
    avg_customer_ltv
from cohort_summary
order by cohort_month desc
