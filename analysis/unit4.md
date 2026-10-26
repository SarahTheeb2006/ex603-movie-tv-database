# Unit 4 Analysis: Movie/TV Database Performance

## Task 4.1: Measuring Platform Performance

### Platform-Wide Statistics

The purpose of this analysis is to evaluate rating activity across the Movie/TV platform and determine how frequently confirmed policy violations occur. The analysis uses the `ratings` table, with each rating representing an event and each reviewer identified by `user_id`.

The SQL query calculates the total number of ratings, total rating score, average score, minimum score, maximum score, and number of distinct reviewers. It also calculates confirmed policy violations as a percentage of all ratings.

My previous investigation identified 200 ratings, including eight with a recorded policy-violation withdrawal reason. This suggests a preliminary confirmed failure rate of 4%. The Unit 4 queries will verify this calculation against the current database.

The minimum and maximum rating scores are also important because unexpected values could indicate data-quality problems requiring further investigation.

### Performance by Producer

For this analysis, each reviewer is treated as a producer and identified by `user_id` rather than name.

Grouping the data by reviewer makes it possible to compare rating activity and average scores. This breakdown is useful because a platform-wide average does not show whether a small number of reviewers account for a disproportionate share of problematic ratings.

The Trust and Safety Manager would use this information to identify reviewers who may require additional investigation. Before taking action, the manager should examine individual rating records, withdrawal reasons, and reviewer activity over time.

### Minimum Event Threshold

I selected a minimum threshold of five ratings per reviewer using the `HAVING` clause.

This threshold helps reduce the influence of reviewers with very little activity. For example, one confirmed violation among two ratings produces a 50% failure rate, but that percentage is based on a very small sample.

Five ratings is an initial screening threshold rather than a statistically definitive measure of reliability. Reviewers meeting this threshold can be compared more meaningfully, although additional data may still be necessary.

### Performance Across Regions

The regional analysis groups ratings by reviewer identifier and `device_country`.

This makes it possible to examine whether rating activity, average scores, and confirmed policy violations differ across geographic areas.

The `device_country` column represents the country associated with the rating event, rather than necessarily identifying the reviewer's residence.

Regional differences should not automatically be interpreted as evidence of misconduct. Differences in participation, sample sizes, and reporting practices may also influence the results.

## Task 4.2: Detailed Leadership Breakdown

### Part A: Conditional Aggregation

Conditional aggregation answers two questions side by side:

1. How many total ratings did each reviewer submit?
2. How many of those ratings were associated with confirmed policy violations?

Using `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` allows both measurements to be calculated within the same grouped query.

The resulting breakdown helps leadership identify reviewers with unusually high numbers or percentages of confirmed violations. Reviewers with high violation counts and sufficient activity should receive additional attention before any decisions are made.

### Part B: Regional Subtotals and Grand Total

The Regional Director needs a summarized view of platform activity rather than individual reviewer records.

The `ROLLUP` query provides a subtotal for each device country and one platform-wide grand total.

Rows labeled with a country represent regional subtotals, while the row labeled `ALL REGIONS - GRAND TOTAL` represents all ratings across the platform.

The grand total supports decisions about overall platform performance and whether broader policy or reporting changes are necessary. Regional subtotals help identify where additional investigation or resources may be appropriate.

### Part C: Two-Step CTE Pipeline

The CTE pipeline answers the question: What is the combined confirmed failure rate among reviewers who submitted at least five ratings?

The first step summarizes the total ratings and confirmed failures for each reviewer. The second step filters those summaries to include reviewers meeting the minimum activity threshold and calculates their combined failure rate.

This creates a baseline that leadership can use when evaluating higher-volume reviewers.

The combined rate is weighted by the number of ratings, so reviewers with more activity contribute proportionally more to the overall result.

## Reflection: Conditional Aggregation Versus Separate Queries

Conditional aggregation is useful because it allows multiple measurements to be calculated together without repeatedly filtering the entire dataset. In this assignment, I used conditional aggregation to calculate the total number of ratings submitted by each reviewer and the number associated with confirmed policy violations. These results appear side by side, making it easier to compare reviewer activity and identify potential concerns.

An alternative approach would involve running two separate queries. One query could count all ratings for each reviewer, while another could filter the data to count only policy violations. Although both approaches could produce the same information, separate queries would require additional processing and might require joining the results together afterward. Reviewers without violations could also be missing from the filtered results unless the queries were combined carefully.

When working with one million rows, efficiency becomes increasingly important. Repeatedly scanning large tables can increase processing time and database resource usage. Conditional aggregation allows the database to evaluate multiple conditions during a single grouped aggregation, potentially reducing unnecessary work.

Another advantage is consistency. Both measurements come from the same query and reflect the same underlying data snapshot. This makes the results easier to compare and explain to leadership.

Overall, conditional aggregation provides an organized and potentially more efficient way to summarize large datasets while supporting accurate, evidence-based decisions.
