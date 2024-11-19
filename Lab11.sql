alter pluggable database BVA_PDB open;

-- 1. ������������ ��������� ��������� GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), 
-- ���������� �� ������� �������� ����� � ���������. 

select  * from teacher;

DECLARE
    PROCEDURE GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE) IS
    BEGIN
        FOR i IN (SELECT * FROM TEACHER WHERE PULPIT = PCODE) LOOP
            DBMS_OUTPUT.PUT_LINE(i.TEACHER_NAME);
        END LOOP;
    END GET_TEACHERS;

BEGIN
    GET_TEACHERS('����');
END;

-- 2-3. ������������ ��������� ������� GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, 
-- ���������� �� ������� �������� ����� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

DECLARE
    FUNCTION GET_NUM_TEACHERS(
        PCODE TEACHER.PULPIT%TYPE)
      RETURN NUMBER IS
        num NUMBER;
    BEGIN
        SELECT COUNT(*) INTO num FROM TEACHER WHERE PULPIT = PCODE;
        RETURN num;
    END GET_NUM_TEACHERS;

BEGIN
   
    DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
END;
-- 4. ������������ ���������:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), 
-- ���������� �� ����������, �������� ����� � ���������.

-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- ��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������,
-- �������� ����� ������� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

create or replace procedure GET_TEACHERS_2(FCODE FACULTY.FACULTY%TYPE) is
begin
  for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
    loop
      dbms_output.put_line(i.TEACHER_NAME);
    end loop;
end;

begin
  GET_TEACHERS_2('����');
end;

create or replace procedure GET_SUBJECTS_2(PCODE SUBJECT.PULPIT%TYPE) is
begin
  for i in (select * from SUBJECT where PULPIT = PCODE)
    loop
      dbms_output.put_line(i.SUBJECT_NAME);
    end loop;
end;

begin
  GET_SUBJECTS_2('����');
end;


-- 4. ������������ ��������� �������
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, ����������
-- �� ����������, �������� ����� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

declare
  FUNCTION GET_NUM_TEACHERS_2(
      FCODE FACULTY.FACULTY%TYPE)
    RETURN NUMBER
  IS
    num NUMBER;
  BEGIN
    SELECT COUNT(*) INTO num FROM TEACHER  where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
    RETURN num;
  END GET_NUM_TEACHERS_2;

begin
  dbms_output.put_line(GET_NUM_TEACHERS_2('���'));
end;

-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
-- ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, 
-- �������� ����� ������� ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

select * from SUBJECT;

create or replace function GET_NUM_SUBJECTS_2(PCODE SUBJECT.PULPIT%TYPE) return number
is
  num number;
begin
  select count(*) into num from SUBJECT where PULPIT = PCODE;
  return num;
end;

begin
  dbms_output.put_line(GET_NUM_SUBJECTS_2('����'));
end;

-- 5. ������������ ����� TEACHERS, ���������� ��������� � �������:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER

create or replace package TEACHERS is
  procedure GET_TEACHERS_2(FCODE FACULTY.FACULTY%TYPE);
  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  function GET_NUM_TEACHERS_2(FCODE FACULTY.FACULTY%TYPE) return number;
  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number;
end TEACHERS;

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE' AND OBJECT_NAME = 'TEACHERS';

create or replace package body TEACHERS is
  procedure GET_TEACHERS_2(FCODE FACULTY.FACULTY%TYPE) is
  begin
    for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
      loop
        dbms_output.put_line(i.TEACHER_NAME);
      end loop;
  end;

  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is
  begin
    for i in (select * from SUBJECT where PULPIT = PCODE)
      loop
        dbms_output.put_line(i.SUBJECT_NAME);
      end loop;
  end;

  function GET_NUM_TEACHERS_2(FCODE FACULTY.FACULTY%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
    return num;
  end;

  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from SUBJECT where PULPIT = PCODE;
    return num;
  end;
end TEACHERS;

begin
dbms_output.put_line('����� (Task6)');
  TEACHERS.GET_TEACHERS_2('����');
  dbms_output.put_line('========');
  TEACHERS.GET_SUBJECTS('����');
  dbms_output.put_line('========');
  dbms_output.put_line(TEACHERS.GET_NUM_TEACHERS_2('���'));
  dbms_output.put_line('========');
  dbms_output.put_line(TEACHERS.GET_NUM_SUBJECTS('����'));
end;