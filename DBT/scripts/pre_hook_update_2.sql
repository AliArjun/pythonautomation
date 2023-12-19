-- scripts/pre_hook_update.sql
-- Update records in trgt_tbl with REC_EXPIR_TS='9999-12-31 23:59:59' from B1 to the latest REC_EFF_TS from B2

UPDATE trgt_tbl
SET
  CURR_REC_IND = 'N',
  REC_EXPIR_TS = t.MIN_REC_EFF_TS - INTERVAL '1' SECOND
FROM (
  SELECT
    t1.ID,
    MIN(t2.REC_EFF_TS) AS MIN_REC_EFF_TS
  FROM trgt_tbl t1
  JOIN src_tbl t2 ON t1.ID = t2.ID
  WHERE t1.REC_EXPIR_TS = '9999-12-31 23:59:59'
    AND t1.BTCH_JOB_ID = 'B1'
    AND t2.BTCH_JOB_ID = 'B2'
  GROUP BY t1.ID
) AS t
WHERE
  trgt_tbl.ID = t.ID
  AND trgt_tbl.REC_EXPIR_TS = '9999-12-31 23:59:59'
  AND trgt_tbl.CURR_REC_IND = 'Y';
