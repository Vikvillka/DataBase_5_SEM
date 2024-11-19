---------------задание1----------------
CREATE TABLESPACE ts_bva
  datafile 'ts_bva.dat' 
  size 7M REUSE 
  AUTOEXTEND ON NEXT 5M 
  MAXSIZE 20M;
  
---------------задание2----------------
CREATE TEMPORARY TABLESPACE ts_bva_temp
  TEMPfile 'ts_bva_temp.dat' 
  size 5M REUSE 
  AUTOEXTEND ON NEXT 3M 
  MAXSIZE 30M;
  
--DROP TABLESPACE ts_bva INCLUDING CONTENTS;
--DROP TABLESPACE ts_bva_temp INCLUDING CONTENTS;
  
---------------задание3----------------  
SELECT tablespace_name
FROM dba_tablespaces;

COMMIT;

---------------задание4----------------
CREATE ROLE C##RL_BVACORE;

GRANT CREATE SESSION TO C##RL_BVACORE;
GRANT CREATE TABLE TO C##RL_BVACORE;
GRANT CREATE VIEW TO C##RL_BVACORE;
GRANT CREATE PROCEDURE TO C##RL_BVACORE;

GRANT DROP ANY TABLE TO C##RL_BVACORE;
GRANT DROP ANY VIEW TO C##RL_BVACORE;
GRANT DROP ANY PROCEDURE TO C##RL_BVACORE;

COMMIT;

---------------задание5----------------
SELECT role
FROM dba_roles
WHERE role = 'C##RL_BVACORE';

SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'C##RL_BVACORE';

---------------задание6----------------
CREATE PROFILE C##BVACORE LIMIT
PASSWORD_LIFE_TIME 180
SESSIONS_PER_USER 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 30

---------------задание7----------------
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'C##BVACORE';

---------------задание8----------------

alter session set "_ORACLE_SCRIPT"=true; 

create user C##BVACOREUSER IDENTIFIED BY 12345 
DEFAULT TABLESPACE ts_bva 
TEMPORARY TABLESPACE ts_bva_temp
PROFILE C##BVACORE
ACCOUNT UNLOCK
PASSWORD EXPIRE

GRANT  C##RL_BVACORE TO C##BVACOREUSER;
GRANT CREATE USER TO C##BVACOREUSER;
GRANT CREATE TABLESPACE TO C##BVACOREUSER;
GRANT ALTER TABLESPACE TO C##BVACOREUSER;
GRANT DROP TABLESPACE TO C##BVACOREUSER;

select * from C##BVACOREUSER;

---------------задание9----------------
--alter user C##bvacoreuser identified by 1111;
---------------задание10----------------
CREATE TABLE ANYTABLE
(
ID NUMBER
);
 
CREATE VIEW ANYVIEW AS SELECT * FROM ANYTABLE; 

---------------задание11----------------

CREATE TABLESPACE BVA_QDATA
DATAFILE 'BVA_QDATA.DTF'
SIZE 10M
OFFLINE;

alter tablespace BVA_QDATA ONLINE;

DROP tablespace BVA_QDATA including contents and datafiles;
SELECT USER FROM DUAL;

ALTER USER C##BVACOREUSER QUOTA 2M ON BVA_QDATA;

create table LastTable (
    id number,
    name varchar(10)
) tablespace BVA_QDATA;

insert into LastTable values (1, 'dddd');
insert into LastTable values (2, 'ssss');
insert into LastTable values (3, 'gggg');

select * from LastTable;
commit
