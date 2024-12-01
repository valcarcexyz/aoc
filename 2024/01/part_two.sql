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

select
    sum(
        location_id_1 * (
            select count(1)
            from input
            where location_id_2 = i1.location_id_1
        )
    )
from input i1;
