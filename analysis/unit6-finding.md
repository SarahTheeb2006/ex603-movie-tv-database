# EX603 Unit 6 — Final Findings Memo

**Project:** Movie and TV Ratings Database  
**Topic:** Producer Activity, Rating Trends, and Policy Violations

## Executive Summary

This analysis examined 200 rating events from January through December 2023 using PostgreSQL window functions, ranking techniques, and monthly trend comparisons. The objective was to identify differences in producer activity, detect unusual patterns, and evaluate the frequency of policy violations.

The database contained eight ratings associated with policy violations, representing an overall failure rate of 4.00%. Although failures were relatively uncommon, their distribution varied throughout the year. The analysis also identified substantial gaps between individual producers' rating events, suggesting that activity was inconsistent across the dataset.

## Key Findings

### 1. Policy Violations Were Unevenly Distributed

Of the 200 rating events, eight were classified as policy violations, producing an overall failure rate of 4.00%.

February recorded the highest number of violations, with three failures among 21 ratings. This represents a monthly failure rate of 14.29%. March recorded one failure among 11 ratings, while June, July, October, and December each recorded one.

Several months, including January, April, May, August, September, and November, recorded no policy violations.

These results suggest that policy-related problems were not evenly distributed across the year. However, the relatively small monthly sample sizes mean that individual events can substantially influence failure rates.

### 2. Monthly Rating Activity Fluctuated

Monthly rating activity varied throughout 2023. January and February each recorded 21 events, while March and April each recorded 11.

Using the `LAG()` window function, the analysis identified a 47.62% decrease in rating activity from February to March. The largest month-over-month increase occurred in May, when activity rose by 54.55%, from 11 to 17 events.

These fluctuations indicate that activity was inconsistent rather than steadily increasing or decreasing. The analysis also confirmed that all 12 calendar months contained rating activity, with no missing months.

### 3. Producer Activity Included Long Inactive Periods

The `LAG()` function was used to compare consecutive rating timestamps within each producer's activity history.

Producer 12 had the longest observed gap, approximately 218 days and 15 hours. Producer 2 had a gap of approximately 194 days, while Producer 30 had a gap of approximately 179 days.

These long intervals suggest irregular participation among some producers. However, gaps alone do not establish why activity decreased or whether the producers permanently stopped participating.

### 4. Ranking Functions Revealed Tied Results

The analysis used `RANK()` and `FIRST_VALUE()` to identify high-scoring rating events for each producer.

For Producer 1, two events received scores of 5.0 and shared rank 1. The next highest event received rank 3. Producer 20 had four events with scores of 5.0, all sharing rank 1.

These examples demonstrate why tie handling matters when selecting top-performing events. Using `RANK()` preserves ties, so filtering to ranks of three or lower can return more than three records for an individual producer.

## Recommendations

**1. Monitor policy violation rates monthly.** Track both the number of violations and the percentage of ratings affected. Reviewing rates alongside monthly event counts will help prevent misleading conclusions when sample sizes are small.

**2. Investigate periods of unusually high failure activity.** February's 14.29% failure rate warrants additional review to determine whether the violations share common characteristics. The existing data identifies the pattern but does not establish its cause.

**3. Monitor irregular producer participation.** Use timestamp comparisons to identify extended periods without activity. These results could support additional investigation into participation patterns, provided inactivity is not automatically treated as a performance problem.

**4. Standardize ranking and reporting rules.** Define whether top-N reports should return exactly N records or include tied results. Consistent ranking rules will make reporting easier to interpret and reproduce.

## Limitations

The analysis is based on 200 rating events from one calendar year. Because the dataset is relatively small, the findings should not be generalized to a larger population without additional evidence.

The analysis uses rating records associated with user identifiers as producer activity. These identifiers serve as the grouping dimension for the assignment and should not be interpreted as independently verified production roles.

Policy violations were identified using the `withdrawn_reason` field. The analysis does not establish the underlying causes of those violations.

Additionally, rating timestamps reveal recorded activity but cannot explain producer motivations, account status, or reasons for inactivity.

## Conclusion

The SQL analysis identified an overall policy violation rate of 4.00%, fluctuating monthly rating activity, and substantial differences in participation patterns across producers. Window functions such as `LAG()`, `RANK()`, and `FIRST_VALUE()` made it possible to compare records while retaining important details.

The strongest recommendation is to establish consistent monthly monitoring of failure rates, activity changes, and producer participation. These measures would help identify unusual patterns earlier and support more informed decisions.
