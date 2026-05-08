/*
================================================================================
EXERCISE 5: JOINS - COMBINING DATA FROM MULTIPLE TABLES
================================================================================

In this exercise, you'll learn:
- What joins are and why they're important
- INNER JOIN (matching records from both tables)
- LEFT JOIN (all records from left table)
- Different ways to write joins
- Joining multiple tables

JOINS help you answer questions like:
- "Which movies did user 'alice_wonder' watch?"
- "Show me viewing data WITH the actual movie titles"
- "Which users from USA watched Sci-Fi movies?"

================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

/*
--------------------------------------------------------------------------------
UNDERSTANDING RELATIONSHIPS
--------------------------------------------------------------------------------

Our tables are related through IDs:

USERS (user_id) ←→ STREAMING_VIEWS (user_id)
MOVIES (movie_id) ←→ STREAMING_VIEWS (movie_id)

STREAMING_VIEWS connects users to movies!
- It tells us WHO (user_id) watched WHAT (movie_id) and WHEN
*/

-- Let's look at our data first
SELECT * FROM STREAMING_VIEWS LIMIT 5;
SELECT * FROM MOVIES LIMIT 5;
SELECT * FROM USERS LIMIT 5;

/*
Notice: STREAMING_VIEWS has user_id and movie_id, but not the actual names.
To see names, we need to JOIN tables!
*/

/*
--------------------------------------------------------------------------------
PART 1: INNER JOIN - Matching Records
--------------------------------------------------------------------------------

INNER JOIN returns only rows where there's a match in BOTH tables.

Syntax:
SELECT columns
FROM table1
INNER JOIN table2 ON table1.column = table2.column
*/

-- Example: Show streaming views WITH movie titles
SELECT 
    sv.view_id,
    sv.user_id,
    m.title AS movie_title,
    sv.watch_duration_minutes,
    sv.device_type
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
ORDER BY sv.view_id;

/*
What happened?
- We joined STREAMING_VIEWS (sv) with MOVIES (m)
- ON sv.movie_id = m.movie_id means "match rows where movie_id is the same"
- Now we can see movie TITLES instead of just movie IDs!
*/

-- Example: Show streaming views WITH usernames
SELECT 
    sv.view_id,
    u.username,
    sv.movie_id,
    sv.watch_duration_minutes,
    sv.view_date
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
ORDER BY sv.view_id;

-- 📝 YOUR TURN: Join STREAMING_VIEWS with MOVIES
-- Show: view_id, movie title, movie genre, watch_duration_minutes
-- Order by view_id





/*
--------------------------------------------------------------------------------
PART 2: Joining Multiple Tables
--------------------------------------------------------------------------------

You can join more than 2 tables to get complete information!
*/

-- Example: Show COMPLETE viewing information (usernames, movie titles, everything!)
SELECT 
    sv.view_id,
    u.username,
    u.country,
    m.title AS movie_title,
    m.genre,
    m.rating AS movie_rating,
    sv.watch_duration_minutes,
    sv.device_type,
    sv.view_date
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
ORDER BY sv.view_date, sv.view_id;

/*
This joins all 3 tables!
- First join: STREAMING_VIEWS + USERS (to get usernames)
- Second join: Result + MOVIES (to get movie details)
*/

-- 📝 YOUR TURN: Show viewing data with usernames and movie titles
-- Include: username, movie title, watch duration, device type
-- Order by username





/*
--------------------------------------------------------------------------------
PART 3: Filtering Joined Data
--------------------------------------------------------------------------------

You can use WHERE with joins to filter results.
*/

-- Example: Show what movies user 'alice_wonder' watched
SELECT 
    u.username,
    m.title AS movie_title,
    m.genre,
    sv.watch_duration_minutes,
    sv.view_date
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
WHERE u.username = 'alice_wonder'
ORDER BY sv.view_date;

-- Example: Show Sci-Fi movies that were watched
SELECT 
    m.title AS movie_title,
    m.genre,
    u.username,
    sv.watch_duration_minutes
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
WHERE m.genre = 'Sci-Fi'
ORDER BY sv.watch_duration_minutes DESC;

-- 📝 YOUR TURN: Show movies watched by Premium users
-- Include: username, subscription type, movie title, watch duration





-- 📝 YOUR TURN: Show movies from 2023 that were watched on Smart TV
SELECT 
    m.title AS movie_title,
    m.release_year,
    sv.device_type,
    u.username
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
WHERE m.release_year = 2023 AND sv.device_type = 'Smart TV';




/*
--------------------------------------------------------------------------------
PART 4: Aggregations with Joins
--------------------------------------------------------------------------------

Combine GROUP BY with JOINS for powerful analysis!
*/

-- Example: How many times was each movie watched?
SELECT 
    m.title AS movie_title,
    m.genre,
    COUNT(*) AS view_count,
    SUM(sv.watch_duration_minutes) AS total_minutes_watched
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
GROUP BY m.title, m.genre
ORDER BY view_count DESC;

-- Example: How many movies did each user watch?
SELECT 
    u.username,
    u.country,
    COUNT(*) AS movies_watched,
    SUM(sv.watch_duration_minutes) AS total_watch_time
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
GROUP BY u.username, u.country
ORDER BY movies_watched DESC;

-- Example: Which genres are most popular (by view count)?
SELECT 
    m.genre,
    COUNT(*) AS view_count,
    COUNT(DISTINCT u.user_id) AS unique_viewers
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
GROUP BY m.genre
ORDER BY view_count DESC;

