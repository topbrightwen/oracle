--------------------------------------------------------------------------------
--
-- File name:   sysstat.sql
-- Purpose:     Display the past 60 seconds system stats.
--
-- Author:      Bright Wen
--              
-- Usage:       sysstat   
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set pagesize 30
set ver off
set echo off
col value head Value for 99999999.99

select 
    inst_id,
    metric_name,
    value,
    metric_unit	
from gv$sysmetric
where metric_id in(2003,2123,2146,2092,2100,2145,2143,2144,2121,2058,2026,2063,2016,2034,2147,2112,2000,2048,2046,2024,2119,2109,2051,2057) 
and group_id = 2
order by value desc
/

