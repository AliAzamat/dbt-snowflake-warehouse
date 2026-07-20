-- A SINGULAR test: a SELECT that should return ZERO rows.
-- Any row it returns is a failing record — revenue must never be negative.
SELECT region, revenue
FROM {{ ref('mart_revenue') }}
WHERE revenue < 0
