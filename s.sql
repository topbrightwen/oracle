--------------------------------------------------------------------------------
--
-- File name:   s.sql
-- Purpose:     Display Session detail infomation
--
-- Author:      Bright Wen
--              
-- Usage:       @s <sid>
--              @s 52,110,225
--              @s "select sid from v$session where username = 'XYZ'"
--              @s &mysid
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col username    head UserName for a20 justify left word_wrap
col program     head Program for a20 justify left word_wrap
col sid         head SID for 999999
col inst_id 	   head Inst for 99

col sql_id      head SQLID for a13  justify left word_wrap
col child_num      head Child# for 999
col module         head Module for a20 justify left word_wrap
col action         head Action for a20 justify left word_wrap
col type           head Type for a10 justify left word_wrap
col LogonTime     head LogonTime for a20
col machine    head Machie for a20 justify left word_wrap
col LastCall   head LastCall

SELECT 
    sid, 
	inst_id,
	SQL_ID,
	sql_child_number as child_num,
    username,
    machine,	
	program, 
	module, 
	action, 
	type,
	to_char(LOGON_TIME,'yyyy-mm-dd hh24:mi:ss') LogonTime,
	status,
	Last_call_et LastCall
FROM gv$session WHERE sid IN (&1)
/
