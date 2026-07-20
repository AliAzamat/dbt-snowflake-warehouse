# Snowflake warehouse notes

## Compute is separate from storage
Snowflake separates **storage** (your data) from **compute** (virtual
warehouses). You size a warehouse (XS → 4XL) for a workload and pay only
while it runs. dbt's heavy transforms run on a bigger warehouse; light
dashboard queries run on a small one — no contention.

## Incremental models
- First run / `dbt run --full-refresh`: builds the whole table.
- Later runs: `is_incremental()` is true, so only NEW rows are scanned and
  MERGEd on `unique_key`. Cost scales with NEW data, not total data.
- `{{ this }}` refers to the existing table — we read its max loaded date.

## Late-arriving data
- A strict `> MAX(ordered_date)` filter silently DROPS rows that arrive
  late (dated in the past). Use a LOOKBACK window (`>= MAX - 3 days`).
- The MERGE on `order_id` makes re-scanning loaded rows harmless — no
  duplicates, just updates. Idempotency is what lets us reprocess safely.

## Recovery
- Suspect corruption or a logic change? `dbt run --full-refresh` rebuilds
  the whole table from source — the always-correct escape hatch.

## Operating tips
- Use AUTO_SUSPEND so idle warehouses stop billing within seconds.
- Scale UP (bigger warehouse) for faster single queries; scale OUT
  (multi-cluster) for many concurrent dashboard users.
