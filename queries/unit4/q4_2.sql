
-- EX603 Movie/TV Database
-- Unit 4 - Task 4.2: Leadership Breakdown
-- Database: ex603_data

-- Part A: Conditional Aggregation
-- Question: How many ratings did each reviewer submit,
-- and how many were confirmed policy violations?

SELECT
    user_id AS producer_id,
    COUNT(*) AS total_events,
    SUM(
        CASE
            WHEN withdrawn_reason = 'Policy violation'
            THEN 1
            ELSE 0
        END
    ) AS confirmed_failures,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN withdrawn_reason = 'Policy violation'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_pct
FROM ratings
GROUP BY user_id
ORDER BY confirmed_failures DESC, total_events DESC;


-- Part B: Regional Subtotals and Grand Total
-- Question: How many ratings and confirmed failures
-- occurred in each device country and platform-wide?

SELECT
    CASE
        WHEN GROUPING(device_country) = 1
        THEN 'ALL REGIONS - GRAND TOTAL'
        ELSE COALESCE(device_country, 'Unknown')
    END AS region,
    COUNT(*) AS total_events,
    SUM(
        CASE
            WHEN withdrawn_reason = 'Policy violation'
            THEN 1
            ELSE 0
        END
    ) AS confirmed_failures,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN withdrawn_reason = 'Policy violation'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS failure_rate_pct
FROM ratings
GROUP BY ROLLUP(device_country)
ORDER BY GROUPING(device_country), region;


-- Part C: Two-Step CTE Pipeline
-- Question: What is the combined failure rate among
-- reviewers with at least five ratings?

WITH producer_summary AS (
    SELECT
        user_id AS producer_id,
        COUNT(*) AS total_events,
        SUM(
            CASE
                WHEN withdrawn_reason = 'Policy violation'
                THEN 1
                ELSE 0
            END
        ) AS confirmed_failures
    FROM ratings
    GROUP BY user_id
)
SELECT
    COUNT(*) AS qualifying_producers,
    SUM(total_events) AS qualifying_events,
    SUM(confirmed_failures) AS qualifying_failures,
    ROUND(
        100.0 * SUM(confirmed_failures)
        / NULLIF(SUM(total_events), 0),
        2
    ) AS high_volume_failure_rate_pct
FROM producer_summary
WHERE total_events >= 5;
