--------------------------------------------------------------------------------
--
-- File name:   top.sql
-- Purpose:     Display the top sql.
--
-- Author:      Bright Wen
--              
-- Usage:       @top             
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
col cpu_s head CPU(s) for 99999999
col ela_s head Elapsed(s) for 99999999
col PIOS head PhysicalReads for 99999999999
col LIOS head BufferGets for 99999999999

prompt
prompt ***********
prompt Buffer Gets
prompt ***********
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	buffer_gets LIOS,
	disk_reads PIOS,
	parse_calls parses,
	loads h_parses,
	executions exec,
	rows_processed Row#,
	sorts, 
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s
FROM gv$sqlarea
ORDER BY buffer_gets DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt ***********
prompt Disk Reads
prompt ***********
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	disk_reads PIOS,
	buffer_gets LIOS,
	parse_calls parses,
	loads h_parses,
	executions exec,
	rows_processed Row#,
	sorts, 
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s
FROM gv$sqlarea
ORDER BY disk_reads DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt ***********
prompt Hard Parses
prompt ***********
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	loads h_parses,
	parse_calls parses,
	disk_reads PIOS,
	buffer_gets LIOS,
	executions exec,
	rows_processed Row#,
	sorts, 
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s
FROM gv$sqlarea
ORDER BY loads DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt ***********
prompt Executions
prompt ***********
SELECT * FROM 
(
select
    inst_id, 
	sql_id,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext,
	executions exec,
	disk_reads PIOS,
	buffer_gets LIOS,
	parse_calls parses,
	loads h_parses,
	rows_processed Row#,
	sorts, 
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s
FROM gv$sqlarea
ORDER BY executions DESC 
) 
WHERE ROWNUM<=10
/
set feedback on