# EX603 Unit 5 — Recommendation Memo

## Task 5.4: Platform Activity and Data Integrity

### Overview

This analysis examines user participation, rating activity, and the importance of selecting appropriate SQL joins when evaluating platform performance. The purpose is to identify potential reporting gaps and recommend improvements that support accurate decision-making.

### Key Findings

**Finding 1: All users have submitted ratings.**

The database contains 30 users, and all 30 have submitted at least one rating. Comparing INNER JOIN and LEFT JOIN results confirmed that zero users were excluded from the rating activity report.

**Finding 2: Different join types can affect reporting completeness.**

Although INNER JOIN, LEFT JOIN, and RIGHT JOIN produced the same user counts in this dataset, these joins do not always return identical results. An INNER JOIN excludes users without matching ratings, while a LEFT JOIN preserves all users.

**Finding 3: Missing-record checks confirmed complete user participation.**

Both NOT EXISTS and EXCEPT returned zero users without ratings. These results support the conclusion that every user in the current dataset has at least one associated rating.

**Finding 4: Previous analysis identified rating policy violations.**

In Unit 4, I identified eight confirmed policy violations among 200 ratings, resulting in a 4.00% failure rate. Although all users participated in rating activity, participation alone does not guarantee that every rating complies with platform policies.

### Recommendations

**1. Use LEFT JOIN for participation reporting.**

I recommend using LEFT JOIN when generating reports intended to include all registered users. This ensures that users without ratings remain visible rather than being silently excluded.

**2. Monitor inactive users.**

The platform should regularly identify users who have not submitted ratings using NOT EXISTS or similar SQL techniques. This could help administrators recognize participation gaps and investigate possible onboarding or engagement issues.

**3. Strengthen rating policy monitoring.**

The platform should continue monitoring rating policy violations and reviewing recurring patterns. The previously identified 4.00% failure rate provides a baseline for evaluating future improvements.

**4. Improve query performance monitoring.**

PostgreSQL EXPLAIN should be used when reviewing complex reporting queries. The execution plan demonstrated how Hash Joins, Nested Loops, Index Scans, and caching operations can support query execution.

### Conclusion

The Unit 5 analysis found that all 30 users had submitted ratings, with no users excluded by the INNER JOIN. However, this result should not lead administrators to assume that INNER JOIN is always appropriate for participation reporting.

Using inclusive join strategies, checking for missing records, and monitoring rating quality can help the platform maintain reliable reporting and make better-informed operational decisions.
