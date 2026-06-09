with source as (
    select
        (card_data ->> 'id')::bigint as card_id,
        card_data -> 'banlist_info' as banlist_info,
        extracted_at
    from {{ source('raw', 'cards_raw') }}
),

resolved as (
    select
        card_id,
        coalesce(banlist_info ->> 'ban_tcg', 'Unlimited') as status_tcg,
        coalesce(banlist_info ->> 'ban_ocg', 'Unlimited') as status_ocg,
        extracted_at::date as banlist_date
    from source
)

select * from resolved