--------------------------------------------------------------------------------
--
-- File name:   ss.sql
-- Purpose:     Display Session detail infomation by sql_id
--
-- Author:      Bright Wen
--              
-- Usage:       @ss <sql_id>
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
prompt List the sessions running sql like '&1'
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
FROM gv$session WHERE sql_id in('&1')
union all
SELECT 
    inst_id,
    sid, 
	prev_sql_id SQL_ID,
	PREV_CHILD_NUMBER as child_num,
    username,
    machine,	
	program, 
	module, 
	action, 
	type,
	to_char(LOGON_TIME,'yyyy-mm-dd hh24:mi:ss') LogonTime,
	status
FROM gv$session WHERE prev_sql_id in('&1')
union all
SELECT 
    s.inst_id,
    s.sid, 
	s.SQL_ID,
	s.sql_child_number as child_num,
    s.username,
    s.machine,	
	s.program, 
	s.module, 
	s.action, 
	s.type,
	to_char(s.LOGON_TIME,'yyyy-mm-dd hh24:mi:ss') LogonTime,
	s.status
from gv$session s join gv$open_cursor o on s.sid = o.sid and s.inst_id = o.inst_id and (s.sql_id <> o.sql_id and s.prev_sql_id <>o.sql_id)
where o.sql_id in('&1') 
order by status asc
/
