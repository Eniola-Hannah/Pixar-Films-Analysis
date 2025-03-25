# PIXAR FILM ANALYSIS
---
![Pixar_works_of_art](https://github.com/user-attachments/assets/db838641-5aaa-4989-b865-c08b88a8a43f)

## Table of contents
- [Introduction](#Introduction)
- [Project Overview](#Project-Overview)
- [Data Dictionary](#Data-Dictionary)
- [Project Objective](#Project-Objective)
- [Data Cleaning](#Data-Cleaning)
- [Data Exploration and Insights](#Data-Exploration-and-Insights)
- [Recommendations](#Recommendations)
- [Files Details](#Files-Detail)
- [Conclusion](#Conclusion)

## Introduction
Pixar has built a reputation for producing high-quality animated films that captivate audiences worldwide. 
This project aims to analyze the performance of Pixar films across various dimensions, including financial success, audience reception, critical acclaim, 
and creative contributions.


## Project-Overview
The dataset comprises multiple CSV files, each containing different aspects of Pixar films, 
such as box office earnings, audience ratings, critical scores, awards, and creative team contributions.


### Initial Data Shape (Before Cleaning):
- pixar_films.csv: 28 rows, 6 columns
- box_office.csv: 27 rows, 5 columns
- academy.csv: 89 rows, 3 columns
- pixar_people.csv: 260 rows, 3 columns
- genres.csv: 204 rows, 3 columns
- public_response.csv: 28 rows, 8 columns


## Data-Dictionary

| Table           | Columns/Fields                  | Description                                                |
|----------------|-----------------------|-----------------------------------------------------------|
| pixar_films     | number                 | Unique identifier for each Pixar film, in order of release |
| pixar_films     | film                   | Title of the Pixar film                                    |
| pixar_films     | release_date           | Release date of the film                                   |
| pixar_films     | run_time               | Duration of the film in minutes                            |
| pixar_films     | film_rating            | Official film rating (e.g., G, PG, PG-13)                  |
| pixar_films     | plot                   | Short summary of the film’s story                          |
| pixar_people    | film                   | Title of the Pixar film                                    |
| pixar_people    | role_type              | Role of the person (e.g., director, producer)              |
| pixar_people    | name                   | Name of the individual                                     |
| genres          | film                   | Title of the Pixar film                                    |
| genres          | category               | Genre or Subgenre                                          |
| genres          | value                  | Genre or Subgenre type (e.g., Animation, Adventure)        |
| box_office      | film                   | Title of the Pixar film                                    |
| box_office      | budget                 | Estimated production budget                                |
| box_office      | box_office_us_canada   | Box office earnings in the US and Canada                   |
| box_office      | box_office_other       | Box office earnings outside the US and Canada              |
| box_office      | box_office_worldwide   | Total worldwide box office earnings                        |
| public_response | film                   | Title of the Pixar film                                    |
| public_response | rotten_tomatoes_score  | Rotten Tomatoes critic score (out of 100)                  |
| public_response | rotten_tomatoes_counts | Number of reviews on Rotten Tomatoes                       |
| public_response | metacritic_score       | Metacritic critic score (out of 100)                       |
| public_response | metacritic_counts      | Number of reviews on Metacritic                            |
| public_response | cinema_score           | CinemaScore rating (e.g., A+, A, B)                        |
| public_response | imdb_score             | IMDb user rating (out of 10)                               |
| public_response | imdb_counts            | Number of user ratings on IMDb                             |
| academy         | film                   | Title of the Pixar film                                    |
| academy         | award_type             | Type of Academy Award (e.g., Best Animated Feature)        |
| academy         | status                 | Status of the award (e.g., won, nominated)                 |



## Project-Objective
With the evolution of the entertainment industry, analyzing Pixar films' performance is crucial. This project aims to address the following Objectives

1. Financial Performance
   - What are the top 5 highest-grossing Pixar films worldwide?
   - How have Pixar films performed financially over the years? What is the relationship between budget and box office earnings? Which films were the most profitable
   - How does budget correlate with box office performance across different regions (US/Canada vs. International)?
   - Which films achieved the highest return on investment (ROI), and how does this compare across different decades?

2. Audience and Critical Reception
   - How do audience ratings (IMDB, Rotten Tomatoes, Metacritic) correlate with box office earnings?
   - What is the distribution of Pixar films by CinemaScore rating, and how does it impact financial success?
   - Have audience ratings improved or declined over the years?

3. Awards and Recognition
   - Which Pixar films have won or been nominated for Academy Awards?
   - How does winning an Oscar impact a film's financial success?
   - Which directors and writers have worked on the most award-winning Pixar films?

4. Genre Trends and Film Characteristics
   - Which genres (Adventure, Comedy, Fantasy, etc.) are most common among Pixar films?
   - What is the average runtime of Pixar films over different periods, and does it affect box office performance?
   - Are certain genres more likely to receive higher critic or audience scores?

5. Creative Team Contributions
   - Who are the most frequent directors, writers, and composers in Pixar's history?
   - Is there a correlation between specific creators and the success of films?
   - Which individuals have worked on the most financially successful and critically acclaimed Pixar films?


## Data-Exploration-and-Insights
During data cleaning, the following changes were made:
- Standardizing Date formats
```sql
SET SQL_SAFE_UPDATES = 0;
UPDATE pixar_films
SET Release_date = STR_TO_DATE(Release_date, "%m/%d/%YYYY");

ALTER TABLE pixar_films
MODIFY COLUMN Release_date DATE;
```
- checking for duplicates
```sql
SELECT film, role_type, name, COUNT(*) AS count FROM pixar_people    
GROUP BY film, role_type, name
HAVING COUNT(*) > 1;

-- Duplicate values present!
```
- Insert into a new table Pixar_people records that contains no duplicate
```sql
CREATE TABLE cleaned_pixar_people AS SELECT DISTINCT * FROM pixar_people;
```
- Exports as an external file and the re-imported back to the workbench
```
SELECT * FROM cleaned_pixar_people;
```
---


## Data-Insights

For each of the key business questions, SQL queries were used to extract meaningful insights:

### Financial Analysis
a. The top 5 highest-grossing pixar films are 
   - 'Inside Out 2' with a figure of 1698030965
   - 'Incredibles 2' with a figure of 1242805359
   - 'Toy Story 4' with a figure of 1073394593
   - 'Toy Story 3' with a figure of 1066969703
   - 'Finding Dory' with a figure of 1028570889


b. Over the years, Pixar films have performed remarkably well financially, with 17 generating high profits, 7 yielding lower profits, and only 4 resulting in losses. 
Found the relationship between budget and box office earning:
   - 12 films happen to be 'block busters'
   - 8 films were a 'Hit'
   - 2 films were 'Break even'
   - 5 films were a 'flop'

     
c. No Significant correlation btwn Budget and box office. Correlation coefficient is about 0.2 


d. ROI analysis revealed the most profitable films... 'Toy story' has the highest with 1214.79% Return on investment

### Audience & Critical Reception
a. A weak positive correlatin between Critics(IMDB, Rotten tomatoes, Metacritics) and box office revenue


b. Distribution of films by CinemaScore rating
  - Films with 'A' Cinemascore rating are 15
  - Films with 'A+' Cinemascore rating are 7
  - Films with 'A-' Cinemascore rating are 3
  - Films with 'NA' (Not Available) Cinemascore rating are 3


  - A+ Has the highest box office earning on an average meaning CinemaScore rating impacts the financial success of a film.

    
c.

### Awards and Recognition
a. About 22 films has either been nominated or won an Oscare Award.


b. Films with Oscars tend to perform better financially.


c. Certain directors have consistently worked on award-winning films.

### Genre Trends
a. Adventure and Animation are dominant genres, followed by Comedy.


b. Longer runtimes result in higher earnings.


c. Family and drama tend to receive higher critic and audience scores.

### Creative Team Contributions
a. Identified the most frequent directors and writers.
  - John Lasseter as the most frequent director
  - Randy Newman as the most frequent musician
  - Andrew Stanton as the most frequent writer.

    
b. Kelsey Mann, Andrea Datzman, Dave Holstein were the creators with the most financial success of pixar films


c. Analyzed individuals that worked on the most financially successful film (Inside out 2) and individuals that worked on critically acclaimed films (IMDB score above 8.0 is critically acclaimed)


## Recommendations
- Pixar films with A or A+ CinemaScore (strong audience approval) tend to bring in the most revenue. It is important to prioritize audience engagement strategies by maintaining high storytelling quality, character development, and emotional depth in future films. 
- Increase investment in genres that historically perform well.
- Leverage successful directors and writers for future projects
- Optimize budget allocation to maximize ROI.
- Enhance audience engagement strategies to maintain high ratings.



## Files-Detail

| File Name                     | Description |
|--------------------------------|-------------|
| `Business Problem Statement.docx` | Objective of the Analysis. |
| `Query.sql`                   | Contains SQL scripts for data extraction and analysis. |
| `pixar_films.csv`             | Contains core details about each Pixar film. |
| `box_office.csv`              | Financial performance data. |
| `academy.csv`                 | Academy Award nominations and wins. |
| `genres.csv`                  | Film genre classifications. |
| `public_response.csv`         | Audience ratings and critic scores. |
| `pixar_people.csv`           | Information about key contributors (directors, writers, etc.)... Contains duplicate records. |
| `cleaned_pixar_people.csv`   | Information about key contributors (directors, writers, etc.)... With no duplicates. |
| `README.md`                   | Project documentation, including objectives, data details, analysis, and insights. |


## Conclusion
This project provides a comprehensive analysis of Pixar films, offering valuable insights into financial performance, audience reception, awards, genre trends, and creative team contributions. The findings will help guide strategic decision-making for future Pixar productions.
