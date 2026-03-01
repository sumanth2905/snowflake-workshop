/*
================================================================================
EXERCISE 4: AGGREGATIONS AND GROUPING
================================================================================

In this exercise, you'll learn:
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY to organize data
- HAVING to filter groups
- Combining aggregations with filtering

AGGREGATIONS help you answer questions like:
- "How many movies do we have?"
- "What's the average rating?"
- "Which genre has the most movies?"

================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

/*
--------------------------------------------------------------------------------
PART 1: COUNT - Counting Rows
--------------------------------------------------------------------------------

COUNT(*) counts all rows
COUNT(column) counts non-null values in that column
*/

-- Example: How many movies do we have?
SELECT COUNT(*) AS total_movies
FROM MOVIES;

-- Example: How many users do we have?
SELECT COUNT(*) AS total_users
FROM USERS;

-- Example: How many streaming views were recorded?
SELECT COUNT(*) AS total_views
FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: Count how many Premium users we have
-- Hint: Use WHERE to filter first, then COUNT





-- 📝 YOUR TURN: Count how many movies are from 2023





/*
--------------------------------------------------------------------------------
PART 2: SUM - Adding Up Values
--------------------------------------------------------------------------------

SUM adds up all values in a numeric column.
*/

-- Example: Total minutes watched across all streaming views
SELECT SUM(watch_duration_minutes) AS total_minutes_watched
FROM STREAMING_VIEWS;

-- Example: Total watch time in hours
SELECT SUM(watch_duration_minutes) / 60 AS total_hours_watched
FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: Calculate the total watch duration for Smart TV devices only
-- Hint: Use WHERE to filter device_type first





/*
--------------------------------------------------------------------------------
PART 3: AVG - Calculating Averages
--------------------------------------------------------------------------------

AVG calculates the average (mean) of numeric values.
*/

-- Example: What's the average movie rating?
SELECT AVG(rating) AS average_rating
FROM MOVIES;

-- Example: Average movie rating rounded to 2 decimal places
SELECT ROUND(AVG(rating), 2) AS average_rating
FROM MOVIES;

-- Example: Average watch duration
SELECT AVG(watch_duration_minutes) AS avg_watch_duration
FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: What's the average rating for Sci-Fi movies?





-- 📝 YOUR TURN: What's the average watch duration for Mobile devices?
SELECT ROUND(AVG(watch_duration_minutes), 2) AS avg_mobile_duration
FROM STREAMING_VIEWS
WHERE device_type = 'Mobile';




/*
--------------------------------------------------------------------------------
PART 4: MIN and MAX - Finding Extremes
--------------------------------------------------------------------------------

MIN finds the smallest value
MAX finds the largest value
*/

-- Example: Lowest and highest movie ratings
SELECT 
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating
FROM MOVIES;

-- Example: Earliest and latest release years
SELECT 
    MIN(release_year) AS oldest_movie_year,
    MAX(release_year) AS newest_movie_year
FROM MOVIES;

-- Example: Shortest and longest viewing sessions
SELECT 
    MIN(watch_duration_minutes) AS shortest_view,
    MAX(watch_duration_minutes) AS longest_view
FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: Find the earliest and latest join dates for users
SELECT 
    MIN(join_date) AS first_user,
    MAX(join_date) AS latest_user
FROM USERS;


/*
--------------------------------------------------------------------------------
PART 5: COMBINING MULTIPLE AGGREGATIONS
--------------------------------------------------------------------------------

You can use multiple aggregate functions in one query!
*/

-- Example: Complete statistics for movie ratings
SELECT 
    COUNT(*) AS total_movies,
    AVG(rating) AS average_rating,
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating,
    ROUND(AVG(rating), 2) AS avg_rating_rounded
FROM MOVIES;

-- Example: Streaming statistics
SELECT 
    COUNT(*) AS total_views,
    SUM(watch_duration_minutes) AS total_minutes,
    AVG(watch_duration_minutes) AS avg_minutes,
    MIN(watch_duration_minutes) AS shortest_session,
    MAX(watch_duration_minutes) AS longest_session
FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: Create user statistics showing:
-- - Total number of users
-- - Number of Premium users
-- - Number of Basic users
-- Hint: Use COUNT with WHERE in subqueries, or use CASE (we'll learn this later)

SELECT 
    COUNT(*) AS total_users,
    COUNT(CASE WHEN subscription_type = 'Premium' THEN 1 END) AS premium_users,
    COUNT(CASE WHEN subscription_type = 'Basic' THEN 1 END) AS basic_users
FROM USERS;




/*
--------------------------------------------------------------------------------
PART 6: GROUP BY - Grouping Data
--------------------------------------------------------------------------------

GROUP BY organizes rows into groups based on column values.
Then you can calculate aggregates for each group!

Think of it like: "Show me statistics FOR EACH category"
*/

-- Example: Count movies by genre
SELECT 
    genre,
    COUNT(*) AS movie_count
FROM MOVIES
GROUP BY genre
ORDER BY movie_count DESC;

-- Example: Count users by country
SELECT 
    country,
    COUNT(*) AS user_count
FROM USERS
GROUP BY country
ORDER BY user_count DESC;

-- Example: Count users by subscription type
SELECT 
    subscription_type,
    COUNT(*) AS user_count
FROM USERS
GROUP BY subscription_type;

-- 📝 YOUR TURN: Count streaming views by device type





-- 📝 YOUR TURN: Count movies by release year
SELECT 
    release_year,
    COUNT(*) AS movies_released
FROM MOVIES
GROUP BY release_year
ORDER BY release_year DESC;




/*
--------------------------------------------------------------------------------
PART 7: GROUP BY with Multiple Aggregations
--------------------------------------------------------------------------------

You can calculate multiple statistics for each group.
*/

-- Example: Statistics for each genre
SELECT 
    genre,
    COUNT(*) AS movie_count,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM MOVIES
GROUP BY genre
ORDER BY avg_rating DESC;

-- Example: Viewing statistics by device type
SELECT 
    device_type,
    COUNT(*) AS view_count,
    SUM(watch_duration_minutes) AS total_minutes,
    AVG(watch_duration_minutes) AS avg_minutes,
    MAX(watch_duration_minutes) AS longest_session
FROM STREAMING_VIEWS
GROUP BY device_type
ORDER BY total_minutes DESC;

-- 📝 YOUR TURN: Show statistics by country:
-- - Country name
-- - Number of users
-- - Number of Premium users (use COUNT with CASE)
SELECT 
    country,
    COUNT(*) AS total_users,
    COUNT(CASE WHEN subscription_type = 'Premium' THEN 1 END) AS premium_users
FROM USERS
GROUP BY country
ORDER BY total_users DESC;




/*
--------------------------------------------------------------------------------
PART 8: GROUP BY Multiple Columns
--------------------------------------------------------------------------------

You can group by multiple columns to create more detailed categories.
*/

-- Example: Count users by country AND subscription type
SELECT 
    country,
    subscription_type,
    COUNT(*) AS user_count
FROM USERS
GROUP BY country, subscription_type
ORDER BY country, subscription_type;

-- Example: Movie count by release year and genre
SELECT 
    release_year,
    genre,
    COUNT(*) AS movie_count,
    AVG(rating) AS avg_rating
FROM MOVIES
GROUP BY release_year, genre
ORDER BY release_year DESC, genre;

-- 📝 YOUR TURN: Show viewing statistics by device_type and user_id
-- Include: device_type, user_id, count of views, total minutes watched
SELECT 
    device_type,
    user_id,
    COUNT(*) AS view_count,
    SUM(watch_duration_minutes) AS total_minutes
FROM STREAMING_VIEWS
GROUP BY device_type, user_id
ORDER BY total_minutes DESC;




/*
--------------------------------------------------------------------------------
PART 9: HAVING - Filtering Groups
--------------------------------------------------------------------------------

WHERE filters rows BEFORE grouping
HAVING filters groups AFTER aggregation

Think of it as: "Show me groups WHERE the aggregate meets a condition"
*/

-- Example: Genres with more than 1 movie
SELECT 
    genre,
    COUNT(*) AS movie_count
FROM MOVIES
GROUP BY genre
HAVING COUNT(*) > 1
ORDER BY movie_count DESC;

-- Example: Countries with more than 1 user
SELECT 
    country,
    COUNT(*) AS user_count
FROM USERS
GROUP BY country
HAVING COUNT(*) > 1
ORDER BY user_count DESC;

-- Example: Genres with average rating above 8.0
SELECT 
    genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM MOVIES
GROUP BY genre
HAVING AVG(rating) > 8.0
ORDER BY avg_rating DESC;

-- 📝 YOUR TURN: Find device types where total watch time exceeds 300 minutes
SELECT 
    device_type,
    SUM(watch_duration_minutes) AS total_minutes
FROM STREAMING_VIEWS
GROUP BY device_type
HAVING SUM(watch_duration_minutes) > 300
ORDER BY total_minutes DESC;




-- 📝 YOUR TURN: Find users who have watched more than 2 times
-- Hint: Group by user_id, count views, filter with HAVING
SELECT 
    user_id,
    COUNT(*) AS view_count
FROM STREAMING_VIEWS
GROUP BY user_id
HAVING COUNT(*) > 2
ORDER BY view_count DESC;




/*
--------------------------------------------------------------------------------
PART 10: Combining WHERE, GROUP BY, and HAVING
--------------------------------------------------------------------------------

You can use all three together!
- WHERE filters rows before grouping
- GROUP BY creates groups
- HAVING filters groups after aggregation
*/

-- Example: Average rating by genre for movies from 2022 onwards,
-- only show genres with avg rating > 8.0
SELECT 
    genre,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM MOVIES
WHERE release_year >= 2022
GROUP BY genre
HAVING AVG(rating) > 8.0
ORDER BY avg_rating DESC;

-- Example: Total watch time by device for sessions over 90 minutes,
-- only show devices with total time > 200 minutes
SELECT 
    device_type,
    COUNT(*) AS session_count,
    SUM(watch_duration_minutes) AS total_minutes
FROM STREAMING_VIEWS
WHERE watch_duration_minutes > 90
GROUP BY device_type
HAVING SUM(watch_duration_minutes) > 200
ORDER BY total_minutes DESC;

-- 📝 YOUR TURN: Count Premium users by country,
-- only for countries with more than 1 Premium user
SELECT 
    country,
    COUNT(*) AS premium_user_count
FROM USERS
WHERE subscription_type = 'Premium'
GROUP BY country
HAVING COUNT(*) > 1
ORDER BY premium_user_count DESC;




/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Find the genre with the highest average rating
-- Show genre, movie count, and average rating





-- Challenge 2: Which user has watched the most total minutes?
-- Show user_id and total minutes watched





-- Challenge 3: For each device type, show:
-- - Device type
-- - Number of views
-- - Total minutes watched
-- - Average minutes per view
-- Only include devices with at least 3 views
-- Order by total minutes (highest first)





-- Challenge 4: Find countries where the average user has been subscribed since before 2023
-- Show country and average join date
-- Hint: Use AVG with dates, and HAVING with a date condition
SELECT 
    country,
    AVG(join_date) AS avg_join_date
FROM USERS
GROUP BY country
HAVING AVG(join_date) < '2023-01-01'
ORDER BY avg_join_date;




-- Challenge 5: Create a summary report showing:
-- - Total movies, avg rating across all movies
-- - Total users, breakdown by subscription type
-- - Total streaming views, total hours watched
-- Hint: Use multiple SELECT statements with UNION ALL (or separate queries)

SELECT 'Movies' AS category, COUNT(*) AS count, ROUND(AVG(rating), 2) AS avg_value
FROM MOVIES
UNION ALL
SELECT 'Users', COUNT(*), NULL
FROM USERS
UNION ALL
SELECT 'Streaming Views', COUNT(*), ROUND(SUM(watch_duration_minutes)/60.0, 2)
FROM STREAMING_VIEWS;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 4: Aggregations and Grouping

KEY TAKEAWAYS:
- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY organizes data into categories
- HAVING filters groups (after aggregation)
- WHERE filters rows (before aggregation)

QUERY STRUCTURE:
SELECT column, AGG_FUNCTION(column)
FROM table
WHERE condition (filters rows)
GROUP BY column
HAVING condition (filters groups)
ORDER BY column
LIMIT number;

NEXT: Move on to Exercise 5 - Joins
================================================================================
*/