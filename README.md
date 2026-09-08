# EX 603 Movie/TV Database

## Project Summary

This project models a relational database for a Movie/TV platform where users can rate movies and movies can be classified into different genres. The database is designed to store users, movies, ratings, genres, and the relationships between movies and genres.

**Theme:** Movie / TV

## Domain

The Movie/TV platform allows users to interact with a catalog of movies by submitting ratings. The database must keep track of each user, the movies available on the platform, and the ratings users submit. Each rating connects a user to a movie and records a score that can later be used to analyze user preferences and movie performance.

Movies can belong to multiple genres, such as comedy, drama, action, or science fiction, and each genre can contain many movies. Because of this many-to-many relationship, the database uses a separate movie-genres relationship to connect movies and genres. The database must support questions such as which movies a user has rated, what ratings a movie has received, what a movie's average rating is, and which movies belong to a particular genre.

The design uses five main roles: users as the actor, movies as the producer, ratings as the event, genres as the catalog, and movie_genres as the junction between movies and genres.

## Schema

The Entity Relationship Diagram (ERD) will be added here after the schema design is completed.
