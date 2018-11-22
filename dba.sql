--------------------------------------------------------------------------------
--
-- File name:   dba.sql
-- Purpose:     Convert data block address to file#,block#
--
-- Author:      Bright Wen
--              
-- Usage:       @dba <data block address>             
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set feedback off
set echo off

select DBMS_UTILITY.DATA_BLOCK_ADDRESS_FILE( TO_NUMBER('&1', 'XXXXXXXX') ) FILE#,
       DBMS_UTILITY.DATA_BLOCK_ADDRESS_BLOCK( TO_NUMBER('&&1', 'XXXXXXXX') ) BLOCK#
from dual
/
