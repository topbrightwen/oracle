--------------------------------------------------------------------------------
--
-- File name:   swg.sql
-- Purpose:     Display given Session Wait info grouped by state and event
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @swg <sid>
--              @swg 52,110,225
-- 	        	@swg "select sid from v$session where username = 'XYZ'"
--              @swg &mysid
--
--------------------------------------------------------------------------------
SET LINESIZE 500
col sw_event 	head EVENT for a60 truncate
col WClass head WaitClass for a20
set ver off
set echo off

select 
	count(*),
	CASE WHEN state != 'WAITING' THEN 'WORKING'
	     ELSE 'WAITING'
	END AS state, 
	event AS sw_event,
	wait_class as WClass
FROM 
	gv$session_wait sw 
WHERE 
	sid IN (&1)
GROUP BY
	CASE WHEN state != 'WAITING' THEN 'WORKING'
	     ELSE 'WAITING'
	END, 
	event,
	wait_class
ORDER BY
	1 DESC, 2 DESC
/
