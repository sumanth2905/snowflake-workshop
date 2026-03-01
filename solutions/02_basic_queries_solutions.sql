/*
================================================================================
SOLUTIONS: EXERCISE 2 - BASIC SQL QUERIES
================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

-- PART 1: SELECTING SPECIFIC COLUMNS

-- Solution: Show only username and country from USERS
SELECT username, country FROM USERS;

-- Solution: Show movie_id, title, and genre from MOVIES
SELECT movie_id, title, genre FROM MOVIES;

-- PART 2: USING ALIASES

-- Solution: Select title as "Movie Title" and director as "Directed By"
SELECT 
    title AS "Movie Title",
    director AS "Directed By"
FROM MOVIES;

-- PART 3: LIMITING RESULTS

-- Solution: Show the first 7 streaming views
SELECT * FROM STREAMING_VIEWS LIMIT 7;

-- Solution: Show the first 2 movies with only title and rating columns
SELECT title, rating FROM MOVIES LIMIT 2;

-- PART 4: SORTING DATA

-- Solution: Show all movies sorted by release_year (newest first)
SELECT title, release_year, genre
FROM MOVIES
ORDER BY release_year DESC;

-- Solution: Show usernames sorted alphabetically, limit to 5
SELECT username, country
FROM USERS
ORDER BY username ASC
LIMIT 5;

-- PART 6: COMBINING TECHNIQUES

-- Solution: Show the top 5 longest viewing sessions
SELECT view_id, user_id, movie_id, watch_duration_minutes, device_type
FROM STREAMING_VIEWS
ORDER BY watch_duration_minutes DESC
LIMIT 5;

-- PART 7: DISTINCT VALUES

-- Solution: What subscription types do we offer?
SELECT DISTINCT subscription_type FROM USERS;

-- CHALLENGE EXERCISES

-- Challenge 1: Show the 3 oldest movies (by release_year) with their titles and directors
SELECT title, director, release_year
FROM MOVIES
ORDER BY release_year ASC
LIMIT 3;

-- Challenge 2: List all unique genres sorted alphabetically
SELECT DISTINCT genre
FROM MOVIES
ORDER BY genre ASC;

-- Challenge 3: Show the top 5 streaming views sorted by watch_duration_minutes (longest first)
SELECT view_id, movie_id, user_id, watch_duration_minutes
FROM STREAMING_VIEWS
ORDER BY watch_duration_minutes DESC
LIMIT 5;

-- Challenge 4: Create a query showing Film Name, Score, Director (top 5 by rating)
SELECT 
    title AS "Film Name",
    rating AS "Score",
    director AS "Director"
FROM MOVIES
ORDER BY rating DESC
LIMIT 5;