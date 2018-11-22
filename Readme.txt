1. sw.sql -- Display current Session Wait info
2. sw2.sql -- Display current Session Wait info(only display P1,P2,P3,without text)
3. swa.sql  -- Display current all Session Wait info
4. swg.sql -- Display given Session Wait info grouped by state and event
5. swag.sql -- Display all Session Wait info grouped by state and event
6. s.sql --  Display Session detail infomation by SIDs
7. se.sql --  Display Session detail infomation by event
8. top.sql --  Display the top sql with high buffer get,disk read,hard parses,executions
9. top2.sql  -- Display the top sql with high CPU,Elapsed Time
10. o.sql --  Display object information by name
11. o2.sql -- Display object information by object id
12. uif.sql -- Display the foreign key without index by owner
13. t.sql -- Display table detail info
14. sql.sql -- Display the full sql text and stat
15. sqlc.sql -- Display the sql executions stat from v$sql by sql_id
16. lobj2.sql -- Display locked object by object name
17. lobj.sql -- Display locked object by sid
18. lock.sql -- Display the locks which the session held and requested
19. oc.sql -- Display Session open cursor
20. k.sql -- Print kill session script
21. kb.sql -- Print kill blocker session script
22. swt.sql -- Display Session Wait Tree from  v$wait_chains
23. swt2.sql -- Display Session Wait Tree from gv$session
24. xp.sql -- Display current SQL execution plan
25. xp2.sql -- Display SQL execution plan by sql_id and child_num
26. xp3.sql -- Display SQL execution plan from AWS  by sql_id
27. topavg.sql -- Display the top sql order by  IO,rows_processed per execution
28. topavg2.sql -- Display the top sql order by elapsed_time,cpu_time,version_count per execution
29. ash.sql -- Display active Session history detail infomation by sid and sample time
30. ashwg.sql -- Display given ASH Session Wait info grouped by state and event
31. ashwt.sql -- Display active Session Wait Tree from gv$active_session_historysession by sample_time
