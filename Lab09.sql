--1. ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������.
alter pluggable database BVA_PDB open;

SELECT * FROM FACULTY;
declare
  faculty_rec FACULTY%ROWTYPE;
BEGIN 
  SELECT * INTO faculty_rec from faculty WHERE faculty = '���';
  DBMS_OUTPUT.PUT_LINE(faculty_rec.FACULTY || ' ' || faculty_rec.FACULTY_NAME);
EXCEPTION
WHEN OTHERS
THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--2. ������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. ����������� ����������� WHEN OTHERS 
--������ ���������� � ���������� ������� SQLERRM, SQLCODE ��� ���������������� �������� �������. 
DECLARE
  v_AUDITORIUM_TYPE     AUDITORIUM_TYPE.AUDITORIUM_TYPE%TYPE;
  v_AUDITORIUM_TYPENAME AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%TYPE;
BEGIN
  SELECT AUDITORIUM_TYPE,
         AUDITORIUM_TYPENAME
  INTO
    v_AUDITORIUM_TYPE,
    v_AUDITORIUM_TYPENAME
  FROM AUDITORIUM_TYPE;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM_TYPE: ' || v_AUDITORIUM_TYPE || ', AUDITORIUM_TYPENAME: ' || v_AUDITORIUM_TYPENAME);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
end;

/
--3. ������������ ��, ��������������� ������ ����������� WHEN TO_MANY_ROWS ������ ���������� ��� ���������������� �������� �������. 
DECLARE
  faculty_rec faculty%rowtype;
BEGIN
  SELECT * INTO faculty_rec FROM faculty;
  dbms_output.put_line(faculty_rec.faculty || '  ' || faculty_rec.faculty_name);
EXCEPTION
WHEN too_many_rows THEN
  dbms_output.put_line('������: ' || SQLCODE || ' ' || sqlerrm );
END;


select * from AUDITORIUM;

--4. ������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND. 
--������������ ��, ��������������� ���������� ��������� �������� �������.

DECLARE
  faculty_rec faculty%rowtype;
BEGIN
  SELECT *INTO faculty_rec FROM faculty WHERE faculty='��';
  dbms_output.put_line(faculty_rec.FACULTY_NAME || faculty_rec.FACULTY);
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('caught: ' || SQLCODE || ' ' || sqlerrm );
END;

--������������ ��, ��������������� ���������� ��������� �������� �������.

DECLARE
    v_FACULTY_NAME faculty.FACULTY_NAME%TYPE; 
    v_FACULTY      faculty.FACULTY%TYPE;     
BEGIN
    
    SELECT FACULTY_NAME, FACULTY
    INTO v_FACULTY_NAME, v_FACULTY
    FROM faculty
    WHERE faculty = '���';

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('��������� �����: ' || SQL%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE('FACULTY_NAME: ' || v_FACULTY_NAME || ', FACULTY: ' || v_FACULTY);
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ �� �������.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ��� ������ ��� �������.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' - ' || SQLERRM);
END;

--5. ������������ ��, ��������������� ���������� ��������� UPDATE ��������� � ����������� COMMIT/ROLLBACK.
select * from AUDITORIUM;
update AUDITORIUM set AUDITORIUM_CAPACITY = 15 where AUDITORIUM = '206-1';

DECLARE
  v_old_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  v_new_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  
  SELECT AUDITORIUM_CAPACITY INTO v_old_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('������� ����������� ��������� 206-1: ' || v_old_capacity);

  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 20
  WHERE AUDITORIUM = '206-1';

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����� ����������� ��������� 206-1: ' || v_new_capacity);

  COMMIT;

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����������� ����������� ��������� 206-1 ����� �������: ' || v_new_capacity);

  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 25
  WHERE AUDITORIUM = '206-1';

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����� ����������� ��������� 206-1: ' || v_new_capacity);

  ROLLBACK;
  
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����������� ��������� 206-1 ����� ������: ' || v_new_capacity);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
    -- ����� ��������� � ������ ������
    ROLLBACK;
