------------------ ������� 1---------------
--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).
select * from DBA_TABLESPACES;

select TABLESPACE_NAME, FILE_NAME from SYS.DBA_DATA_FILES;
select TABLESPACE_NAME, FILE_NAME from SYS.DBA_TEMP_FILES;
------------------ ������� 2---------------
--2. �������� ��������� ������������ � ������ XXX_QDATA (10m). 
CREATE TABLESPACE BVA_QDATA
DATAFILE 'BVA_QDATAFILE.DTF'
SIZE 10M
OFFLINE;

alter tablespace BVA_QDATA ONLINE;

DROP tablespace BVA_QDATA including contents and datafiles;

SELECT tablespace_name FROM dba_tablespaces WHERE tablespace_name = 'BVA_QDATA';

ALTER USER C##BVA QUOTA 2M ON BVA_QDATA CONTAINER=CURRENT;

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS current_pdb FROM dual;

SELECT * FROM dba_ts_quotas WHERE username = 'C##BVA' AND tablespace_name = 'BVA_QDATA';

create table BVA_T1 (
    x integer primary key,
    y integer
) tablespace BVA_QDATA;

insert into BVA_T1(x, y) values (1, 2);
insert into BVA_T1(x, y) values (2, 3);
insert into BVA_T1(x, y) values (3, 4);

select * from BVA_T1;

------------------ ������� 3---------------
--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1.
select * from dba_segments where tablespace_name = 'BVA_QDATA';
------------------ ������� 4---------------
--4. ������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. 
--��������� SELECT-������ � ������������� USER_RECYCLEBIN
drop table BVA_T1;

select * from dba_segments where tablespace_name = 'BVA_QDATA';
select * from USER_RECYCLEBIN -- ������������� � ����� ��� �������� ��������� ������ ��� ��������;
------------------ ������� 5---------------
--5. ������������ (FLASHBACK) ��������� �������. 
flashback table BVA_T1 to before drop;
------------------ ������� 6---------------
--6. ��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����). 
declare
    i integer := 4;
begin
    while i < 10004 loop
        insert into BVA_T1(x, y) values (i, i);
        i := i + 1;
    end loop;
end;

select count(*) from BVA_T1;
------------------ ������� 7---------------
--7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. 
select extents, bytes, blocks from dba_segments where segment_name = 'BVA_T1';
select * from dba_extents where segment_name = 'BVA_T1';--��� ��������� ��������, ������������ ��� ���������� ������� � ��������� �������������
------------------ ������� 8---------------
--8. ������� ��������� ������������ XXX_QDATA � ��� ����. 
drop tablespace BVA_QDATA including contents and datafiles;
------------------ ������� 9---------------
--9. �������� �������� ���� ����� �������� ������� --��� ���������, ������������ ��� ����������� ���������� � �������������� ������ � ���� ������..
SELECT * FROM V$LOG;
------------------ ������� 10---------------
--10. �������� �������� ������ ���� �������� ������� ��������.
select member from v$logfile;
------------------ ������� 11---------------
--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. 
select group#, status from v$log;
alter system switch logfile;
select TO_CHAR(SYSDATE, 'HH24:MI DD MONTH YYYY') as current_date from DUAL;
--14:29 29 �������� 24
select group# from v$log where status = 'CURRENT';
------------------ ������� 12---------------
--�������� �������������� ������ �������� ������� � ����� ������� �������. ��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). 
alter database add logfile 
    group 4 
    'D:\app\vika\oradata\orcl\REDO0422.LOG'
    size 50m 
    blocksize 512;
    
alter database add logfile 
    member 
     'D:\app\vika\oradata\orcl\REDO04_1.LOG' 
    to group 4;
alter database add logfile 
    member 
     'D:\app\vika\oradata\orcl\REDO04_2.LOG' 
    to group 4;
alter database add logfile 
    member 
     'D:\app\vika\oradata\orcl\REDO04_3.LOG' 
    to group 4;
    
select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;

alter system switch logfile;
select group#, status from V$LOG;
select group# from V$LOG where status = 'CURRENT';
------------------ ������� 13---------------
--������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_3.LOG' ;
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_2.LOG' ;
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_1.LOG' ;

alter database drop logfile group 4;
------------------ ������� 14---------------
--14. ����������, ����������� ��� ��� ������������� �������� �������
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
------------------ ������� 15---------------
--15. ���������� ����� ���������� ������.
--��� ������� ���������� �������� ���������� ���������� (redo logs) � �������� ����� ����� ����, ��� ��� ���� �������� � ��������� �������������� ��� ������� ��������.
select * from V$ARCHIVED_LOG;
------------------ ������� 16---------------
--�������� �������������. 
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
select * from v$log;
------------------ ������� 17---------------
--�������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������.
alter system switch logfile;
select * from V$LOG where status = 'CURRENT';
select * from V$ARCHIVED_LOG;

------------------ ������� 18---------------
--��������� �������������. ���������, ��� ������������� ���������.  
archive log list;
------------------ ������� 19---------------
--19. �������� ������ ����������� ������ ��� ���������� ������ �����, ���������� ���������� � ��������� ���� ������. .
select * from V$CONTROLFILE;

------------------ ������� 20---------------
--20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.

select type, record_size, records_total from v$controlfile_record_section;
select * from V$CONTROLFILE;
------------------ ������� 21---------------
--21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. --spfile
select * from V$PARAMETER;
------------------ ������� 22---------------
--22. ����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.
--D:\app\vika\product\12.1.0\dbhome_1\database
create pfile = 'BVA_PFILE.ora' from spfile;
------------------ ������� 23---------------
---23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. 
select * from V$PWFILE_USERS; 
SHOW PARAMETER passwordfile;
SELECT *
FROM v$parameter
WHERE name like '%password%';
------------------ ������� 24---------------
--24. �������� �������� ����������� ��� ������ ��������� � �����������. 
select * from V$DIAG_INFO;

commit;