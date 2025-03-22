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