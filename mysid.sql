--------------------------------------------------------------------------------
--
-- File name:   mysid.sql
-- Purpose:     Display my session id
--
-- Author:      Bright Wen
--              
-- Usage:       @mysid
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
set feedback off
col sid         head SID for 999999

select 
   sid 
from 
   v$mystat 
where 
   rownum <=1
/
set feedback on