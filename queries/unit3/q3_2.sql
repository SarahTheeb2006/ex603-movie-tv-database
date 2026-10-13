-- EX603 Movie/TV Database
-- Unit 3 - Task 3.2: Find the Bug

-- ========================================
-- PART A: The Rows That Vanished
-- ========================================

-- A1: Total number of ratings
SELECT COUNT(*) AS total_ratings
FROM ratings;

-- A2: Broken query
-- This excludes withdrawn ratings, but also
-- silently excludes rows with NULL reasons.

SELECT COUNT(*) AS not_policy_violation
FROM ratings
WHERE withdrawn_reason != 'Policy violation';

-- A3: Count the rows with the excluded value
SELECT COUNT(*) AS policy_violation_count
FROM ratings
WHERE withdrawn_reason = 'Policy violation';

-- A4: Count the NULL values silently omitted
SELECT COUNT(*) AS missing_reason_count
FROM ratings
WHERE withdrawn_reason IS NULL;

-- A5: Show all counts together
SELECT
    COUNT(*) AS total_ratings,
    COUNT(*) FILTER (
        WHERE withdrawn_reason != 'Policy violation'
    ) AS not_policy_violation,
    COUNT(*) FILTER (
        WHERE withdrawn_reason = 'Policy violation'
    ) AS policy_violation_count,
    COUNT(*) FILTER (
        WHERE withdrawn_reason IS NULL
    ) AS silently_omitted
FROM ratings;

-- A6: Repaired query
-- Include NULL explicitly.
SELECT COUNT(*) AS corrected_count
FROM ratings
WHERE withdrawn_reason != 'Policy violation'
   OR withdrawn_reason IS NULL;


-- ========================================
-- PART B: The Alias That Did Not Exist Yet
-- ========================================

-- B1: Intentionally broken query
-- Run this separately and capture the error.
-- SELECT
--     rating_id,
--     score * 20 AS score_percentage
-- FROM ratings
-- WHERE score_percentage >= 80;

-- B2: Correct rewrite 1
-- Repeat the expression in WHERE.
SELECT
    rating_id,
    score * 20 AS score_percentage
FROM ratings
WHERE score * 20 >= 80
ORDER BY rating_id
LIMIT 10;

-- B3: Correct rewrite 2
-- Use a CTE so the alias is available.
WITH rating_percentages AS (
    SELECT
        rating_id,
        score * 20 AS score_percentage
    FROM ratings
)
SELECT
    rating_id,
    score_percentage
FROM rating_percentages
WHERE score_percentage >= 80
ORDER BY rating_id
LIMIT 10;
