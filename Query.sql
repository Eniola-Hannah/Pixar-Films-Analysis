CREATE DATABASE Pixar_films_db;

USE Pixar_films_db;

-- Difficulty in importing pixar_films dataset ~~~ import Manually
CREATE TABLE pixar_films (
Number INT, 
Film TEXT,
Release_date TEXT,
Run_time INT,
Film_rating TEXT,
Plot TEXT);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\pixar_films.csv"      
INTO TABLE pixar_films
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 LINES;

-- Data Cleaning
-- Standardizing Date formats  
SET SQL_SAFE_UPDATES = 0;
UPDATE pixar_films
SET Release_date = STR_TO_DATE(Release_date, "%m/%d/%YYYY");
ALTER TABLE pixar_films
MODIFY COLUMN Release_date DATE;

-- checking for duplicates
SELECT film, award_type, status, COUNT(*) AS count FROM academy
GROUP BY film, award_type, status
HAVING COUNT(*) > 1;

SELECT film, budget, box_office_us_canada, box_office_other, box_office_worldwide, COUNT(*) AS count FROM box_office
GROUP BY film, budget, box_office_us_canada, box_office_other, box_office_worldwide
HAVING COUNT(*) > 1;

SELECT film, category, value, COUNT(*) AS count FROM genres
GROUP BY film, category, value
HAVING COUNT(*) > 1;

SELECT Number, film, Release_date, Run_time, Film_rating, COUNT(*) AS count FROM pixar_films
GROUP BY Number, film, Release_date, Run_time, Film_rating
HAVING COUNT(*) > 1;

SELECT film, rotten_tomatoes_score, rotten_tomatoes_counts, metacritic_score, metacritic_counts, COUNT(*) AS count FROM public_response
GROUP BY film, rotten_tomatoes_score, rotten_tomatoes_counts, metacritic_score, metacritic_counts
HAVING COUNT(*) > 1;

SELECT film, role_type, name, COUNT(*) AS count FROM pixar_people    -- Duplicate values present!
GROUP BY film, role_type, name
HAVING COUNT(*) > 1;

CREATE TABLE cleaned_pixar_people AS SELECT DISTINCT * FROM pixar_people;

SELECT * FROM cleaned_pixar_people;   -- Exports as an external file

-- Data Exploration
-- 1.	Financial Performance Analysis:
-- (a) What are the top 5 highest-grossing Pixar films worldwide?
SELECT film, box_office_worldwide FROM box_office
ORDER BY box_office_worldwide DESC LIMIT 5;

-- (b) How have Pixar films performed financially over the years? What is the relationship between budget and box office earnings? 
-- Which films were the most profitable

WITH CTE AS (
SELECT film, budget, (box_office_worldwide - budget) AS profit FROM box_office 
)
SELECT Year(p.Release_date) AS Movie_year, p.film, C.PROFIT, CASE 
WHEN c.profit > c.budget * 2 THEN "High profit" 
WHEN c.profit > 0 AND c.profit < c.budget * 2 THEN "Low profit" ELSE "Loss" END AS financial_performance
FROM CTE AS c RIGHT JOIN pixar_films AS p
ON c.film = p.film
ORDER BY Movie_year;

SELECT film, budget, box_office_worldwide, CASE 
			WHEN box_office_worldwide < budget THEN "Flop"                                  
			WHEN box_office_worldwide = budget THEN "Break-even"                                     -- Covered costs but no profit
			WHEN  box_office_worldwide > budget AND box_office_worldwide <= (budget * 2) THEN "Hit"   --  Profitable, made good returns
            WHEN box_office_worldwide > (budget * 2) THEN "Blockbuster"                               -- A massive success, major profits
			END AS relationship_term FROM box_office
ORDER BY relationship_term;

WITH CTE AS (
SELECT film, budget, box_office_worldwide, CASE
			WHEN box_office_worldwide < budget THEN "Flop"                                  
			WHEN box_office_worldwide = budget THEN "Break-even"
			WHEN  box_office_worldwide > budget AND box_office_worldwide <= (budget * 2) THEN "Hit"
            WHEN box_office_worldwide > (budget * 2) THEN "Blockbuster"
			END AS relationship_term FROM box_office
ORDER BY box_office_worldwide
) 
SELECT film AS profitable_films FROM CTE
WHERE relationship_term = "Blockbuster";


-- (c) How does budget correlate with box office performance across different regions (US/Canada vs. International)?