END;

--6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
select * from AUDITORIUM;

DECLARE
BEGIN
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = '���������'
  WHERE AUDITORIUM_CAPACITY = 90;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

--7. ������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM = '111-1';

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('111-1', '111-1', 100, '��')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  COMMIT;

  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('112-1', '112-2', 100, '��')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

  ROLLBACK;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;
--8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.

DECLARE
BEGIN
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values ('429-4', '429-4', '��', 90);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

--9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
DECLARE
  v_count_before NUMBER;
  v_count_after NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count_before FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('���������� ������� �� ��������: ' || v_count_before);
  DELETE FROM AUDITORIUM WHERE auditorium_capacity = 100;
  SELECT COUNT(*) INTO v_count_after FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('���������� ������� ����� ��������: ' || v_count_after);
 
  --COMMIT;
  
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('��������� ���� ��������.');
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('��������� ������. ��������� ���� ��������.');
END;

--10. ����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
select * from FACULTY;
DECLARE
BEGIN
delete from FACULTY where FACULTY = '����';
rollback;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

---------------����� �������
--11. �������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. ��������� ������ ������ ���� �������� 
--� ����������, ����������� � ����������� ����� %TYPE.
select * from TEACHER;

DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  FOR i IN c_TEACHER
    LOOP
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      v_PULPIT := i.PULPIT;
      DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                           v_PULPIT);
    END LOOP;
end;

--12. �������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� �WHILE-�����. 
--��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
DECLARE
  v_SUBJECT SUBJECT%ROWTYPE;
  CURSOR c_SUBJECT IS
    SELECT *
    FROM SUBJECT;
BEGIN
  OPEN c_SUBJECT;
  WHILE TRUE
    LOOP
      FETCH c_SUBJECT INTO v_SUBJECT;
      EXIT WHEN c_SUBJECT%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || v_SUBJECT.SUBJECT || ', SUBJECT_NAME: ' || v_SUBJECT.SUBJECT_NAME ||
                           ', PULPIT: ' || v_SUBJECT.PULPIT);
    END LOOP;
end;

--13. �������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER) �����������, 
--���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
DECLARE
  v_PULPIT         PULPIT.PULPIT%TYPE;
  v_PULPIT_NAME    PULPIT.PULPIT_NAME%TYPE;
  v_FACULTY        PULPIT.FACULTY%TYPE;
  v_TEACHER        TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME   TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT_TEACHER PULPIT.PULPIT%TYPE;
  
  CURSOR c_PULPIT_TEACHER IS
    SELECT PULPIT.PULPIT,
           PULPIT.PULPIT_NAME,
           PULPIT.FACULTY,
           TEACHER.TEACHER,
           TEACHER.TEACHER_NAME
    FROM PULPIT
           JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT;
BEGIN
  FOR i IN c_PULPIT_TEACHER
    LOOP
      v_PULPIT := i.PULPIT;
      v_PULPIT_NAME := i.PULPIT_NAME;
      v_FACULTY := i.FACULTY;
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_PULPIT || ', PULPIT_NAME: ' || v_PULPIT_NAME || ', FACULTY: ' || v_FACULTY ||
                           ', TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME);
    END LOOP;
end;

--14. �������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM) 
--� ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

  -- �������� ������ ��� ���� ���������
  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY 
    FROM AUDITORIUM 
    ORDER BY AUDITORIUM_CAPACITY;

  -- ��������� ������ � ����������� ��� ��������� �����������
  CURSOR c_AUDITORIUM_BY_CAPACITY(p_min_capacity IN NUMBER, p_max_capacity IN NUMBER) IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY 
    FROM AUDITORIUM 
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min_capacity AND p_max_capacity
    ORDER BY AUDITORIUM_CAPACITY;

