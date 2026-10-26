# Unit 4 Finding: Movie/TV Platform Failure Rate Investigation

**To:** Platform Leadership, Trust and Safety Team, and Data Analytics Team

**Subject:** Confirmed Policy Violations and Reviewer Performance

## Overview

Following the correction of the dashboard's misleading failure-rate calculation in Unit 3, this investigation examines the platform's confirmed policy violations and identifies reviewers whose activity may require additional attention.

The PostgreSQL analysis confirmed 200 total ratings, including eight ratings associated with confirmed policy violations. This results in a verified platform-wide failure rate of 4.00%.

The current reviewer-level analysis confirms that eight policy violations are distributed across five reviewers.

## Reviewer Performance Breakdown

The results show that confirmed policy violations are not evenly distributed across reviewers.

| **Producer ID** | **Total Ratings** | **Confirmed Failures** | **Failure Rate** |
|---|---|---|---|
| 8 | 9 | 3 | 33.33% |
| 23 | 11 | 2 | 18.18% |
| 22 | 6 | 1 | 16.67% |
| 28 | 8 | 1 | 12.50% |
| 16 | 11 | 1 | 9.09% |

Producer 8 recorded three confirmed policy violations across nine ratings, resulting in the highest observed failure rate of 33.33%.

Producer 23 recorded two violations across eleven ratings, resulting in an 18.18% failure rate.

Producer 22 recorded one violation across six ratings, resulting in a 16.67% failure rate.

Producers 28 and 16 each recorded one confirmed violation, with failure rates of 12.50% and 9.09%, respectively.

The remaining 25 reviewers had no confirmed policy violations recorded in the dataset. However, differences in rating volume should be considered when interpreting these results.

## Recommended Reviewers for Investigation

Based on the available evidence, I recommend prioritizing three reviewers for further investigation:

**Producer 8:** This reviewer has the highest number of confirmed violations and the highest observed failure rate. With three violations across nine ratings, the 33.33% failure rate is substantially higher than the platform-wide rate of 4.00%. A closer examination of rating history and withdrawal reasons would help determine whether the violations reflect a recurring pattern.

**Producer 23:** This reviewer has the second-highest number of confirmed violations, with two violations across eleven ratings and a failure rate of 18.18%. Reviewing the circumstances surrounding these events may help determine whether additional guidance or intervention is appropriate.

**Producer 22:** This reviewer has a relatively high failure rate of 16.67%, although the sample contains only six ratings. Additional observations would be necessary before determining whether this represents a consistent performance issue.

These recommendations are intended to guide further investigation rather than establish misconduct based solely on summary statistics.

## Regional Performance Findings

The regional analysis identified differences in confirmed policy-violation rates across five device countries.

| **Region** | **Total Ratings** | **Confirmed Failures** | **Failure Rate** |
|---|---|---|---|
| Brazil | 39 | 1 | 2.56% |
| India | 40 | 2 | 5.00% |
| UK | 40 | 1 | 2.50% |
| US | 38 | 2 | 5.26% |
| Vietnam | 43 | 2 | 4.65% |
| **Grand Total** | **200** | **8** | **4.00%** |

The United States had the highest observed regional failure rate at 5.26%, followed by India at 5.00% and Vietnam at 4.65%.

The United Kingdom had the lowest observed failure rate at 2.50%, followed by Brazil at 2.56%.

Although these differences may help identify areas for additional monitoring, regional totals alone do not establish the causes of policy violations. Leadership should consider differences in reviewer activity and reporting practices before drawing conclusions about regional performance.

## Minimum Activity Threshold Analysis

To provide a more meaningful comparison, the analysis also examined reviewers who submitted at least five ratings.

The results identified 24 qualifying reviewers who collectively submitted 183 ratings and accounted for all eight confirmed policy violations.

The combined confirmed failure rate for this group was 4.37%, compared with the platform-wide failure rate of 4.00%.

This comparison demonstrates how applying a minimum activity threshold can change the population being evaluated and the resulting aggregate percentage.

The threshold helps reduce the influence of reviewers with very limited activity, but it does not eliminate uncertainty associated with smaller samples.

## Implications for Leadership

The findings demonstrate why platform-wide averages should be supported by reviewer-level and regional analysis.

Although the verified platform-wide confirmed failure rate is 4.00%, individual reviewers show substantially different rates. Looking only at the overall percentage could conceal concentrations of confirmed violations among a small number of reviewers.

Leadership should consider reviewing individual violation records, changes in reviewer activity over time, and potential differences in reporting practices.

The Trust and Safety Team should conduct the initial investigations, while the Data Analytics Team should continue monitoring the accuracy and consistency of the dashboard's calculations.

The analysis also demonstrates the importance of using appropriate SQL aggregation methods. Conditional aggregation allows confirmed policy violations to be counted alongside total ratings, while grouping and ROLLUP provide reviewer-level and regional summaries. Common Table Expressions help organize calculations involving minimum activity thresholds.

Together, these techniques provide leadership with a more transparent and reliable foundation for evaluating platform performance.

## Conclusion

The corrected analysis provides a more useful foundation for evaluating reviewer performance than the original dashboard calculation.

The PostgreSQL results verified 200 total ratings, eight confirmed policy violations, and a platform-wide failure rate of 4.00%. Among the 24 reviewers who met the minimum threshold of five ratings, the combined failure rate was 4.37%.

Based on the available results, producers 8, 23, and 22 are the strongest candidates for additional review because of their observed violation counts and failure rates.

Further investigation should focus on understanding the circumstances behind the confirmed violations before making decisions about reviewer payouts, restrictions, or corrective actions.

By combining accurate aggregate calculations with reviewer-level investigation, the platform can improve the reliability of its reporting and support fairer, evidence-based leadership decisions.
