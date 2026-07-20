-- {{ ref('stg_orders') }} points at another MODEL, not a raw table.
-- dbt reads these refs to build a DAG and run models in dependency order.
SELECT
    region,
    SUM(amount) AS revenue,
    COUNT(*)    AS paid_orders
FROM {{ ref('stg_orders') }}
WHERE status = 'paid'
GROUP BY region
