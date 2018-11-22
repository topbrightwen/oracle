--------------------------------------------------------------------------------
--
-- File name:   lobj.sql
-- Purpose:     Display locked object by sid
--
-- Author:      Bright Wen
--              
-- Usage:       @lobj <sid>
--              @lobj 52,110,225
--              @lobj "select sid from v$session where username = 'XYZ'"
--              @lobj &mysid
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

col OBJECT_TYPE      head ObjectType for a20  justify left word_wrap
col owner            head Owner for a20 justify left word_wrap
col UserName         head UserName for a20 justify left word_wrap

prompt
prompt ************
prompt DML/TX Lock
prompt ************
prompt
select 
    a.session_id as SID,
    a.object_id,
	b.owner,
	b.OBJECT_NAME,
	b.OBJECT_TYPE,
	a.locked_mode,
	a.ORACLE_USERNAME as UserName 
from v$locked_object a join dba_objects b on a.OBJECT_ID = b.OBJECT_ID
WHERE a.session_id IN (&1)
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
     'Unknown') mode_held
from  dba_kgllock l join x$kglob o on l.kgllkhdl = o.kglhdadr
  join gv$session s on l.kgllkuse = s.saddr
  where o.kglhdnsp in(0,1,2,3,4,5,13,14,32)
      and s.sid in(&1) and (l.kgllkmod > 1)
order by s.sid
/