/*
================================================================================
SOLUTIONS: EXERCISE 5 - JOINS
================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

-- PART 1: INNER JOIN

-- Solution: Join STREAMING_VIEWS with MOVIES
SELECT 
    sv.view_id,
    m.title AS movie_title,
    m.genre,
    sv.watch_duration_minutes,
    sv.device_type
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
ORDER BY sv.view_id;

-- PART 2: JOINING MULTIPLE TABLES

-- Solution: Show viewing data with usernames and movie titles
SELECT 
    u.username,
    m.title AS movie_title,
    sv.watch_duration_minutes,
    sv.device_type,
    sv.view_date
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
ORDER BY u.username;

-- PART 3: FILTERING JOINED DATA

-- Solution: Show movies watched by Premium users
SELECT 
    u.username,
    u.subscription_type,
    m.title AS movie_title,
    m.genre,
    sv.watch_duration_minutes
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
WHERE u.subscription_type = 'Premium'
ORDER BY u.username;

-- Solution: Show movies from 2023 that were watched on Smart TV
SELECT 
    m.title AS movie_title,
    m.release_year,
    sv.device_type,
    u.username,
    sv.watch_duration_minutes
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
WHERE m.release_year = 2023 AND sv.device_type = 'Smart TV';

-- PART 4: AGGREGATIONS WITH JOINS

-- Solution: Show total watch time by country
SELECT 
    u.country,
    SUM(sv.watch_duration_minutes) AS total_minutes,
    COUNT(*) AS view_count,
    COUNT(DISTINCT u.user_id) AS unique_users
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
GROUP BY u.country
ORDER BY total_minutes DESC;

-- Solution: Show viewing statistics by device type
SELECT 
    sv.device_type,
    COUNT(DISTINCT sv.user_id) AS unique_users,
    COUNT(*) AS total_views,
    ROUND(AVG(sv.watch_duration_minutes), 2) AS avg_duration,
    SUM(sv.watch_duration_minutes) AS total_minutes
FROM STREAMING_VIEWS sv
GROUP BY sv.device_type
ORDER BY total_views DESC;

-- PART 5: LEFT JOIN

-- Solution: Show ALL users and how many movies they've watched (including users with 0 views)
SELECT 
    u.user_id,
    u.username,
    u.country,
    u.subscription_type,
    COUNT(sv.view_id) AS movies_watched,
    COALESCE(SUM(sv.watch_duration_minutes), 0) AS total_watch_time
FROM USERS u
LEFT JOIN STREAMING_VIEWS sv ON u.user_id = sv.user_id
GROUP BY u.user_id, u.username, u.country, u.subscription_type
ORDER BY movies_watched DESC;

-- CHALLENGE EXERCISES

-- Challenge 1: Find the most-watched movie
SELECT 
    m.title AS movie_title,
    m.genre,
    m.director,
    COUNT(*) AS view_count,
    SUM(sv.watch_duration_minutes) AS total_watch_time
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
GROUP BY m.title, m.genre, m.director
ORDER BY view_count DESC
LIMIT 1;

-- Challenge 2: Which Premium users have watched Sci-Fi movies?
SELECT DISTINCT
    u.username,
    u.country,
    m.title AS movie_title,
    sv.watch_duration_minutes
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
WHERE u.subscription_type = 'Premium'
  AND m.genre = 'Sci-Fi'
ORDER BY u.username, m.title;

-- Challenge 3: Create a report showing for each country
SELECT 
    u.country,
    COUNT(DISTINCT u.user_id) AS user_count,
    COUNT(sv.view_id) AS total_movies_watched,
    ROUND(SUM(sv.watch_duration_minutes) / 60.0, 2) AS total_hours,
    ROUND(AVG(sv.watch_duration_minutes), 2) AS avg_session_minutes
FROM USERS u
LEFT JOIN STREAMING_VIEWS sv ON u.user_id = sv.user_id
GROUP BY u.country
ORDER BY total_hours DESC;

-- Challenge 4: Find users who have watched movies with rating > 8.0
SELECT DISTINCT
    u.username,
    u.subscription_type,
    m.title AS movie_title,
    m.rating,
    m.genre
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
WHERE m.rating > 8.0
ORDER BY u.username, m.rating DESC;

-- Challenge 5: Which director's movies have been watched the most?
SELECT 
    m.director,
    COUNT(DISTINCT m.movie_id) AS movie_count,
    COUNT(sv.view_id) AS total_views,
    SUM(sv.watch_duration_minutes) AS total_watch_time,
    ROUND(AVG(m.rating), 2) AS avg_movie_rating
FROM MOVIES m
LEFT JOIN STREAMING_VIEWS sv ON m.movie_id = sv.movie_id
GROUP BY m.director
ORDER BY total_views DESC;

-- Challenge 7: Find movies that are popular (>= 2 views) among Premium users only
SELECT 
    m.title AS movie_title,
    m.genre,
    m.rating,
    COUNT(*) AS premium_view_count,
    COUNT(DISTINCT u.user_id) AS unique_premium_viewers
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
WHERE u.subscription_type = 'Premium'
GROUP BY m.title, m.genre, m.rating
HAVING COUNT(*) >= 2
ORDER BY premium_view_count DESC;