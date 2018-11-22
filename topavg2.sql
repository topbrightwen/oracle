--------------------------------------------------------------------------------
--
-- File name:   topavg2.sql
-- Purpose:     Display the top sql order by elapsed_time,cpu_time,version_count per execution
--
-- Author:      Bright Wen
--              
-- Usage:       @topavg2            
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
set feedback off
set pagesize 16
col sqltext  head SQLText for a60 truncate
col module head Module for a30 justify left word_wrap
col ela_s head "Elapsed Time(s)" for 999999999
col cpu_s head "CPU Time(s)" for 999999999
col ElaPerExec head "Elapsed Time|Per Exec(s)" for 999999999
col CPUPerExec head "CPU Time|Per Exec(s)" for 999999999
col inst_id head Inst for 99
col exec head Exec# for 999999999
col sql_id head SQLID for a15

prompt
prompt *************
prompt Elapsed Time
prompt *************
SELECT * FROM 
(
select
	elapsed_time/1000000 ela_s,
	executions exec,
    elapsed_time / 1000000 / decode(executions,0,1,null,1,executions) as ElaPerExec,
	inst_id, 
	sql_id,
	module,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext
FROM gv$sqlarea
ORDER BY ElaPerExec DESC 
) 
WHERE ROWNUM<=10
/
prompt
prompt *********
prompt CPU Time
prompt *********
SELECT * FROM 
(
select
	cpu_time/1000000 cpu_s,
	executions exec,
	cpu_time/1000000/decode(executions,0,1,null,1,executions) as CPUPerExec,
	inst_id, 
	sql_id,
	module,
	replace(replace(sql_text,chr(13),''),chr(10),'') sqltext
FROM gv$sqlarea
ORDER BY CPUPerExec DESC 
) 
WHERE ROWNUM<=10
/
set feedback on