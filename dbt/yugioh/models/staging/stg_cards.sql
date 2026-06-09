with source as (
    select
        card_data,
        extracted_at
    from {{ source('raw', 'cards_raw') }}
),

cleaned as (
    select
        (card_data ->> 'id')::bigint as card_id,
        case
            when (card_data ->> 'name') like '"%"'
            then trim(both '"' from (card_data ->> 'name'))
            else card_data ->> 'name'
        end as card_name,
        card_data ->> 'type' as card_type,
        card_data ->> 'frameType' as frame_type,
        card_data ->> 'race' as race,
        card_data ->> 'attribute' as attribute,
        (card_data ->> 'atk')::int as atk,
        (card_data ->> 'def')::int as def,
        (card_data ->> 'level')::int as level,
        card_data ->> 'archetype' as archetype,
        card_data ->> 'desc' as card_description,
        extracted_at
    from source
)

select * from cleaned