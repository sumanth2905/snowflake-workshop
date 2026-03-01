/*
================================================================================
EXERCISE 2: BASIC SQL QUERIES
================================================================================

In this exercise, you'll learn:
- How to select specific columns
- How to limit results
- How to sort data
- How to make your queries readable

REMEMBER: SQL is like asking questions to your database!

================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

/*
--------------------------------------------------------------------------------
PART 1: SELECTING SPECIFIC COLUMNS
--------------------------------------------------------------------------------

Instead of SELECT *, we can choose exactly which columns we want.
This is faster and easier to read!
*/

-- Example: Show only movie titles and ratings
SELECT title, rating FROM MOVIES;

-- Example: Show movie info without the movie_id
SELECT title, genre, release_year, rating, director FROM MOVIES;

-- 📝 YOUR TURN: Show only username and country from USERS





-- 📝 YOUR TURN: Show movie_id, title, and genre from MOVIES





/*
--------------------------------------------------------------------------------
PART 2: USING ALIASES (Renaming Columns)
--------------------------------------------------------------------------------

We can rename columns in our results to make them clearer.
Use AS to give a column a new name.
*/

-- Example: Rename columns to be more readable
SELECT 
    title AS movie_name,
    rating AS score,
    release_year AS year
FROM MOVIES;

-- Example: Create descriptive names
SELECT 
    username AS user_name,
    country AS location,
    subscription_type AS plan
FROM USERS;

-- 📝 YOUR TURN: Select title as "Movie Title" and director as "Directed By"
-- Note: Use quotes when your alias has spaces





/*
--------------------------------------------------------------------------------
PART 3: LIMITING RESULTS
--------------------------------------------------------------------------------

LIMIT restricts how many rows you get back.
Useful for large tables or quick previews.
*/

-- Example: Show only the first 5 movies
SELECT * FROM MOVIES LIMIT 5;

-- Example: Show 3 users
SELECT username, country FROM USERS LIMIT 3;

-- 📝 YOUR TURN: Show the first 7 streaming views





-- 📝 YOUR TURN: Show the first 2 movies with only title and rating columns





/*
--------------------------------------------------------------------------------
PART 4: SORTING DATA (ORDER BY)
--------------------------------------------------------------------------------

ORDER BY sorts your results.
- ASC = Ascending (smallest to largest, A to Z) - this is default
- DESC = Descending (largest to smallest, Z to A)
*/

-- Example: Sort movies by rating (lowest to highest)
SELECT title, rating 
FROM MOVIES 
ORDER BY rating ASC;

-- Example: Sort movies by rating (highest to lowest)
SELECT title, rating 
FROM MOVIES 
ORDER BY rating DESC;

-- Example: Sort users alphabetically by username
SELECT username, country 
FROM USERS 
ORDER BY username ASC;

-- 📝 YOUR TURN: Show all movies sorted by release_year (newest first)





-- 📝 YOUR TURN: Show usernames sorted alphabetically, limit to 5





/*
--------------------------------------------------------------------------------
PART 5: SORTING BY MULTIPLE COLUMNS
--------------------------------------------------------------------------------

You can sort by multiple columns! The first column is sorted first,
then ties are broken by the second column.
*/

-- Example: Sort by genre first, then by rating within each genre
SELECT title, genre, rating 
FROM MOVIES 
ORDER BY genre ASC, rating DESC;

-- This shows movies grouped by genre, with highest-rated first in each genre

-- 📝 YOUR TURN: Sort users by country, then by username within each country
SELECT username, country, subscription_type
FROM USERS
ORDER BY country ASC, username ASC;




/*
--------------------------------------------------------------------------------
PART 6: COMBINING TECHNIQUES
--------------------------------------------------------------------------------

Let's use everything together: SELECT specific columns, ORDER BY, and LIMIT
*/

-- Example: Top 3 highest-rated movies
SELECT title, rating, director
FROM MOVIES
ORDER BY rating DESC
LIMIT 3;

-- Example: 5 most recent movies
SELECT title, release_year, genre
FROM MOVIES
ORDER BY release_year DESC
LIMIT 5;

-- 📝 YOUR TURN: Show the top 5 longest viewing sessions
-- Hint: Use STREAMING_VIEWS table, sort by watch_duration_minutes





-- 📝 YOUR TURN: Show 3 users with Premium subscription
-- Hint: We'll learn filtering in the next exercise, but try ORDER BY and LIMIT for now
SELECT username, subscription_type, country
FROM USERS
LIMIT 3;




/*
--------------------------------------------------------------------------------
PART 7: DISTINCT VALUES
--------------------------------------------------------------------------------

DISTINCT removes duplicates and shows only unique values.
*/

-- Example: What genres do we have?
SELECT DISTINCT genre FROM MOVIES;

-- Example: What countries are our users from?
SELECT DISTINCT country FROM USERS;

-- Example: What device types are used for streaming?
SELECT DISTINCT device_type FROM STREAMING_VIEWS;

-- 📝 YOUR TURN: What subscription types do we offer?





-- 📝 YOUR TURN: What years are our movies from?
SELECT DISTINCT release_year FROM MOVIES ORDER BY release_year DESC;




/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Show the 3 oldest movies (by release_year) with their titles and directors





-- Challenge 2: List all unique genres sorted alphabetically





-- Challenge 3: Show the top 5 streaming views sorted by watch_duration_minutes (longest first)
-- Include view_id, movie_id, user_id, and watch_duration_minutes





-- Challenge 4: Create a query that shows:
-- - Movie titles (aliased as "Film Name")
-- - Ratings (aliased as "Score")  
-- - Directors (aliased as "Director")
-- - Sorted by rating (highest first)
-- - Limited to top 5





-- Challenge 5: Show all unique combinations of country and subscription_type
-- Hint: You can use DISTINCT with multiple columns
SELECT DISTINCT country, subscription_type 
FROM USERS 
ORDER BY country, subscription_type;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 2: Basic SQL Queries

KEY TAKEAWAYS:
- SELECT column1, column2 chooses specific columns
- AS creates aliases (renamed columns)
- LIMIT n shows only n rows
- ORDER BY sorts results (ASC or DESC)
- DISTINCT shows only unique values
- You can combine all these techniques!

QUERY STRUCTURE:
SELECT columns
FROM table
ORDER BY column
LIMIT number;

NEXT: Move on to Exercise 3 - Filtering Data
================================================================================
*/