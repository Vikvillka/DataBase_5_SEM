------------- ЗАДАНИЕ 1 ----------------

alter session set container = BVA_PDB;
alter pluggable database BVA_PDB open;

select * from dba_tablespaces where TABLESPACE_NAME like 'BVA%';
select * from dba_users where USERNAME like '%U1%';

GRANT CREATE SESSION TO U1_BVA_PDB;
GRANT RESTRICTED SESSION TO U1_BVA_PDB;
GRANT CREATE ANY TABLE TO U1_BVA_PDB;
GRANT CREATE ANY VIEW TO U1_BVA_PDB;
GRANT CREATE SEQUENCE TO U1_BVA_PDB;
GRANT UNLIMITED TABLESPACE TO U1_BVA_PDB;
GRANT CREATE CLUSTER TO U1_BVA_PDB;
GRANT CREATE SYNONYM TO U1_BVA_PDB;
GRANT CREATE PUBLIC SYNONYM TO U1_BVA_PDB;
GRANT CREATE MATERIALIZED VIEW TO U1_BVA_PDB;
GRANT SELECT ON 

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE LIKE '%BVA_PDB';

------------- ЗАДАНИЕ 2 ----------------
--2.	Создайте последовательность S1 (SEQUENCE), со следующими
--характеристиками: начальное значение 1000; приращение 10; нет минимального 
--значения; нет максимального значения; не циклическая; значения не кэшируются в памяти; хронология значений не гарантируется.
--Получите несколько значений последовательности. Получите текущее значение последовательности.
create sequence S1
  start with 1000
  increment by 10 
  nominvalue 
  nomaxvalue 
  nocycle
  nocache
  noorder;
  

select S1.NEXTVAL from DUAL;
select S1.CURRVAL from DUAL;

------------- ЗАДАНИЕ 3 ----------------
--3.	Создайте последовательность S2 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение 10; максимальное значение 100; 
-- не циклическую. Получите все значения последовательности. Попытайтесь получить значение, выходящее за максимальное значение.

create sequence S2
  start with 10
  increment by 10
  maxvalue 100
  nocycle;

select S2.NEXTVAL from DUAL;
------------- ЗАДАНИЕ 4 ----------------
------------- ЗАДАНИЕ 5 ----------------
--5.	Создайте последовательность S3 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение -10; минимальное значение -100; не циклическую; 
--гарантирующую хронологию значений. Получите все значения последовательности. 
--Попытайтесь получить значение, меньше минимального значения.
create sequence S3
  start with 10
  increment by -10
  minvalue -100
  maxvalue 100
  nocycle
  order;

select S3.NEXTVAL from DUAL;
------------- ЗАДАНИЕ 6 ----------------
--6.	Создайте последовательность S4 (SEQUENCE), со следующими характеристиками: начальное значение 1; приращение 1; минимальное значение 10; циклическая;
--кэшируется в памяти 5 значений; хронология значений не гарантируется. 
create sequence S4
  start with 1
  increment by 1
  maxvalue 10
  cycle
  cache 5
  noorder;

select S4.NEXTVAL from DUAL;

DROP sequence S1;
DROP sequence S2;
DROP sequence S3;
DROP sequence S4;
------------- ЗАДАНИЕ 7 ----------------
--7.	Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX.
SELECT * FROM USER_SEQUENCES;
------------- ЗАДАНИЕ 8 -----------------
--8.	Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP. С помощью оператора INSERT
--добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью последовательностей S1, S2, S3, S4.
CREATE TABLE T1 (
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)
) CACHE STORAGE ( BUFFER_POOL KEEP ) tablespace BVA_PDB_TS;

BEGIN
  FOR i IN 1..7 LOOP
    INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
  END LOOP;
END;

SELECT * FROM T1;
------------- ЗАДАНИЕ 9 ----------------
--9.	Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
CREATE CLUSTER ABC (
  X NUMBER(10),
  V VARCHAR2(12)
) SIZE 200 HASHKEYS 200;
------------- ЗАДАНИЕ 10 ----------------
--10.	Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.
CREATE TABLE A (
  XA NUMBER(10),
  VA VARCHAR2(12),
  Y NUMBER(10)
) CLUSTER ABC(XA, VA);
------------- ЗАДАНИЕ 11 ----------------
--11.	Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.
CREATE TABLE B (
  XB NUMBER(10),
  VB VARCHAR2(12),
  Z NUMBER(10)
) CLUSTER ABC(XB, VB);

INSERT INTO B VALUES (1, '1', 1);
------------- ЗАДАНИЕ 12 ----------------
--12.	Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец. 
CREATE TABLE C (
  XC NUMBER(10),
  VC VARCHAR2(12),
  W NUMBER(10)
) CLUSTER ABC(XC, VC);

INSERT INTO C VALUES (1, '1', 1);
------------- ЗАДАНИЕ 13 ----------------
--13.	Найдите созданные таблицы и кластер в представлениях словаря Oracle.
SELECT TABLE_NAME FROM USER_TABLES;
SELECT CLUSTER_NAME FROM USER_CLUSTERS;

------------- ЗАДАНИЕ 14 ----------------
--14.	Создайте частный синоним для таблицы XXX.С и продемонстрируйте его применение.
CREATE SYNONYM SC FOR C;
SELECT * FROM C;
SELECT * FROM SC;
DROP SYNONYM SC;
------------- ЗАДАНИЕ 15 ----------------
CREATE PUBLIC SYNONYM SB_1 FOR B;
SELECT * FROM SB_1;
------------- ЗАДАНИЕ 16 ----------------
--16.	Создайте две произвольные таблицы A и B (с первичным и внешним ключами), заполните их данными, создайте представление
--V1, основанное на SELECT... FOR A inner join B. Продемонстрируйте его работоспособность.
CREATE TABLE A16 (
  XA NUMBER(10),
  VA VARCHAR2(12),
  Y NUMBER(10),
  CONSTRAINT PK_A16 PRIMARY KEY (XA)
);

CREATE TABLE B16 (
  XB NUMBER(10),
  VB VARCHAR2(12),
  Z NUMBER(10),
  CONSTRAINT FK_B16 FOREIGN KEY (XB) REFERENCES A16(XA)
);

INSERT INTO A16 VALUES (1, '1', 1);
INSERT INTO B16 VALUES (1, '1', 1);

INSERT INTO A16 VALUES (2, '2', 2);
INSERT INTO B16 VALUES (2, '2', 2);

INSERT INTO A16 VALUES (3, '3', 3);
INSERT INTO B16 VALUES (3, '3', 3);

COMMIT;

CREATE VIEW V1 AS
  SELECT * FROM A16
  INNER JOIN B16 ON A16.XA = B16.XB;

SELECT * FROM V1;

------------- ЗАДАНИЕ 17 ----------------
--17.	На основе таблиц A и B создайте материализованное представление MV,
--которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.
CREATE MATERIALIZED VIEW MV
  REFRESH FORCE ON DEMAND
  next SYSDATE + 2/1440|}
as
    select * from A16
    inner join
    B16
    on A16.XA = B16.XB;

select * from MV;

EXECUTE DBMS_MVIEW.REFRESH('MV');