SELECT ((COUNT(*) * SUM(XY)) - (SUM(X) * SUM(Y))) / 
SQRT( 
	((COUNT(*) * SUM(X_squared)) - (SUM(X) * SUM(X))) * 
	((COUNT(*) * SUM(Y_squared)) - (SUM(Y) * SUM(Y)))
)
AS Correlation_coefficient
FROM (
SELECT budget AS X, 
	   box_office_us_canada AS Y, 
	   budget * box_office_us_canada AS XY, 
       budget * budget AS X_squared,
       box_office_us_canada * box_office_us_canada AS Y_squared 
       FROM box_office
) AS Subquery;
-- No Significant correlation btwn Budget and box office US/Canada ~~ A weak positive correlation 
-- +0.1 - +0.3 = weak positive correlation


SELECT ((COUNT(*) * SUM(XY)) - (SUM(X) * SUM(Y))) / 
SQRT( 
	((COUNT(*) * SUM(X_squared)) - (SUM(X) * SUM(X))) * 
	((COUNT(*) * SUM(Y_squared)) - (SUM(Y) * SUM(Y)))
)
AS Correlation_coefficient
FROM (
SELECT budget AS X, 
	   box_office_other AS Y, 
	   budget * box_office_other AS XY, 
       budget * budget AS X_squared,
       box_office_other * box_office_other AS Y_squared 
       FROM box_office
) AS Subquery;
-- No Significant correlation btwn Budget and box office International ~~ A weak positive correlation 
-- +0.1 - +0.3 = weak positive correlation


-- (d) Which films achieved the highest return on investment (ROI), and how does this compare across different decades?
WITH CTE AS (
SELECT film, ROUND(((box_office_worldwide - budget)/budget) * 100, 2) AS ROI FROM box_office ORDER BY ROI DESC
LIMIT 10
) 
SELECT film, CONCAT(ROI, " %") AS ROI FROM CTE;

WITH CTE AS (
SELECT film, ROUND(((box_office_worldwide - budget)/budget) * 100, 2) AS ROI FROM box_office ORDER BY ROI DESC
LIMIT 10
) 
SELECT c.film, CONCAT(c.ROI, " %") AS ROI, CONCAT(FLOOR(YEAR(p.release_date) / 10) * 10, "s") AS decade FROM CTE AS c
JOIN pixar_films AS p
ON c.film = p.film
ORDER BY decade;

WITH CTE AS (
SELECT SUM(box_office_worldwide) AS decade_box_office, SUM(budget) AS decade_budget, 
CONCAT(FLOOR(YEAR(p.release_date) / 10) * 10, "s") AS decade FROM box_office AS b
JOIN pixar_films AS p
ON b.film = p.film
GROUP BY decade
ORDER BY decade)
SELECT decade, CONCAT(ROUND(((decade_box_office - decade_budget)/decade_budget) * 100, 2), "%") AS ROI FROM CTE;



-- 2.	Audience and Critical Reception:
-- (a) How do audience ratings (IMDB, Rotten Tomatoes, Metacritic) correlate with box office earnings?
-- IMDB correlation
SELECT ((COUNT(*) * SUM(XY)) - (SUM(X) * SUM(Y))) / 
SQRT( 
	((COUNT(*) * SUM(X_squared)) - (SUM(X) * SUM(X))) * 
	((COUNT(*) * SUM(Y_squared)) - (SUM(Y) * SUM(Y)))
)
AS Correlation_coefficient
FROM (
SELECT imdb_score AS X, 
	   box_office_worldwide AS Y, 
	   imdb_score * box_office_worldwide AS XY, 
       imdb_score * imdb_score AS X_squared,
       box_office_worldwide * box_office_worldwide AS Y_squared 
       FROM box_office AS b
       JOIN public_response AS p 
       ON b.film = p.film 
) AS Subquery;

-- Rotten tomatoe correlation
SELECT ((COUNT(*) * SUM(XY)) - (SUM(X) * SUM(Y))) / 
SQRT( 
	((COUNT(*) * SUM(X_squared)) - (SUM(X) * SUM(X))) * 
	((COUNT(*) * SUM(Y_squared)) - (SUM(Y) * SUM(Y)))
)
AS Correlation_coefficient
FROM (
SELECT rotten_tomatoes_score AS X, 
	   box_office_worldwide AS Y, 
	   rotten_tomatoes_score * box_office_worldwide AS XY, 
       rotten_tomatoes_score * rotten_tomatoes_score AS X_squared,
       box_office_worldwide * box_office_worldwide AS Y_squared 
       FROM box_office AS b
       JOIN public_response AS p 
       ON b.film = p.film 
) AS Subquery;

