alter session set "_ORACLE_SCRIPT"=true; 

CREATE USER vikatest identified by Vika296164039

grant create session to vikatest;
grant create table to vikatest;
grant create procedure to vikatest;
grant create trigger to vikatest;
grant create view to vikatest;
grant create sequence to vikatest;
grant alter any table to vikatest;
grant alter any procedure to vikatest;
grant alter any trigger to vikatest;
grant alter profile to vikatest;
grant delete any table to vikatest;
grant drop any table to vikatest;
grant drop any procedure to vikatest;
grant drop any trigger to vikatest;
grant drop any view to vikatest;
grant drop profile to vikatest;

grant select on sys.v_$session to vikatest;
grant select on sys.v_$sesstat to vikatest;
grant select on sys.v_$statname to vikatest;
grant SELECT ANY DICTIONARY to vikatest;

ALTER USER vikatest QUOTA UNLIMITED ON USERS;
