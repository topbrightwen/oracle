--------------------------------------------------------------------------------
--
-- File name:   sesstat.sql
-- Purpose:     Show given sessions stats
--
-- Author:      Bright Wen

--              
-- Usage:       @sesstat <sid> <snapshot_seconds>
--
--------------------------------------------------------------------------------

prompt Taking a &2 second snapshot from v$sesstat for by &1...
set linesize 500
set pagesize 20
set echo off
set ver off
set feedback off
col name head StatName for a50 
col value head Value for 9999999999.99

with s1 as    (select /*+ NO_MERGE MATERIALIZE */ a.sid,a.value,b.NAME,a.STATISTIC# from v$sesstat a join v$statname b on a.STATISTIC# = b.STATISTIC#  where sid in(&1) and a.STATISTIC# in(6,7,14,37,50,84,88,108,194,410,573,625,626,629,641)
   ), sleep as (select /*+ NO_MERGE MATERIALIZE */ sleep(&2) x from dual)
   , s2 as    (select /*+ NO_MERGE MATERIALIZE */ a.sid,a.value,b.NAME,a.STATISTIC# from v$sesstat a join v$statname b on a.STATISTIC# = b.STATISTIC#  where sid in(&1) and a.STATISTIC# in(6,7,14,37,50,84,88,108,194,410,573,625,626,629,641)
)
select *
from (
    select /*+ ORDERED */
         s2.sid, 
		 s2.name,
         s2.value  - s1.value  value
    from
         s1,
         sleep,
         s2
    where
         s2.sid = s1.sid (+)
    and  s2.STATISTIC# = s1.STATISTIC# (+)
    and  sleep.x = 1
) sq
order by sid,value DESC
/
set feedback on


