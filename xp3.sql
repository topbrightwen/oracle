--------------------------------------------------------------------------------
--
-- File name:   xp3.sql
-- Purpose:     Display SQL execution plan from AWS  by sql_id
--
-- Author:      Bright Wen
--              
-- Usage:       @xp3 <sqlid>        
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
SET PAGESIZE 0
set echo off

SELECT * FROM table(DBMS_XPLAN.DISPLAY_AWR('&1',NULL,NULL,'ADVANCED ALLSTATS LAST PEEKED_BINDS'))
/
SET PAGESIZE 1000
