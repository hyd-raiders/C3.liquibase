--liquibase formatted sql

--changeset yourname:3
insert into test1 (id, name) values (3, 'name 3');
insert into test1 (id, name) values (4, 'name 4');

--changeset yourname:5
insert into test1 (id, name) values (6, 'name 6');
insert into test1 (id, name) values (7, 'name 7');