--------------------------------------------------------------------------------
--
-- File name:   ashwt.sql
-- Purpose:     Display active Session Wait Tree from gv$active_session_historysession by sample_time
--
-- Author:      Bright Wen
--              
-- Usage:       @ashwt "2017-01-09 14:00:00" "2017-01-09 15:00:00"
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set echo off
set ver off
set feedback off
col sw_event    head EVENT for a36 truncate
col sw_p1transl head P1TRANSL for a20
col waiting_session head SID for a10

col sqltext       head SQLTEXT for a40  truncate
col object_name    head OBJECT for a30 justify left word_wrap
col machine        head HostName for a16 justify left word_wrap
col inst_id 	   head Inst for 99 
col child_num      head CNum for 999
col sql_id         head SQLID for a13

WITH s AS
 (SELECT /*+materialize*/
   distinct 
   session_id sid,
   session_serial# SERIAL#,
   blocking_session,
   blocking_inst_id blocking_instance,
   current_obj# row_wait_obj#,
   sql_id,
   sql_child_number,
   inst_id,
   p1,
   machine,
   event
  FROM gv$active_session_history where sample_time between to_date('&1','yyyy-mm-dd hh24:mi:ss') and to_date('&2','yyyy-mm-dd hh24:mi:ss'))
select 
    RPAD(' ', 2 * (level - 1)) || s.sid as waiting_session,
    s.SERIAL#,
    s.INST_ID, 
    s.event AS sw_event, 
    CASE 
        WHEN s.event like 'cursor:%' THEN
            '0x'||trim(to_char(s.p1, 'XXXXXXXXXXXXXXXX'))
        WHEN (s.event like 'enq%' OR s.event = 'DFS lock handle') THEN 
            ' mode '||bitand(s.p1, power(2,14)-1)
        WHEN s.event like 'latch%' THEN 
              '0x'||trim(to_char(s.p1, 'XXXXXXXXXXXXXXXX'))
    ELSE NULL END AS sw_p1transl,
    replace(replace(sql.sql_text,chr(13),''),chr(10),'') sqltext,
	s.sql_id,
	s.sql_child_number as child_num,
    o.object_name,
	s.machine
FROM 
    s 
        LEFT JOIN gv$sql sql ON (sql.sql_id = s.sql_id AND sql.child_number = s.sql_child_number and s.inst_id = sql.inst_id)
	    LEFT JOIN dba_objects o ON (s.row_wait_obj# = o.object_id)
WHERE (s.sid,s.inst_id) IN (SELECT blocking_session,BLOCKING_INST_ID FROM gv$active_session_history where sample_time between to_date('&&1','yyyy-mm-dd hh24:mi:ss') and to_date('&&2','yyyy-mm-dd hh24:mi:ss'))
    OR s.blocking_session IS NOT NULL
CONNECT BY PRIOR s.sid = s.blocking_session
         AND PRIOR s.inst_id = s.blocking_instance
START WITH s.blocking_session IS NULL
/
