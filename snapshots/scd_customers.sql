-- A SNAPSHOT captures how a row changes over TIME (SCD Type 2). dbt adds
-- dbt_valid_from / dbt_valid_to so you can ask "what tier was this customer
-- on the day of the order?" — point-in-time correctness.
{% snapshot scd_customers %}
{{
  config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='check',
    check_cols=['tier', 'region']   -- a new version is recorded when these change
  )
}}
SELECT customer_id, name, region, tier
FROM {{ source('raw', 'customers') }}
{% endsnapshot %}
