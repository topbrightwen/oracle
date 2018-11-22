--------------------------------------------------------------------------------
--
-- File name:   rowid.sql
-- Purpose:     Convert rowid to file#,block#,row#
--
-- Author:      Bright Wen
--              
-- Usage:       @rowid <rowid#>             
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off

select dbms_rowid.rowid_object('&1') object_id, 
	   dbms_rowid.rowid_relative_fno('&1')  file_id, 
	   dbms_rowid.rowid_block_number('&1')  block_id, 
	   dbms_rowid.rowid_row_number('&1')   num  
from dual
/

