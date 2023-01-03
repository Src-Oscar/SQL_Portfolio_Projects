-- Project done by Ravi Chandra

select *
from Projects..vgsales

-- I realized there are multiple NULLs in Year column

select *
from Projects..vgsales
where Year is not null

-- All Genres & Platforms along with Thier Counts

select Platform, COUNT(Platform) as Counts
from Projects..vgsales
group by Platform
order by Counts desc

select Genre, COUNT(Genre) Counts
from Projects..vgsales
where Year is not null
GROUP BY Genre
order by Counts desc

-- Categorizing the most sold game based on distinct platforms

select *
from Projects..vgsales
where Year is not null and
Platform = 'Wii' -- we can go through each publisher and analyse their global sales
ORDER BY Global_Sales DESC

-- Sum of global sales year wise

select Year,COUNT(Year) as Games_Published, SUM(Global_Sales) total_Global_Sale
from Projects..vgsales
where Year is not null
GROUP BY Year
ORDER BY total_Global_Sale DESC

-- Creating a new table (Cleaned), [although there wasn't much to clean but to remove NULL Years]

SELECT * into New_VGsales
from Projects..vgsales
where Year is not null
