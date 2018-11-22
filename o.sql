--------------------------------------------------------------------------------
--
-- File name:   o.sql
-- Purpose:     Display object information by name
--
-- Author:      Bright Wen
--              
-- Usage:       @o <objectname>             
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col object_id    head ObjectID for 999999999
col OBJECT_NAME     head ObjectName for a30 justify left word_wrap

col OBJECT_TYPE      head ObjectType for a20  justify left word_wrap
col owner            head Owner for a20 justify left word_wrap
col CREATEDON        head CreatedOn for a20
col lastddltime      head LastDDLTime for a20

select 
    OWNER,
	OBJECT_TYPE,
	OBJECT_ID,
	OBJECT_NAME,
	TO_char(CREATED,'YYYY-MM-DD HH24:MI:SS') CREATEDON,
	TO_char(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LASTDDLTIME,
	STATUS
from dba_objects 
WHERE OBJECT_NAME = upper('&1')
/