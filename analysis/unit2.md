# Unit 2 Analysis — Movie/TV Database

## Foreign Key Constraints

| Foreign Key | ON DELETE Choice | Reason |
|---|---|---|
| ratings.user_id → users.user_id | CASCADE | If a user is deleted, the ratings created by that user should also be removed. |
| ratings.movie_id → movies.movie_id | CASCADE | If a movie is deleted, its ratings should also be removed because they no longer have a movie to reference. |
| movie_genres.movie_id → movies.movie_id | CASCADE | If a movie is deleted, its genre relationships should also be removed. |
| movie_genres.genre_id → genres.genre_id | CASCADE | If a genre is deleted, the connections between that genre and movies should also be removed. |

## ON DELETE Reasoning

For the relationship between users and ratings, I chose ON DELETE CASCADE because a rating depends on the user who created it. If a user is removed from the platform, their ratings should be removed as well. Without CASCADE, ratings could remain that reference a user who no longer exists.

I also chose ON DELETE CASCADE for the relationship between movies and ratings. A rating only makes sense when it is connected to a movie. If a movie is removed from the database, keeping its ratings would leave information that is no longer useful to the platform.

For movie_genres, I used ON DELETE CASCADE for both foreign keys. The movie_genres table only represents the relationship between a movie and a genre. If either the movie or genre is deleted, that relationship should no longer exist. Using CASCADE automatically removes those rows and prevents relationships from being left behind with missing movies or genres.

## CHECK Constraints

### Movie Release Year

The `chk_movies_release_year` constraint requires `release_year` to be 1888 or later. This prevents an invalid year, such as 1700, from being stored for a movie. Without this constraint, incorrect data could be entered accidentally and remain in the database.

### Movie Runtime

The `chk_movies_runtime` constraint requires `runtime_min` to be greater than 0. This prevents impossible values such as a runtime of 0 or a negative number. A movie must have a positive runtime, so this constraint helps keep the data valid.

### Rating Score

The `chk_ratings_score` constraint requires the score to be between 1 and 5. This prevents values outside the rating system, such as 0, 6, or a negative number, from being stored. This keeps every rating within the range used by the platform.

## Implementation Notes

The PostgreSQL implementation follows the same overall design as the Unit 1 ERD. The tables are created in dependency order so that every referenced table exists before its foreign keys are created. The `movie_genres` table uses the combination of `movie_id` and `genre_id` as its composite primary key because each row represents one unique relationship between a movie and a genre.
