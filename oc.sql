--------------------------------------------------------------------------------
--
-- File name:   oc.sql
-- Purpose:     Display Session open cursor
--
-- Author:      Bright Wen
--              
-- Usage:       @oc <sid>
--              @oc 52,110,225
--              @oc "select sid from v$session where username = 'XYZ'"
--              @oc &mysid
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col user_name    head UserName for a20 justify left word_wrap
col sqltext     head SQLText for a60 truncate
col sid          head SID for 999999

col sql_id       head SQLID for a20  justify left word_wrap
col lastactivetime     head LastActiveTime for a20

select 
    sid, 
	user_name, 
	sql_id, 
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext, 
	to_char(last_sql_active_time,'yyyy-mm-dd hh24:mi:ss') as lastactivetime
from v$open_cursor
where sid IN (&1)
order by sid
/
