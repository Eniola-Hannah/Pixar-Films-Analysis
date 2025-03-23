# PIXAR FILM ANALYSIS
---
![Pixar_works_of_art](https://github.com/user-attachments/assets/db838641-5aaa-4989-b865-c08b88a8a43f)

## Table of contents
- [Introduction](#Introduction)
- [Project Overview](#Project-Overview)
- [Data Disctionary](#Data-Dictionary)
- [Project Objective](#Project-Objective)
- [Data Cleaning](#Data-Cleaning-and-Transformation)
- [Data Exploration and Insights](#Data-Exploration-and-Insights)
- [Recommendation](#Recommendation)
- [Files Details](#Files-Details)
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


## Project Objectives
With the evolution of the entertainment industry, analyzing Pixar films' performance is crucial. This project aims to address the following questions:

### Financial Performance
- What are the top 5 highest-grossing Pixar films worldwide?
- How has Pixar's financial performance changed over the years?
- What is the relationship between budget and box office earnings?
- Which films achieved the highest return on investment (ROI)?

### Audience and Critical Reception
- How do audience ratings (IMDB, Rotten Tomatoes, Metacritic) correlate with box office earnings?
- What is the distribution of Pixar films by CinemaScore rating?
- Have audience ratings improved or declined over the years?

### Awards and Recognition
- Which Pixar films have won or been nominated for Academy Awards?
- How does winning an Oscar impact a film's financial success?
- Genre Trends and Film Characteristics
- Which genres are most common among Pixar films?
- What is the average runtime of Pixar films, and does it affect box office performance?

### Creative Team Contributions
- Who are the most frequent directors, writers, and composers in Pixar’s history?
- Is there a correlation between specific creators and the success of films?