-- 📝 YOUR TURN: Show total watch time by country
-- Include: country, total minutes watched, number of views





-- 📝 YOUR TURN: Show viewing statistics by device type
-- Include: device type, number of unique users, total views, avg watch duration





/*
--------------------------------------------------------------------------------
PART 5: LEFT JOIN - Including Non-Matching Records
--------------------------------------------------------------------------------

LEFT JOIN returns ALL rows from the left table, even if there's no match in the right table.
Useful for finding "what's missing" or "complete lists"
*/

-- Example: Show ALL movies, including ones that haven't been watched yet
SELECT 
    m.movie_id,
    m.title AS movie_title,
    m.genre,
    COUNT(sv.view_id) AS view_count
FROM MOVIES m
LEFT JOIN STREAMING_VIEWS sv ON m.movie_id = sv.movie_id
GROUP BY m.movie_id, m.title, m.genre
ORDER BY view_count DESC;

/*
Notice: Even movies with 0 views show up!
- INNER JOIN would exclude movies with no views
- LEFT JOIN includes them with NULL values (which COUNT ignores)
*/

-- Example: Find movies that have NEVER been watched
SELECT 
    m.movie_id,
    m.title AS movie_title,
    m.genre,
    m.rating
FROM MOVIES m
LEFT JOIN STREAMING_VIEWS sv ON m.movie_id = sv.movie_id
WHERE sv.view_id IS NULL;

-- 📝 YOUR TURN: Show ALL users and how many movies they've watched (including users with 0 views)





/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Find the most-watched movie
-- Show: movie title, genre, director, total view count
-- Hint: Join, group by movie, order by count, limit 1





-- Challenge 2: Which Premium users have watched Sci-Fi movies?
-- Show: username, country, movie title, watch duration
-- Remove duplicates if a user watched the same movie multiple times (use DISTINCT)





-- Challenge 3: Create a report showing for each country:
-- - Country name
-- - Number of users
-- - Total movies watched
-- - Total watch time in hours (not minutes!)
-- Order by total watch time descending
SELECT 
    u.country,
    COUNT(DISTINCT u.user_id) AS user_count,
    COUNT(sv.view_id) AS total_movies_watched,
    ROUND(SUM(sv.watch_duration_minutes) / 60.0, 2) AS total_hours
FROM USERS u
LEFT JOIN STREAMING_VIEWS sv ON u.user_id = sv.user_id
GROUP BY u.country
ORDER BY total_hours DESC;




-- Challenge 4: Find users who have watched movies with rating > 8.0
-- Show: username, subscription type, movie title, movie rating
-- Only show each user once per movie (use DISTINCT)
SELECT DISTINCT
    u.username,
    u.subscription_type,
    m.title AS movie_title,
    m.rating
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
WHERE m.rating > 8.0
ORDER BY u.username, m.rating DESC;




-- Challenge 5: Which director's movies have been watched the most?
-- Show: director, number of movies, total view count, total watch time
-- Order by total view count
SELECT 
    m.director,
    COUNT(DISTINCT m.movie_id) AS movie_count,
    COUNT(sv.view_id) AS total_views,
    SUM(sv.watch_duration_minutes) AS total_watch_time
FROM MOVIES m
LEFT JOIN STREAMING_VIEWS sv ON m.movie_id = sv.movie_id
GROUP BY m.director
ORDER BY total_views DESC;




-- Challenge 6: Create a "User Activity Report"
-- For each user show:
-- - Username and country
-- - Number of different movies watched
-- - Favorite genre (most watched genre) - This is advanced!
-- - Total watch time
-- Order by total watch time descending

-- Simplified version without "favorite genre":
SELECT 
    u.username,
    u.country,
    COUNT(DISTINCT m.movie_id) AS different_movies,
    SUM(sv.watch_duration_minutes) AS total_watch_time
FROM USERS u
LEFT JOIN STREAMING_VIEWS sv ON u.user_id = sv.user_id
LEFT JOIN MOVIES m ON sv.movie_id = m.movie_id
GROUP BY u.username, u.country
ORDER BY total_watch_time DESC;




-- Challenge 7: Find movies that are popular (>= 2 views) among Premium users only
-- Show: movie title, genre, rating, view count (from Premium users only)
SELECT 
    m.title AS movie_title,
    m.genre,
    m.rating,
    COUNT(*) AS premium_view_count
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
INNER JOIN USERS u ON sv.user_id = u.user_id
WHERE u.subscription_type = 'Premium'
GROUP BY m.title, m.genre, m.rating
HAVING COUNT(*) >= 2
ORDER BY premium_view_count DESC;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 5: Joins

KEY TAKEAWAYS:
- INNER JOIN returns only matching records from both tables
- LEFT JOIN returns all records from left table + matches from right
- Use ON to specify how tables are related
- You can join multiple tables in one query
- Combine joins with WHERE, GROUP BY, HAVING for powerful analysis
- Table aliases (sv, m, u) make queries shorter and clearer

QUERY STRUCTURE:
SELECT columns
FROM table1 alias1
INNER JOIN table2 alias2 ON alias1.column = alias2.column
LEFT JOIN table3 alias3 ON alias1.column = alias3.column
WHERE condition
GROUP BY columns
HAVING condition
ORDER BY column
LIMIT number;

NEXT: Move on to Exercise 6 - Cool Snowflake Features
================================================================================
*/