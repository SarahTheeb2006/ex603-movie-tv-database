-- EX603 Movie/TV Database
-- Unit 3 - Task 3.1: Data Exploration

-- 3.1a: Available movies released after 2015
-- SELECT, WHERE, ORDER BY, LIMIT

SELECT movie_id, title, release_year, is_available
FROM movies
WHERE is_available = TRUE
  AND release_year > 2015
ORDER BY release_year DESC, movie_id
LIMIT 10;


-- 3.1b: Find all distinct rating statuses
-- SELECT DISTINCT

SELECT DISTINCT rating_status
FROM ratings
ORDER BY rating_status;


-- 3.1c: Ratings with scores between 3 and 5
-- Numeric range using BETWEEN

SELECT rating_id, movie_id, score, rating_status
FROM ratings
WHERE score BETWEEN 3 AND 5
ORDER BY score DESC, rating_id
LIMIT 10;


-- 3.1c: Ratings that are flagged or withdrawn
-- Explicit list using IN

SELECT rating_id, movie_id, score, rating_status
FROM ratings
WHERE rating_status IN ('flagged', 'withdrawn')
ORDER BY rating_id
LIMIT 10;


-- 3.1d: Movie title pattern using LIKE

SELECT movie_id, title, release_year
FROM movies
WHERE title LIKE 'Title\_0%' ESCAPE '\'
ORDER BY movie_id;


-- 3.1d: Missing withdrawal reasons
-- IS NULL and COALESCE

SELECT
    rating_id,
    rating_status,
    withdrawn_reason,
    COALESCE(withdrawn_reason, 'No reason provided')
        AS reason_display
FROM ratings
WHERE withdrawn_reason IS NULL
ORDER BY rating_id
LIMIT 10;


-- 3.1e: Calculated rating percentage and category
-- Arithmetic expressions and CASE

SELECT
    rating_id,
    movie_id,
    score,
    ROUND(score * 20, 0) AS score_percentage,
    CASE
        WHEN score >= 4.5 THEN 'Excellent'
        WHEN score >= 3.5 THEN 'Good'
        WHEN score >= 2.5 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    rating_status
FROM ratings
ORDER BY rating_id
LIMIT 15;
