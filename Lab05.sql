------------------ задание 1---------------
--1.	Определите общий размер области SGA
select sum(value) from v$sga;
------------------ задание 2---------------
--2.	Определите текущие размеры основных пулов SGA
select * from v$sga;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;
------------------ задание 3---------------
--3.	Определите размеры гранулы для каждого пула.
select
    component,
    current_size,
    max_size,
    last_oper_mode,
    last_oper_time,
    granule_size,
    current_size/granule_size as Ratio
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
------------------ задание 7---------------
--7.	Создайте таблицу, которая будет помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table KEEP_TABLE (num int) storage (buffer_pool keep) tablespace users;
insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (2);

select * from KEEP_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like '%KEEP%';
------------------ задание 8---------------
--8.	Создайте таблицу, которая будет кэшироваться в пуле DEFAULT. Продемонстрируйте сегмент таблицы.
create table DEFAULT_TABLE (num int) storage (buffer_pool default) tablespace users;
insert into DEFAULT_TABLE values (3);
insert into DEFAULT_TABLE values (4);

select * from DEFAULT_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like 'DEFAULT%';

drop table KEEP_TABLE;
drop table DEFAULT_TABLE;
------------------ задание 9---------------
--9.	Найдите размер буфера журналов повтора.
show parameter log_buffer;
------------------ задание 10---------------
--10.	Найдите размер свободной памяти в большом пуле
select * from  v$sgastat where pool = 'large pool';

select 
    component, 
    min_size,
    max_size, 
    current_size,
    max_size - current_size as free_space
from v$sga_dynamic_components
where component = 'large pool';
------------------ задание 11---------------
--11.	Определите режимы текущих соединений с инстансом (dedicated, shared).

select 
    username, 
    service_name, 
    server 
from v$session where username is not null;
------------------ задание 12---------------
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
--services.msc
------------------ задание 18---------------
--18.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA.
--D:\app\asusvika\product\12.1.0\dbhome_1\NETWORK\ADMIN\SAMPLE
------------------ задание 19---------------
--19.	Запустите утилиту lsnrctl и поясните ее основные команды.
 /*
        1. start - Запускает слушатель баз данных Oracle.
        2. servacls - Отображает список сервисов и их доступа для подключений через слушателя.
        3. trace - Включает или отключает функцию трассировки для слушателя.
        4. show - Отображает текущие настройки слушателя или информацию о подключенных клиентах.
        5. stop - Останавливает слушатель баз данных Oracle.
        6. version - Отображает версию слушателя.
        7. quit или exit - Выходит из lsnrctl.
        8. status - Отображает текущий статус слушателя.
        9. reload - Перезагружает конфигурацию слушателя без его остановки.
        10. services - Отображает список доступных сервисов, которые могут быть запущены через слушателя.
        11. save_config - Сохраняет текущую конфигурацию слушателя в файл.
    */
------------------ задание 20---------------
--20.	Получите список служб инстанса, обслуживаемых процессом LISTENER.
 --services