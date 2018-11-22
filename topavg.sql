--------------------------------------------------------------------------------
--
-- File name:   topavg.sql
-- Purpose:     Display the top sql order by  IO,rows_processed per execution
--
-- Author:      Bright Wen
--              
-- Usage:       @topavg            
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
set feedback off
set pagesize 16
col sqltext  head SQLText for a60 truncate
col module head Module for a30 justify left word_wrap
col BufferGets head BufferGets for 99999999999
col GetsPerExec head GetsPerExec for 99999999999
col ReadsPerExec head ReadsPerExec for 99999999999
col PIOS head PhysicalReads for 99999999999
col RowsPerExec head RowsPerExec for 9999999999
col rows_processed head Row# for 99999999999
col inst_id head Inst for 99
col exec head Exec# for 99999999

prompt
prompt ***********
prompt Buffer Gets
prompt ***********
SELECT * FROM 
(
select
	buffer_gets BufferGets,
	executions exec,
    buffer_gets / decode(executions,0,1,null,1,executions) as GetsPerExec,
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s,
	inst_id, 
	sql_id,
	module,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext
FROM gv$sqlarea
ORDER BY GetsPerExec DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt **********
prompt Disk Reads
prompt **********
SELECT * FROM 
(
select
	disk_reads PIOS,
	executions exec,
	disk_reads / decode(executions,0,1,null,1,executions) as ReadsPerExec,
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s,
	inst_id, 
	sql_id,
	module,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext
FROM gv$sqlarea
ORDER BY ReadsPerExec DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt **********
prompt Executions
prompt **********
SELECT * FROM 
(
select
	executions exec,
	rows_processed,
	rows_processed / decode(executions,0,1,null,1,executions) RowsPerExec,
	cpu_time/1000000 cpu_s,
	elapsed_time/1000000 ela_s,
	inst_id, 
	sql_id,
	module,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext
FROM gv$sqlarea
ORDER BY RowsPerExec DESC 
) 
WHERE ROWNUM<=10
/
set feedback on