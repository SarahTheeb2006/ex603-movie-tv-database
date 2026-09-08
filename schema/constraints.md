# Integrity Constraints

These constraints are used to keep the data in the Movie/TV database accurate and prevent invalid information from being stored.

## Users

- `user_id` is the primary key and must be unique and not NULL.
- `display_name` cannot be NULL.

## Movies

- `movie_id` is the primary key and must be unique and not NULL.
- `title` cannot be NULL.
- `release_year` cannot be NULL and must be 1888 or later.
- `is_active` cannot be NULL.
- `runtime_min` cannot be NULL and must be greater than 0.

## Ratings

- `rating_id` is the primary key and must be unique and not NULL.
- `user_id` cannot be NULL.
- `movie_id` cannot be NULL.
- `rated_at` cannot be NULL.
- `score` cannot be NULL and must be between 1 and 5.
- The combination of `user_id` and `movie_id` must be unique so a user cannot have more than one current rating for the same movie.

### Foreign Keys

`ratings.user_id` references `users.user_id`.

**ON DELETE: RESTRICT**

I chose RESTRICT because a user should not be deleted if ratings are still connected to that user. This helps preserve rating history.

`ratings.movie_id` references `movies.movie_id`.

**ON DELETE: RESTRICT**

I chose RESTRICT because deleting a movie that already has ratings would remove part of the platform's history. A movie can instead be marked inactive using `is_active`.

## Genres

- `genre_id` is the primary key and must be unique and not NULL.
- `name` cannot be NULL.
- Each genre name must be unique so the same genre is not entered more than once.

## Movie Genres

- The primary key is (`movie_id`, `genre_id`).
- `movie_id` and `genre_id` cannot be NULL.
- The composite primary key prevents the same movie and genre combination from being added more than once.

### Foreign Keys

`movie_genres.movie_id` references `movies.movie_id`.

**ON DELETE: CASCADE**

I chose CASCADE because if a movie is permanently deleted, its connections to genres are no longer needed and should also be removed.

`movie_genres.genre_id` references `genres.genre_id`.

**ON DELETE: CASCADE**

I chose CASCADE because if a genre is deleted, the movie-genre relationships connected to it should also be removed.
