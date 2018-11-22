--------------------------------------------------------------------------------
--
-- File name:   se.sql
-- Purpose:     Display Session detail infomation by event
--
-- Author:      Bright Wen
--              
-- Usage:       @se <event>
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
col module         head Module for a30 justify left word_wrap
col action         head Action for a20 justify left word_wrap
col type           head Type for a10 justify left word_wrap
col LogonTime     head LogonTime for a20
col machine    head Machie for a20 justify left word_wrap

prompt
prompt *******************************************************
prompt List the sessions waiting for the event like '&1%'
prompt *******************************************************
SELECT 
    inst_id,
    sid, 
	SQL_ID,
	sql_child_number as child_num,
    username,
    machine,	
	program, 
	module, 
	action, 
	type,
	to_char(LOGON_TIME,'yyyy-mm-dd hh24:mi:ss') LogonTime,
	status
FROM gv$session WHERE event like '&1%'
order by status asc
/
