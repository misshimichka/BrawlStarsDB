-- DDL SCRIPTS
create schema if not exists hse_project;

set search_path to hse_project;

create table if not exists Event (
    event_id serial primary key not null,
    event_name text,
    players_amount integer
);

create table if not exists Map (
    map_id serial primary key not null,
    map_name text,
    creation_date date
);

create table if not exists Club (
    club_id serial primary key not null,
    club_name text,
    information text, 
    trophy_limit integer constraint non_negative_trophy_limit check (trophy_limit >= 0),
    is_private boolean,
    capitain_id integer constraint not_null_capitain_id check (capitain_id != null),
    creation_date date
);

create table if not exists Player (
    player_id serial primary key not null,
    player_name text,
    club_id integer references Club(club_id),
    creation_date date,
    coin_amount integer constraint non_negative_coin_amount check (coin_amount >= 0),
    trophy_amount integer constraint non_negative_trophy_amount check (trophy_amount >= 0)
);

create table if not exists Fight (
    fight_id serial primary key not null,
    event_id integer references Event(event_id) not null,
    map_id integer references Map(map_id) not null,
    player_id integer references Player(player_id) not null,
    begin_time time,
    end_time time,
    is_finished boolean default false,
    fight_uid integer constraint fight_uid_not_null check (fight_uid != null),
    place integer
);

create table if not exists Shop (
    item_id serial primary key not null,
    player_id integer references Player(player_id) not null,
    item_name text,
    purchase_date date,
    price integer constraint non_negative_price check (price >= 0),
    amount integer constraint non_negative_amount check (amount >= 0)
);

create table if not exists Brawler (
    brawler_id serial primary key not null,
    brawler_name text,
    health integer constraint positive_health check (health > 0),
    attack integer constraint positive_attack check (attack > 0),
    class text, 
    rarity text
);

create table if not exists Gear (
    gear_id serial primary key not null,
    brawler_id integer references Brawler(brawler_id) not null,
    gear_name text,
    rarity text
);

create table if not exists Player_X_Brawler (
    id serial primary key not null,
    brawler_id integer references Brawler(brawler_id) not null,
    player_id integer references Player(player_id) not null
);


-- INSERT VALUES
insert into Event(event_name, players_amount) values 
    ('Shutdown', 10),
    ('Dual shutdown', 10),
    ('Brawlball', 6),
    ('Duo', 2);


insert into Map(map_name, creation_date) values 
    ('Map 1', '2020-10-10'),
    ('Map 2', '2024-12-05'),
    ('Map 3', '2021-06-15'),
    ('Map 4', '2022-02-24'),
    ('Map 5', '2020-01-01');


insert into Club(club_name, information, trophy_limit, is_private, capitain_id, creation_date) values 
    ('Club 1', 'info 1', 0, false, 2, '2020-05-12'),
    ('Club 2', null, 1000, false, 3, '2021-06-16'),
    ('Club 3', 'info 3', 10000, true, 4, '2019-10-19');


insert into Player(player_name, club_id, creation_date, coin_amount, trophy_amount) values 
    ('Taisia', null, '2019-01-01', 1337, 65535),
    ('Alisa', 1, '2024-09-10', 2000, 23000),
    ('Bob', 2, '2021-03-26', 16000, 15000),
    ('User 4', 3, '2020-05-15', 1000, 16258);


insert into Fight(event_id, map_id, player_id, begin_time, end_time, is_finished, fight_uid, place) values 
    (4, 1, 1, '2024-12-07 22:22:22', null, false, 1, null),
    (4, 1, 2, '2024-12-07 22:22:22', null, false, 1, null),
    (4, 3, 3, '2024-12-09 10:23:54', '2024-12-09 10:27:01', true, 2, 2),
    (4, 3, 4, '2024-12-09 10:23:54', '2024-12-09 10:27:01', true, 2, 1);


insert into Shop(player_id, item_name, purchase_date, price, amount) values 
    (1, 'Item 1', '2019-02-21', 30, 100),
    (1, 'Item 2', '2019-02-21', 3000, 1),
    (2, 'Item 3', '2019-10-19', 50, 3),
    (3, 'Item 2', '2019-03-21', 3000, 1),
    (3, 'Item 2', '2019-04-21', 3000, 1),
    (3, 'Item 1', '2019-04-22', 30, 50),
    (4, 'Item 1', '2019-02-28', 30, 150),
    (4, 'Item 3', '2019-03-05', 50, 10);


