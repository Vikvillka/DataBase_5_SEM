------------------ ������� 1---------------
--1.	���������� ����� ������ ������� SGA
select sum(value) from v$sga;
------------------ ������� 2---------------
--2.	���������� ������� ������� �������� ����� SGA
select * from v$sga;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;
------------------ ������� 3---------------
--3.	���������� ������� ������� ��� ������� ����.
select
    component,
    current_size,
    max_size,
    last_oper_mode,
    last_oper_time,
    granule_size,
    current_size/granule_size as Ratio
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
------------------ ������� 7---------------
--7.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
create table KEEP_TABLE (num int) storage (buffer_pool keep) tablespace users;
insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (2);

select * from KEEP_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like '%KEEP%';
------------------ ������� 8---------------
--8.	�������� �������, ������� ����� ������������ � ���� DEFAULT. ����������������� ������� �������.
create table DEFAULT_TABLE (num int) storage (buffer_pool default) tablespace users;
insert into DEFAULT_TABLE values (3);
insert into DEFAULT_TABLE values (4);

select * from DEFAULT_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like 'DEFAULT%';

drop table KEEP_TABLE;
drop table DEFAULT_TABLE;
------------------ ������� 9---------------
--9.	������� ������ ������ �������� �������.
show parameter log_buffer;
------------------ ������� 10---------------
--10.	������� ������ ��������� ������ � ������� ����
select * from  v$sgastat where pool = 'large pool';

select 
    component, 
    min_size,
    max_size, 
    current_size,
    max_size - current_size as free_space
from v$sga_dynamic_components
where component = 'large pool';
------------------ ������� 11---------------
--11.	���������� ������ ������� ���������� � ��������� (dedicated, shared).

select 
    username, 
    service_name, 
    server 
from v$session where username is not null;
------------------ ������� 12---------------
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
--services.msc
------------------ ������� 18---------------
--18.	����������������� � �������� ���������� ����� LISTENER.ORA.
--D:\app\asusvika\product\12.1.0\dbhome_1\NETWORK\ADMIN\SAMPLE
------------------ ������� 19---------------
--19.	��������� ������� lsnrctl � �������� �� �������� �������.
 /*
        1. start - ��������� ��������� ��� ������ Oracle.
        2. servacls - ���������� ������ �������� � �� ������� ��� ����������� ����� ���������.
        3. trace - �������� ��� ��������� ������� ����������� ��� ���������.
        4. show - ���������� ������� ��������� ��������� ��� ���������� � ������������ ��������.
        5. stop - ������������� ��������� ��� ������ Oracle.
        6. version - ���������� ������ ���������.
        7. quit ��� exit - ������� �� lsnrctl.
        8. status - ���������� ������� ������ ���������.
        9. reload - ������������� ������������ ��������� ��� ��� ���������.
        10. services - ���������� ������ ��������� ��������, ������� ����� ���� �������� ����� ���������.
        11. save_config - ��������� ������� ������������ ��������� � ����.
    */
------------------ ������� 20---------------
--20.	�������� ������ ����� ��������, ������������� ��������� LISTENER.
 --services