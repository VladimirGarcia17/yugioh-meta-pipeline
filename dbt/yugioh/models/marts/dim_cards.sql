with cards as (
    select * from {{ ref('stg_cards') }}
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
    from cards
)

select * from final