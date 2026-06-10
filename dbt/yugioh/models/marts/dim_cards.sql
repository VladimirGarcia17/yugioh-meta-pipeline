with cards as (
    select * from {{ ref('stg_cards') }}
),

ranked as (
    select
        *,
        row_number() over (
            partition by card_id
            order by extracted_at desc
        ) as rn
    from cards
),

final as (
    select
        card_id,
        card_name,
        card_type,
        frame_type,
        race,
        attribute,
        atk,
        def,
        level,
        archetype,
        card_description
    from ranked
    where rn = 1
)

select * from final