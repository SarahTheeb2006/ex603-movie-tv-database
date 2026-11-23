
-- ============================================================
-- EX603 Unit 6 - Task 6.3
-- Top-N Events and Monthly Performance Trends
-- Database: ex603_data
-- ============================================================


-- ============================================================
-- PART A: TOP THREE RATING EVENTS PER PRODUCER
-- ============================================================

-- Rank rating events by score within each producer.
-- RANK() preserves ties, so more than three rows may
-- appear for a producer if scores tie at third place.
-- FIRST_VALUE() identifies each producer's highest score.

WITH ranked_events AS (
    SELECT
        rating_id,
        user_id AS producer_id,
        rated_at,
        score,
        RANK() OVER (
            PARTITION BY user_id
            ORDER BY score DESC
        ) AS score_rank,
        FIRST_VALUE(score) OVER (
            PARTITION BY user_id
            ORDER BY score DESC, rated_at, rating_id
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND UNBOUNDED FOLLOWING
        ) AS producer_top_score
    FROM ratings
)
SELECT
    producer_id,
    rating_id,
    rated_at,
    score,
    score_rank,
    producer_top_score
FROM ranked_events
WHERE score_rank <= 3
ORDER BY producer_id, score_rank, rated_at, rating_id;


-- ============================================================
-- PART B: MONTHLY ACTIVITY AND PERCENTAGE CHANGE
-- ============================================================

-- Aggregate events by calendar month.
-- LAG() compares each month with the previous
-- observed month.
-- NULLIF() prevents division by zero.

WITH monthly_activity AS (
    SELECT
        DATE_TRUNC('month', rated_at)::date AS event_month,
        COUNT(*) AS total_events,
        ROUND(AVG(score), 2) AS average_score,
        COUNT(*) FILTER (
            WHERE withdrawn_reason = 'Policy violation'
        ) AS failure_events
    FROM ratings
    GROUP BY DATE_TRUNC('month', rated_at)::date
),
monthly_comparison AS (
    SELECT
        event_month,
        total_events,
        average_score,
        failure_events,
        LAG(event_month) OVER (
            ORDER BY event_month
        ) AS previous_month,
        LAG(total_events) OVER (
            ORDER BY event_month
        ) AS previous_month_events
    FROM monthly_activity
)
SELECT
    event_month,
    total_events,
    average_score,
    failure_events,
    previous_month_events,
    ROUND(
        100.0 * (total_events - previous_month_events)
        / NULLIF(previous_month_events, 0),
        2
    ) AS month_over_month_change_pct,
    CASE
        WHEN previous_month IS NULL THEN
            'First observed month'
        WHEN event_month >
             (previous_month + INTERVAL '1 month')::date THEN
            'Missing calendar month(s) before this month'
        ELSE
            'Consecutive month'
    END AS month_continuity
FROM monthly_comparison
ORDER BY event_month;


-- ============================================================
-- PART B - ADDITIONAL CHECK: MISSING CALENDAR MONTHS
-- ============================================================

-- Generate every month between the first and last event
-- to identify months with zero ratings.

WITH month_range AS (
    SELECT
        GENERATE_SERIES(
            DATE_TRUNC('month', MIN(rated_at)),
            DATE_TRUNC('month', MAX(rated_at)),
            INTERVAL '1 month'
        )::date AS event_month
    FROM ratings
),
monthly_counts AS (
    SELECT
        DATE_TRUNC('month', rated_at)::date AS event_month,
        COUNT(*) AS total_events
    FROM ratings
    GROUP BY DATE_TRUNC('month', rated_at)::date
)
SELECT
    mr.event_month,
    COALESCE(mc.total_events, 0) AS total_events,
    CASE
        WHEN mc.event_month IS NULL THEN 'Missing month'
        ELSE 'Month with activity'
    END AS month_status
FROM month_range mr
LEFT JOIN monthly_counts mc
    ON mr.event_month = mc.event_month
ORDER BY mr.event_month;


-- ============================================================
-- PART C: FIRST_VALUE AND LAST_VALUE COMPARISON
-- ============================================================

-- Explicit full-partition frames ensure that both
-- values represent the entire producer's score range.
-- Compare highest and lowest scores for producers 1, 2, 3.

SELECT
    user_id AS producer_id,
    rating_id,
    score,
    FIRST_VALUE(score) OVER (
        PARTITION BY user_id
        ORDER BY score DESC, rated_at, rating_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS highest_score,
    LAST_VALUE(score) OVER (
        PARTITION BY user_id
        ORDER BY score DESC, rated_at, rating_id
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND UNBOUNDED FOLLOWING
    ) AS lowest_score
FROM ratings
WHERE user_id IN (1, 2, 3)
ORDER BY producer_id, score DESC, rating_id;


-- ============================================================
-- END OF TASK 6.3
-- ============================================================
