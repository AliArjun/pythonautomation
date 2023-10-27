-- upsert_abc_tables.sql

{% macro upsert_abc_tables(database_name, schema_name) %}
    {% set tables = adapter.execute(
        "SELECT TABLE_NAME FROM {{ database_name }}.{{ schema_name }}.information_schema.tables WHERE TABLE_NAME LIKE 'ABC_T%'"
    ) %}

    {% for table in tables %}
        -- Generate and execute the upsert SQL for each table
        {% set table_name = table.TABLE_NAME %}
        {% set upsert_sql = config(
            materialized='table',
            sql=<<
                MERGE INTO {{ database_name }}.{{ schema_name }}.{{ table_name }} AS target
                USING (SELECT '-999999999' AS ID) AS source
                ON target.ID = source.ID
                WHEN NOT MATCHED THEN INSERT (ID) VALUES (source.ID);
            >>
        ) %}
    {% endfor %}
{% endmacro %}

-- upsert_abc_tables.sql

{% macro upsert_abc_tables(database_name, schema_name) %}
    {% set tables = adapter.execute(
        "SELECT TABLE_NAME FROM {{ database_name }}.{{ schema_name }}.information_schema.tables WHERE TABLE_NAME LIKE 'ABC_T%'"
    ) %}

    {% for table in tables %}
        -- Generate and execute the upsert SQL for each table
        {% set table_name = table.TABLE_NAME %}
        {% set upsert_sql = "MERGE INTO {{ database_name }}.{{ schema_name }}.{{ table_name }} AS target " ~
                            "USING (SELECT '-999999999' AS ID) AS source " ~
                            "ON target.ID = source.ID " ~
                            "WHEN NOT MATCHED THEN INSERT (ID) VALUES (source.ID);" %}
        
        {{ adapter.execute(upsert_sql) }}
    {% endfor %}
{% endmacro %}

