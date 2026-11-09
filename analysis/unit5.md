# EX603 Unit 5 — SQL Joins and Platform Analysis

## Task 5.1: Connecting Platform Data

### Question 1: Three-Table Join

For this task, I used an INNER JOIN to connect the users, ratings, and movies tables. The query displayed the user who submitted each rating, the associated movie, the rating score, and the date of the rating.

This information could support a movie-rating activity dashboard. Administrators could use the report to monitor rating activity, identify frequently rated movies, and investigate unusual rating patterns.

### Question 2: Junction Table

I used the movie_genres junction table to connect movies with their associated genres. This table is important because a movie can belong to multiple genres, and each genre can be associated with multiple movies.

Without the junction table, managing these many-to-many relationships would be more difficult and could introduce duplicated information.

### Question 3: Self Join

I used a self join to compare users from the same country and examine differences in their rating activity.

The results demonstrated that users sharing the same country can have different numbers of ratings. This comparison could help administrators identify activity patterns, although further investigation would be necessary to explain the differences.

## Task 5.2: Identifying Missing Records

### Part A: INNER JOIN vs. LEFT JOIN

The LEFT JOIN returned all 30 users, including any users without ratings. The INNER JOIN also returned 30 users.

The comparison confirmed that zero users were excluded by the INNER JOIN.

**Results:**

- Total users: 30
- Users with ratings: 30
- Users excluded: 0

No user identifiers were missing because every user had at least one associated rating.

### Part B: RIGHT JOIN and FULL OUTER JOIN

The RIGHT JOIN returned the same 30 users and rating counts as the LEFT JOIN.

The FULL OUTER JOIN also returned 30 user groups. Unlike a LEFT JOIN or RIGHT JOIN alone, a FULL OUTER JOIN can reveal unmatched records from both tables.

### Part C: NOT EXISTS and EXCEPT

Both NOT EXISTS and EXCEPT returned zero rows, confirming that no users without ratings were identified.

NOT EXISTS checks whether a matching rating record is absent for each user. EXCEPT subtracts users with ratings from the complete set of users.

Both approaches produced the same result.

### Leadership Implications

A report relying only on INNER JOIN could exclude users who have never submitted ratings, giving leadership an incomplete understanding of platform participation.

Although no inactive users were identified in this dataset, identifying such users in future analyses could help leadership investigate onboarding difficulties, account inactivity, or engagement barriers.

The available data establishes whether users have ratings but does not independently explain why someone might be inactive.

## Task 5.3: CROSS JOIN and Query Execution

### Part A: CROSS JOIN

For this task, I used a CROSS JOIN to combine five movies with five genres. The query returned 25 rows, which matched the expected result of multiplying the number of rows in each dataset (5 × 5 = 25).

Each movie was paired with every genre, regardless of whether the movie was actually assigned to that genre. This demonstrates how CROSS JOIN creates a Cartesian product without requiring a matching condition.

CROSS JOIN can be useful when generating all possible combinations, but it can also produce unnecessarily large datasets if used without careful planning.

### Part B: Three-Table Join and Execution Plan

I used EXPLAIN to examine how PostgreSQL planned to execute a query joining the ratings, users, and movies tables.

The execution plan included a Hash Join to connect ratings with users, followed by a Nested Loop to connect the intermediate results with movies.

PostgreSQL also used an Index Scan on the movies primary key and a Memoize operation to cache movie lookups.

Finally, the query plan included a Sort operation to order ratings by their submission date and rating ID, followed by a Limit operation to return the 20 most recent records.

This demonstrated that PostgreSQL can combine different join strategies and indexing techniques to execute a multi-table query.

## Unit 5 Reflection

Throughout Unit 5, I developed a stronger understanding of how SQL joins affect both the accuracy and completeness of database reports. Working with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN helped me recognize that selecting the wrong join type can unintentionally exclude important records.

One finding that stood out was that all 30 users in my dataset had submitted at least one rating. Although the INNER JOIN and LEFT JOIN returned identical results, I learned that this would not necessarily happen in a database containing inactive users. This reinforced the importance of checking for missing records rather than assuming that all users have related activity.

I also gained experience using NOT EXISTS and EXCEPT to identify missing relationships. Both approaches returned zero users without ratings, confirming the results of my earlier queries.

The CROSS JOIN exercise demonstrated how quickly result sets can grow when every record is combined with every other record. Finally, examining PostgreSQL's execution plan introduced me to Hash Joins, Nested Loops, Index Scans, and query optimization.

Overall, this assignment helped me understand how SQL queries can support more reliable reporting and better decision-making. In future projects, I will pay closer attention to join selection, missing data, and query performance.
