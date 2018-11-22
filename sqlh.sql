--------------------------------------------------------------------------------
--
-- File name:   sqlh.sql
-- Purpose:     Display the full sql text from dba_hist_sqltext
--
-- Author:      Bright Wen
--              
-- Usage:       @sqlh <sqlid>         
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set long 5000
set ver off
set echo off
set feedback off
set pagesize 60
col sql_fulltext  head SQLFullText for a100 justify left word_wrap
col parse_calls head Parses for 99999
col h_parses    head HardParse for 99999

select 
	sql_text as sql_fulltext
from dba_hist_sqltext
where sql_id in('&1')
/
set feedback on