-- A dbt model is just a SELECT. dbt wraps it in CREATE based on the config.
-- {{ source(...) }} references a declared raw table — dbt tracks the lineage.
SELECT
    order_id,
    customer_id,
    -- Reuse the macro instead of re-writing the /100.0 rounding everywhere.
    {{ cents_to_dollars('amount_cents') }} AS amount,
    LOWER(status)                 AS status,
    ordered_at::DATE              AS ordered_date
FROM {{ source('raw', 'orders') }}
WHERE amount_cents IS NOT NULL