-- Metacritic correlation
SELECT ((COUNT(*) * SUM(XY)) - (SUM(X) * SUM(Y))) / 
SQRT( 
	((COUNT(*) * SUM(X_squared)) - (SUM(X) * SUM(X))) * 
	((COUNT(*) * SUM(Y_squared)) - (SUM(Y) * SUM(Y)))
)
AS Correlation_coefficient
FROM (
SELECT metacritic_score AS X, 
	   box_office_worldwide AS Y, 
	   metacritic_score * box_office_worldwide AS XY, 
       metacritic_score * metacritic_score AS X_squared,
       box_office_worldwide * box_office_worldwide AS Y_squared 
       FROM box_office AS b
       JOIN public_response AS p 
       ON b.film = p.film 
) AS Subquery;

-- (b) What is the distribution of Pixar films by CinemaScore rating, and how does it impact financial success?
SELECT cinema_score, COUNT(cinema_score) AS cinemaScore_distribution FROM public_response
GROUP BY cinema_score;
-- Most Pixar films receive A or A+ ratings, showing strong audience approval

SELECT 
    p.cinema_score,
    ROUND(AVG(b.box_office_us_canada), 2) AS avg_us_canada_revenue,
    ROUND(AVG(b.box_office_other), 2) AS avg_international_revenue,
    ROUND(AVG(b.box_office_worldwide), 2) AS avg_worldwide_revenue
FROM public_response AS p
JOIN box_office AS b ON p.film = b.film
GROUP BY P.cinema_score
ORDER BY avg_worldwide_revenue DESC;


-- (c) Have audience ratings improved or declined over the years?
WITH CTE AS (
SELECT pr.*, YEAR(p.Release_date) AS year, LAG(rotten_tomatoes_score) OVER(ORDER BY p.release_date) AS prev_rotten_score 
FROM public_response AS pr INNER JOIN pixar_films AS p 
ON pr.film = p.film
), 
diff_table AS (
SELECT year, film, rotten_tomatoes_score, prev_rotten_score, 
CONCAT(ROUND(((rotten_tomatoes_score - prev_rotten_score)/prev_rotten_score) * 100, 2), "%") AS percentage_diff FROM CTE
ORDER BY year
) SELECT year, rotten_tomatoes_score, prev_rotten_score, CASE 
WHEN percentage_diff IS NULL THEN "First Rating" 
WHEN percentage_diff > 0 THEN "Improved Rating" 
WHEN percentage_diff = 0 THEN "No changes"
ELSE "Declined Rating" END AS Rating_State 
FROM diff_table;

WITH CTE AS (
SELECT pr.*, YEAR(p.Release_date) AS year, LAG(rotten_tomatoes_score) OVER(ORDER BY p.release_date) AS prev_rotten_score 
FROM public_response AS pr INNER JOIN pixar_films AS p 
ON pr.film = p.film
), 
diff_table AS (
SELECT year, film, rotten_tomatoes_score, prev_rotten_score, 
CONCAT(ROUND(((rotten_tomatoes_score - prev_rotten_score)/prev_rotten_score) * 100, 2), "%") AS percentage_diff FROM CTE
ORDER BY year
), newTable AS (
SELECT year, rotten_tomatoes_score, prev_rotten_score, CASE 
WHEN percentage_diff IS NULL THEN "First Rating" 
WHEN percentage_diff > 0 THEN "Improved Rating" 
WHEN percentage_diff = 0 THEN "No changes"
ELSE "Declined Rating" END AS Rating_State 
FROM diff_table
) SELECT Rating_State, COUNT(*) AS count FROM newTable
GROUP BY Rating_State;


-- 3.	Awards and Recognition:
-- (a) Which Pixar films have won or been nominated for Academy Awards?
with cte as (SELECT distinct film, status FROM academy
WHERE status in ("Won", "Nominated"))
select film, count(film) from CTE
GROUP BY FILM
ORDER BY Count(film) DESC;

-- (b) How does winning an Oscar impact a film's financial success?
SELECT * FROM academy;

ALTER TABLE academy
ADD COLUMN Oscar TEXT;

SET SQL_SAFE_UPDATES = 0;
UPDATE academy
SET Oscar = CASE WHEN status in ("Won", "Won Special Achievement") THEN "Oscar_winners" ELSE "Non_Oscar_winners" END;

SELECT Oscar, ROUND(AVG(b.box_office_us_canada), 2) AS avg_us_canada_finance,
ROUND(AVG(b.box_office_other), 2) AS Avg_international_finace, ROUND(AVG(b.box_office_worldwide), 2) AS Avg_worldwide_finace
FROM academy AS a
JOIN box_office AS b
ON a.film = b.film
GROUP BY Oscar
order by avg_us_canada_finance desc, Avg_international_finace desc, Avg_worldwide_finace desc;
        
-- Winning an Oscar does impact a film's financial success


