--------------------------------------------------------------------------------
--
-- File name:   hide.sql
-- Purpose:     Display hidden parameters
--
-- Author:      Bright Wen
--              
-- Usage:       @hide 
--              
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set pagesize 20
set ver off
set echo off
set feedback off
col name    head ParameterName for a50 justify left word_wrap
col value     head Value for a100 justify left word_wrap

select
    i.ksppinm name,
    cv.ksppstvl value
from sys.x$ksppi i,sys.x$ksppcv cv
where
    i.inst_id=userenv('Instance') and
    cv.inst_id=userenv('Instance') and
    i.indx=cv.indx and
    i.ksppinm like '/_%' escape '/'
order by
replace(i.ksppinm,'_','')
/
set feedback on
