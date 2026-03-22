USE master
GO

/*Drop/Create Database */
drop database if exists g6_pokedex
go
create database g6_pokedex
go
use g6_pokedex
go

--FKs Down--
if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_generation_caught_in_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_generation_caught_in_id
GO

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_base_stat_pokemon_pokedex_id') 
	alter table pokemon_base_stats drop CONSTRAINT fk_pokemon_base_stat_pokemon_pokedex_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_type_type_id') 
	alter table pokemon_types drop CONSTRAINT fk_pokemon_type_type_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_user_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_user_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_base_stats_pokemon_base_stat_base_stat_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_base_stats_pokemon_base_stat_base_stat_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_type_pokemon_pokedex_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_type_pokemon_pokedex_id
GO

/*Drop Tables*/
drop table if exists pokemon
drop table if exists generations_caught_in
drop table if exists users
drop table if exists pokemon_base_stats
drop table if exists base_stats
drop table if exists pokemon_types
drop table if exists types
GO

/*Create Tables */
CREATE TABLE pokemon (
pokemon_pokedex_id int not null,
pokemon_name varchar(50) not null,
pokemon_height decimal(10,2) null,
pokemon_weight decimal(10,2) null,
pokemon_evolve_level int null,
pokemon_rarity varchar(20) null,
pokemon_caught char(1) not null,
pokemon_watch_list char(1) null,
pokemon_generation_caught_in_id int not null,
pokemon_user_id int null,
constraint pk_pokemon_pokedex_id PRIMARY KEY (pokemon_pokedex_id),
)
GO

CREATE TABLE generations_caught_in (
generation_caught_in_id int IDENTITY not null,
generation_caught_in_game_title varchar(50) not null,
generation_caught_in_game_release_date date not null,
generation_caught_in_game_release_price money null,
constraint pk_generations_generation_caught_in_id PRIMARY KEY (generation_caught_in_id),
constraint u_generations_generation_caught_in_game_title UNIQUE (generation_caught_in_game_title),
)
GO

CREATE TABLE users (
user_id int IDENTITY not null,
user_email varchar(50) not null,
user_firstname varchar(50) not null,
user_lastname varchar(50) not null,
user_first_game varchar(50) null,
constraint pk_users_user_id PRIMARY KEY (user_id),
constraint u_users_user_email UNIQUE (user_email),
)
GO

CREATE TABLE pokemon_base_stats (
pokemon_base_stat_id int IDENTITY not null,
pokemon_base_stat_pokemon_pokedex_id int not null,
pokemon_base_stats_base_stat_id int not null,
constraint pk_pokemon_base_stat_id PRIMARY KEY (pokemon_base_stat_id),
)
GO

CREATE TABLE base_stats (
base_stat_id int IDENTITY not null,
base_stat_hp int not null,
base_stat_speed int not null,
base_stat_phsyical_attack int not null,
base_stat_phsyical_defense int not null,
base_stat_special_attack int not null,
base_stat_special_defense int not null,
base_stat_capture_rate int not null,
constraint pk_pokemon_base_stats_base_stat_id PRIMARY KEY (base_stat_id),
)
GO


CREATE TABLE pokemon_types (
pokemon_type_id int IDENTITY not null,
pokemon_type_pokemon_pokedex_id int not null,
pokemon_type_type_id int not null,
constraint pk_pokemon_types_pokemon_type_id PRIMARY KEY (pokemon_type_id),
)
GO

CREATE TABLE types (
type_id int IDENTITY not null,
type_name varchar(50) not null,
type_rarity_rank int not null,
type_supereffective_against varchar(50) null,
type_weak_agaianst varchar(50) null,
constraint pk_types_type_id PRIMARY KEY (type_id),
)
GO




/* FKs for Pokemon Table*/
--Up--
ALTER TABLE pokemon
add constraint fk_pokemon_generation_caught_in_id FOREIGN KEY (pokemon_generation_caught_in_id)
REFERENCES generations_caught_in (generation_caught_in_id),
constraint fk_pokemon_user_id FOREIGN KEY (pokemon_user_id)
REFERENCES users(user_id)
GO

