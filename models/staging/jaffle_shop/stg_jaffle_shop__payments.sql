with

source as (

    select * from {{ source('jaffle_shop', 'payments') }}

),

renamed as (

    select
        cast(id as integer)                                     as payment_id,
        cast(order_id as integer)                               as order_id,
        payment_method,
        cast(cast(amount as integer) / 100 as decimal(10, 2))   as amount,
        _loaded_at

    from source

)

select * from renamed