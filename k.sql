--------------------------------------------------------------------------------
--
-- File name:   k.sql
-- Purpose:     Print kill session script
--
-- Author:      Bright Wen
--              
-- Usage:       @k <sid> 
-- Other:       This script doesnt actually kill any sessions       
--              it just generates the ALTER SYSTEM KILL SESSION
--              commands, the user can select and paste in the selected
--              commands manually           
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col command    head Commands for a60
col comments   head Comments for a60 truncate

select 
    'alter system kill session '''||sid||','||serial#||','||'@'||inst_id||''';' command,
    username||'@'||machine||' ('||program||')@Instance :'||to_char(inst_id) comments
from gv$session
where sid in(&1)
and sid != (select sid from v$mystat where rownum = 1)
/ 