insert into Brawler(brawler_name, health, attack, class, rarity) values 
    ('Nita', 4000, 960, 'damage', 'rare'),
    ('Bull', 5000, 440, 'tank', 'rare'),
    ('Shelly', 3700, 300, 'damage', 'starting'),
    ('Kolt', 2800, 360, 'damage', 'rare');


insert into Gear(brawler_id, gear_name, rarity) values 
    (1, 'Gear 1', 'rare'),
    (1, 'Gear 2', 'rare'),
    (2, 'Gear 2', 'epic'),
    (4, 'Gear 3', 'epic'),
    (3, 'Gear 4', 'legendary'),
    (3, 'Gear 1', 'rare'),
    (3, 'Gear 2', 'rare'),
    (2, 'Gear 3', 'epic'),
    (4, 'Gear 4', 'legendary'),
    (1, 'Gear 4', 'legendary');


insert into Player_X_Brawler(brawler_id, player_id) values 
    (1, 1),
    (1, 2),
    (3, 1),
    (4, 1),
    (2, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (2, 4);


-- CRUD QUERIES
select * 
from Player 
where trophy_amount > 20000;


INSERT INTO Shop(player_id, item_name, purchase_date, price, amount) VALUES
    (1, 'Item 1', '2023-03-01', 30, 100),
    (2, 'Item 4', '2023-03-10', 700, 1),
    (2, 'Item 2', '2023-03-15', 3000, 1),
    (3, 'Item 3', '2023-03-20', 50, 1),
    (3, 'Item 5', '2023-03-25', 300, 1),
    (4, 'Item 5', '2023-03-30', 300, 2),
    (4, 'Item 6', '2023-04-01', 500, 1),
    (1, 'Item 1', '2023-04-05', 50, 3),
    (2, 'Item 4', '2023-04-10', 700, 1);


update Player 
set player_name = 'aboba'
where player_id = 4;


delete from Map
where creation_date < '2010.01.01';


-- QUERIES
-- Вывести среднее количество трофеев пользователей, участвовавших в одном бою. 
-- Формат вывода: id пользователя, имя пользователя, uid боя, количество трофеев пользователя, среднее количество трофеев.
select 
    P.player_id,
    P.player_name,
    F.fight_uid,
    P.trophy_amount,
    avg(P.trophy_amount) over (partition by F.fight_uid order by F.fight_uid asc)
from Fight as F
left join Player as P
on F.player_id = P.player_id;


-- Для каждого пользователя вывести потраченную им сумму. Отсортировать по убыванию.
-- Формат вывода: id пользователя, имя пользователя, суммарное количество потраченных денег. 
select 
    P.player_id,
    P.player_name,
    sum(S.price * S.amount) as "total_spent"
from Player as P
left join Shop as S
on S.player_id = P.player_id
group by P.player_id
order by "total_spent";


-- Вывести в отсортированном виде (по убыванию числа трофеев) топ-5 игроков с наибольшим числом трофеев по каждому клубу.
-- Формат вывода: id пользователя, имя пользователя, число трофеев, место пользователя в топе, id клуба.
-- Пользователей, не состоящих ни в каком клубе, учитывать не нужно.
select 
    *
from (
    select 
        player_id, 
        player_name, 
        trophy_amount, 
        club_id,
        rank() over (partition by club_id order by coin_amount desc) as place
    from Player
    where club_id is not null;
)
WHERE place <= 5;


-- Вывести всех игроков, участовавших в матчах на карте Map 1
select 
    p.player_name
from Player as p
left join Fight as f 
on p.player_id = f.player_id
left join Map as m 
on f.map_id = m.map_id
where m.map_name = 'Map 1'
order by f.begin_time;


-- VIEWS
create view event_view as
    select 
        event_name, 
        players_amount 
    from Event;


create view map_view as
    select map_name from Map;


create view club_view as
    select 
        club_name,
        information, 
        trophy_limit, 
        is_private 
    from Club;


create view player_view as
    select 
        player_name, 
        club_id, 
        trophy_amount 
    from Player;


create view fight_view as
    select 
        event_id, 
        map_id, 
        player_id, 
        begin_time, 
        end_time, 
        is_finished
    from Fight; 


create view shop_view as
    select 
        player_id, 
        item_name, 
        purchase_date 
    from Shop; 


create view brawler_view as
    select 
        brawler_name, 
        health, 
        attack, 
        class, 
        rarity 
    from Brawler;


create view gear_view as
    select 
        gear_name, 
        gear_rarity
    from Gear;


create view player_x_brawler_view as
    select 
        brawler_id,
        player_id
    from Player_X_Brawler;


-- COMPOSITE VIEWS
-- Статистика по всем клубам: количество игроков в клубе, суммарное число трофеев в клубе, среднее число трофеев у игрока в клубе.
create view club_statistics as
    select
        c.club_id,
        c.club_name,
        count(p.player_id) as total_players,
        coalesce(sum(p.trophy_amount), 0) as total_trophies,
        coalesce(sum(p.trophy_amount), 0) / count(p.player_id) as avg_trophies
    from Club as c
    left join Player as p 
    on c.club_id = p.club_id
    group by c.club_id, c.club_name;


-- Статистика по покупкам каждого пользователя: общая потраченная сумма, число купленных item'ов.
create view player_shop_statistics as
    select
        p.player_id,
        p.player_name,
        coalesce(sum(s.price * s.amount), 0) as total_spent,
        coalesce(sum(s.amount), 0) as total_items_purchased
    from Player as p
    left join Shop as s 
    on p.player_id = s.player_id
    group by p.player_id, p.player_name;


-- Статистика по всем завершенным боям: длительность боя, название карты, название события, имена игроков, занявших первые 3 места.
create view fight_statistics as
    select 
        *
    from (
        select
            f.fight_id,
            e.event_name as event_name,
            m.map_name as map_name,
            p.player_name as player_name,
            extract(epoch from f.end_time - f.begin_time) as fight_duration,
            rank() over (partition by f.fight_uid order by f.place) as place
        from Fight as f
        left join Event as e 
        on f.event_id = e.event_id
        left join Map as m 
        on f.map_id = m.map_id
        left join Player as p 
        on f.player_id = p.player_id
        where f.is_finished = true
    )
    where place <= 3;


-- TRIGGERS
-- Триггер проверяет, проходит ли игрок в клуб по числу трофеев. 
-- Если число трофеев меньше, чем установленная нижняя граница в настройках клуба, то запись не добавляется в таблицу.
create or replace function check_trophy_amount()
returns trigger as $$
begin
    if (select trophy_limit from Club where club_id = new.club_id) > new.trophy_amount then
        raise exception 'Player trophy amount is less than club trophy limit';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trigger_check_trophy_amount
before insert or update on Player
for each row
execute function check_trophy_amount();


-- Триггер проверяет, хватает ли средств у игрока для покупки item'а.
create or replace function check_coin_amount()
returns trigger as $$
begin
    if (select coin_amount from Player where palyer_id = new.player_id) < new.price * new.amount then
        raise exception 'Player coin amount must be not less than %', new.price * new.amount;
    end if;
    update Player
    set coin_amount = coin_amount - new.price * new.amount
    where player_id = new.player_id;
    return new;
end;
$$ language plpgsql;

create trigger trigger_check_coin_amount
before insert on Shop
for each row
execute function check_coin_amount();


-- FUNCTIONS
-- Функция добавляет нового игрока с начальным числом трофеев и монет.
create or replace procedure add_new_player(
    player_name text,
    creation_date date
) as $$
begin
    insert into Player(player_name, creation_date, coin_amount, trophy_amount) values 
        (player_name, current_date, 100, 0);
    raise notice 'Player % has been added with 100 coins and 0 trophies', player_name;
end;
$$ language plpgsql;


-- Функция добавляет время окончания боя и выставляет нужный флаг. 
create or replace procedure finish_fight(
    fight_id integer
) as $$
begin
    if fight_id not in (select fight_id from Fight as f where f.fight_id = fight_id) then
        raise exception 'Fight with id % does not exist', fight_id;
    end if;
    update Fight
    set 
        is_finished = true,
        end_time = now()
    where fight_id = fight_id;
end;
$$ language plpgsql;