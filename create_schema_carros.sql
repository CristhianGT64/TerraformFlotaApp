create schema coffee

create table coffe.types (
    id serial primary key,
    name varchar(100) not null,
    description text
);