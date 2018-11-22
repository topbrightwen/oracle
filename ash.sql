--------------------------------------------------------------------------------
--
-- File name:   ash.sql
-- Purpose:     Display active Session history detail infomation
--
-- Author:      Bright Wen
--              
-- Usage:       @ash <sid> "2017-01-09 14:00:00" "2017-01-09 15:00:00"
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col program     head Program for a20 justify left word_wrap
col sid         head SID for 999999
col inst_id 	   head Inst for 99

col sql_id      head SQLID for a13  justify left word_wrap
col child_num      head Child# for 999
col module         head Module for a20 justify left word_wrap
col action         head Action for a20 justify left word_wrap
col type           head Type for a10 justify left word_wrap
col SampleTime     head SampleTime for a20
col machine    head Machie for a20 justify left word_wrap
col BlockingSession head BlockingSession
col BlockingInstID head BlockingInstID

SELECT 
    session_id sid, 
    inst_id,
    to_char(sample_time,'yyyy-mm-dd hh24:mi:ss') SampleTime,
    SQL_ID,
    sql_child_number as child_num,
    program, 
    machine,	
    module, 
    action, 
    session_type type,
    session_state status,
    blocking_session as BlockingSession,
    blocking_inst_id as BlockingInstID
FROM gv$active_session_history WHERE session_id IN (&1)
and sample_time between to_date('&2','yyyy-mm-dd hh24:mi:ss') and to_date('&3','yyyy-mm-dd hh24:mi:ss')
order by sample_time asc
/
