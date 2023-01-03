-- ANALYZING THE DIFFRENCE BETWEEN CASUALS AND MEMBERS

CREATE view casual_bikersview AS
(
select
start_station_name,
end_station_name,
started_at,
ended_at,
datepart(weekday, started_at) as day_of_start,
cast(datediff(minute,started_at, ended_at) as int) duration_in_mins
from Cyclistic..[202110]
where start_station_name is not NULL and
end_station_name is not NULL and
member_casual = 'casual'
)

CREATE view member_bikersview AS
(
select
start_station_name,
end_station_name,
started_at,
ended_at,
datepart(weekday, started_at) as day_of_start,
cast(datediff(minute,started_at, ended_at) as int) duration_in_mins
from Cyclistic..[202110]
where start_station_name is not NULL and
end_station_name is not NULL and
member_casual = 'member'
)

select * into casual_biker from casual_bikersview
where duration_in_mins > 0 and duration_in_mins < 240
go

select * into member_biker from member_bikersview
where duration_in_mins > 0 and duration_in_mins < 240
go

select * from master..member_biker


