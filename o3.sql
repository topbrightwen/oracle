--------------------------------------------------------------------------------
--
-- File name:   o3.sql
-- Purpose:     Display object information by block# and file#
--
-- Author:      Bright Wen
--              
-- Usage:       @o3 <file# block#>             
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col owner    head Owner for a30 justify left word_wrap
col OBJECT_NAME     head ObjectName for a30 justify left word_wrap

select owner,
       segment_name object_name
from dba_extents
where file_id = &1
			and &2 between block_id and block_id + blocks - 1
			and rownum = 1
/