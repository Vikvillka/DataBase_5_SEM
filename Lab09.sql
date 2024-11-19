--1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой.
alter pluggable database BVA_PDB open;

SELECT * FROM FACULTY;
declare
  faculty_rec FACULTY%ROWTYPE;
BEGIN 
  SELECT * INTO faculty_rec from faculty WHERE faculty = 'ЛХФ';
  DBMS_OUTPUT.PUT_LINE(faculty_rec.FACULTY || ' ' || faculty_rec.FACULTY_NAME);
EXCEPTION
WHEN OTHERS
THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

--2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой. Используйте конструкцию WHEN OTHERS 
--секции исключений и встроенную функции SQLERRM, SQLCODE для диагностирования неточной выборки. 
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
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

/
--3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS секции исключений для диагностирования неточной выборки. 
DECLARE
  faculty_rec faculty%rowtype;
BEGIN
  SELECT * INTO faculty_rec FROM faculty;
  dbms_output.put_line(faculty_rec.faculty || '  ' || faculty_rec.faculty_name);
EXCEPTION
WHEN too_many_rows THEN
  dbms_output.put_line('Ошибка: ' || SQLCODE || ' ' || sqlerrm );
END;


select * from AUDITORIUM;

--4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND. 
--Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.

DECLARE
  faculty_rec faculty%rowtype;
BEGIN
  SELECT *INTO faculty_rec FROM faculty WHERE faculty='ЛХ';
  dbms_output.put_line(faculty_rec.FACULTY_NAME || faculty_rec.FACULTY);
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('caught: ' || SQLCODE || ' ' || sqlerrm );
END;

--Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.

DECLARE
    v_FACULTY_NAME faculty.FACULTY_NAME%TYPE; 
    v_FACULTY      faculty.FACULTY%TYPE;     
BEGIN
    
    SELECT FACULTY_NAME, FACULTY
    INTO v_FACULTY_NAME, v_FACULTY
    FROM faculty
    WHERE faculty = 'ЛХФ';

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Затронуто строк: ' || SQL%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE('FACULTY_NAME: ' || v_FACULTY_NAME || ', FACULTY: ' || v_FACULTY);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Запись не найдена.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Нет данных для выборки.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' - ' || SQLERRM);
END;

--5. Разработайте АБ, демонстрирующий применение оператора UPDATE совместно с операторами COMMIT/ROLLBACK.
select * from AUDITORIUM;
update AUDITORIUM set AUDITORIUM_CAPACITY = 15 where AUDITORIUM = '206-1';

DECLARE
  v_old_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  v_new_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  
  SELECT AUDITORIUM_CAPACITY INTO v_old_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Текущая вместимость аудитории 206-1: ' || v_old_capacity);

  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 20
  WHERE AUDITORIUM = '206-1';

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Новая вместимость аудитории 206-1: ' || v_new_capacity);

  COMMIT;

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Обновленная вместимость аудитории 206-1 после коммита: ' || v_new_capacity);

  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 25
  WHERE AUDITORIUM = '206-1';

  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Новая вместимость аудитории 206-1: ' || v_new_capacity);

  ROLLBACK;
  
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Вместимость аудитории 206-1 после отката: ' || v_new_capacity);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
    -- откат изменений в случае ошибки
    ROLLBACK;
END;

--6. Продемонстрируйте оператор UPDATE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.
select * from AUDITORIUM;

DECLARE
BEGIN
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 'Аудитория'
  WHERE AUDITORIUM_CAPACITY = 90;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

--7. Разработайте АБ, демонстрирующий применение оператора INSERT совместно с операторами COMMIT/ROLLBACK.
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM = '111-1';

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('111-1', '111-1', 100, 'ЛК')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  COMMIT;

  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('112-1', '112-2', 100, 'ЛК')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

  ROLLBACK;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;
--8. Продемонстрируйте оператор INSERT, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.

DECLARE
BEGIN
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values ('429-4', '429-4', 'ЛК', 90);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

--9. Разработайте АБ, демонстрирующий применение оператора DELETE совместно с операторами COMMIT/ROLLBACK.
DECLARE
  v_count_before NUMBER;
  v_count_after NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count_before FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('Количество записей до удаления: ' || v_count_before);
  DELETE FROM AUDITORIUM WHERE auditorium_capacity = 100;
  SELECT COUNT(*) INTO v_count_after FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('Количество записей после удаления: ' || v_count_after);
 
  --COMMIT;
  
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('Изменения были откачены.');
  
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка. Изменения были отменены.');
END;

