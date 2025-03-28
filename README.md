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

### 1. Financial Analysis
**a.** Top 5 Highest-Grossing Pixar Films
The top five highest-grossing Pixar films based on worldwide box office revenue are:
- Inside Out 2 – $1,698,030,965
- Incredibles 2 – $1,242,805,359
- Toy Story 4 – $1,073,394,593
- Toy Story 3 – $1,066,969,703
- Finding Dory – $1,028,570,889


**b.** Financial Performance of Pixar Films
Over the years, Pixar films have performed remarkably well at the box office:
   - 17 films generated high profits
   - 7 films yielded lower profits
   - 4 films resulted in losses


There are some terms in the film industry used to define the relationship between budget and box office earning, they include;
   - flop: A movie that fails financially.
   - Break-even: Covered costs but no profit whatsoever
   - Hit: Profitable, made good returns
   - Blockbuster: A massive success, major profits


Among Pixar films:
   - 22 films were classified as Blockbusters
   - 2 films were classified as Hits
   - 3 films were classified as Flops

     
**c.** Budget vs. Box Office Earnings Correlation
There is a weak positive correlation between a film’s budget and its box office earnings in different regions:
   - US/Canada Region – Correlation coefficient: 0.1999
   - International Region – Correlation coefficient: 0.3389


Correlation values between 0.1 and 0.3 indicate a weak positive correlation, meaning budget alone does not significantly influence box office earnings. Other factors, such as film stars, marketing/publicity, and regional audience preferences, may play a more significant role in a film’s success.


**d.** Top Films by ROI (Return on Investment)
ROI measures a film’s profitability relative to its budget. The top 5 most profitable Pixar films, ranked by ROI, are:
   - Toy Story – 1214.79%
   - Finding Nemo – 826.61%
   - Inside Out 2 – 749.02%
   - The Incredibles – 586.35%
   - Incredibles 2 – 521.40%


ROI Comparison Across Decades
A decade-wise comparison shows that the 1990s had the highest average ROI, indicating the most profitable era for Pixar films:
   - 1990s – 428.77% 
   - 2000s – 372.28%
   - 2010s – 314.51%
   - 2020s – 146.05%


This trend suggests that earlier Pixar films had higher profitability relative to their budgets, while more recent productions, despite high earnings, may have faced increased production and marketing costs, affecting ROI.



### 2. Audience & Critical Reception
**a.** Correlation Between Critics’ Ratings and Box Office Revenue
There is a weak positive correlation between a film’s ratings from critics and its box office earnings:
   - IMDB vs. Box Office – Correlation coefficient: 0.2962
   - Rotten Tomatoes vs. Box Office – Correlation coefficient: 0.2294
   - Metacritic vs. Box Office – Correlation coefficient: 0.2152


Since correlation values between 0.1 and 0.3 indicate a weak positive relationship, this suggests that critics' ratings (IMDB, Rotten Tomatoes, and Metacritic) do not significantly impact box office revenue.

However, CinemaScore appears to have a stronger impact on box office earnings than critics' ratings, making it a more reliable indicator of a film’s financial success.

**b.** Distribution of Films by CinemaScore Rating
CinemaScore ratings reflect audience satisfaction based on surveys conducted at movie theaters. Here’s how Pixar films are distributed based on their CinemaScore ratings:   - Films with ‘A’ CinemaScore rating: 15
   - Films with ‘A+’ CinemaScore rating: 7
   - Films with ‘A-’ CinemaScore rating: 3
   - Films with ‘NA’ (Not Available) CinemaScore rating: 3


This distribution highlights that the majority of Pixar films receive high audience approval, with most earning ‘A’ or ‘A+’ ratings, reinforcing their strong connection with viewers.


A further analysis was made of average worldwide box office earnings per CinemaScore rating which shows that films with an A+ rating generate the highest average revenue, suggesting that a CinemaScore of A+ positively impacts a film’s financial success.
   - A+	: 762162029.86
   - A	: 705627954.13
   - A-	: 309405952.67
   - NA	: 71858621.50



This reinforces the idea that audience sentiment at cinemas (CinemaScore) is a stronger predictor of box office success than critics' reviews.
    
