with banlist as (
    select * from {{ ref('int_banlist') }}
),

final as (
    select
        card_id,
        banlist_date,
        status_tcg,
        status_ocg
    from banlist
)

select * from final