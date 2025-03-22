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