-- (c) Which directors and writers have worked on the most award-winning Pixar films?
WITH CTE AS (
SELECT film, COUNT(status) AS count FROM academy
WHERE status = "won"
GROUP BY film
ORDER BY count DESC
), most_award_winning_film AS (
SELECT * FROM CTE 
WHERE count = (SELECT MAX(count) FROM CTE)
) 
SELECT DISTINCT c.name, m.film FROM cleaned_pixar_people AS c
JOIN most_award_winning_film AS m
ON m.film = c.film
WHERE role_type IN ("Director", "Screenwriter", "Storywriter");


-- 4.	Genre Trends and Film Characteristics:
-- (a) Which genres (Adventure, Comedy, Fantasy, etc.) are most common among Pixar films?
SELECT value, COUNT(value) AS count FROM genres
WHERE category = "Genre"
GROUP BY value
ORDER BY count DESC;

-- Adventure and Animation are dominant genres, followed by Comedy

-- (b) What is the average runtime of Pixar films over different periods, and does it affect box office performance?
SELECT min(YEAR(Release_date)), max(YEAR(Release_date)) from pixar_films;
SELECT CASE 
			WHEN YEAR(Release_date) BETWEEN "1990" AND "1999" THEN "1990 - 1999"
            WHEN YEAR(Release_date) BETWEEN "2000" AND "2009" THEN "2000 - 2009"
            WHEN YEAR(Release_date) BETWEEN "2010" AND "2019" THEN "2010 - 2019"
            ELSE "2020 - Present"
            END AS 10_yr_period, ROUND(AVG(Run_time), 2) AS avg_runtime FROM pixar_films
GROUP BY 10_yr_period;
		
SELECT CASE 
			WHEN YEAR(Release_date) BETWEEN "1990" AND "1999" THEN "1990 - 1999"
            WHEN YEAR(Release_date) BETWEEN "2000" AND "2009" THEN "2000 - 2009"
            WHEN YEAR(Release_date) BETWEEN "2010" AND "2019" THEN "2010 - 2019"
            ELSE "2020 - Present"
            END AS period, 
            ROUND(AVG(Run_time), 2) AS avg_runtime,
            ROUND(AVG(b.box_office_worldwide), 2) AS avg_box_office 
FROM pixar_films AS p LEFT JOIN box_office AS b 
ON p.film = b.film
GROUP BY period
ORDER BY avg_box_office DESC;

-- (c) Are certain genres more likely to receive higher critic or audience scores?
SELECT g.value, ROUND(AVG(p.metacritic_score), 1) AS avg_critic, ROUND(AVG(p.imdb_score), 1) AS avg_audience_score FROM public_response AS p
JOIN genres AS g
ON p.film = g.film
WHERE category = "Genre"
GROUP BY g.value
ORDER BY avg_critic DESC, avg_audience_score DESC;



-- 5. Creative Team Contributions:
-- (a) Who are the most frequent directors and writers in Pixar's history?
WITH CTE AS (
SELECT name, role_type, COUNT(name) AS frequency FROM cleaned_pixar_people
WHERE role_type IN ("Director", "Screenwriter", "Storywriter")
GROUP BY name, role_type
ORDER BY frequency DESC
), Ranked_Table AS (
SELECT *, RANK() OVER(partition by role_type ORDER BY frequency DESC) AS Ranking FROM CTE
) 
SELECT name, role_type, frequency FROM Ranked_Table WHERE Ranking = 1;


-- (b) Is there a correlation between specific creators and the success of films?
with cte as (
select film, count(name) AS No_of_creators from cleaned_pixar_people
group by film
) SELECT c.film, c.No_of_creators, ROUND(((box_office_worldwide - budget)/budget) * 100, 2) AS success_rate FROM box_office AS b
join cte as c on b.film = c.film
order by success_rate desc;


-- (c) Which individuals have worked on the most financially successful and critically acclaimed Pixar films?

-- Individuals that worked on the most financially successful film
WITH CTE AS (
SELECT film, ROUND(((box_office_worldwide - budget)/budget) * 100, 2) AS success_rate FROM box_office
ORDER BY success_rate DESC LIMIT 1
)
SELECT cp.name, c.film FROM CTE AS c
JOIN cleaned_pixar_people AS cp
ON c.film = cp.film;

-- Individuals that worked on critically acclaimed films (IMDB score above 8.0 is referred to as critically acclaimed)
SELECT c.name, b.film, b.imdb_score FROM cleaned_pixar_people AS c
JOIN public_response AS b
ON c.film = b.film
WHERE b.imdb_score > 8.0
ORDER BY b.imdb_score DESC;

SELECT * FROM academy;
SELECT * FROM box_office;
SELECT * FROM genres;
SELECT * FROM pixar_films;
SELECT * FROM cleaned_pixar_people;  
SELECT * FROM pixar_people;  
SELECT * FROM public_response;

SELECT p.film, b.film from pixar_films as p
left join box_office as b on p.film = b.film;