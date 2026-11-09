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
