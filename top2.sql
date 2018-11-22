--------------------------------------------------------------------------------
--
-- File name:   top2.sql
-- Purpose:     Display the top cpu/ela time sql.
--
-- Author:      Bright Wen
--              
-- Usage:       @top2           
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
set feedback off
set pagesize 16
col sqltext  head SQLText for a60 truncate
col parses head Parses for 99999999999
col h_parses    head HardParse for 99999
col rows_processed head Row# for 9999
col inst_id head Inst for 99
col exec head Exec# for 99999999999
col PIOS head PhysicalReads for 99999999999
col LIOS head BufferGets for 99999999999
col cpu_s head CPU(s) for 99999999
col ela_s head Elapsed(s) for 99999999
col version_count head VersionCount

prompt
prompt ***********
prompt CPU Time
prompt ***********
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s,
	buffer_gets LIOS,
	disk_reads PIOS,
	parse_calls parses,
	loads h_parses,
	executions exec,
	rows_processed Row#,
	sorts
FROM gv$sqlarea
ORDER BY cpu_s DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt **************
prompt Elapsed Time
prompt **************
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	elapsed_time/1000000 ela_s,
	cpu_time/1000000 cpu_s,
	disk_reads PIOS,
	buffer_gets LIOS,
	parse_calls parses,
	loads h_parses,
	executions exec,
	rows_processed Row#,
	sorts
FROM gv$sqlarea
ORDER BY ela_s DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt **************
prompt Version Count
prompt **************
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	version_count,
	parse_calls parses,
	loads h_parses,
	executions exec,
	rows_processed Row#,
	sorts
FROM gv$sqlarea
ORDER BY version_count DESC 
) 
WHERE ROWNUM<=10
/
set feedback on