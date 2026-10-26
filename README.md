# EX 603 Movie/TV Database

## Project Summary

This project models a relational database for a Movie/TV platform where users can rate movies and movies can be classified into different genres. The database is designed to store users, movies, ratings, genres, and the relationships between movies and genres.

**Theme:** Movie / TV

## Domain

The Movie/TV platform allows users to interact with a catalog of movies by submitting ratings. The database must keep track of each user, the movies available on the platform, and the ratings users submit. Each rating connects a user to a movie and records a score that can later be used to analyze user preferences and movie performance.

Movies can belong to multiple genres, such as comedy, drama, action, or science fiction, and each genre can contain many movies. Because of this many-to-many relationship, the database uses a separate movie-genres relationship to connect movies and genres.

The database must support questions such as which movies a user has rated, what ratings a movie has received, what a movie's average rating is, and which movies belong to a particular genre.

The design uses five main roles: users as the actor, movies as the producer, ratings as the event, genres as the catalog, and movie_genres as the junction between movies and genres.

## Schema

The Entity Relationship Diagram below shows the relationships between Users, Ratings, Movies, Movie Genres, and Genres.

[Movie/TV Database ERD](https://github.com/SarahTheeb2006/ex603-movie-tv-database/blob/main/schema/erd.png) ([image](https://github.com/SarahTheeb2006/ex603-movie-tv-database/raw/main/schema/erd.png))

## Unit 2 – SQL Schema Implementation

In Unit 2, the conceptual database design from Unit 1 was implemented as a PostgreSQL schema. The schema creates the five tables used by the Movie/TV database: `users`, `movies`, `ratings`, `genres`, and `movie_genres`.

The implementation includes primary keys, foreign keys, `NOT NULL`, `UNIQUE`, and `CHECK` constraints to maintain data integrity. Foreign key relationships also include `ON DELETE CASCADE` where dependent records should be removed when their related parent record is deleted.

The SQL script includes a reset block using `DROP TABLE IF EXISTS` so that the complete schema can be executed multiple times without requiring manual cleanup. The script was tested in PostgreSQL 18 and successfully executed twice in a row.

### Unit 2 Files

- [`schema/schema.sql`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/blob/main/schema/schema.sql) – Complete PostgreSQL DDL for the database.
- [`analysis/unit2.md`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/blob/main/analysis/unit2.md) – Explanation of foreign key actions and CHECK constraints.
- [`screenshots/`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/tree/main/screenshots) – PostgreSQL execution and verification screenshots.

### Verification

The schema was tested by running `schema.sql` twice consecutively. The second execution successfully dropped and recreated all five tables. The PostgreSQL `\dt` command was then used to confirm that all five tables were created successfully.

## Unit 3 – SQL Query Investigation

Unit 3 focuses on investigating the Movie/TV database through SQL queries and identifying potential problems in database reporting.

The investigation includes exploratory queries, reproducing SQL errors, and implementing corrected queries using different SQL techniques.

### Unit 3 Files

- `queries/unit3/q3_1.sql` – Exploratory queries using filtering, comparisons, and calculated expressions.
- `queries/unit3/q3_2.sql` – Demonstration of SQL errors and unexpected query behavior.
- `queries/unit3/q3_3.sql` – Corrected query implementations using JOIN, EXISTS, and Common Table Expressions.
- `analysis/unit3-finding.md` – Investigation findings and explanation of the reporting issue.

### Unit 3 Findings

The investigation demonstrated how SQL logic and filtering decisions can affect the accuracy of database reporting.

The analysis emphasized the importance of handling NULL values correctly, using appropriate query conditions, and validating results before presenting information to decision-makers.

These findings provided a foundation for the aggregate analysis and reviewer performance investigation completed in Unit 4.

## Unit 4 – Aggregate Analysis and Leadership Reporting

Unit 4 investigates the Movie/TV platform's confirmed policy-violation rate and examines differences in reviewer performance.

The analysis uses PostgreSQL aggregate functions, grouping, conditional aggregation, ROLLUP, and Common Table Expressions (CTEs).

The purpose of this investigation is to provide leadership with accurate platform-wide statistics, identify reviewers whose activity may require further investigation, and demonstrate how SQL aggregation supports evidence-based decision-making.

### Unit 4 Query Catalogue

| **File** | **Task** | **Business Question** |
|---|---|---|
| `queries/unit4/q4_1.sql` | 4.1.1 | What are the overall rating statistics, and how many distinct reviewers contributed ratings? |
| `queries/unit4/q4_1.sql` | 4.1.2 | How many ratings did each reviewer submit, and what was their average score? |
| `queries/unit4/q4_1.sql` | 4.1.3 | Which reviewers meet the minimum activity threshold, and what are their confirmed failure rates? |
| `queries/unit4/q4_1.sql` | 4.1.4 | How do rating activity and confirmed failure rates vary by reviewer and device country? |
| `queries/unit4/q4_2.sql` | 4.2A | How many total ratings and confirmed policy violations does each reviewer have? |
| `queries/unit4/q4_2.sql` | 4.2B | What are the regional subtotals and platform-wide grand total? |
| `queries/unit4/q4_2.sql` | 4.2C | What is the combined confirmed failure rate among reviewers with at least five ratings? |

### Analysis and Findings

- [`analysis/unit4.md`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/blob/main/analysis/unit4.md) – Explains the aggregate analysis, reviewer comparisons, regional breakdown, and conditional aggregation reflection.
- [`analysis/unit4-finding.md`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/blob/main/analysis/unit4-finding.md) – Presents findings for leadership and identifies reviewers recommended for additional investigation.

### Platform-Wide Results

The PostgreSQL analysis verified the following platform-wide statistics:

| **Metric** | **Result** |
|---|---|
| Total Ratings | 200 |
| Total Score | 569.3 |
| Average Score | 2.85 |
| Minimum Score | 0.5 |
| Maximum Score | 5.0 |
| Unique Reviewers | 30 |
| Confirmed Policy Violations | 8 |
| Platform-Wide Failure Rate | 4.00% |

The verified platform-wide failure rate was calculated by dividing the eight confirmed policy violations by the 200 total ratings and multiplying by 100.

This calculation provides a consistent baseline for comparing reviewer performance and regional results.

### Reviewer Performance Findings

The reviewer-level analysis identified five reviewers with confirmed policy violations.

| **Producer ID** | **Total Ratings** | **Confirmed Failures** | **Failure Rate** |
|---|---|---|---|
| 8 | 9 | 3 | 33.33% |
| 23 | 11 | 2 | 18.18% |
| 22 | 6 | 1 | 16.67% |
| 28 | 8 | 1 | 12.50% |
| 16 | 11 | 1 | 9.09% |

Producer 8 recorded the highest number of confirmed violations, with three violations across nine ratings.

Producer 23 followed with two violations across eleven ratings.

Producers 22, 28, and 16 each recorded one confirmed violation.

Based on the observed violation counts and failure rates, producers 8, 23, and 22 were identified as priorities for further investigation.

These results do not independently establish misconduct. Additional review of individual records is necessary before corrective actions are considered.

### Regional Performance Findings

The regional analysis used PostgreSQL ROLLUP to calculate country-level statistics and the platform-wide grand total.

| **Region** | **Total Ratings** | **Confirmed Failures** | **Failure Rate** |
|---|---|---|---|
| Brazil | 39 | 1 | 2.56% |
| India | 40 | 2 | 5.00% |
| UK | 40 | 1 | 2.50% |
| US | 38 | 2 | 5.26% |
| Vietnam | 43 | 2 | 4.65% |
| **Grand Total** | **200** | **8** | **4.00%** |

The United States had the highest observed regional failure rate at 5.26%, while the United Kingdom had the lowest at 2.50%.

The regional findings demonstrate how grouping data by device country can reveal differences that are not immediately visible in platform-wide averages.

### Minimum Activity Threshold

The analysis also evaluated reviewers who submitted at least five ratings.

The results identified:

- 24 qualifying reviewers.
- 183 total ratings among qualifying reviewers.
- Eight confirmed policy violations.
- A combined confirmed failure rate of 4.37%.

The 4.37% failure rate was calculated using the combined number of confirmed violations divided by the combined number of ratings from qualifying reviewers.

This result differs from the platform-wide rate of 4.00% because the minimum activity threshold excludes reviewers with fewer than five ratings.

### Unit 4 Screenshots

The following screenshots document the execution and results of the seven Unit 4 SQL tasks:

- `screenshots/q4_1_1.png` – Platform-wide aggregate statistics.
- `screenshots/q4_1_2.png` – Reviewer rating counts and average scores.
- `screenshots/q4_1_3.png` – Reviewer failure rates with minimum activity threshold.
- `screenshots/q4_1_4.png` – Reviewer performance by device country.
- `screenshots/q4_2_A.png` – Conditional aggregation of confirmed violations.
- `screenshots/q4_2_B.png` – Regional ROLLUP and grand total.
- `screenshots/q4_2_C.png` – Combined failure rate for qualifying reviewers.

All screenshots are available in the [`screenshots/`](https://github.com/SarahTheeb2006/ex603-movie-tv-database/tree/main/screenshots) directory.

### Key Findings

The Unit 4 investigation confirmed that the Movie/TV platform contained 200 ratings and eight confirmed policy violations, resulting in a verified platform-wide failure rate of 4.00%.

The reviewer-level breakdown identified producers 8, 23, and 22 as priorities for additional investigation based on their observed failure counts and rates.

Regional analysis showed that confirmed failure rates varied across device countries, with the United States recording the highest observed regional rate of 5.26%.

The minimum activity threshold analysis identified 24 qualifying reviewers with 183 ratings and eight confirmed violations, producing a combined failure rate of 4.37%.

These findings demonstrate the importance of accurate SQL aggregation, appropriate grouping, and careful interpretation of summary statistics.

## Conclusion

The EX 603 Movie/TV Database project demonstrates the design, implementation, and analysis of a relational database using PostgreSQL.

The project progressed from developing a relational schema to investigating SQL query behavior and performing aggregate analysis for leadership reporting.

Unit 4 established a verified platform-wide failure rate and identified reviewer-level differences that warrant further examination.

By combining SQL queries, documented analysis, and supporting screenshots, the project provides a transparent and reproducible approach to database investigation and reporting.
