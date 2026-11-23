# EX603 Unit 6 — Window Functions and Analytical SQL

**Project:** Movie and TV Ratings Database  
**Database:** PostgreSQL  
**Student:** Sarah Theeb

## Task 6.1 — Window Functions, Rankings, and NTILE

### Window Averages Versus GROUP BY

I used `AVG()` with `OVER (PARTITION BY user_id)` to calculate the average rating score for each producer while preserving the individual rating records. This allowed me to compare each rating against its producer's overall average without losing details such as the rating ID, score, and date.

I also compared this approach with `GROUP BY`, which combines records into one summary row per producer. Both approaches are useful, but window functions are more appropriate when the analysis requires both individual records and aggregated information.

### ROW_NUMBER(), RANK(), and DENSE_RANK()

I compared three ranking functions to understand how PostgreSQL handles tied values.

- `ROW_NUMBER()` assigns a unique sequential number to every record, even when values are tied.
- `RANK()` assigns equal ranks to tied values but skips subsequent ranking positions.
- `DENSE_RANK()` assigns equal ranks to ties without skipping ranking positions.

For example, producers 13, 16, and 23 each had 11 rating events, demonstrating why tie handling is important when comparing producer activity.

The ranking method should depend on whether the goal is to assign unique positions or preserve equal standings.

### NTILE(4)

I used `NTILE(4)` to divide producers into four approximately equal groups based on their activity levels.

This approach makes it easier to compare producers across activity bands rather than examining every individual count. However, `NTILE()` divides rows into groups and may place producers with identical counts into different quartiles. Therefore, these bands should not be interpreted as exact performance categories.

## Task 6.2 — LAG, LEAD, Running Totals, and Activity Gaps

### LAG() and LEAD()

I used `LAG()` and `LEAD()` to examine previous and subsequent rating scores within each producer's activity history.

For Producer 1, one rating increased from 1.1 to 5.0, representing a positive change of 3.90 points. Another rating decreased from 5.0 to 1.7, representing a negative change of 3.30 points.

These comparisons demonstrate how window functions can identify changes between consecutive events without requiring a self-join.

The query ordered records by timestamp and rating ID to provide consistent ordering when timestamps are identical.

### Running Totals and Moving Averages

I used `SUM() OVER()` to calculate cumulative rating activity and a moving average to examine changes in daily average scores.

The running total shows how activity accumulates over time. I also compared the cumulative count with an illustrative target of 200 rating events, matching the dataset's total size.

The moving average used `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`, which includes up to seven observed dates. This is not necessarily equivalent to seven consecutive calendar days.

I chose a `ROWS` frame because it clearly defines the number of preceding observations. A `RANGE` frame would behave differently because it considers values or intervals in the ordering column rather than a fixed number of rows.

### Producer Activity Gaps

I calculated the time difference between consecutive rating events using `LAG(rated_at)`.

Producer 12 had the longest observed gap, approximately 218 days and 15 hours. Producer 2 had a gap of approximately 194 days, and Producer 30 had a gap of approximately 179 days.

These results indicate that some producers had irregular activity patterns. However, the data does not explain why those gaps occurred.

## Task 6.3 — Top-N Analysis and Monthly Trends

### Top Three Events per Producer

I used a common table expression (CTE) with `RANK()` to identify the highest-scoring rating events for each producer.

For Producer 1, two ratings scored 5.0 and both received rank 1. The next highest rating received rank 3.

Producer 20 had four ratings scoring 5.0, all assigned rank 1. This shows that filtering for `RANK() <= 3` can return more than three records when ties occur.

I also used `FIRST_VALUE()` with an explicit window frame extending from `UNBOUNDED PRECEDING` to `UNBOUNDED FOLLOWING` to retrieve each producer's highest score consistently.

For comparison, `LAST_VALUE()` requires careful attention to the window frame. With PostgreSQL's default frame, it may return the value from the current frame boundary rather than the final row of the entire partition. An explicit full-partition frame is appropriate when the goal is to retrieve the final value for the entire producer group.

### Monthly Trends and Percentage Changes

I grouped ratings by calendar month and used `LAG()` to compare each month's event count with the previous observed month.

The results showed that January and February each contained 21 events. March decreased to 11 events, a decline of 47.62%.

May recorded the largest monthly increase, rising from 11 to 17 events, or 54.55%.

I used `NULLIF()` in the percentage-change calculation to prevent division-by-zero errors. The first month has no previous month for comparison, so its percentage change is `NULL`.

### Missing-Month Validation

I used `GENERATE_SERIES()` to create a complete calendar-month sequence between the first and last rating dates.

I then compared the generated months against the actual monthly activity records using a `LEFT JOIN`.

The results confirmed that every month from January through December 2023 contained activity. No calendar months were missing.

This validation is important because `LAG()` normally compares consecutive rows in its result set, which may not represent consecutive calendar months if months are absent.

## Task 6.4 — Findings and Recommendations

The database contained 200 rating events, including eight policy violations, producing an overall failure rate of 4.00%.

February had the highest monthly failure count, with three violations among 21 ratings, representing 14.29% of that month's activity.

The findings indicate that policy violations and producer activity were unevenly distributed throughout the year.

I recommend monitoring monthly failure rates, investigating periods with unusually high violations, reviewing extended inactivity gaps, and establishing consistent rules for ranking tied results.

The complete findings and recommendations are documented in [Unit 6 Final Findings Memo](unit6-finding.md).

## Reflection

Completing Unit 6 helped me understand how SQL window functions can provide deeper insights than traditional aggregation alone. Before this assignment, I mainly relied on `GROUP BY` to summarize information. However, using `AVG() OVER()` showed me how I could calculate group-level statistics while keeping individual records available for comparison.

One of the most important lessons was understanding the differences between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`. When I examined the top rating events for each producer, I noticed that tied scores could produce more than three results. This reinforced the importance of choosing a ranking function based on the intended business question rather than simply selecting whichever function produces an output.

I also found `LAG()` especially useful because it allowed me to compare rating activity over time without writing complicated joins. The monthly analysis revealed changes in event volume, while the activity-gap analysis highlighted long periods between producer events. These findings demonstrated how SQL can identify patterns that might otherwise be overlooked.

Another important lesson involved window frames. I learned that `ROWS` and `RANGE` can produce different results, and that functions such as `LAST_VALUE()` require careful frame definitions.

Overall, this assignment strengthened my confidence in writing analytical SQL, interpreting results, and recognizing the limitations of the data before making recommendations.

## Conclusion

Unit 6 demonstrated how PostgreSQL window functions can support detailed analysis of producer activity, rating trends, and policy violations.

By combining window averages, ranking functions, running totals, time-based comparisons, and calendar validation, I was able to identify meaningful patterns while maintaining the underlying record details.

The results also emphasized the importance of clear SQL logic, consistent tie handling, and cautious interpretation when working with a relatively small dataset.
