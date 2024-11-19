CREATE TABLE BVA_t
  (x NUMBER(3), s VARCHAR2(50)
  );
  
INSERT INTO bva_t
  (x,s
  ) VALUES
  (22,'hello'
  );
INSERT INTO bva_t
  (x,s
  ) VALUES
  (23,'hello1'
  );
INSERT INTO bva_t
  (x,s
  ) VALUES
  (24,'hello2'
  );

insert all
into bva_t (x,s) values(1, 'first')
into bva_t (x,s) values(2, 'second')
into bva_t (x,s) values(3, 'third')
select * from dual;
commit;
  
select * from bva_t;

update bva_t set s='helloWorld' where x =22; 
update bva_t set s='helloWorld1' where x =23; 
commit;

select * from bva_t 
where s like '%o%'; 

SELECT count(*) FROM bva_t; 

select * from bva_t
where x = (select max(x) from bva_t);

delete from bva_t where x = 24; 
commit;

CREATE TABLE bva_t_second
  (
    id NUMBER(10) NOT NULL,
    x  NUMBER(3) NOT NULL,
    y  VARCHAR(50) NOT NULL,
    constraint bva_pk primary key (id),
    FOREIGN KEY (x) REFERENCES bva_t(x)
  );
  
alter table bva_t add constraint bva_t_pk primary key(x);

select * from bva_t_second;

insert into bva_t_second(id,x,y) values(1,22,'word');
insert into bva_t_second(id,x,y) values(2,23,'word1');

select * from bva_t inner join bva_t_second on bva_t.x = bva_t_second.id;
select * from bva_t left outer join bva_t_second on bva_t.x = bva_t_second.id;
select * from bva_t right outer join bva_t_second on bva_t.x = bva_t_second.id;

commit;
