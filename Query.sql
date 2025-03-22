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