--10. Продемонстрируйте оператор DELETE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.
select * from FACULTY;
DECLARE
BEGIN
delete from FACULTY where FACULTY = 'ТТЛП';
rollback;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

---------------Явные курсоры
--11. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением явного курсора LOOP-цикла. Считанные данные должны быть записаны 
--в переменные, объявленные с применением опции %TYPE.
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

--12. Создайте АБ, распечатывающий таблицу SUBJECT с применением явного курсора иWHILE-цикла. 
--Считанные данные должны быть записаны в запись (RECORD), объявленную с применением опции %ROWTYPE.
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

--13. Создайте АБ, распечатывающий все кафедры (таблица PULPIT) и фамилии всех преподавателей (TEACHER) использовав, 
--соединение (JOIN) PULPIT и TEACHER и с применением явного курсора и FOR-цикла.
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

--14. Создайте АБ, распечатывающий следующие списки аудиторий: все аудитории (таблица AUDITORIUM) 
--с вместимостью меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше. Примените курсор с параметрами и три способа организации цикла по строкам курсора.

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;

  -- Основной курсор для всех аудиторий
  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY 
    FROM AUDITORIUM 
    ORDER BY AUDITORIUM_CAPACITY;

  -- Объявляем курсор с параметрами для диапазона вместимости
  CURSOR c_AUDITORIUM_BY_CAPACITY(p_min_capacity IN NUMBER, p_max_capacity IN NUMBER) IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY 
    FROM AUDITORIUM 
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min_capacity AND p_max_capacity
    ORDER BY AUDITORIUM_CAPACITY;

BEGIN
  -- 1. Цикл с FETCH
  DBMS_OUTPUT.PUT_LINE('--- Цикл с FETCH ---');
  DBMS_OUTPUT.PUT_LINE('--- Аудитории до 20 ---');
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;

    IF v_AUDITORIUM_CAPACITY < 20 THEN
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', NAME: ' || v_AUDITORIUM_NAME || ', CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;
  END LOOP;
  CLOSE c_AUDITORIUM;

  -- 2. Цикл FOR
  DBMS_OUTPUT.PUT_LINE('--- Цикл FOR ---');
  DBMS_OUTPUT.PUT_LINE('--- Аудитории от 21 до 30 ---');
  FOR rec IN c_AUDITORIUM LOOP
    IF rec.AUDITORIUM_CAPACITY >= 21 AND rec.AUDITORIUM_CAPACITY <= 30 THEN
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
    END IF;
  END LOOP;

  -- 3. Использование курсора с параметрами
  DBMS_OUTPUT.PUT_LINE('--- Способ 3: Курсор с параметрами ---');

  -- Используем курсор с параметрами для диапазона 31-60
  DBMS_OUTPUT.PUT_LINE('--- Аудитории от 31 до 60 ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(31, 60) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Аудитории от 61 до 80 ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(61, 80) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Аудитории 81 и выше ---');
  FOR rec IN c_AUDITORIUM_BY_CAPACITY(81, 9999) LOOP
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || rec.AUDITORIUM || ', NAME: ' || rec.AUDITORIUM_NAME || ', CAPACITY: ' || rec.AUDITORIUM_CAPACITY);
  END LOOP;

END;

--15. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor.
-- позволяет обращаться к набору данных не требуя заранее определять их структуру
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
    WHERE AUDITORIUM_TYPE = 'ЛК';

  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                         ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

--16. Создайте AБ. Продемонстрируйте понятие курсорный подзапрос?

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
         'Аудитория: ' || auditorium_id ||
         ', Название: ' || auditorium_name ||
         ', Тип: ' || auditorium_type ||
         ', Вместимость: ' || auditorium_capacity
      );
   END LOOP;
   CLOSE task;
END;

--17. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM) вместимостью от 40 до 80 на 10%. 
--цикл FOR, конструкцию UPDATE CURRENT OF. 
--UPDATE CURRENT OF в PL/SQL используется для обновления строки, на которую указывает курсор в данный момент.
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

--18. Создайте AБ. Удалите все аудитории (таблица AUDITORIUM) вместимостью от 0 до 20. Используйте явный курсор с параметрами, цикл WHILE, конструкцию UPDATE CURRENT OF.

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

--19. Создайте AБ. Продемонстрируйте применение псевдостолбца ROWID в операторах UPDATE и DELETE. 
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
--20. Распечатайте в одном цикле всех преподавателей (TEACHER), разделив группами по три (отделите группы линией -------------). 


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
