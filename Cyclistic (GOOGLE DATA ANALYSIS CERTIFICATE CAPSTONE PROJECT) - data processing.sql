/*
insert into Cyclistic..[202110]
select *
from Cyclistic..[202110]


select
started_at, ended_at,
datediff(minute,started_at, ended_at) as duration
from Cyclistic..[202110]
*/

--CREATE VIEW bikerider AS
--WITH clean_data 

use sqlserverguides
go
CREATE view casted_biker AS
(
select
start_station_name,
end_station_name,
cast(started_at as date) as started_date,
cast(ended_at as date) as ended_date,
datepart(hour,started_at) as started_hour,
datepart(hour,ended_at) as end_hour,
cast(datediff(minute,started_at, ended_at) as int) duration
from Cyclistic..[202110]
where start_station_name is not NULL and
end_station_name is not NULL
)

select MAX(duration) from casted_biker

select cast(duration as int),
duration/max(cast(duration as int)) as mean 
from casted_biker


select * into new_bikercleans from new_biker
where duration > 0 and duration < 240
go

select
started_at, ended_at,
datediff(minute,started_at, ended_at) as duration
from Cyclistic..[202110]
