
-- ============================================================
-- EX603 Unit 6 - Task 6.2
-- Comparing Events Over Time
-- Database: ex603_data
-- Theme: Movie/TV Platform
-- ============================================================


-- ============================================================
-- PART A: LAG(), LEAD(), AND EVENT DELTAS
-- ============================================================

-- Task 6.2A
-- Question: How does each rating score compare with the
-- previous and next rating from the same producer?
-- Producer 1 is selected for the final output.

WITH producer_trends AS (
    SELECT
        rating_id,
        user_id AS producer_id,
        rated_at,
        score,
        LAG(score) OVER (
            PARTITION BY user_id
            ORDER BY rated_at, rating_id
        ) AS previous_score,
        LEAD(score) OVER (
            PARTITION BY user_id
            ORDER BY rated_at, rating_id
        ) AS next_score
    FROM ratings
)
SELECT
    rating_id,
    producer_id,
    rated_at,
    score,
    previous_score,
    next_score,
    ROUND(score - previous_score, 2)
        AS score_change
FROM producer_trends
WHERE producer_id = 1
ORDER BY rated_at, rating_id;


-- ============================================================
-- PART B: RUNNING TOTAL AND MOVING AVERAGE
-- ============================================================

-- Task 6.2B
-- Question: How is the platform performing over time,
-- based on cumulative ratings and recent average scores?
--
-- Target: 200 total ratings during the observed period.
-- A seven-row moving average smooths recent score changes.
-- ROWS counts records, not calendar days.

WITH daily_metrics AS (
    SELECT
        rated_at::date AS event_date,
        COUNT(*) AS daily_events,
        ROUND(AVG(score), 2) AS daily_average_score
    FROM ratings
    GROUP BY rated_at::date
),
running_metrics AS (
    SELECT
        event_date,
        daily_events,
        daily_average_score,
        SUM(daily_events) OVER (
            ORDER BY event_date
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_total_events,
        ROUND(
            AVG(daily_average_score) OVER (
                ORDER BY event_date
                ROWS BETWEEN 6 PRECEDING
                         AND CURRENT ROW
            ), 2
        ) AS moving_average_score
    FROM daily_metrics
)
SELECT
    event_date,
    daily_events,
    daily_average_score,
    running_total_events,
    moving_average_score,
    200 AS target_events,
    200 - running_total_events AS events_remaining,
    ROUND(
        100.0 * running_total_events / 200,
        2
    ) AS target_completion_pct
FROM running_metrics
ORDER BY event_date;


-- ============================================================
-- PART C: DETECT GAPS IN PRODUCER ACTIVITY
-- ============================================================

-- Task 6.2C
-- Question: Which producers have gaps of more than
-- seven days between consecutive rating events?
--
-- LAG() finds each producer's previous event.
-- The outer query filters gaps longer than seven days.
-- A gap does not automatically mean the producer left
-- the platform; it may reflect irregular activity.

WITH producer_events AS (
    SELECT
        rating_id,
        user_id AS producer_id,
        rated_at,
        LAG(rated_at) OVER (
            PARTITION BY user_id
            ORDER BY rated_at, rating_id
        ) AS previous_event_at
    FROM ratings
),
activity_gaps AS (
    SELECT
        producer_id,
        rating_id,
        previous_event_at,
        rated_at AS current_event_at,
        rated_at - previous_event_at AS gap_duration
    FROM producer_events
)
SELECT
    producer_id,
    rating_id,
    previous_event_at,
    current_event_at,
    gap_duration
FROM activity_gaps
WHERE gap_duration > INTERVAL '7 days'
ORDER BY gap_duration DESC, producer_id, rating_id;


-- ============================================================
-- END OF TASK 6.2
-- ============================================================
