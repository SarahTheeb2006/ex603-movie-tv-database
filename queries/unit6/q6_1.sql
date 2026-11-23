
-- ============================================================
-- EX603 Unit 6 - Task 6.1: Window Functions and Rankings
-- Database: ex603_data
-- Theme: Movie/TV Platform
-- ============================================================

-- ============================================================
-- PART A: Compare Events to Producer Averages
-- ============================================================

-- Task 6.1A - Window Function
-- Question: How does each individual rating compare with
-- the average score of ratings submitted by its producer?
-- Producers are represented by user_id.
-- AVG() OVER keeps every individual rating in the result.

SELECT
    rating_id,
    user_id AS producer_id,
    score,
    ROUND(
        AVG(score) OVER (
            PARTITION BY user_id
        ), 2
    ) AS producer_average_score,
    ROUND(
        score - AVG(score) OVER (
            PARTITION BY user_id
        ), 2
    ) AS difference_from_average
FROM ratings
ORDER BY producer_id, rating_id;


-- Task 6.1A - GROUP BY Comparison
-- Question: What is the average rating score per producer?
-- GROUP BY combines all events for each producer into
-- one summary row, losing individual rating details.

SELECT
    user_id AS producer_id,
    COUNT(*) AS total_events,
    ROUND(AVG(score), 2) AS producer_average_score
FROM ratings
GROUP BY user_id
ORDER BY producer_id;


-- Task 6.1A - Row Count Comparison
-- Question: How many rows are returned by the window
-- function compared with the GROUP BY version?
-- The window query returns one row per rating.
-- The GROUP BY query returns one row per producer.

SELECT
    (SELECT COUNT(*)
     FROM ratings) AS window_query_rows,
    (SELECT COUNT(DISTINCT user_id)
     FROM ratings) AS grouped_query_rows;


-- ============================================================
-- PART B: Rank Producers Three Ways
-- ============================================================

-- Task 6.1B - Producer Leaderboard
-- Question: How do ROW_NUMBER(), RANK(), and DENSE_RANK()
-- rank producers based on their total number of events?
--
-- ROW_NUMBER assigns a unique position to every producer.
-- RANK assigns equal ranks to ties and skips positions.
-- DENSE_RANK assigns equal ranks without skipping positions.
--
-- Producer ID is used as a deterministic tiebreaker
-- for ROW_NUMBER only. RANK and DENSE_RANK preserve ties.

WITH producer_counts AS (
    SELECT
        user_id AS producer_id,
        COUNT(*) AS total_events
    FROM ratings
    GROUP BY user_id
)
SELECT
    producer_id,
    total_events,
    ROW_NUMBER() OVER (
        ORDER BY total_events DESC, producer_id
    ) AS row_number_position,
    RANK() OVER (
        ORDER BY total_events DESC
    ) AS rank_position,
    DENSE_RANK() OVER (
        ORDER BY total_events DESC
    ) AS dense_rank_position
FROM producer_counts
ORDER BY total_events DESC, producer_id;


-- Task 6.1B - Identify Tied Producers
-- Question: Which event counts are shared by multiple
-- producers, demonstrating ranking ties?

WITH producer_counts AS (
    SELECT
        user_id AS producer_id,
        COUNT(*) AS total_events
    FROM ratings
    GROUP BY user_id
)
SELECT
    total_events,
    COUNT(*) AS producers_with_same_count
FROM producer_counts
GROUP BY total_events
HAVING COUNT(*) > 1
ORDER BY total_events DESC;


-- ============================================================
-- PART C: Divide Producers Into Four Activity Bands
-- ============================================================

-- Task 6.1C - NTILE(4)
-- Question: How can producers be divided into four
-- groups based on the number of events they submitted?
--
-- Band 1 contains the highest-activity producers.
-- Band 4 contains the lowest-activity producers.
--
-- NTILE distributes producers into approximately equal
-- sized groups. Producers with the same event count
-- may be placed into different bands at a boundary.
-- Producer ID ensures deterministic ordering.

WITH producer_counts AS (
    SELECT
        user_id AS producer_id,
        COUNT(*) AS total_events
    FROM ratings
    GROUP BY user_id
)
SELECT
    producer_id,
    total_events,
    NTILE(4) OVER (
        ORDER BY total_events DESC, producer_id
    ) AS activity_band
FROM producer_counts
ORDER BY activity_band, total_events DESC, producer_id;


-- Task 6.1C - Activity Band Summary
-- Question: How many producers belong to each activity
-- band, and what is the event count range in each band?

WITH producer_counts AS (
    SELECT
        user_id AS producer_id,
        COUNT(*) AS total_events
    FROM ratings
    GROUP BY user_id
),
producer_bands AS (
    SELECT
        producer_id,
        total_events,
        NTILE(4) OVER (
            ORDER BY total_events DESC, producer_id
        ) AS activity_band
    FROM producer_counts
)
SELECT
    activity_band,
    COUNT(*) AS total_producers,
    MIN(total_events) AS minimum_events,
    MAX(total_events) AS maximum_events,
    ROUND(AVG(total_events), 2) AS average_events
FROM producer_bands
GROUP BY activity_band
ORDER BY activity_band;


-- ============================================================
-- END OF TASK 6.1
-- ============================================================
