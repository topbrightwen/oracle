--------------------------------------------------------------------------------
--
-- File name:   sql.sql
-- Purpose:     Display the full sql text and stat
--
-- Author:      Bright Wen
--              
-- Usage:       @sql <sqlid>         
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set long 5000
set ver off
set echo off
set feedback off
set pagesize 60
col sql_fulltext  head SQLFullText for a100 justify left word_wrap
col parse_calls head Parses for 99999
col h_parses    head HardParse for 99999

select 
	sql_fulltext
from gv$sqlarea
where sql_id in('&1')
/

set pagesize 16
select 
	parse_calls parses,
	loads h_parses,
	executions,
	fetches,
	rows_processed,
	buffer_gets LIOS,
	disk_reads PIOS,
	sorts, 
	cpu_time/1000 cpu_ms,
	elapsed_time/1000 ela_ms,
	users_executing
from gv$sqlarea
where sql_id in('&&1')
/
set feedback on
