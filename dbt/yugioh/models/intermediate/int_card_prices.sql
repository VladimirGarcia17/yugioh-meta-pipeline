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
        nullif((prices ->> 'tcgplayer_price')::numeric(10,2), 999.99) as tcgplayer_price,
        nullif((prices ->> 'cardmarket_price')::numeric(10,2), 999.99) as cardmarket_price,
        nullif((prices ->> 'ebay_price')::numeric(10,2), 999.99) as ebay_price,
        nullif((prices ->> 'amazon_price')::numeric(10,2), 999.99) as amazon_price,
        nullif((prices ->> 'coolstuffinc_price')::numeric(10,2), 999.99) as coolstuffinc_price,
        extracted_at::date as price_date
    from source
)

select * from unpacked