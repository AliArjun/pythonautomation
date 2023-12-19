-- scripts/pre_hook_update.sql
UPDATE trgt_tbl
SET
  REC_EXPIR_TS = t.REC_EFF_TS - INTERVAL '1' SECOND,
  CURR_REC_IND = 'Y'
FROM (
  SELECT
    ID,
    MIN(SEQVAL) AS MIN_SEQVAL
  FROM trgt_tbl
  WHERE REC_EXPIR_TS = '9999-12-31'
  GROUP BY ID
) AS t
WHERE
  trgt_tbl.ID = t.ID
  AND trgt_tbl.SEQVAL = t.MIN_SEQVAL
  AND trgt_tbl.CURR_REC_IND = 'N';

/* 
The pre-hook script handles updates for records with REC_EXPIR_TS = '9999-12-31' 
 by setting REC_EXPIR_TS to the next batch's REC_EFF_TS and updating CURR_IND accordingly.

*/