**c.** Trend in Audience Ratings Over the Years
An analysis of audience ratings over time reveals that there has been no consistent improvement or decline. The number of films with improved ratings is equal to those with declined ratings, indicating a fluctuating trend rather than a clear upward or downward movement.
   - First Rating: 1 (Initial baseline)
   - Declined Rating: 13
   - Improved Rating: 13
   - No Change: 1


This suggests that audience perception of Pixar films has remained relatively stable over time, with both positive and negative shifts occurring in equal measure.


### 3. Awards and Recognition
**a.** Top Pixar Films with Awards and Nominations
The following Pixar films have received the most academy awards and nominations, making them the most critically recognized in the studio’s history:
   - Monsters, Inc.
   - Finding Nemo
   - The Incredibles
   - Ratatouille
   - WALL-E
   - Up

**b.** The Impact of Winning an Oscar on Box Office Success
Winning an Oscar appears to have a significant impact on a film’s financial success. To analyze this, a new column was added to the Academy Awards table to classify films as Oscar winners or non-winners:
```sql
ALTER TABLE academy
ADD COLUMN Oscar TEXT;

SET SQL_SAFE_UPDATES = 0;
UPDATE academy
SET Oscar = CASE WHEN status in ("Won", "Won Special Achievement")
                 THEN "Oscar_winners" ELSE "Non_Oscar_winners"
            END;
```
With this new classification, further analysis was conducted to compare box office earnings on an average between Oscar-winning and non-winning films. The results indicate that Oscar-winning films tend to generate higher box office revenue, confirming the award’s influence on a film’s financial performance.
| **Oscar Status**       | **Avg. US/Canada Revenue** | **Avg. International Revenue** | **Avg. Worldwide Revenue** |
|------------------------|--------------------------|------------------------------|----------------------------|
| **Oscar Winners**      | $257,697,958.94          | $417,266,685.56              | $674,964,644.50            |
| **Non-Oscar Winners**  | $257,653,942.30          | $365,363,477.49              | $623,017,419.80            |



**c.** Pixar Films with the Most Academy Award Wins

The following Pixar films have won the most Academy Awards, along with their directors and writers:

- **🏆 The Incredibles**  
  -  Brad Bird (Director & Writer)

- **🏆Up**  
  - Pete Docter (Director)  
  - Bob Peterson (Writer)  
  - Tom McCarthy (Writer)  

- **🏆 Toy Story 3**  
  - Lee Unkrich (Director)  
  - Michael Arndt (Writer)  
  - John Lasseter (Writer)  
  - Andrew Stanton (Writer)  

- **🏆 Coco**  
  - Lee Unkrich (Director)  
  - Matthew Aldrich (Writer)  
  - Adrian Molina (Writer)  
  - Jason Katz (Writer)  

- **🏆 Soul**  
  - Pete Docter (Director)  
  - Mike Jones (Writer)  
  - Kemp Powers (Writer)  



### 4. Genre Trends  

#### a. Most Common Genres Among Pixar Films  
The most frequent genres in Pixar films are:  
- **Adventure**  - 28 films  
- **Animation**  - 28 films  
- **Comedy**  - 21 films  

Adventure and Animation are the dominant genres, followed closely by Comedy.  


#### b. Average Runtime of Pixar Films Over the Decades  
The average runtime of Pixar films over different periods:  
- **1990 - 1999** : 89.33 minutes  
- **2000 - 2009** : 104.00 minutes  
- **2010 - 2019** : 101.45 minutes  
- **2020 - Present** : 99.86 minutes  

It is safe to say that longer runtimes generally correlate with higher box office performance.  

| **Period**         | **Avg. Runtime (min)** | **Avg. Box Office Revenue** |
|----------------|------------------|----------------------------|
| **2010 - 2019**  | 101.45             | $785,684,220.64             |
| **2000 - 2009**  | 104.00             | $624,764,356.57             |
| **2020 - Present** | 99.86              | $451,092,996.33             |
| **1990 - 1999**  | 89.33              | $423,017,907.00             |

This trend suggests that films with a **longer runtimes (2000 - 2019** tend to generate higher box office revenue.  



c. All pixar films genre have a good positive critic but family and drama tends to receive higher critic or audience scores. 
| Genre   | avg. critic   | avg. audience score |
|--------|--------------|------------------|
|Family	| 95.0	|8.4   |
|Drama	| 81.0	| 8.4  |

### 5. Creative Team Contributions
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
