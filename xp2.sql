--------------------------------------------------------------------------------
--
-- File name:   xp2.sql
-- Purpose:     Display SQL execution plan by sql_id and child_num
--
-- Author:      Bright Wen
--              
-- Usage:       @xp2 <sqlid> <child_number>         
--              @xp2 <sqlid> null   --display all child execution plan of sqlid
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
SET PAGESIZE 0
set echo off

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&1',&2,'ADVANCED ALLSTATS LAST PEEKED_BINDS'))
/
SET PAGESIZE 1000
