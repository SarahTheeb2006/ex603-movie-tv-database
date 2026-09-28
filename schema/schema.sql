-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Movie/TV Database
-- Author: Sarah Theeb
-- Target: PostgreSQL 14+
-- =================================================================

-- Reset. Reverse creation order so dependencies do not block a drop.

DROP TABLE IF EXISTS movie_genres CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS users CASCADE;


-- -----------------------------------------------------------------
-- 1. users — created first because it references no other tables.
-- -----------------------------------------------------------------

CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY,
    display_name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (user_id)
);


-- -----------------------------------------------------------------
-- 2. movies — created next because it references no other tables.
-- -----------------------------------------------------------------

CREATE TABLE movies (
    movie_id INTEGER GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(200) NOT NULL,
    release_year INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL,
    runtime_min INTEGER NOT NULL,

    CONSTRAINT pk_movies PRIMARY KEY (movie_id),
    CONSTRAINT chk_movies_release_year CHECK (release_year >= 1888),
    CONSTRAINT chk_movies_runtime CHECK (runtime_min > 0)
);


-- -----------------------------------------------------------------
-- 3. genres — created before movie_genres because the junction
-- table references it.
-- -----------------------------------------------------------------

CREATE TABLE genres (
    genre_id INTEGER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_genres PRIMARY KEY (genre_id),
    CONSTRAINT uq_genres_name UNIQUE (name)
);


-- -----------------------------------------------------------------
-- 4. ratings — created after users and movies because it
-- references both tables.
-- -----------------------------------------------------------------

CREATE TABLE ratings (
    rating_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    score INTEGER NOT NULL,
    rating_date DATE NOT NULL,

    CONSTRAINT pk_ratings PRIMARY KEY (rating_id),
    CONSTRAINT fk_ratings_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ratings_movie
        FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_ratings_score CHECK (score BETWEEN 1 AND 5),
    CONSTRAINT uq_ratings_user_movie UNIQUE (user_id, movie_id)
);


-- -----------------------------------------------------------------
-- 5. movie_genres — created last because it references
-- both movies and genres.
-- -----------------------------------------------------------------

CREATE TABLE movie_genres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    CONSTRAINT pk_movie_genres PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_movie_genres_movie
        FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_movie_genres_genre
        FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
        ON DELETE CASCADE
);
