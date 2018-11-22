--------------------------------------------------------------------------------
--
-- File name:   s2p.sql
-- Purpose:     Display process infomation by sid
--
-- Author:      Bright Wen
--              
-- Usage:       @s2p  <sid>
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
set feedback off
col username    head UserName for a20 justify left word_wrap
col program     head Program for a20 justify left word_wrap
col sid         head SID for 999999
col spid        head SPID for a10
col inst_id 	   head Inst for 99

col sql_id      head SQLID for a13  justify left word_wrap
col child_num      head Child# for 999
col module         head Module for a30 justify left word_wrap
col action         head Action for a20 justify left word_wrap
col type           head Type for a10 justify left word_wrap
col LogonTime     head LogonTime for a20
col machine    head Machie for a20 justify left word_wrap
col terminal head Terminal for a20 justify left word_wrap

prompt
prompt *******************************************************
prompt List the process info for the session id like '&1'
prompt *******************************************************
SELECT 
    s.inst_id,
    s.sid, 
	p.spid,
	p.terminal,
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
FROM gv$session s join v$process p on s.paddr = p.addr 
WHERE s.sid in(&1)
order by status asc
/
set feedback on
