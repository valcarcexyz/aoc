create table if not exists dirty_input (
    raw_input text
);

create table if not exists input (
    location_id_1 integer
    , location_id_2 integer 
);


create trigger if not exists trigger_clean_input
after insert on dirty_input
for each row
begin 
    insert into input(location_id_1, location_id_2)
    values (
        substr(new.raw_input, 1 , instr(new.raw_input, '   ') -1),
        substr(new.raw_input, instr(new.raw_input, '   ') + 1)
    );
end;

.import input dirty_input
.output stdout

with data as (
    select
        location_id_1, row_number() over (order by location_id_1) r1,
        location_id_2, row_number() over (order by location_id_2) r2
    from input
)
select sum(abs(d2.location_id_2 - d1.location_id_1)) as solution
from
    data d1
    inner join
    data d2
    on d1.r1 = d2.r2;
