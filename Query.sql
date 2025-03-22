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
SELECT Year(p.Release_date) AS Movie_year, c.film, C.PROFIT, CASE 
WHEN c.profit > c.budget * 2 THEN "High profit" WHEN c.profit > 0 THEN "Low profit" ELSE "Loss" END AS financial_performance
FROM CTE AS c INNER JOIN pixar_films AS p
ON c.film = p.film
ORDER BY Movie_year;

SELECT film, budget, box_office_worldwide, CASE 
			WHEN box_office_worldwide < (budget * 2) THEN "Flop"                                   -- Lost money or barely recovered costs
			WHEN box_office_worldwide BETWEEN (budget * 2) AND (budget * 2.5) THEN "Break Even"    -- Covered costs but no major profit
			WHEN box_office_worldwide BETWEEN (budget * 2.5) AND (budget * 4.5) THEN "Hit"         --  Profitable, made good returns
            WHEN box_office_worldwide > (budget * 4.5) THEN "Block buster"                         -- A massive success, major profits
			END AS relationship_term FROM box_office
ORDER BY box_office_worldwide;

WITH CTE AS (
SELECT film, budget, box_office_worldwide, CASE
			WHEN box_office_worldwide < (budget * 2) THEN "Flop"    
			WHEN box_office_worldwide BETWEEN (budget * 2) AND (budget * 2.5) THEN "Break Even"
			WHEN box_office_worldwide BETWEEN (budget * 2.5) AND (budget * 4.5) THEN "Hit"
            WHEN box_office_worldwide > (budget * 4.5) THEN "Block buster"
			END AS relationship_term FROM box_office
ORDER BY box_office_worldwide
) 
SELECT film AS profitable_films FROM CTE
WHERE relationship_term = "Block buster";

       

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
-- Lag function


-- 3.	Awards and Recognition:
-- (a) Which Pixar films have won or been nominated for Academy Awards?
SELECT film, award_type, status FROM academy
WHERE status in ("Won", "Nominated");

-- (b) How does winning an Oscar impact a film's financial success?
SELECT CASE 
		WHEN a.status = "won" THEN "Oscar_winners"
        ELSE "Non_Oscar_winners"
        END AS Oscar, 
        ROUND(AVG(b.box_office_us_canada), 2) AS avg_us_canada_finance,
        ROUND(AVG(b.box_office_other), 2) AS Avg_international_finace,
        ROUND(AVG(b.box_office_worldwide), 2) AS Avg_worldwide_finace
FROM academy AS a LEFT JOIN box_office AS b
ON a.film = b.film
GROUP BY  a.status
ORDER BY Avg_worldwide_finace DESC;
        
-- Oscar winning films has the highest financial success


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
SELECT c.name, c.role_type, m.film FROM cleaned_pixar_people AS c
JOIN most_award_winning_film AS m
ON m.film = c.film
WHERE role_type IN ("Director", "Screenwriter", "Storywriter");


-- 4.	Genre Trends and Film Characteristics:
-- (a) Wich genres (Adventure, Comedy, Fantasy, etc.) are most common among Pixar films?
SELECT value, COUNT(value) AS count FROM genres
WHERE category = "Genre"
GROUP BY value
ORDER BY count DESC;

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



SELECT * FROM academy;
SELECT * FROM box_office;
SELECT * FROM genres;
SELECT * FROM pixar_films;
SELECT * FROM cleaned_pixar_people;  
SELECT * FROM box_office;
SELECT * FROM public_response;