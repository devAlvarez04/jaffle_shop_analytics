with

source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        cast(id as integer)         as order_id,
        cast(user_id as integer)    as customer_id,
        cast(order_date as date)    as order_date,
        status,
        _loaded_at

    from source

)

select * from renamed