BEGIN
  -- 1. ���� � FETCH
  DBMS_OUTPUT.PUT_LINE('--- ���� � FETCH ---');
  DBMS_OUTPUT.PUT_LINE('--- ��������� �� 20 ---');
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;

    IF v_AUDITORIUM_CAPACITY < 20 THEN
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', NAME: ' || v_AUDITORIUM_NAME || ', CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;
  END LOOP;
  CLOSE c_AUDITORIUM;

  -- 2. ���� FOR
  DBMS_OUTPUT.PUT_LINE('--- ���� FOR ---');
  DBMS_OUTPUT.PUT_LINE('--- ��������� �� 21 �� 30 ---');
  FOR rec IN c_AUDITORIUM LOOP
    IF rec.AUDITORIUM_CAPACITY >= 21 AND rec.AUDITORIUM_CAPACITY <= 30 THEN
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
    END IF;
  END LOOP;

  -- 3. ������������� ������� � �����������
  DBMS_OUTPUT.PUT_LINE('--- ������ 3: ������ � ����������� ---');

  -- ���������� ������ � ����������� ��� ��������� 31-60
  DBMS_OUTPUT.PUT_LINE('--- ��������� �� 31 �� 60 ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(31, 60) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- ��������� �� 61 �� 80 ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(61, 80) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- ��������� 81 � ���� ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(81, 9999) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

END;

--15. �������� A�. �������� ��������� ���������� � ������� ���������� ���� refcursor.
-- ��������� ���������� � ������ ������ �� ������ ������� ���������� �� ���������
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  c_AUDITORIUM          SYS_REFCURSOR;
BEGIN
  OPEN c_AUDITORIUM FOR
    SELECT AUDITORIUM,
           AUDITORIUM_NAME,
           AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE = '��';

  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                         ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

--16. �������� A�. ����������������� ������� ��������� ���������?

DECLARE
   CURSOR task IS
      SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
      FROM AUDITORIUM
      WHERE AUDITORIUM_TYPE = (
         SELECT AUDITORIUM_TYPE
         FROM AUDITORIUM
         WHERE AUDITORIUM_NAME = '429-4'
      );
   auditorium_id AUDITORIUM.AUDITORIUM%TYPE;
   auditorium_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
   auditorium_type AUDITORIUM.AUDITORIUM_TYPE%TYPE;
   auditorium_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
   OPEN task;
   LOOP
      FETCH task INTO auditorium_id, auditorium_name, auditorium_type, auditorium_capacity;
      EXIT WHEN task%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(
         '���������: ' || auditorium_id ||
         ', ��������: ' || auditorium_name ||
         ', ���: ' || auditorium_type ||
         ', �����������: ' || auditorium_capacity
      );
   END LOOP;
   CLOSE task;
END;

--17. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%. 
--���� FOR, ����������� UPDATE CURRENT OF. 
--UPDATE CURRENT OF � PL/SQL ������������ ��� ���������� ������, �� ������� ��������� ������ � ������ ������.
select * from AUDITORIUM;
rollback;

DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT *
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 40
      and AUDITORIUM_CAPACITY <= 80
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE CURRENT OF c_AUDITORIUM;
    END LOOP;
end;

--18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF.

select * from AUDITORIUM;
rollback;

DECLARE
  v_AUDITORIUM AUDITORIUM.AUDITORIUM%TYPE;
  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DELETE
    FROM AUDITORIUM
    WHERE CURRENT OF c_AUDITORIUM;
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

--19. �������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
SELECT * FROM AUDITORIUM;
ROLLBACK;

DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT ROWID
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE ROWID = i.ROWID;
      DELETE
      FROM AUDITORIUM
      WHERE ROWID = i.ROWID;
    END LOOP;
end;
--20. ������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 


DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  OPEN c_TEACHER;
  LOOP
    FETCH c_TEACHER INTO v_TEACHER, v_TEACHER_NAME, v_PULPIT;
    EXIT WHEN c_TEACHER%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                         v_PULPIT);
    IF MOD(c_TEACHER%ROWCOUNT, 3) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('-----------------');
    END IF;
  END LOOP;

  CLOSE c_TEACHER;
end;
