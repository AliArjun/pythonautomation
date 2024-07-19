Create a macro to extract the source query:

{% macro get_source_query(model) %}
  {% set source_relation = model.source_name ~ '.' ~ model.name if model.source_name else model.name %}
  {% set query %}
    SELECT * FROM {{ source_relation }}
  {% endset %}
  {{ return(query) }}
{% endmacro %}


Create a macro to count rows:
{% macro count_rows(query) %}
  {% set count_query %}
    SELECT COUNT(*) AS row_count FROM ({{ query }}) subquery
  {% endset %}
  {% set results = run_query(count_query) %}
  {{ return(results[0][0]) }}
{% endmacro %}

Modify your dbt model file to include these macros:
{{ config(
    pre_hook=[
      "{% set source_query = get_source_query(this) %}",
      "{% set row_count = count_rows(source_query) %}",
      "{{ log('Source row count: ' ~ row_count, info=True) }}",
      "{% do run_query('CREATE TABLE IF NOT EXISTS {{ target.schema }}.row_counts (model_name TEXT, row_count INT)') %}",
      "{% do run_query('INSERT INTO {{ target.schema }}.row_counts (model_name, row_count) VALUES (\'' ~ this.name ~ '\', ' ~ row_count ~ ')') %}"
    ]
) }}

-- Your original model SQL here
SELECT ...
