--------------------------------------------------------------------------------
--
-- File name:   swt2.sql
-- Purpose:     Display Session Wait Tree from gv$session
--
-- Author:      Bright Wen
--              
-- Usage:       @swt2
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set echo off
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
   sid,
   SERIAL#,
   blocking_session,
   blocking_instance,
   row_wait_obj#,
   sql_id,
   sql_child_number,
   inst_id,
   seconds_in_wait,
   p1,
   p1raw,
   machine,
   event
  FROM gv$session)
select 
    RPAD(' ', 2 * (level - 1)) || s.sid as waiting_session,
    s.SERIAL#,
    s.INST_ID, 
    s.event AS sw_event, 
    s.seconds_in_wait sec_in_wait,
    CASE 
        WHEN s.event like 'cursor:%' THEN
            '0x'||trim(to_char(s.p1, 'XXXXXXXXXXXXXXXX'))
        WHEN (s.event like 'enq%' OR s.event = 'DFS lock handle') THEN 
            ' mode '||bitand(s.p1, power(2,14)-1)
        WHEN s.event like 'latch%' THEN 
              '0x'||trim(to_char(s.p1, 'XXXXXXXXXXXXXXXX'))
        WHEN event like 'library cache pin' THEN
              '0x'||RAWTOHEX(p1raw)
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
WHERE (s.sid,s.inst_id) IN (SELECT blocking_session,blocking_instance FROM gv$session)
    OR s.blocking_session IS NOT NULL
CONNECT BY PRIOR s.sid = s.blocking_session
         AND PRIOR s.inst_id = s.blocking_instance
START WITH s.blocking_session IS NULL
/
