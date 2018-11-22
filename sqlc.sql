--------------------------------------------------------------------------------
--
-- File name:   sqlc.sql
-- Purpose:     Display the sql executions stat from v$sql by sql_id
--
-- Author:      Bright Wen
--              
-- Usage:       @sqlc <sqlid>   
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col parse_calls head Parses for 99999
col h_parses    head HardParse for 99999
col child_number head Child# for 9999
select * from
(select
    inst_id, 
	sql_id,
    child_number,
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
from gv$sql
where sql_id = '&1'
order by buffer_gets desc
)
where rownum <=20
/

