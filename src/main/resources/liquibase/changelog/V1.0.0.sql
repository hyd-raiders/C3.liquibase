--liquibase formatted sql

--changeset xyliu:1
insert into test1 (id, name) values (8, 'name 8');

--rollback
delete  from test1 where id =8;

--changeset xyliu:13
insert into test1 (id, name) values (8, 'name 8');

--rollback
delete  from test1 where id =8;

--changeset xyliu:16
insert into test1 (id, name) values (16, 'name 16');

--rollback
delete  from test1 where id =16;

--changeset xyliu:17
insert into test1 (id, name) values (17, 'name 17');

--rollback delete  from test1 where id =17;

--changeset xyliu:18
insert into test1 (id, name) values (18, 'name 18');

--rollback delete  from test1 where id =18;
