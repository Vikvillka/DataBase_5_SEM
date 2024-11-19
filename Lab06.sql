GRANT SET CONTAINER TO SYSTEM;
GRANT SET CONTAINER TO SYSTEM;

SELECT * FROM USER_SYS_PRIVS;

SELECT * FROM USER_ROLE_PRIVS;

GRANT BVA_PDB_RL TO SYSTEM;

grant 
    connect, 
    create session,
    restricted session, 
    alter session, 
    create any table,
    alter any table,
    drop any table,
    SYSDBA
to C##BVA container = all;

GRANT UNLIMITED TABLESPACE TO C##BVA;

ALTER USER C##BVA QUOTA UNLIMITED ON USERS;


alter session set container = BVA_PDB;
alter pluggable database BVA_PDB open;


-- 10
select * from dba_segments where owner LIKE '%C##BVA%';

-- 11
create or replace view segment_summary as
select
    owner,
    segment_type,
    count(*) as segment_count,
    sum(extents) as total_extents,
    sum(blocks) as total_blocks,
    sum(bytes) / 1024 as total_size_kb
from
    dba_segments
group by
    owner,
    segment_type;
    
select * from segment_summary;