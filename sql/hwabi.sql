create database hwabi;

create table if not exists accounts (
    id              serial primary key,
    username        varchar(13) not null unique,
    password_hash   varchar(255) not null,

    gender          smallint not null default 0,
    gm_level        smallint not null default 0,
    banned          boolean not null default false,

    created_at      timestamp not null default now(),
    last_login_at   timestamp,
    updated_at      timestamp not null default now()
);