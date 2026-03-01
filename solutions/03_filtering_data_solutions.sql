/*
================================================================================
SOLUTIONS: EXERCISE 3 - FILTERING DATA
================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

-- PART 1: BASIC WHERE CLAUSE

-- Solution: Show only movies from 2023
SELECT title, release_year, genre
FROM MOVIES
WHERE release_year = 2023;

-- Solution: Show only users from USA
SELECT username, country, subscription_type
FROM USERS
WHERE country = 'USA';

-- PART 2: COMPARISON OPERATORS

-- Solution: Show streaming views where watch_duration_minutes is greater than 100
SELECT view_id, user_id, movie_id, watch_duration_minutes
FROM STREAMING_VIEWS
WHERE watch_duration_minutes > 100;

-- Solution: Show movies that are NOT from 2023
SELECT title, release_year
FROM MOVIES
WHERE release_year != 2023;
-- OR
SELECT title, release_year
FROM MOVIES
WHERE release_year <> 2023;

-- PART 3: COMBINING CONDITIONS WITH AND

-- Solution: Movies from 2023 with rating greater than 8.0
SELECT title, release_year, rating, genre
FROM MOVIES
WHERE release_year = 2023 AND rating > 8.0;

-- Solution: Streaming views on Smart TV with duration over 100 minutes
SELECT view_id, device_type, watch_duration_minutes, user_id
FROM STREAMING_VIEWS
WHERE device_type = 'Smart TV' AND watch_duration_minutes > 100;

-- PART 4: COMBINING CONDITIONS WITH OR

-- Solution: Movies from either 2023 or 2022
SELECT title, release_year, genre
FROM MOVIES
WHERE release_year = 2023 OR release_year = 2022;

-- PART 5: COMBINING AND & OR

-- Solution: Movies from 2023 that are either Drama or Romance
SELECT title, release_year, genre, rating
FROM MOVIES
WHERE release_year = 2023 AND (genre = 'Drama' OR genre = 'Romance');

-- Solution: Streaming views on Smart TV or Laptop with duration over 120 minutes
SELECT view_id, device_type, watch_duration_minutes
FROM STREAMING_VIEWS
WHERE (device_type = 'Smart TV' OR device_type = 'Laptop') 
  AND watch_duration_minutes > 120;

-- PART 6: IN OPERATOR

-- Solution: Movies from years 2021, 2022, or 2023
SELECT title, release_year, genre
FROM MOVIES
WHERE release_year IN (2021, 2022, 2023);

-- PART 7: BETWEEN OPERATOR

-- Solution: Streaming views with duration between 90 and 120 minutes
SELECT view_id, user_id, watch_duration_minutes
FROM STREAMING_VIEWS
WHERE watch_duration_minutes BETWEEN 90 AND 120;

-- PART 8: LIKE OPERATOR

-- Solution: Users whose username starts with 'a'
SELECT username, country
FROM USERS
WHERE username LIKE 'a%';

-- Solution: Movies with "Cloud" anywhere in the title
SELECT title, genre, rating
FROM MOVIES
WHERE title LIKE '%Cloud%';

-- PART 9: NOT OPERATOR

-- Solution: Streaming views NOT on Mobile devices
SELECT view_id, device_type, watch_duration_minutes
FROM STREAMING_VIEWS
WHERE device_type != 'Mobile';
-- OR
SELECT view_id, device_type, watch_duration_minutes
FROM STREAMING_VIEWS
WHERE NOT device_type = 'Mobile';

-- CHALLENGE EXERCISES

-- Challenge 1: Find all Drama movies from 2023 with rating above 8.0
SELECT title, genre, release_year, rating
FROM MOVIES
WHERE genre = 'Drama' 
  AND release_year = 2023 
  AND rating > 8.0;

-- Challenge 2: Find Premium users from USA or UK who joined in 2022
SELECT username, country, subscription_type, join_date
FROM USERS
WHERE subscription_type = 'Premium'
  AND (country = 'USA' OR country = 'UK')
  AND join_date BETWEEN '2022-01-01' AND '2022-12-31';

-- Challenge 3: Find streaming views on Smart TV or Laptop with duration between 100 and 130 minutes
SELECT view_id, device_type, watch_duration_minutes, user_id
FROM STREAMING_VIEWS
WHERE (device_type = 'Smart TV' OR device_type = 'Laptop')
  AND watch_duration_minutes BETWEEN 100 AND 130;

-- Challenge 4: Find movies that are either Sci-Fi or Adventure, rating >= 8.0, from 2022 or 2023
SELECT title, genre, rating, release_year
FROM MOVIES
WHERE (genre = 'Sci-Fi' OR genre = 'Adventure')
  AND rating >= 8.0
  AND release_year IN (2022, 2023);

-- Challenge 5: Find users whose username contains "a" and are from Canada or Germany
SELECT username, country
FROM USERS
WHERE username LIKE '%a%'
  AND (country = 'Canada' OR country = 'Germany');

-- Challenge 6: Find movies that are NOT (Drama OR Romance) and have rating above 8.0
SELECT title, genre, rating
FROM MOVIES
WHERE NOT (genre = 'Drama' OR genre = 'Romance')
  AND rating > 8.0;
-- OR
SELECT title, genre, rating
FROM MOVIES
WHERE genre NOT IN ('Drama', 'Romance')
  AND rating > 8.0;