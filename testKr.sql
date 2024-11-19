--USER_XXXXXXXXX - представления, которые представляют возможность видеть объекты принадлежащие пользователю
--ALL_XXXXXXXXXX - представления, которые представляют возможность видеть объекты принадлежащие пользователю или на которые ему были выданы привилегии
--DBA_XXXXXXXXXX - представления, которые представляют возможность видеть все объекты. Представления предназначены для администратора базы данных
--V$XXXXXXXXXXX – динамические представления производительности, информация об экземпляре БД к которому подключен пользователь.
--GV$XXXXXXXXXX - динамические представления производительности, информация обо всех экземплярах БД.

--------- табличные пространства -----------
SELECT tablespace_name FROM dba_tablespaces;
--------- пользователи -----------
select * from dba_users;
--------- роли пользователей -----------
SELECT role FROM dba_roles WHERE role = 'C##RL_BVACORE';
SELECT grantee, privilege FROM dba_sys_privs WHERE grantee = 'C##RL_BVACORE';
--------- профили -----------
SELECT * FROM DBA_PROFILES;
----------------- все пдб -----------------
select * from dba_pdbs;
----------------- инстанс -----------------
SELECT * FROM v$instance;
----------------- опции инстанса -----------------
select * from v$option;
------------ глобальный обькт -----------------
select global_name from global_name;
------ 
select * from dba_tablespaces where TABLESPACE_NAME like 'BVA%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'BVA%';
select * from dba_sys_privs where GRANTEE like 'BVA%';
select * from dba_profiles where PROFILE like 'BVA%';
select * from dba_users where USERNAME like '%BVA%';

--------------- сегменты табличного пространства 
--3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1.
select * from dba_segments where tablespace_name = 'BVA_QDATA';
select * from USER_RECYCLEBIN; -- представление в оракл для хранения удаленных таблиц или индексов;

--9. Получите перечень всех групп журналов повтора --это механизмы, используемые для обеспечения надежности и восстановления данных в базе данных..
SELECT * FROM V$LOG;
------------------ задание 10---------------
--10. Получите перечень файлов всех журналов повтора инстанса.
select member from v$logfile;
------------------ задание 11---------------
--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. 
select group#, status from v$log;
alter system switch logfile;

----
select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;

alter system switch logfile;
select group#, status from V$LOG;
select group# from V$LOG where status = 'CURRENT';

--14. Определите, выполняется или нет архивирование журналов повтора
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

----- архивирование -------
select * from V$ARCHIVED_LOG;

--19. Получите список управляющих файлов это критически важные файлы, содержащие информацию о структуре базы данных. .
select * from V$CONTROLFILE;

------------------ задание 20---------------
--20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.

select type, record_size, records_total from v$controlfile_record_section;

-----
--21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. --spfile
select * from V$PARAMETER;

-------23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. 
select * from V$PWFILE_USERS; 
--24. Получите перечень директориев для файлов сообщений и диагностики. 
select * from V$DIAG_INFO;


------------------ задание 1---------------
--1.	Определите общий размер области SGA
select sum(value) from v$sga;
------------------ задание 2---------------
--2.	Определите текущие размеры основных пулов SGA
select * from v$sga;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;
------------------ задание 3---------------
--3.	Определите размеры гранулы для каждого пула.
select *
from v$sga_dynamic_components;
------------------ задание 4---------------
--4.	Определите объем доступной свободной памяти в SGA.
select current_size from v$sga_dynamic_free_memory;
------------------ задание 5---------------
--5.	Определите максимальный и целевой размер области SGA.
select value from v$parameter where name = 'sga_target';
select value from v$parameter where name = 'sga_max_size';
------------------ задание 6---------------
--6.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select component, min_size, current_size 
from v$sga_dynamic_components;

--10.	Найдите размер свободной памяти в большом пуле
select * from  v$sgastat where pool = 'large pool';

--11.	Определите режимы текущих соединений с инстансом (dedicated, shared).

select *
from v$session where username is not null;

--12.	Получите полный список работающих в настоящее время фоновых процессов.
select count(*) from v$bgprocess;

select name, description from v$bgprocess where paddr != hextoraw('00') order by name;
------------------ задание 13---------------
--13.	Получите список работающих в настоящее время серверных процессов.
select pname, program from v$process where background is null order by pname;
------------------ задание 14---------------
--14.	Определите, сколько процессов DBWn работает в настоящий момент.
select count(*) from v$bgprocess where name like 'DBW%';
select * from v$bgprocess where name like 'DBW%';
------------------ задание 15---------------
--15.	Определите сервисы (точки подключения экземпляра).
select name, network_name, pdb from v$services;
------------------ задание 16---------------
--16.	Получите известные вам параметры диспетчеров.
select * from v$dispatcher;
------------------ задание 17---------------
--17.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
select * from v$services;