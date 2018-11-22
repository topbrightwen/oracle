--------------------------------------------------------------------------------
--
-- File name:   swag.sql
-- Purpose:     Display all Session Wait info grouped by state and event
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @swag 

--
--------------------------------------------------------------------------------
@@swg "select sid from gv$session"