ALTER TABLE pokemon_base_stats
add constraint fk_pokemon_base_stat_pokemon_pokedex_id FOREIGN KEY (pokemon_base_stat_pokemon_pokedex_id)
REFERENCES pokemon(pokemon_pokedex_id)
GO

ALTER TABLE pokemon_base_stats
add constraint fk_pokemon_base_stats_pokemon_base_stat_base_stat_id FOREIGN KEY (pokemon_base_stats_base_stat_id)
REFERENCES base_stats (base_stat_id)
GO

ALTER TABLE pokemon_types
add constraint fk_pokemon_type_type_id FOREIGN KEY (pokemon_type_type_id)
REFERENCES types(type_id)
GO

ALTER TABLE pokemon_types
add constraint fk_pokemon_type_pokemon_pokedex_id FOREIGN KEY (pokemon_type_pokemon_pokedex_id)
REFERENCES pokemon(pokemon_pokedex_id)
GO

/* Check Tables
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES */

/* Insert into generations_caught_in table*/
insert into generations_caught_in (
	generation_caught_in_game_title, 
	generation_caught_in_game_release_date, 
	generation_caught_in_game_release_price)
values 
	('Red/Blue', '1998-09-28', $29.95),
	('Gold/Silver', '2000-10-15', $29.95),
	('Ruby/Sapphire', '2002-11-21', $34.99),
	('Diamond/Pearl', '2006-09-28', $39.99),
	('Black/White', '2010-09-18', $34.99),
	('X/Y', '2013-10-12', $39.99),
	('Sun/Moon', '2016-11-18', $59.99),
	('Sword/Shield', '2019-11-15', $59.99),
	('Scarlet/Violet', '2022-11-18', $59.99);
GO

/* Insert into types table*/
insert into types (
	type_name, 
	type_rarity_rank, 
	type_supereffective_against, 
	type_weak_agaianst)
values 
	('Bug', 13, 'Grass/Fight/Ground', 'Fire/Flying/Rock'),
	('Dark', 9, 'Psychic/Ghost', 'Fight/Bug/Fairy'),
	('Dragon', 5, 'Fire/Water/Electric/Grass', 'Ice/Dragon/Fairy'),
	('Electric', 4, 'Flying/Steel', 'Ground'),
	('Fight', 10, 'Bug/Rock/Dark', 'Flying/Psychic/Fairy'),
	('Fire', 12, 'Grass/Ice/Bug/Steel', 'Water/Ground/Rock'),
	('Flying', 15, 'Grass/Ground/Bug/Ghost', 'Electric/Ice/Rock'),
	('Ghost', 3, 'Normal/Fight/Poison/Bug', 'Ghost/Dark'),
	('Grass', 16, 'Water/Electric/Ground', 'Fire/Ice/Poison/Flying/Bug'),
	('Ground', 7, 'Electric/Poison/Rock', 'Water/Grass/Ice/'),
	('Ice', 1, 'Dragon/Flying/Grass/Ground', 'Fighting/Fire/Rock/Steel'),
	('Normal', 17, 'Ghost', 'Fight'),
	('Poison', 11, 'Grass/Fight/Bug/Fairy', 'Ground/Psychic'),
	('Psychic', 14, 'Fight', 'Bug/Ghost/Dark'),
	('Rock', 8, 'Normal/Fire/Poison/Flying', 'Water/Grass/Fight/Ground/Steel'),
	('Steel', 6, 'Fairty/Ice/Rock/Fairy', 'Fighting/Fire/Ground'),
	('Water', 18, 'Fire/Ice/Steel', 'Electic/Grass'),
	('Fairy', 2, 'Dark/Fighting/Dragon', 'Dark/Fighting/Dragon');
GO

