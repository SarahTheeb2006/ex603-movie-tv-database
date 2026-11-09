
-- EX603 Unit 5: SQL Joins and Platform Analysis
-- Database: ex603_data

-- ==========================================
-- Task 5.1: Connecting Platform Data
-- ==========================================

-- Question 1: Three-table join
-- Show users, movies, and their ratings.

SELECT
    u.user_id,
    u.user_name,
    m.movie_id,
    m.title AS movie_title,
    r.rating_id,
    r.score,
    r.rated_at
FROM ratings AS r
INNER JOIN users AS u
    ON r.user_id = u.user_id
INNER JOIN movies AS m
    ON r.movie_id = m.movie_id
ORDER BY r.rated_at DESC, r.rating_id DESC
LIMIT 20;


-- Question 2: Movies associated with each genre

SELECT
    m.movie_id,
    m.title AS movie_title,
    g.genre_name,
    mg.tagged_on
FROM movies AS m
INNER JOIN movie_genres AS mg
    ON m.movie_id = mg.movie_id
INNER JOIN genres AS g
    ON mg.genre_id = g.genre_id
ORDER BY g.genre_name, m.title
LIMIT 20;


-- Question 3: Compare users from the same country

WITH user_activity AS (
    SELECT
        u.user_id,
        u.user_name,
        u.country,
        COUNT(r.rating_id) AS total_ratings
    FROM users AS u
    LEFT JOIN ratings AS r
        ON u.user_id = r.user_id
    GROUP BY u.user_id, u.user_name, u.country
)
SELECT
    a.user_name AS user_1,
    b.user_name AS user_2,
    a.country,
    a.total_ratings AS user_1_ratings,
    b.total_ratings AS user_2_ratings
FROM user_activity AS a
INNER JOIN user_activity AS b
    ON a.country = b.country
    AND a.user_id < b.user_id
ORDER BY a.country, a.user_id, b.user_id
LIMIT 20;


-- ==========================================
-- Task 5.2: Comparing Join Types
-- ==========================================

-- Part A: LEFT JOIN

SELECT
    u.user_id,
    u.user_name,
    COUNT(r.rating_id) AS total_ratings
FROM users AS u
LEFT JOIN ratings AS r
    ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;


-- Part A: INNER JOIN

SELECT
    u.user_id,
    u.user_name,
    COUNT(r.rating_id) AS total_ratings
FROM users AS u
INNER JOIN ratings AS r
    ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;


-- Part A: Count excluded users

SELECT
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(DISTINCT u.user_id)
     FROM users AS u
     INNER JOIN ratings AS r
         ON u.user_id = r.user_id) AS users_with_ratings,
    (SELECT COUNT(*) FROM users)
    -
    (SELECT COUNT(DISTINCT u.user_id)
     FROM users AS u
     INNER JOIN ratings AS r
         ON u.user_id = r.user_id) AS excluded_users;


-- Part B: RIGHT JOIN

SELECT
    u.user_id,
    u.user_name,
    COUNT(r.rating_id) AS total_ratings
FROM ratings AS r
RIGHT JOIN users AS u
    ON r.user_id = u.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;


-- Part B: FULL OUTER JOIN

SELECT
    u.user_id,
    u.user_name,
    COUNT(r.rating_id) AS total_ratings
FROM users AS u
FULL OUTER JOIN ratings AS r
    ON u.user_id = r.user_id
GROUP BY u.user_id, u.user_name
ORDER BY u.user_id;


-- Part C: Find users without ratings using NOT EXISTS

SELECT
    u.user_id,
    u.user_name
FROM users AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings AS r
    WHERE r.user_id = u.user_id
)
ORDER BY u.user_id;


-- Part C: Find users without ratings using EXCEPT

SELECT
    u.user_id,
    u.user_name
FROM users AS u

EXCEPT

SELECT
    u.user_id,
    u.user_name
FROM users AS u
INNER JOIN ratings AS r
    ON u.user_id = r.user_id
ORDER BY user_id;


-- ==========================================
-- Task 5.3: CROSS JOIN and Query Execution
-- ==========================================

-- Part A: Count CROSS JOIN combinations

WITH
small_movies AS (
    SELECT movie_id, title
    FROM movies
    ORDER BY movie_id
    LIMIT 5
),
small_genres AS (
    SELECT genre_id, genre_name
    FROM genres
    ORDER BY genre_id
    LIMIT 5
)
SELECT
    (SELECT COUNT(*) FROM small_movies) AS movie_count,
    (SELECT COUNT(*) FROM small_genres) AS genre_count,
    (SELECT COUNT(*)
     FROM small_movies
     CROSS JOIN small_genres) AS cross_join_count;


-- Part A: Display CROSS JOIN combinations

WITH small_movies AS (
    SELECT movie_id, title
    FROM movies
    ORDER BY movie_id
    LIMIT 5
),
small_genres AS (
    SELECT genre_id, genre_name
    FROM genres
    ORDER BY genre_id
    LIMIT 5
)
SELECT
    m.movie_id,
    m.title AS movie_title,
    g.genre_id,
    g.genre_name
FROM small_movies AS m
CROSS JOIN small_genres AS g
ORDER BY m.movie_id, g.genre_id;


-- Part B: PostgreSQL execution plan

EXPLAIN
SELECT
    u.user_id,
    u.user_name,
    m.movie_id,
    m.title AS movie_title,
    r.rating_id,
    r.score,
    r.rated_at
FROM ratings AS r
INNER JOIN users AS u
    ON r.user_id = u.user_id
INNER JOIN movies AS m
    ON r.movie_id = m.movie_id
ORDER BY r.rated_at DESC, r.rating_id DESC
LIMIT 20;
