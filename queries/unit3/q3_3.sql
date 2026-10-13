-- EX603 Movie/TV Database
-- Unit 3 - Task 3.3
-- Three Equivalent SQL Queries

-- Question:
-- Which users rated available movies released after 2015?


-- Query 1: Subquery using IN

SELECT DISTINCT u.user_id, u.user_name
FROM users u
JOIN ratings r ON u.user_id = r.user_id
WHERE r.movie_id IN (
    SELECT m.movie_id
    FROM movies m
    WHERE m.is_available = TRUE
      AND m.release_year > 2015
)
ORDER BY u.user_id;


-- Query 2: Common Table Expression (CTE)

WITH eligible_movies AS (
    SELECT movie_id
    FROM movies
    WHERE is_available = TRUE
      AND release_year > 2015
)
SELECT DISTINCT u.user_id, u.user_name
FROM users u
JOIN ratings r ON u.user_id = r.user_id
JOIN eligible_movies em ON r.movie_id = em.movie_id
ORDER BY u.user_id;


-- Query 3: Correlated EXISTS Subquery

SELECT u.user_id, u.user_name
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM ratings r
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE r.user_id = u.user_id
      AND m.is_available = TRUE
      AND m.release_year > 2015
)
ORDER BY u.user_id;

-- Task 3.3: Verify all three queries return identical rows

WITH
query1 AS (
    SELECT DISTINCT u.user_id, u.user_name
    FROM users u
    JOIN ratings r ON u.user_id = r.user_id
    WHERE r.movie_id IN (
        SELECT m.movie_id
        FROM movies m
        WHERE m.is_available = TRUE
          AND m.release_year > 2015
    )
),
query2 AS (
    SELECT DISTINCT u.user_id, u.user_name
    FROM users u
    JOIN ratings r ON u.user_id = r.user_id
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE m.is_available = TRUE
      AND m.release_year > 2015
),
query3 AS (
    SELECT u.user_id, u.user_name
    FROM users u
    WHERE EXISTS (
        SELECT 1
        FROM ratings r
        JOIN movies m ON r.movie_id = m.movie_id
        WHERE r.user_id = u.user_id
          AND m.is_available = TRUE
          AND m.release_year > 2015
    )
)
SELECT
    (SELECT COUNT(*) FROM query1) AS query1_rows,
    (SELECT COUNT(*) FROM query2) AS query2_rows,
    (SELECT COUNT(*) FROM query3) AS query3_rows,
    NOT EXISTS (
        (SELECT * FROM query1 EXCEPT SELECT * FROM query2)
        UNION ALL
        (SELECT * FROM query2 EXCEPT SELECT * FROM query1)
        UNION ALL
        (SELECT * FROM query1 EXCEPT SELECT * FROM query3)
        UNION ALL
        (SELECT * FROM query3 EXCEPT SELECT * FROM query1)
    ) AS identical_results;

    -- Equivalence explanation:
-- All three queries identify users who rated available movies
-- released after 2015. DISTINCT prevents duplicate users
-- in the first two queries, while EXISTS naturally returns
-- each matching user once.
--
-- Potential difference:
-- If DISTINCT were removed from Query 1 or Query 2,
-- users who rated multiple qualifying movies could appear
-- more than once. Query 3 would still return each user once.
