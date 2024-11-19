--USER_XXXXXXXXX - �������������, ������� ������������ ����������� ������ ������� ������������� ������������
--ALL_XXXXXXXXXX - �������������, ������� ������������ ����������� ������ ������� ������������� ������������ ��� �� ������� ��� ���� ������ ����������
--DBA_XXXXXXXXXX - �������������, ������� ������������ ����������� ������ ��� �������. ������������� ������������� ��� �������������� ���� ������
--V$XXXXXXXXXXX � ������������ ������������� ������������������, ���������� �� ���������� �� � �������� ��������� ������������.
--GV$XXXXXXXXXX - ������������ ������������� ������������������, ���������� ��� ���� ����������� ��.

--------- ��������� ������������ -----------
SELECT tablespace_name FROM dba_tablespaces;
--------- ������������ -----------
select * from dba_users;
--------- ���� ������������� -----------
SELECT role FROM dba_roles WHERE role = 'C##RL_BVACORE';
SELECT grantee, privilege FROM dba_sys_privs WHERE grantee = 'C##RL_BVACORE';
--------- ������� -----------
SELECT * FROM DBA_PROFILES;
----------------- ��� ��� -----------------
select * from dba_pdbs;
----------------- ������� -----------------
SELECT * FROM v$instance;
----------------- ����� �������� -----------------
select * from v$option;
------------ ���������� ����� -----------------
select global_name from global_name;
------ 
select * from dba_tablespaces where TABLESPACE_NAME like 'BVA%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'BVA%';
select * from dba_sys_privs where GRANTEE like 'BVA%';
select * from dba_profiles where PROFILE like 'BVA%';
select * from dba_users where USERNAME like '%BVA%';

--------------- �������� ���������� ������������ 
--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1.
select * from dba_segments where tablespace_name = 'BVA_QDATA';
select * from USER_RECYCLEBIN; -- ������������� � ����� ��� �������� ��������� ������ ��� ��������;

--9. �������� �������� ���� ����� �������� ������� --��� ���������, ������������ ��� ����������� ���������� � �������������� ������ � ���� ������..
SELECT * FROM V$LOG;
------------------ ������� 10---------------
--10. �������� �������� ������ ���� �������� ������� ��������.
select member from v$logfile;
------------------ ������� 11---------------
--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. 
select group#, status from v$log;
alter system switch logfile;

----
select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;

alter system switch logfile;
select group#, status from V$LOG;
select group# from V$LOG where status = 'CURRENT';

--14. ����������, ����������� ��� ��� ������������� �������� �������
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

----- ������������� -------
select * from V$ARCHIVED_LOG;

--19. �������� ������ ����������� ������ ��� ���������� ������ �����, ���������� ���������� � ��������� ���� ������. .
select * from V$CONTROLFILE;

------------------ ������� 20---------------
--20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.

select type, record_size, records_total from v$controlfile_record_section;

-----
--21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. --spfile
select * from V$PARAMETER;

-------23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. 
select * from V$PWFILE_USERS; 
--24. �������� �������� ����������� ��� ������ ��������� � �����������. 
select * from V$DIAG_INFO;


------------------ ������� 1---------------
--1.	���������� ����� ������ ������� SGA
select sum(value) from v$sga;
------------------ ������� 2---------------
--2.	���������� ������� ������� �������� ����� SGA
select * from v$sga;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;
------------------ ������� 3---------------
--3.	���������� ������� ������� ��� ������� ����.
select *
from v$sga_dynamic_components;
------------------ ������� 4---------------
--4.	���������� ����� ��������� ��������� ������ � SGA.
select current_size from v$sga_dynamic_free_memory;
------------------ ������� 5---------------
--5.	���������� ������������ � ������� ������ ������� SGA.
select value from v$parameter where name = 'sga_target';
select value from v$parameter where name = 'sga_max_size';
------------------ ������� 6---------------
--6.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select component, min_size, current_size 
from v$sga_dynamic_components;

--10.	������� ������ ��������� ������ � ������� ����
select * from  v$sgastat where pool = 'large pool';

--11.	���������� ������ ������� ���������� � ��������� (dedicated, shared).

select *
from v$session where username is not null;

--12.	�������� ������ ������ ���������� � ��������� ����� ������� ���������.
select count(*) from v$bgprocess;

select name, description from v$bgprocess where paddr != hextoraw('00') order by name;
------------------ ������� 13---------------
--13.	�������� ������ ���������� � ��������� ����� ��������� ���������.
select pname, program from v$process where background is null order by pname;
------------------ ������� 14---------------
--14.	����������, ������� ��������� DBWn �������� � ��������� ������.
select count(*) from v$bgprocess where name like 'DBW%';
select * from v$bgprocess where name like 'DBW%';
------------------ ������� 15---------------
--15.	���������� ������� (����� ����������� ����������).
select name, network_name, pdb from v$services;
------------------ ������� 16---------------
--16.	�������� ��������� ��� ��������� �����������.
select * from v$dispatcher;
------------------ ������� 17---------------
--17.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
select * from v$services;