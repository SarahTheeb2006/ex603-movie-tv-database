
-- EX603 Unit 6 - Task 6.1
-- Question: How do individual movie ratings compare
-- with their movie's average, and how can movies
-- be ranked and divided into activity groups?

-- Part A: Window average without collapsing rows
SELECT
    r.rating_id,
    m.title AS movie_title,
    r.score,
    ROUND(
        AVG(r.score) OVER (PARTITION BY r.movie_id),
        2
    ) AS movie_average
FROM ratings AS r
JOIN movies AS m
    ON r.movie_id = m.movie_id
ORDER BY m.title, r.rating_id;

-- Part A: GROUP BY comparison
SELECT
    m.movie_id,
    m.title AS movie_title,
    ROUND(AVG(r.score), 2) AS movie_average
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY m.title;

-- Part B: Three ranking functions
WITH movie_counts AS (
    SELECT
        m.movie_id,
        m.title,
        COUNT(r.rating_id) AS total_ratings
    FROM movies AS m
    LEFT JOIN ratings AS r
        ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT
    movie_id,
    title,
    total_ratings,
    ROW_NUMBER() OVER (
        ORDER BY total_ratings DESC, movie_id
    ) AS row_number_rank,
    RANK() OVER (
        ORDER BY total_ratings DESC
    ) AS rank_value,
    DENSE_RANK() OVER (
        ORDER BY total_ratings DESC
    ) AS dense_rank_value
FROM movie_counts
ORDER BY total_ratings DESC, movie_id;

-- Part C: Divide movies into four bands
WITH movie_counts AS (
    SELECT
        m.movie_id,
        m.title,
        COUNT(r.rating_id) AS total_ratings
    FROM movies AS m
    LEFT JOIN ratings AS r
        ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT
    movie_id,
    title,
    total_ratings,
    NTILE(4) OVER (
        ORDER BY total_ratings DESC, movie_id
    ) AS activity_band
FROM movie_counts
ORDER BY activity_band, total_ratings DESC;
