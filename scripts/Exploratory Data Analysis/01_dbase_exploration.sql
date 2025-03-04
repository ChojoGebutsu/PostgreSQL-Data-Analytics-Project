-- Exploring All Objects in the Data Warehouse
SELECT 
    table_catalog,
    table_schema, 
    table_name, table_type
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema NOT IN ('information_schema', 'pg_catalog');

-- Exploring All Columns in the Data Warehouse
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
    table_schema NOT IN ('information_schema', 'pg_catalog') AND
    table_name = 'dim_customers';