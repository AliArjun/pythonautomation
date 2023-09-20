{% macro insert_dummy_rows() %}
{% for table in adapter.get_relations(schema='SCHEMA') if table.name starts_with 'TAB_' %}

-- Check if row with ID='-999999999' already exists in {{ table.name }}
{% set id_exists = not run_query(
  "SELECT 1 FROM " ~ table.name ~ " WHERE ID = -999999999",
  fetch='one'
) %}

{% if id_exists %}
-- Row with ID='-999999999' already exists in {{ table.name }}
{% else %}
-- Row with ID='-999999999' does not exist in {{ table.name }}
INSERT INTO {{ table.name }} (ID, NAME, DESCRIPTION, CREAT_TS, UPDT_TS)
VALUES (-999999999, 'TAB__{{ table.name }}', 'TAB__{{ table.name }}', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());
{% endif %}

{% endfor %}
{% endmacro %}
