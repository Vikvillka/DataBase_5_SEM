------------- ������� 1 ----------------

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

------------- ������� 2 ----------------
--2.	�������� ������������������ S1 (SEQUENCE), �� ����������
--����������������: ��������� �������� 1000; ���������� 10; ��� ������������ 
--��������; ��� ������������� ��������; �� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������.
--�������� ��������� �������� ������������������. �������� ������� �������� ������������������.
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

------------- ������� 3 ----------------
--3.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� 10; ������������ �������� 100; 
-- �� �����������. �������� ��� �������� ������������������. ����������� �������� ��������, ��������� �� ������������ ��������.

create sequence S2
  start with 10
  increment by 10
  maxvalue 100
  nocycle;

select S2.NEXTVAL from DUAL;
------------- ������� 4 ----------------
------------- ������� 5 ----------------
--5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� -10; ����������� �������� -100; �� �����������; 
--������������� ���������� ��������. �������� ��� �������� ������������������. 
--����������� �������� ��������, ������ ������������ ��������.
create sequence S3
  start with 10
  increment by -10
  minvalue -100
  maxvalue 100
  nocycle
  order;

select S3.NEXTVAL from DUAL;
------------- ������� 6 ----------------
--6.	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; ����������� �������� 10; �����������;
--���������� � ������ 5 ��������; ���������� �������� �� �������������. 
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
------------- ������� 7 ----------------
--7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.
SELECT * FROM USER_SEQUENCES;
------------- ������� 8 -----------------
--8.	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP. � ������� ��������� INSERT
--�������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4.
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
------------- ������� 9 ----------------
--9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
CREATE CLUSTER ABC (
  X NUMBER(10),
  V VARCHAR2(12)
) SIZE 200 HASHKEYS 200;
------------- ������� 10 ----------------
--10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE A (
  XA NUMBER(10),
  VA VARCHAR2(12),
  Y NUMBER(10)
) CLUSTER ABC(XA, VA);
------------- ������� 11 ----------------
--11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE B (
  XB NUMBER(10),
  VB VARCHAR2(12),
  Z NUMBER(10)
) CLUSTER ABC(XB, VB);

INSERT INTO B VALUES (1, '1', 1);
------------- ������� 12 ----------------
--12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������. 
CREATE TABLE C (
  XC NUMBER(10),
  VC VARCHAR2(12),
  W NUMBER(10)
) CLUSTER ABC(XC, VC);

INSERT INTO C VALUES (1, '1', 1);
------------- ������� 13 ----------------
--13.	������� ��������� ������� � ������� � �������������� ������� Oracle.
SELECT TABLE_NAME FROM USER_TABLES;
SELECT CLUSTER_NAME FROM USER_CLUSTERS;

------------- ������� 14 ----------------
--14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
CREATE SYNONYM SC FOR C;
SELECT * FROM C;
SELECT * FROM SC;
DROP SYNONYM SC;
------------- ������� 15 ----------------
CREATE PUBLIC SYNONYM SB_1 FOR B;
SELECT * FROM SB_1;
------------- ������� 16 ----------------
--16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, �������� �������������
--V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������.
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

------------- ������� 17 ----------------
--17.	�� ������ ������ A � B �������� ����������������� ������������� MV,
--������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.
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