with

payments as (

    select * from {{ ref('stg_jaffle_shop__payments') }}

),
order_payments as (

    select
        order_id,
        sum(amount) as order_amount
    from payments
    group by order_id

)

select * from order_payments