/*
================================================================================
SOLUTIONS: EXERCISE 4 - AGGREGATIONS AND GROUPING
================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

-- PART 1: COUNT

-- Solution: Count how many Premium users we have
SELECT COUNT(*) AS premium_user_count
FROM USERS
WHERE subscription_type = 'Premium';

-- Solution: Count how many movies are from 2023
SELECT COUNT(*) AS movies_from_2023
FROM MOVIES
WHERE release_year = 2023;

-- PART 2: SUM

-- Solution: Calculate the total watch duration for Smart TV devices only
SELECT SUM(watch_duration_minutes) AS total_smart_tv_minutes
FROM STREAMING_VIEWS
WHERE device_type = 'Smart TV';

-- PART 3: AVG

-- Solution: What's the average rating for Sci-Fi movies?
SELECT ROUND(AVG(rating), 2) AS avg_scifi_rating
FROM MOVIES
WHERE genre = 'Sci-Fi';

-- PART 6: GROUP BY

-- Solution: Count streaming views by device type
SELECT 
    device_type,
    COUNT(*) AS view_count
FROM STREAMING_VIEWS
GROUP BY device_type
ORDER BY view_count DESC;

-- PART 9: HAVING

-- Solution: Find device types where total watch time exceeds 300 minutes
SELECT 
    device_type,
    SUM(watch_duration_minutes) AS total_minutes,
    COUNT(*) AS view_count
FROM STREAMING_VIEWS
GROUP BY device_type
HAVING SUM(watch_duration_minutes) > 300
ORDER BY total_minutes DESC;

-- Solution: Find users who have watched more than 2 times
SELECT 
    user_id,
    COUNT(*) AS view_count,
    SUM(watch_duration_minutes) AS total_watch_time
FROM STREAMING_VIEWS
GROUP BY user_id
HAVING COUNT(*) > 2
ORDER BY view_count DESC;

-- PART 10: COMBINING WHERE, GROUP BY, AND HAVING

-- Solution: Count Premium users by country, only for countries with more than 1 Premium user
SELECT 
    country,
    COUNT(*) AS premium_user_count
FROM USERS
WHERE subscription_type = 'Premium'
GROUP BY country
HAVING COUNT(*) > 1
ORDER BY premium_user_count DESC;

-- CHALLENGE EXERCISES

-- Challenge 1: Find the genre with the highest average rating
SELECT 
    genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM MOVIES
GROUP BY genre
ORDER BY avg_rating DESC
LIMIT 1;

-- Challenge 2: Which user has watched the most total minutes?
SELECT 
    user_id,
    SUM(watch_duration_minutes) AS total_minutes_watched,
    COUNT(*) AS view_count
FROM STREAMING_VIEWS
GROUP BY user_id
ORDER BY total_minutes_watched DESC
LIMIT 1;

-- Challenge 3: For each device type, show statistics (only devices with >= 3 views)
SELECT 
    device_type,
    COUNT(*) AS view_count,
    SUM(watch_duration_minutes) AS total_minutes,
    ROUND(AVG(watch_duration_minutes), 2) AS avg_minutes_per_view
FROM STREAMING_VIEWS
GROUP BY device_type
HAVING COUNT(*) >= 3
ORDER BY total_minutes DESC;