/* Insert into Pokemon*/
insert into pokemon (
	pokemon_pokedex_id,
    pokemon_name,
    pokemon_height,
    pokemon_weight,
    pokemon_evolve_level,
    pokemon_rarity,
    pokemon_caught,
    pokemon_watch_list,
    pokemon_generation_caught_in_id,
    pokemon_user_id)
values
    (147, 'Dratini', 1.80, 3.30, 30, null, 'Y', NULL, 1, null),
    (148, 'Dragonair', 4.00, 16.50, 55, 'Rare', 'Y', NULL, 1, null),
    (149, 'Dragonite', 2.20, 210.00, NULL, 'Rare', 'Y', 'Y', 1, null),
    (230, 'Kingdra', 1.80, 152.00, NULL, 'Rare', 'N', NULL, 2, null),
    (329, 'Vibrava', 1.10, 15.30, 45, null, 'Y', NULL, 3, null),
    (330, 'Flygon', 2.00, 82.00, NULL, 'Rare', 'N', 'Y', 3, null),
    (334, 'Altaria', 1.10, 20.60, NULL, 'Rare', 'Y', NULL, 3, null),
    (371, 'Bagon', 0.60, 42.10, 30, 'Rare', 'Y', NULL, 3, null),
    (372, 'Shelgon', 1.10, 110.50, 50, 'Rare', 'Y', NULL, 3, null),
    (373, 'Salamence', 1.50, 102.60, NULL, 'Rare', 'Y', NULL, 3, null),
    (380, 'Latias', 1.40, 40.00, NULL, 'Legendary', 'N', 'Y', 3, null),
    (381, 'Latios', 2.00, 60.00, NULL, 'Legendary', 'Y', NULL, 3, null),
    (384, 'Rayquaza', 7.00, 206.50, NULL, 'Legendary', 'Y', NULL, 3, null);
GO

INSERT INTO base_stats (
    base_stat_hp,
    base_stat_speed,
    base_stat_phsyical_attack,
    base_stat_phsyical_defense,
    base_stat_special_attack,
    base_stat_special_defense,
    base_stat_capture_rate
) VALUES
    (41, 50, 64, 45, 50, 50, 45),  -- Dratini
    (61, 70, 84, 65, 70, 70, 45),  -- Dragonair
    (91, 80, 134, 95, 100, 100, 45),  -- Dragonite
    (75, 85, 95, 95, 95, 95, 45),  -- Kingdra
    (50, 70, 70, 50, 50, 50, 120),  -- Vibrava
    (80, 100, 100, 80, 80, 80, 120),  -- Flygon
    (75, 80, 70, 90, 70, 90, 45),  -- Altaria
    (45, 50, 75, 60, 40, 30, 45),  -- Bagon
    (65, 50, 95, 100, 60, 50, 45),  -- Shelgon
    (95, 100, 135, 80, 110, 80, 45),  -- Salamence
    (80, 110, 80, 90, 110, 130, 3),  -- Latias
    (80, 110, 90, 80, 130, 110, 3),  -- Latios
    (105, 95, 150, 90, 150, 90, 3);  -- Rayquaza
GO

/* Insert into pokemon_types */
INSERT INTO pokemon_types (
    pokemon_type_pokemon_pokedex_id, 
    pokemon_type_type_id)
