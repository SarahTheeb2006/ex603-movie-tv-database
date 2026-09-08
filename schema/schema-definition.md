# Schema Definition

This file defines the five relations for my Movie/TV database. It includes the attributes, domains, and primary key for each relation.

## 1. Users

**Relation:** users(user_id, display_name)

| Attribute | Domain | Description |
| --- | --- | --- |
| user_id | INTEGER | Unique ID for each user |
| display_name | VARCHAR(100) | Name displayed for the user |

**Primary Key:** user_id

## 2. Movies

**Relation:** movies(movie_id, title, release_year, is_active, runtime_min)

| Attribute | Domain | Description |
| --- | --- | --- |
| movie_id | INTEGER | Unique ID for each movie |
| title | VARCHAR(255) | Title of the movie |
| release_year | INTEGER | Year the movie was released |
| is_active | BOOLEAN | Shows whether the movie is active on the platform |
| runtime_min | INTEGER | Length of the movie in minutes |

**Primary Key:** movie_id

I chose `runtime_min` as the numeric attribute for movies because it can be used later to filter movies based on their length.

## 3. Ratings

**Relation:** ratings(rating_id, user_id, movie_id, rated_at, score)

| Attribute | Domain | Description |
| --- | --- | --- |
| rating_id | INTEGER | Unique ID for each rating |
| user_id | INTEGER | User who submitted the rating |
| movie_id | INTEGER | Movie that was rated |
| rated_at | TIMESTAMP | Date and time the rating was submitted |
| score | INTEGER | Rating score given by the user |

**Primary Key:** rating_id

`user_id` and `movie_id` will also be foreign keys connecting a rating to a user and a movie.

## 4. Genres

**Relation:** genres(genre_id, name)

| Attribute | Domain | Description |
| --- | --- | --- |
| genre_id | INTEGER | Unique ID for each genre |
| name | VARCHAR(100) | Name of the genre |

**Primary Key:** genre_id

## 5. Movie Genres

**Relation:** movie_genres(movie_id, genre_id)

| Attribute | Domain | Description |
| --- | --- | --- |
| movie_id | INTEGER | Movie in the relationship |
| genre_id | INTEGER | Genre assigned to the movie |

**Primary Key:** (movie_id, genre_id)

I used both IDs together as the primary key because a movie can have several genres, and a genre can be connected to many movies.
