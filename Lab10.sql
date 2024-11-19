--1. �������� � ������� TEACHERS ��� ������� BIRTHDAY� SALARY, ��������� �� ����������.
   
ALTER TABLE TEACHER
ADD (BIRTHDAY DATE, SALARY NUMBER);

UPDATE TEACHER
SET BIRTHDAY = TRUNC(SYSDATE) - FLOOR(DBMS_RANDOM.VALUE(365*63, 365*23)),
    SALARY = FLOOR(DBMS_RANDOM.VALUE(1000, 4000));


ALTER TABLE TEACHER
DROP COLUMN BIRTHDAY;

ALTER TABLE TEACHER
DROP COLUMN SALARY;

  
select * from TEACHER;

--2. �������� ������ �������������� � ���� ������� �.�.

CREATE OR REPLACE FUNCTION GET_FIO(TEACHER_NAME VARCHAR2)
    RETURN VARCHAR2
IS
    FIO VARCHAR2(200);
BEGIN
    FIO := SUBSTR(TEACHER_NAME, 1, INSTR(TEACHER_NAME, ' ')) ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ') + 1, 1) || '.' ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ', 1, 2) + 1, 1) || '.';

    RETURN FIO;
END;

select GET_FIO(TEACHER_NAME) from TEACHER;

--3. �������� ������ ��������������, ���������� � �����������.
SELECT TEACHER_NAME, BIRTHDAY FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'D') = '1';

--4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.
create view TEACHERS_NEXT_MONTH as
select TEACHER_NAME as TEACHER_NAME, -- ���������� ������� � ���
       to_char(BIRTHDAY, 'DD.MM.YYYY')   as BIRTHDAY
from teacher
where to_char(BIRTHDAY, 'MM') = to_char(sysdate, 'MM') + 1;

--drop view TEACHERS_NEXT_MONTH;
select * from TEACHERS_NEXT_MONTH;
--5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.
CREATE VIEW teachers_by_month AS
SELECT 
    TO_CHAR(BIRTHDAY, 'MM') AS month,  
    COUNT(*) AS teacher_count           
FROM 
    TEACHER
GROUP BY 
    TO_CHAR(BIRTHDAY, 'MM')            
ORDER BY 
    month;  
  
SELECT * FROM teachers_by_month;
--6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
declare
  cursor c1 is
    select TEACHER_NAME as teacher_name,
           to_char(BIRTHDAY, 'DD.MM.YYYY')   as birthday
    from TEACHER
    where MOD((to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(BIRTHDAY, 'YYYY')) + 1), 5) = 0;
begin
  for i in c1
    loop
      dbms_output.put_line(i.teacher_name || ' ' || i.birthday);
    end loop;
end;

--7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, ������� ������� �������� ��������
--��� ������� ���������� � ��� ���� ����������� � �����.
INSERT INTO FACULTY VALUES('����','�������������� ������� � ����������');

select * from TEACHER;
select * from FACULTY;
SELECT * FROM PULPIT;

DECLARE
  CURSOR c_average_salary IS
    SELECT P.PULPIT AS PULPIT_NAME, AVG(T.SALARY) AS AVERAGE_SALARY
    FROM TEACHER T
    INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
    GROUP BY P.PULPIT;

  CURSOR c_faculty_average IS
    SELECT P.FACULTY, AVG(T.SALARY) AS AVERAGE_SALARY
    FROM TEACHER T
    INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
    GROUP BY P.FACULTY;

  v_pulpit_name CHAR(20);
  v_average_salary NUMBER; -- ������� �� �������
  v_total_average_salary NUMBER := 0;
  v_count_pulpits NUMBER := 0; -- ���������� ������
  
  v_faculty_name CHAR(20);
  v_faculty_average_salary NUMBER; -- ������� �� ����������
  v_total_faculty_average_salary NUMBER := 0; -- ����� ������� �� ���� �����������
  v_count_faculties NUMBER := 0; -- ���������� �����������
BEGIN
  -- ������� ������� �������� �� ��������
  OPEN c_average_salary;
  
  DBMS_OUTPUT.PUT_LINE('Average Salary by Pulpit:');
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  
  LOOP
    FETCH c_average_salary INTO v_pulpit_name, v_average_salary;
    EXIT WHEN c_average_salary%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Pulpit: ' || v_pulpit_name || ', Average Salary: ' || FLOOR(v_average_salary));
    
    v_total_average_salary := v_total_average_salary + v_average_salary;
    v_count_pulpits := v_count_pulpits + 1;
  END LOOP;
  
  CLOSE c_average_salary;
  
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  IF v_count_pulpits > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Total Average Salary for all Pulpits: ' || FLOOR(v_total_average_salary / v_count_pulpits));
  ELSE
    DBMS_OUTPUT.PUT_LINE('No Pulpits available.');
  END IF;

  -- ������� ������� �������� �� �����������
  OPEN c_faculty_average;
  
  DBMS_OUTPUT.PUT_LINE('Average Salary by Faculty:');
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  
  LOOP
    FETCH c_faculty_average INTO v_faculty_name, v_faculty_average_salary;
    EXIT WHEN c_faculty_average%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Faculty: ' || v_faculty_name || ', Average Salary: ' || FLOOR(v_faculty_average_salary));
    
    v_total_faculty_average_salary := v_total_faculty_average_salary + v_faculty_average_salary;
    v_count_faculties := v_count_faculties + 1;
  END LOOP;
  
  CLOSE c_faculty_average;

  DBMS_OUTPUT.PUT_LINE('-------------------------');
  IF v_count_faculties > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Total Average Salary for all Faculties: ' || FLOOR(v_total_faculty_average_salary / v_count_faculties));
  ELSE
    DBMS_OUTPUT.PUT_LINE('No Faculties available.');
  END IF;
END;

SELECT * FROM FACULTY;
SELECT * FROM PULPIT;
--8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. ����������������� ������ � ���������� ��������.
--����������������� � ��������� �������� ����������. 

DECLARE

    TYPE StudentRecord IS RECORD (
        student_id NUMBER,
        student_name VARCHAR2(100)
    );

    TYPE CourseRecord IS RECORD (
        course_id NUMBER,
        course_name VARCHAR2(100)
    );

    TYPE EnrollmentRecord IS RECORD (
        student_info StudentRecord,
        course_info CourseRecord
    );

    enrollment EnrollmentRecord;

BEGIN
    enrollment.student_info.student_id := 1;
    enrollment.student_info.student_name := '���� ������';
    enrollment.course_info.course_id := 101;
    enrollment.course_info.course_name := 'PL/SQL';

    DBMS_OUTPUT.PUT_LINE('�������: ' || enrollment.student_info.student_name);
    DBMS_OUTPUT.PUT_LINE('����: ' || enrollment.course_info.course_name);
    
    -- �������� ����������
    DECLARE
        another_enrollment EnrollmentRecord;
    BEGIN
        another_enrollment := enrollment; -- k���������� ������

        another_enrollment.student_info.student_name := '���� ������';

        DBMS_OUTPUT.PUT_LINE('������ �������: ' || another_enrollment.student_info.student_name);
    END;

END;
