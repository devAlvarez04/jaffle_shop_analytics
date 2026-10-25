with

source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

renamed as (

    select
        cast(id as integer)     as customer_id,
        first_name,
        last_name,
        _loaded_at

    from source

)

select * from renamed