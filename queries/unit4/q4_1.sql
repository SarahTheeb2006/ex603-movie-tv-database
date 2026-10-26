
-- EX 603 Movie/TV Database
-- Unit 4 - Task 4.1: Aggregate Analysis
-- Database: ex603_data

-- Task 4.1.1: Platform-Wide Statistics
-- Calculate overall rating statistics and confirmed failure rate.

SELECT
    COUNT(*) AS total_events,
    SUM(score) AS total_score,
    ROUND(AVG(score), 2) AS average_score,
    MIN(score) AS minimum_score,
    MAX(score) AS maximum_score,
    COUNT(DISTINCT user_id) AS unique_reviewers,
    COUNT(*) FILTER (
        WHERE withdrawn_reason = 'Policy violation'
    ) AS confirmed_failures,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE withdrawn_reason = 'Policy violation'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_pct
FROM ratings;


-- Task 4.1.2: Performance by Producer
-- Count ratings and calculate average score per reviewer.

SELECT
    user_id AS producer_id,
    COUNT(*) AS total_events,
    ROUND(AVG(score), 2) AS average_score
FROM ratings
GROUP BY user_id
ORDER BY total_events DESC, producer_id;


-- Task 4.1.3: Minimum Event Threshold
-- Include reviewers with at least five ratings.
-- Calculate confirmed failures and failure rates.

SELECT
    user_id AS producer_id,
    COUNT(*) AS total_events,
    COUNT(*) FILTER (
        WHERE withdrawn_reason = 'Policy violation'
    ) AS confirmed_failures,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE withdrawn_reason = 'Policy violation'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_pct
FROM ratings
GROUP BY user_id
HAVING COUNT(*) >= 5
ORDER BY failure_rate_pct DESC, total_events DESC;


-- Task 4.1.4: Performance Across Regions
-- Group ratings by reviewer and device country.

SELECT
    user_id AS producer_id,
    COALESCE(device_country, 'Unknown') AS region,
    COUNT(*) AS total_events,
    ROUND(AVG(score), 2) AS average_score,
    COUNT(*) FILTER (
        WHERE withdrawn_reason = 'Policy violation'
    ) AS confirmed_failures,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE withdrawn_reason = 'Policy violation'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_pct
FROM ratings
GROUP BY user_id, device_country
ORDER BY producer_id, region;

