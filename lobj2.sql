--------------------------------------------------------------------------------
--
-- File name:   lobj2.sql
-- Purpose:     Display locked object by object name
--
-- Author:      Bright Wen
--              
-- Usage:       @lobj2 <ObjectName>
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col object_id    head ObjectID for 999999999
col OBJECT_NAME     head ObjectName for a30 justify left word_wrap
col SID         head SID for 999999
col locked_mode	head LockedMode for 9
col mode_held   head HeldLockMode for a12
col event    head EVENT for a36 truncate
col owner            head Owner for a20 justify left word_wrap

col OBJECT_TYPE      head ObjectType for a20  justify left word_wrap
col UserName         head UserName for a20 justify left word_wrap

prompt
prompt ************
prompt DML/TX Lock
prompt ************
prompt
select 
    a.session_id as SID,
	s.serial#,
	s.event,
	s.sql_id,
	s.username,
	a.locked_mode,
	a.object_id,
	b.OBJECT_TYPE,
	b.owner,
	b.OBJECT_NAME
from v$locked_object a join dba_objects b on a.OBJECT_ID = b.OBJECT_ID
    join gv$session s on a.session_id = s.sid
WHERE b.object_name = upper('&1')
/
prompt
prompt *************
prompt DDL Lock/Pin
prompt *************
prompt
select 
  s.sid, 
  s.serial#,
  s.event,
  s.sql_id,
  s.username,
  case 
    when o.kglhdnsp in(1,2,3,4) then  substr(o.kglnaown,1,30)||'.'||substr(o.kglnaobj,1,30)
    else substr(o.kglnaobj,1,30) end as Object_Name,
  decode(o.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure/Type', 2, 'Body',
           3, 'Trigger', 4, 'Index', 5, 'Cluster', 13, 'Java Source',
             14, 'Java Resource', 32, 'Java Data') OBJECT_TYPE,
  l.kgllktype Lock_Type,
  decode(l.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
     'Unknown') mode_held,
from  dba_kgllock l join x$kglob o on l.kgllkhdl = o.kglhdadr
  join gv$session s on l.kgllkuse = s.saddr
  where o.kglhdnsp in(0,1,2,3,4,5,13,14,32)
      and o.kglnaobj = upper('&1') and (l.kgllkmod > 1)
order by s.sid
/