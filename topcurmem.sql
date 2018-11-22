set linesize 500
set pagesize 25
col sql_text_partial format a100
SELECT * FROM (
    SELECT
        sharable_mem, sql_id, hash_value, SUBSTR(sql_text,1,100) sql_text_partial
    FROM
        v$sql
    ORDER BY
        sharable_mem DESC
)
WHERE rownum <= 20
/

