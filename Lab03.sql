----------------- задание 1 -----------------
select * from dba_pdbs;
----------------- задание 2 -----------------
SELECT * FROM v$instance;
----------------- задание 3 -----------------
select * from v$option;
----------------- задание 4-5 -----------------
select * from dba_pdbs;
----------------- задание 6 -----------------
alter session set container = BVA_PDB;
alter pluggable database BVA_PDB open;
alter session set "_ORACLE_SCRIPT" = true;
alter session set container = CDB$ROOT; --вернутся

create tablespace BVA_PDB_TS
  datafile 'BVA_PDB_TS_1.dbf'
  size 10M
  autoextend on next 5M
  maxsize 50M;
  
create temporary tablespace BVA_PDB_TS_TEMP
  tempfile 'BVA_PDB_TS_TEMP_1.dbf'
  size 5M
  autoextend on next 2M
  maxsize 40M;
  
select * from dba_tablespaces where TABLESPACE_NAME like 'BVA%';
drop tablespace BVA_PDB_TS including contents and datafiles;
drop tablespace BVA_PDB_TS_TEMP including contents and datafiles;

create role BVA_PDB_RL;

grant 
    connect, 
    create session,
    alter session,
    create any table, 
    drop any table, 
    create any view, 
    drop any view, 
    create any procedure, 
    drop any procedure 
to BVA_PDB_RL;

select * from dba_roles where ROLE like '%RL%';
drop role BVA_PDB_RL;

create profile BVA_PDB_PROFILE limit
  password_life_time 365
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  connect_time 180;
  
select * from dba_profiles where PROFILE like '%BVA_PDB_PROFILE%';
drop profile BVA_PDB_PROFILE;

create user U1_BVA_PDB 
    identified by 111
    default tablespace BVA_PDB_TS 
    quota unlimited on BVA_PDB_TS
    temporary tablespace BVA_PDB_TS_TEMP
    profile BVA_PDB_PROFILE
    account unlock
    password expire;
    
grant 
    BVA_PDB_RL,
    SYSDBA
to U1_BVA_PDB; 

select * from dba_users where USERNAME like '%U1%';
drop user U1_BVA_PDB;
----------------- задание 7 -----------------
select global_name from global_name;

create table BVA_PDB_TABLE 
(
    id int primary key,
    field varchar(50)
);

insert into BVA_PDB_TABLE values (1, 'Value1'); 
insert into BVA_PDB_TABLE values (2, 'Value2');
insert into BVA_PDB_TABLE values (3, 'Value3');

select * from BVA_PDB_TABLE
drop table  BVA_PDB_TABLE;
----------------- задание 8 -----------------

select * from dba_tablespaces where TABLESPACE_NAME like 'BVA%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'BVA%';
select * from dba_sys_privs where GRANTEE like 'BVA%';
select * from dba_profiles where PROFILE like 'BVA%';
select * from dba_users where USERNAME like '%BVA%';
----------------- задание 9 -----------------

alter session set container = CDB$ROOT;

create user C##BVA
    identified by 111;
    
grant 
    connect, 
    create session, 
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##BVA container = all;

GRANT CREATE USER TO C##BVA;
GRANT CREATE TABLESPACE TO C##BVA;
GRANT ALTER TABLESPACE TO C##BVA;
GRANT DROP TABLESPACE TO C##BVA;
select * from  dba_users where USERNAME like '%C##%';

create table x (id int);
insert into x values (1); 
insert into x values (2);
insert into x values (3);
COMMIT;
drop table x;

----------------- задание 10 -----------------
alter pluggable database BVA_PDB open;
drop pluggable database BVA_PDB including datafiles;



