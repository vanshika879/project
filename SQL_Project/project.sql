use p
select * from basketball

---Q1:What is the total number of records in the dataset?
SELECT COUNT(*) AS total_records FROM basketball


---Q2:What are the unique values in a specific column?
SELECT DISTINCT team FROM basketball


---Q3:How many missing values are there in each column?
SELECT college, COUNT(*) AS missing_values
FROM basketball
WHERE college IS NULL
GROUP BY college

---Q4:What is the average value of a games,points and minutes played?
SELECT AVG(games) AS avg_games,AVG(points) AS avg_points,AVG(minutes_played) AS average_minutes FROM basketball

---Q5:What is the minimum value in a games,points and minutes played?
SELECT MIN(games) AS min_games,MIN(points) AS min_points,MIN(minutes_played) AS min_minutes FROM basketball
where games is not null
group by games
order by games

---Q6:What is the maximum value in a games,points and minutes played?
SELECT MAX(games) AS max_games,MAX(points) AS max_points,MAX(minutes_played) AS max_minutes FROM basketball
where games is not null
group by games
order by games desc

---Q7:which are top 5 teams each year based on  points?
SELECT year, team
FROM (
  SELECT year, team,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY points DESC) AS row_num
  FROM basketball
) AS ranked_teams
WHERE row_num <= 5
ORDER BY year, row_num;


---Q8: which players are playing basketball for more than 10 years?

SELECT player ,
year
from basketball
where years_active >10

---Q9:What is the percentage of missing values in each column?
SELECT college, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM basketball) AS missing_percentage
FROM basketball
WHERE college IS NULL
GROUP BY college


---Q10:How many records have a specific value in a LAC or CHI?
SELECT COUNT(*) AS records_count
FROM basketball
WHERE team = 'LAC' or team='CHI'

---Q11:which team ha smax occurence ?
SELECT team, COUNT(*) AS occurrence
FROM basketball
GROUP BY team
HAVING COUNT(*) = (
    SELECT MAX(occurrence)
    FROM (
        SELECT team, COUNT(*) AS occurrence
        FROM basketball
        GROUP BY team
    ) AS subquery
)


---Q12:which all player are from which college?
SELECT player,college,team, COUNT(DISTINCT college) AS unique_values
FROM basketball
where college is not null
GROUP BY college,team,player

---Q13:What is the average value of a games by each team?
SELECT team, AVG(games) AS average_games
FROM basketball
GROUP BY team
order by avg(games) desc


---Q14:  How does the NBA drafting count change over time?
SELECT 
        year ,
        COUNT(DISTINCT id) as player_selected
    FROM basketball
    GROUP BY year

	

---Q15: What are the top 10 NBA team that drafted most number of player from university?
SELECT top 10
        college ,
        COUNT(DISTINCT id) as drafted
    FROM basketball
	where college is not null
    GROUP BY college 
    ORDER BY drafted DESC

	

---Q16:which player is top rank for each year?
select year,player from basketball
	where rank =1


--Q17: players played highest amount of games for each year?
	
SELECT t.year, t.player, t.games
FROM basketball t
JOIN (
    SELECT year, MAX(games) AS max_games_played
    FROM basketball
    GROUP BY year
) AS subquery
ON t.year = subquery.year AND t.games = subquery.max_games_played


---Q18: How does the free throw percentage (FT%) is for each team? which team had the best FT%?

SELECT 
	
        TEAM AS team_name,
		free_throw_percentage
    FROM BASKETBALL
	where free_throw_percentage is not null
    GROUP BY  year ,team,free_throw_percentage
	order by free_throw_percentage desc
 
---Q19: What is the standard deviation of a numeric column?
 SELECT STDEV(games) as std_games,STDEV(points) as std_points,STDEV(minutes_played) AS std_minutes
FROM basketball

---Q20:How many records have duplicate values in a college?
SELECT COUNT(college) - COUNT(DISTINCT college) AS duplicate_count
FROM basketball;

---Q21:What are the top 10 teams who has scored most points?
SELECT top 10 team, sum(points) as total_points
FROM basketball
group by team
ORDER BY sum(points) DESC


---Q22:How does the three point field goal percentage (3P%) is for each team?which team had the best 3P%?
SELECT 
	
        TEAM AS team_name,
		_3_point_percentage
    FROM BASKETBALL
	where _3_point_percentage is not null
    GROUP BY  year ,team,_3_point_percentage
	order by _3_point_percentage desc

---Q23: how many players are from lakers from last 6 years?
select year,player from basketball
	where team='LAC' and year between 2015 and 2021

	
---Q24:Retrieve the players who have played the most minutes in 2021?
SELECT player, SUM(minutes_played) AS total_minutes FROM basketball
	WHERE year = 2021 GROUP BY player ORDER BY total_minutes DESC;

---Q25:Retrieve the players who have recorded a quadruple-double (points, rebounds, assists, and years active ) in a game?
SELECT * FROM basketball WHERE points >= 1000 AND total_rebounds >= 1000 AND assists >= 1000 AND years_active>10

---Q26: how to remove outliers?
WITH stats AS (
  SELECT AVG(minutes_played) AS mean, STDEV(minutes_played) AS stddev
  FROM basketball
)
SELECT *
FROM basketball
JOIN stats ON 1=1
WHERE minutes_played BETWEEN (mean - 3 * stddev) AND (mean + 3 * stddev)

---Q27: how to remove null values?
DELETE FROM basketball
WHERE college IS NULL;

---Q28:what is efficiency of the players?
SELECT top 5 field_goal_percentage, player from basketball 
order by field_goal_percentage desc
