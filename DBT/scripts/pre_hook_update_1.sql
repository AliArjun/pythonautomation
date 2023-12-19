-- scripts/pre_hook_update.sql
UPDATE trgt_tbl
SET
  REC_EXPIR_TS = t.REC_EFF_TS - INTERVAL '1' SECOND,
  CURR_REC_IND = 'Y'
FROM (
  SELECT
    t.ID,
    MAX(t.REC_EFF_TS) AS REC_EFF_TS
  FROM trgt_tbl t
  WHERE t.REC_EXPIR_TS = '9999-12-31'
    AND t.BTCH_JOB_ID = (SELECT MAX(BTCH_JOB_ID) FROM trgt_tbl) -- Filter based on the latest BTCH_JOB_ID
  GROUP BY t.ID
) AS t
WHERE
  trgt_tbl.ID = t.ID
  AND trgt_tbl.REC_EFF_TS = t.REC_EFF_TS
  AND trgt_tbl.CURR_REC_IND = 'N';
