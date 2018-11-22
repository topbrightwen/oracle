--------------------------------------------------------------------------------
--
-- File name:   lock.sql
-- Purpose:     Display the locks which the session held and requested
--
-- Author:      Bright Wen
--              
-- Usage:       @lock <sid>
--              @lock 52,110,225
--              @lock "select sid from v$session where username = 'XYZ'"
--              @lock &mysid
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
break on SID
col mode_held    head Held for a20 justify left word_wrap
col mode_requested    head Request for a20 justify left word_wrap
col lock_type    head LockType for a20 justify left word_wrap
col sid          head SID for 999999
col blocking_others  head Blocking for a20
col Object_Name  head ObjectName for a40 justify left word_wrap
col lock_id1     head ID1 for a12 
col lock_id2     head ID2 for a12

prompt
prompt ************
prompt DML/TX Lock
prompt ************
prompt
select 
    session_id as sid,
	lock_type,
	mode_held,
	mode_requested,
	lock_id1,
	lock_id2,
	CASE
	    WHEN lock_type = 'DML' THEN 
		    (SELECT OWNER||'.'||OBJECT_NAME 
			FROM DBA_OBJECTS WHERE OBJECT_ID = lock_id1)
		ELSE NULL END AS Object_Name,
	blocking_others 
from dba_locks where  session_id in(&1)
order by session_id
/
prompt
prompt *************
prompt DDL Lock/Pin
prompt *************
prompt
select 
  s.sid, 
  case 
    when o.kglhdnsp in(1,2,3,4) then  substr(o.kglnaown,1,30)||'.'||substr(o.kglnaobj,1,30)
    else substr(o.kglnaobj,1,30) end as Object_Name,
  decode(o.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure/Type', 2, 'Body',
           3, 'Trigger', 4, 'Index', 5, 'Cluster', 13, 'Java Source',
             14, 'Java Resource', 32, 'Java Data') objtype,
  l.kgllktype Lock_Type,
  decode(l.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
     'Unknown') mode_held,
  decode(l.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
     'Unknown') mode_requested
from  dba_kgllock l join x$kglob o on l.kgllkhdl = o.kglhdadr
  join gv$session s on l.kgllkuse = s.saddr
  where o.kglhdnsp in(0,1,2,3,4,5,13,14,32)
      and s.sid in(&1) and (l.kgllkmod > 1 or l.kgllkreq > 1)
order by s.sid
/