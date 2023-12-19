-- macros/split_into_batches.sql

{% macro split_into_batches(source_table, start_date, end_date) %}
WITH split_batches AS (
  SELECT
    ID,
    SEQVAL,
    REC_EFF_TS,
    REC_EXPIR_TS,
    '{{ dbt_utils.uuid() }}' AS BTCH_JOB_ID, -- Use dbt_utils.uuid() to generate a random UUID
    CASE
      WHEN REC_EFF_TS BETWEEN '{{ start_date }}' AND '{{ end_date }}' THEN 'batch1'
      WHEN REC_EFF_TS BETWEEN '{{ start_date + interval '1 day' }}' AND '{{ end_date }}' THEN 'batch2'
      ELSE NULL
    END AS new_batch
  FROM {{ source_table }}
)

SELECT
  ID,
  SEQVAL,
  REC_EFF_TS,
  REC_EXPIR_TS,
  BTCH_JOB_ID
FROM split_batches
WHERE new_batch IS NOT NULL;
{% endmacro %}
