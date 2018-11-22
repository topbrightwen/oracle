--------------------------------------------------------------------------------
--
-- File name:   xp.sql
-- Purpose:     Display current SQL execution plan
--
-- Author:      Bright Wen
--              
-- Usage:       @xp        
--
--------------------------------------------------------------------------------
SET LINESIZE 500
SET PAGESIZE 0
set echo off

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR(null,null,'ADVANCED ALLSTATS LAST PEEKED_BINDS'))
/
SET PAGESIZE 1000