-- models/trgt_src_combined.sql
WITH ranked_records AS (
  SELECT
    t.ID,
    t.SEQVAL,
    t.REC_EFF_TS,
    t.REC_EXPIR_TS,
    t.BTCH_JOB_ID,
    t.TBL1_COL,
    t.TBL2_COL,
    r1.SOME_OTHER_COL1 AS SOME_OTHER_COL1_1,
    r1.SOME_OTHER_COL2 AS SOME_OTHER_COL2_1,
    r2.SOME_OTHER_COL1 AS SOME_OTHER_COL1_2,
    r2.SOME_OTHER_COL2 AS SOME_OTHER_COL2_2,
    ROW_NUMBER() OVER (PARTITION BY t.ID ORDER BY t.SEQVAL DESC, t.REC_EFF_TS DESC) AS row_num
  FROM src_tbl t
  LEFT JOIN src_tbl1 r1 ON t.ID = r1.ID AND t.SEQVAL = r1.SEQVAL
  LEFT JOIN src_tbl2 r2 ON t.ID = r2.ID AND t.SEQVAL = r2.SEQVAL
  WHERE t.BTCH_JOB_ID = (SELECT MAX(BTCH_JOB_ID) FROM trgt_tbl)  -- Filter based on the latest BTCH_JOB_ID
)

-- Config block
{{ config(
    materialized='table',
    unique_key='ID, SEQVAL',
    sort='ID, REC_EFF_TS',
    incremental_strategy='merge'
) }}

-- Schema.yml
{{ docs(trgt_tbl) }}
