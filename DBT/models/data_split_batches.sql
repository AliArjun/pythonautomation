-- models/data_split_batches.sql
{{ config(
    materialized='table',
    unique_key='ID, SEQVAL',
    sort='ID, REC_EFF_TS',
    incremental_strategy='merge'
) }}

{{ macro('split_into_batches', source_table='src_tbl', start_date='2023-11-14', end_date='2023-11-16') }}
UNION ALL
{{ macro('split_into_batches', source_table='src_tbl', start_date='2023-11-20', end_date='2023-11-28') }}
