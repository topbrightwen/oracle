--------------------------------------------------------------------------------
--
-- File name:   ashwg.sql
-- Purpose:     Display given ASH Session Wait info grouped by state and event
--
-- Author:      Bright Wen
--              
-- Usage:       @ashwg "2017-01-09 14:00:00" "2017-01-09 15:00:00"
--
--------------------------------------------------------------------------------
SET LINESIZE 500
col sw_event 	head EVENT for a40 truncate
col session_id		head SID for 999999
col percent head "PCT%" for a10 justify right
set ver off
set echo off
set feedback off
set pagesize 50

prompt
prompt ********************************
prompt Session Wait by State and Event
prompt ********************************
select 
  count(*),
  lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent,
  CASE WHEN session_state != 'WAITING' THEN 'WORKING'
       ELSE 'WAITING'
  END AS state, 
  event AS sw_event
FROM 
  gv$active_session_history 
WHERE 
sample_time between to_date('&1','yyyy-mm-dd hh24:mi:ss') and to_date('&2','yyyy-mm-dd hh24:mi:ss')
GROUP BY
  CASE WHEN session_state != 'WAITING' THEN 'WORKING'
       ELSE 'WAITING'
  END, 
	event
ORDER BY
	percent desc
/
prompt
prompt ************************************
prompt Session Wait by State,Event and SID
prompt ************************************
select 
  count(*),
  lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent,
  session_id,
  CASE WHEN session_state != 'WAITING' THEN 'WORKING'
       ELSE 'WAITING'
  END AS state, 
  event AS sw_event
FROM 
  gv$active_session_history 
WHERE 
sample_time between to_date('&&1','yyyy-mm-dd hh24:mi:ss') and to_date('&&2','yyyy-mm-dd hh24:mi:ss')
GROUP BY
  session_id,
  CASE WHEN session_state != 'WAITING' THEN 'WORKING'
       ELSE 'WAITING'
  END, 
	event
ORDER BY
	percent DESC
/