with source as (
    select
        (card_data ->> 'id')::bigint as card_id,
        card_data -> 'card_prices' -> 0 as prices,
        extracted_at
    from {{ source('raw', 'cards_raw') }}
),

unpacked as (
    select
        card_id,
        (prices ->> 'tcgplayer_price')::numeric(10,2) as tcgplayer_price,
        (prices ->> 'cardmarket_price')::numeric(10,2) as cardmarket_price,
        (prices ->> 'ebay_price')::numeric(10,2) as ebay_price,
        (prices ->> 'amazon_price')::numeric(10,2) as amazon_price,
        (prices ->> 'coolstuffinc_price')::numeric(10,2) as coolstuffinc_price,
        extracted_at::date as price_date
    from source
)

select * from unpacked