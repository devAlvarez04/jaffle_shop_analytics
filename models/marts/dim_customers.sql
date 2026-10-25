with

customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select * from {{ ref('stg_jaffle_shop__payments') }}

),

order_payments as (

    select
        order_id,
        sum(amount) as order_amount
    from payments
    group by order_id

),

customer_orders as (

    select
        orders.customer_id,
        min(orders.order_date)              as first_order_date,
        max(orders.order_date)              as most_recent_order_date,
        count(orders.order_id)              as number_of_orders,
        count( 
            case 
                when orders.status in ('returned','return_pending')then orders.order_id
            end 
            ) 
            as number_of_returned_orders,
        sum(order_payments.order_amount)    as lifetime_value,
        sum(
            case 
                when orders.status not in ('returned','return_pending') then order_payments.order_amount 
                else 0 
            end) 
            as lifetime_net_value

    from orders
    left join order_payments
        on orders.order_id = order_payments.order_id
    group by orders.customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0)   as number_of_orders,
        coalesce(customer_orders.number_of_returned_orders, 0)  as number_of_returned_orders,
        coalesce(customer_orders.lifetime_value, 0)     as lifetime_value,
        coalesce(customer_orders.lifetime_net_value, 0) as lifetime_net_value
    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select * from final