VALUES
    -- Dratini
    (147, (SELECT type_id FROM types WHERE type_name = 'Dragon')),  
    -- Dragonair
    (148, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Dragonite
    (149, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (149, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Kingdra
    (230, (SELECT type_id FROM types WHERE type_name = 'Water')),
    (230, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Vibrava
    (329, (SELECT type_id FROM types WHERE type_name = 'Ground')),
    (329, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Flygon
    (330, (SELECT type_id FROM types WHERE type_name = 'Ground')),
    (330, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Altaria
    (334, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (334, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Bagon
    (371, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Shelgon
    (372, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Salamence
    (373, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (373, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Latias
    (380, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (380, (SELECT type_id FROM types WHERE type_name = 'Psychic')),
    -- Latios
    (381, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (381, (SELECT type_id FROM types WHERE type_name = 'Psychic')),
    -- Rayquaza
    (384, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (384, (SELECT type_id FROM types WHERE type_name = 'Flying'));
GO

/* Insert into pokemon_base_stats */
INSERT INTO pokemon_base_stats (
    pokemon_base_stat_pokemon_pokedex_id,
    pokemon_base_stats_base_stat_id
)
VALUES
    -- Dratini
    (147, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 41 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 64 AND base_stat_phsyical_defense = 45 AND base_stat_special_attack = 50 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 45)),
    -- Dragonair
    (148, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 61 AND base_stat_speed = 70 AND base_stat_phsyical_attack = 84 AND base_stat_phsyical_defense = 65 AND base_stat_special_attack = 70 AND base_stat_special_defense = 70 AND base_stat_capture_rate = 45)),
    -- Dragonite
    (149, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 91 AND base_stat_speed = 80 AND base_stat_phsyical_attack = 134 AND base_stat_phsyical_defense = 95 AND base_stat_special_attack = 100 AND base_stat_special_defense = 100 AND base_stat_capture_rate = 45)),
    -- Kingdra
    (230, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 75 AND base_stat_speed = 85 AND base_stat_phsyical_attack = 95 AND base_stat_phsyical_defense = 95 AND base_stat_special_attack = 95 AND base_stat_special_defense = 95 AND base_stat_capture_rate = 45)),
    -- Vibrava
    (329, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 50 AND base_stat_speed = 70 AND base_stat_phsyical_attack = 70 AND base_stat_phsyical_defense = 50 AND base_stat_special_attack = 50 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 120)),
    -- Flygon
    (330, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 100 AND base_stat_phsyical_attack = 100 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 80 AND base_stat_special_defense = 80 AND base_stat_capture_rate = 120)),
    -- Altaria
    (334, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 75 AND base_stat_speed = 80 AND base_stat_phsyical_attack = 70 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 70 AND base_stat_special_defense = 90 AND base_stat_capture_rate = 45)),
    -- Bagon
    (371, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 45 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 75 AND base_stat_phsyical_defense = 60 AND base_stat_special_attack = 40 AND base_stat_special_defense = 30 AND base_stat_capture_rate = 45)),
    -- Shelgon
    (372, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 65 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 95 AND base_stat_phsyical_defense = 100 AND base_stat_special_attack = 60 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 45)),
    -- Salamence
    (373, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 95 AND base_stat_speed = 100 AND base_stat_phsyical_attack = 135 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 110 AND base_stat_special_defense = 80 AND base_stat_capture_rate = 45)),
    -- Latias
    (380, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 110 AND base_stat_phsyical_attack = 80 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 110 AND base_stat_special_defense = 130 AND base_stat_capture_rate = 3)),
    -- Latios
    (381, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 110 AND base_stat_phsyical_attack = 90 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 130 AND base_stat_special_defense = 110 AND base_stat_capture_rate = 3)),
    -- Rayquaza
    (384, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 105 AND base_stat_speed = 95 AND base_stat_phsyical_attack = 150 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 150 AND base_stat_special_defense = 90 AND base_stat_capture_rate = 3));
GO


select p.pokemon_pokedex_id, p.pokemon_name,t.type_name, t.type_supereffective_against, t.type_weak_agaianst, bs.base_stat_hp, bs.base_stat_speed, gci.generation_caught_in_game_title from pokemon p
    join pokemon_types pt on p.pokemon_pokedex_id = pt.pokemon_type_pokemon_pokedex_id
    join types t on t.type_id = pt.pokemon_type_type_id
    join pokemon_base_stats pbs on pbs.pokemon_base_stat_pokemon_pokedex_id = p.pokemon_pokedex_id
    join base_stats bs on bs.base_stat_id = pbs.pokemon_base_stats_base_stat_id
    join generations_caught_in gci on gci.generation_caught_in_id = p.pokemon_generation_caught_in_id