--------------------------------------------------------------------------------
--
-- File name:   uif.sql
-- Purpose:     Display the foreign key without index by owner
--
-- Author:      Bright Wen
--              
-- Usage:       @uif <owner>             
--
--------------------------------------------------------------------------------
SET LINESIZE 500
set ver off
set echo off
col OWNER                head Owner for a30
col TABLE_NAME           head TableName for a30 justify left word_wrap

col CONSTRAINT_NAME      head ConstraintName for a30  justify left word_wrap
col COLUMNS              head Columns for a60 justify left word_wrap

SELECT OWNER,
       TABLE_NAME,
       CONSTRAINT_NAME,
       CNAME1 || NVL2(CNAME2, ',' || CNAME2, NULL) ||
       NVL2(CNAME3, ',' || CNAME3, NULL) ||
       NVL2(CNAME4, ',' || CNAME4, NULL) ||
       NVL2(CNAME5, ',' || CNAME5, NULL) ||
       NVL2(CNAME6, ',' || CNAME6, NULL) ||
       NVL2(CNAME7, ',' || CNAME7, NULL) ||
       NVL2(CNAME8, ',' || CNAME8, NULL) COLUMNS
  FROM (SELECT B.TABLE_NAME,
               B.CONSTRAINT_NAME,
               B.OWNER,
               MAX(DECODE(POSITION, 1, COLUMN_NAME, NULL)) CNAME1,
               MAX(DECODE(POSITION, 2, COLUMN_NAME, NULL)) CNAME2,
               MAX(DECODE(POSITION, 3, COLUMN_NAME, NULL)) CNAME3,
               MAX(DECODE(POSITION, 4, COLUMN_NAME, NULL)) CNAME4,
               MAX(DECODE(POSITION, 5, COLUMN_NAME, NULL)) CNAME5,
               MAX(DECODE(POSITION, 6, COLUMN_NAME, NULL)) CNAME6,
               MAX(DECODE(POSITION, 7, COLUMN_NAME, NULL)) CNAME7,
               MAX(DECODE(POSITION, 8, COLUMN_NAME, NULL)) CNAME8,
               COUNT(*) COL_CNT
          FROM (SELECT SUBSTR(TABLE_NAME, 1, 30) TABLE_NAME,
                       SUBSTR(CONSTRAINT_NAME, 1, 30) CONSTRAINT_NAME,
                       SUBSTR(COLUMN_NAME, 1, 30) COLUMN_NAME,
                       POSITION,
                       OWNER
                  FROM DBA_CONS_COLUMNS WHERE OWNER = UPPER('&1')) A,
               DBA_CONSTRAINTS B
         WHERE A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
           AND A.OWNER = B.OWNER
           AND B.CONSTRAINT_TYPE = 'R' AND B.OWNER = UPPER('&1')
         GROUP BY B.TABLE_NAME, B.CONSTRAINT_NAME,B.OWNER) CONS
WHERE COL_CNT > ALL
 (SELECT COUNT(*)
          FROM DBA_IND_COLUMNS I
         WHERE I.TABLE_NAME = CONS.TABLE_NAME
           AND I.TABLE_OWNER = CONS.OWNER 
           AND I.TABLE_OWNER = UPPER('&1')
           AND I.COLUMN_NAME IN (CNAME1, CNAME2, CNAME3, CNAME4, CNAME5,
                CNAME6, CNAME7, CNAME8)
           AND I.COLUMN_POSITION <= CONS.COL_CNT
         GROUP BY I.INDEX_NAME)
/