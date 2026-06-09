with prices as (
    select * from {{ ref('int_card_prices') }}
),

final as (
    select
        card_id,
        price_date,
        tcgplayer_price,
        cardmarket_price,
        ebay_price,
        amazon_price,
        coolstuffinc_price
    from prices
)

select * from final