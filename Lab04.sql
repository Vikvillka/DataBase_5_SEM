------------------ задание 1---------------
--1. Получите список всех файлов табличных пространств (перманентных  и временных).
select * from DBA_TABLESPACES;

select TABLESPACE_NAME, FILE_NAME from SYS.DBA_DATA_FILES;
select TABLESPACE_NAME, FILE_NAME from SYS.DBA_TEMP_FILES;
------------------ задание 2---------------
--2. Создайте табличное пространство с именем XXX_QDATA (10m). 
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

------------------ задание 3---------------
--3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1.
select * from dba_segments where tablespace_name = 'BVA_QDATA';
------------------ задание 4---------------
--4. Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. 
--Выполните SELECT-запрос к представлению USER_RECYCLEBIN
drop table BVA_T1;

select * from dba_segments where tablespace_name = 'BVA_QDATA';
select * from USER_RECYCLEBIN -- представление в оракл для хранения удаленных таблиц или индексов;
------------------ задание 5---------------
--5. Восстановите (FLASHBACK) удаленную таблицу. 
flashback table BVA_T1 to before drop;
------------------ задание 6---------------
--6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк). 
declare
    i integer := 4;
begin
    while i < 10004 loop
        insert into BVA_T1(x, y) values (i, i);
        i := i + 1;
    end loop;
end;

select count(*) from BVA_T1;
------------------ задание 7---------------
--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. 
select extents, bytes, blocks from dba_segments where segment_name = 'BVA_T1';
select * from dba_extents where segment_name = 'BVA_T1';--это структуры хранения, используемые для управления памятью в табличных пространствах
------------------ задание 8---------------
--8. Удалите табличное пространство XXX_QDATA и его файл. 
drop tablespace BVA_QDATA including contents and datafiles;
------------------ задание 9---------------
--9. Получите перечень всех групп журналов повтора --это механизмы, используемые для обеспечения надежности и восстановления данных в базе данных..
SELECT * FROM V$LOG;
------------------ задание 10---------------
--10. Получите перечень файлов всех журналов повтора инстанса.
select member from v$logfile;
------------------ задание 11---------------
--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. 
select group#, status from v$log;
alter system switch logfile;
select TO_CHAR(SYSDATE, 'HH24:MI DD MONTH YYYY') as current_date from DUAL;
--14:29 29 СЕНТЯБРЯ 24
select group# from v$log where status = 'CURRENT';
------------------ задание 12---------------
--Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). 
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
------------------ задание 13---------------
--Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_3.LOG' ;
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_2.LOG' ;
alter database drop logfile member 'D:\app\vika\oradata\orcl\REDO04_1.LOG' ;

alter database drop logfile group 4;
------------------ задание 14---------------
--14. Определите, выполняется или нет архивирование журналов повтора
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
------------------ задание 15---------------
--15. Определите номер последнего архива.
--это процесс сохранения журналов повторного выполнения (redo logs) в архивные файлы после того, как они были записаны и перестали использоваться для текущих операций.
select * from V$ARCHIVED_LOG;
------------------ задание 16---------------
--Включите архивирование. 
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
select * from v$log;
------------------ задание 17---------------
--создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии.
alter system switch logfile;
select * from V$LOG where status = 'CURRENT';
select * from V$ARCHIVED_LOG;

------------------ задание 18---------------
--Отключите архивирование. Убедитесь, что архивирование отключено.  
archive log list;
------------------ задание 19---------------
--19. Получите список управляющих файлов это критически важные файлы, содержащие информацию о структуре базы данных. .
select * from V$CONTROLFILE;

------------------ задание 20---------------
--20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.

select type, record_size, records_total from v$controlfile_record_section;
select * from V$CONTROLFILE;
------------------ задание 21---------------
--21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. --spfile
select * from V$PARAMETER;
------------------ задание 22---------------
--22. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.
--D:\app\vika\product\12.1.0\dbhome_1\database
create pfile = 'BVA_PFILE.ora' from spfile;
------------------ задание 23---------------
---23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. 
select * from V$PWFILE_USERS; 
SHOW PARAMETER passwordfile;
SELECT *
FROM v$parameter
WHERE name like '%password%';
------------------ задание 24---------------
--24. Получите перечень директориев для файлов сообщений и диагностики. 
select * from V$DIAG_INFO;

commit;