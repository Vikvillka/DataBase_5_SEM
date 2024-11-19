--1.	–азработайте пакет выполнени€ заданий, в котором:
alter pluggable database BVA_PDB open;
alter session set container = BVA_PDB;

drop table LAB_14;
drop table LAB_14_TO;
drop table job_status;

create table LAB_14
(
    a number,
    b number
);
create table LAB_14_TO
(
    a number,
    b number
);

create table job_status
(
    status        nvarchar2(50),
    error_message nvarchar2(500),
    datetime      date default sysdate
);

insert into LAB_14 values (1, 24);
insert into LAB_14 values (3, 21);
insert into LAB_14 values (6, 18);
insert into LAB_14 values (9, 15);
insert into LAB_14 values (12, 12);
insert into LAB_14 values (15, 9);
insert into LAB_14 values (18, 6);
insert into LAB_14 values (21, 3);
insert into LAB_14 values (24, 1);
commit;
select * from LAB_14;
--2.	–аз в неделю в определенное врем€ выполн€етс€ копирование части данных по условию из одной таблицы в другую, после чего эти данные из первой таблицы удал€ютс€. 
drop procedure job_procedure;
create or replace procedure job_procedure
is
    cursor job_cursor is
    select * from LAB_14;

    err_message varchar2(500);
begin
    for m in job_cursor
    loop
        insert into LAB_14_TO values (m.a, m.b);
    end loop;

    delete from LAB_14;
    insert into job_status (status, datetime) values ('SUCCESS', sysdate);
    commit;
    exception
      when others then
          err_message := sqlerrm;
          insert into job_status (status, error_message) values ('FAILURE', err_message);
          commit;
end job_procedure;


declare job_number user_jobs.job%type;
begin
  dbms_job.submit(job_number, 'BEGIN job_procedure(); END;', sysdate, 'sysdate + 7');
  commit;
  dbms_output.put_line(job_number);
end;

select * from JOB_STATUS;

--- задание под номером 21 удалила следущее через 7 дней
--3.	Ќеобходимо провер€ть, было ли выполнено задание, и в какой-либо таблице сохран€ть сведени€ о попытках выполнени€, как успешных, так и неуспешных.
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;
--4.	Ќеобходимо провер€ть, выполн€етс€ ли сейчас это задание.

--5.	Ќеобходимо дать возможность выполн€ть задание в другое врем€, приостановить или отменить вообще.

begin
  dbms_job.run(21);
end;

begin
  dbms_job.remove(21);
end;

select * from JOB_STATUS;

--ѕакет DBMS_SHEDULER

--6.	–азработайте пакет, функционально аналогичный пакету из задани€ 1-5. »спользуйте пакет DBMS_SHEDULER. 
begin
dbms_scheduler.create_schedule(
  schedule_name => 'SCH_1',
  start_date => sysdate,
  repeat_interval => 'FREQ=WEEKLY',
  comments => 'SCH_1 WEEKLY starts now'
);
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
  program_name => 'PROGRAM_1',
  program_type => 'STORED_PROCEDURE',
  program_action => 'job_procedure',
  number_of_arguments => 0,
  enabled => true,
  comments => 'PROGRAM_1'
);
end;

select * from user_scheduler_programs;


begin
    dbms_scheduler.create_job(
            job_name => 'JOB_1',
            program_name => 'PROGRAM_1',
            schedule_name => 'SCH_1',
            enabled => true
        );
end;

select * from user_scheduler_jobs;

begin
  DBMS_SCHEDULER.DISABLE('JOB_1');
end;

begin
    DBMS_SCHEDULER.RUN_JOB('JOB_1');
end;

begin
  DBMS_SCHEDULER.DROP_JOB( JOB_NAME => 'JOB_1');
end;