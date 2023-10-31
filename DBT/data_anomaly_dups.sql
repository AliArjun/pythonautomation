CREATE OR REPLACE PROCEDURE ProcessTables()
    RETURNS STRING
    LANGUAGE SQL
    EXECUTE AS CALLER
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TABLE IF NOT EXISTS Results (Table_Name STRING, ID NUMBER, REC_EXPIR_TS TIMESTAMP, Count NUMBER)';

DECLARE
    table_name STRING;
    sql_stmt STRING;
BEGIN
    FOR table_rec IN (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'SCHEMA1' AND TABLE_NAME LIKE 'T%') DO
        table_name := table_rec.TABLE_NAME;
        
        sql_stmt := 'SELECT ''' || table_name || ''' AS Table_Name, ID, REC_EXPIR_TS, COUNT(*) AS Count FROM SCHEMA1."' || table_name || '" GROUP BY 1, 2 HAVING COUNT(*) > 2';
        
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TABLE IF NOT EXISTS Results (Table_Name STRING, ID NUMBER, REC_EXPIR_TS TIMESTAMP, Count NUMBER)';

        EXECUTE IMMEDIATE 'INSERT INTO Results ' || sql_stmt;
    END FOR;
    
    RETURN 'Stored procedure executed successfully.';
END;
