# Unit 1 Analysis

## Modelling Justification

For my Movie/TV database, I designed five relations: Users, Movies, Ratings, Genres, and Movie Genres. My goal was to keep the database organized while making sure each record can be uniquely identified and that relationships between the different types of data are clearly defined.

For the Users relation, I chose `user_id` as the primary key because every user needs a unique identifier. A display name would not work well as a primary key because two users could have the same name, and a user may also want to change their display name later. Similarly, I chose `movie_id`, `rating_id`, and `genre_id` as the primary keys for Movies, Ratings, and Genres. Using IDs makes it easier to reference these records without depending on information such as a movie title or genre name that could potentially change.

The Movie Genres relation is different because I used a composite primary key consisting of `movie_id` and `genre_id`. This relation connects movies with genres. A movie can belong to several genres, while one genre can be assigned to many movies. Using both IDs as the primary key prevents the same movie and genre combination from being stored more than once.

I also made specific decisions about how deletions should be handled. The foreign keys `ratings.user_id` and `ratings.movie_id` use `ON DELETE RESTRICT`. I chose this because ratings are part of the platform's history. If a user has submitted ratings, deleting that user could leave incomplete information. Movies with ratings should also not be permanently deleted. Instead, the `is_active` attribute allows a movie to remain in the database while no longer being active on the platform. This preserves its existing ratings and historical information.

For the Movie Genres relation, I chose `ON DELETE CASCADE` for both foreign keys. If a movie is permanently deleted, there is no reason to keep records connecting that movie to genres. The same applies if a genre is deleted. Automatically removing these relationships prevents records in Movie Genres from referring to data that no longer exists.

Several rules are enforced in the database schema instead of being left entirely to the application. For example, a rating score must be between 1 and 5, a movie's runtime must be greater than zero, and its release year must be 1888 or later. Genre names must also be unique. I also made the combination of `user_id` and `movie_id` unique in Ratings so one user cannot have multiple current ratings for the same movie. Enforcing these rules at the database level provides an additional layer of protection. Even if the application contains an error, the database can still reject data that violates these requirements.

Overall, these design decisions help keep the database consistent while supporting the main information the Movie/TV platform needs to store and retrieve.

## Reflection

One design decision that another designer could reasonably make differently is how user ratings are stored. I decided that a user can have only one current rating for each movie. The combination of `user_id` and `movie_id` is therefore unique in the Ratings relation. If a user changes their opinion about a movie, the existing rating can be updated instead of creating another rating record.

Another designer might choose to allow multiple ratings from the same user for the same movie. That approach could preserve a complete history of how a user's rating changed over time. Since the Ratings relation already includes `rated_at`, storing multiple ratings would make it possible to analyze those changes.

I chose the one-current-rating approach because I think it better matches the common read and write patterns of a Movie/TV platform. When displaying a movie, the platform will often need to calculate its current average rating or determine what score a particular user gave it. Having only one current rating per user and movie makes these reads simpler because the system does not have to determine which rating is the newest. When a user changes a score, the platform can update one existing record. This keeps the current rating data straightforward while still recording when the rating was last submitted or updated.
