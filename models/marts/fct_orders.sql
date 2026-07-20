{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
  )
}}

-- Naive "ordered_date > MAX" misses LATE-ARRIVING rows: an order dated
-- Monday that lands Wednesday is older than the max and gets skipped forever.
-- Fix: reprocess a small LOOKBACK WINDOW every run and MERGE on the key.
SELECT
    order_id,
    customer_id,
    amount,
    status,
    ordered_date
FROM {{ ref('stg_orders') }}

{% if is_incremental() %}
  -- Re-scan the last 3 days so late rows are picked up; the MERGE on
  -- order_id makes re-processing already-loaded rows harmless (idempotent).
  WHERE ordered_date >= (SELECT DATEADD('day', -3, MAX(ordered_date)) FROM {{ this }})
{% endif %}
