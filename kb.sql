--------------------------------------------------------------------------------
--
-- File name:   kb.sql
-- Purpose:     Print kill blocker session script
--
-- Author:      Bright Wen
--              
-- Usage:       @kb
-- Other:       This script doesnt actually kill any sessions       
--              it just generates the ALTER SYSTEM KILL SESSION
--              commands, the user can select and paste in the selected
--              commands manually           
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set echo off
col command    head Commands for a60
col comments   head Comments for a60 truncate

select 
    'alter system kill session '''||sid||','||serial#||','||'@'||inst_id||''';' command,
    username||'@'||machine||' ('||program||')@Instance :'||to_char(inst_id) comments
from gv$session
where (sid,inst_id) in(
  select final_blocking_session,final_blocking_instance  
  from gv$session where final_blocking_session is not null
  )
/ 
