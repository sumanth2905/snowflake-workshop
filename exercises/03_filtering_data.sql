/*
================================================================================
EXERCISE 3: FILTERING DATA WITH WHERE
================================================================================

In this exercise, you'll learn:
- How to filter rows using WHERE
- Comparison operators (=, >, <, >=, <=, !=)
- Logical operators (AND, OR, NOT)
- Pattern matching with LIKE
- Working with NULL values

FILTERING is like asking: "Show me only the data that meets certain conditions"

================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

/*
--------------------------------------------------------------------------------
PART 1: BASIC WHERE CLAUSE
--------------------------------------------------------------------------------

WHERE filters rows based on a condition.
Only rows that meet the condition are returned.
*/

-- Example: Show only Sci-Fi movies
SELECT title, genre, rating
FROM MOVIES
WHERE genre = 'Sci-Fi';

-- Example: Show only Premium users
SELECT username, subscription_type, country
FROM USERS
WHERE subscription_type = 'Premium';

-- 📝 YOUR TURN: Show only movies from 2023





-- 📝 YOUR TURN: Show only users from USA





/*
--------------------------------------------------------------------------------
PART 2: COMPARISON OPERATORS
--------------------------------------------------------------------------------

Operators you can use:
- =   equals
- !=  or <> not equals
- >   greater than
- <   less than
- >=  greater than or equal to
- <=  less than or equal to
*/

-- Example: Movies with rating greater than 8.0
SELECT title, rating, genre
FROM MOVIES
WHERE rating > 8.0;

-- Example: Movies released before 2023
SELECT title, release_year
FROM MOVIES
WHERE release_year < 2023;

-- Example: Movies with rating of 8.0 or higher
SELECT title, rating
FROM MOVIES
WHERE rating >= 8.0;

-- 📝 YOUR TURN: Show streaming views where watch_duration_minutes is greater than 100





-- 📝 YOUR TURN: Show movies that are NOT from 2023
-- Hint: Use != or <>





/*
--------------------------------------------------------------------------------
PART 3: COMBINING CONDITIONS WITH AND
--------------------------------------------------------------------------------

AND means BOTH conditions must be true.
*/

-- Example: Sci-Fi movies with rating above 8.0
SELECT title, genre, rating
FROM MOVIES
WHERE genre = 'Sci-Fi' AND rating > 8.0;

-- Example: Premium users from USA
SELECT username, country, subscription_type
FROM USERS
WHERE country = 'USA' AND subscription_type = 'Premium';

-- 📝 YOUR TURN: Movies from 2023 with rating greater than 8.0





-- 📝 YOUR TURN: Streaming views on Smart TV with duration over 100 minutes





/*
--------------------------------------------------------------------------------
PART 4: COMBINING CONDITIONS WITH OR
--------------------------------------------------------------------------------

OR means AT LEAST ONE condition must be true.
*/

-- Example: Movies that are either Sci-Fi OR have rating above 8.5
SELECT title, genre, rating
FROM MOVIES
WHERE genre = 'Sci-Fi' OR rating > 8.5;

-- Example: Users from USA or Canada
SELECT username, country
FROM USERS
WHERE country = 'USA' OR country = 'Canada';

-- 📝 YOUR TURN: Movies from either 2023 or 2022





-- 📝 YOUR TURN: Streaming views on either Mobile or Tablet devices





/*
--------------------------------------------------------------------------------
PART 5: COMBINING AND & OR (Using Parentheses)
--------------------------------------------------------------------------------

Use parentheses () to group conditions, just like in math!
*/

-- Example: (Sci-Fi OR Adventure) AND rating above 8.0
SELECT title, genre, rating
FROM MOVIES
WHERE (genre = 'Sci-Fi' OR genre = 'Adventure') 
  AND rating > 8.0;

-- Example: Premium users from USA or Canada
SELECT username, country, subscription_type
FROM USERS
WHERE subscription_type = 'Premium' 
  AND (country = 'USA' OR country = 'Canada');

-- 📝 YOUR TURN: Movies from 2023 that are either Drama or Romance





-- 📝 YOUR TURN: Streaming views on Smart TV or Laptop with duration over 120 minutes





/*
--------------------------------------------------------------------------------
PART 6: IN OPERATOR (Checking Multiple Values)
--------------------------------------------------------------------------------

IN is a shortcut for multiple OR conditions.
Instead of: country = 'USA' OR country = 'Canada' OR country = 'UK'
Use: country IN ('USA', 'Canada', 'UK')
*/

-- Example: Movies that are Sci-Fi, Adventure, or Fantasy
SELECT title, genre, rating
FROM MOVIES
WHERE genre IN ('Sci-Fi', 'Adventure', 'Fantasy');

-- Example: Users from USA, UK, or Canada
SELECT username, country
FROM USERS
WHERE country IN ('USA', 'UK', 'Canada');

-- 📝 YOUR TURN: Movies from years 2021, 2022, or 2023





-- 📝 YOUR TURN: Streaming views on Smart TV, Laptop, or Tablet





/*
--------------------------------------------------------------------------------
PART 7: BETWEEN OPERATOR (Range of Values)
--------------------------------------------------------------------------------

BETWEEN checks if a value is within a range (inclusive).
*/

-- Example: Movies with ratings between 7.5 and 8.5
SELECT title, rating
FROM MOVIES
WHERE rating BETWEEN 7.5 AND 8.5;

-- Example: Movies released between 2022 and 2023
SELECT title, release_year
FROM MOVIES
WHERE release_year BETWEEN 2022 AND 2023;

-- 📝 YOUR TURN: Streaming views with duration between 90 and 120 minutes





-- 📝 YOUR TURN: Users who joined between 2022-01-01 and 2022-12-31





/*
--------------------------------------------------------------------------------
PART 8: LIKE OPERATOR (Pattern Matching)
--------------------------------------------------------------------------------

LIKE searches for patterns in text.
- % means "any characters" (zero or more)
- _ means "exactly one character"
*/

-- Example: Movies with "Data" in the title
SELECT title, genre
FROM MOVIES
WHERE title LIKE '%Data%';

-- Example: Movies starting with "The"
SELECT title
FROM MOVIES
WHERE title LIKE 'The%';

-- Example: Movies ending with "Chronicles"
SELECT title
FROM MOVIES
WHERE title LIKE '%Chronicles';

-- 📝 YOUR TURN: Users whose username starts with 'a'
-- Hint: LIKE is case-insensitive in Snowflake by default





-- 📝 YOUR TURN: Movies with "Cloud" anywhere in the title





/*
--------------------------------------------------------------------------------
PART 9: NOT OPERATOR (Negation)
--------------------------------------------------------------------------------

NOT reverses a condition.
*/

-- Example: Movies that are NOT Sci-Fi
SELECT title, genre
FROM MOVIES
WHERE genre != 'Sci-Fi';
-- OR
SELECT title, genre
FROM MOVIES
WHERE NOT genre = 'Sci-Fi';

-- Example: Users NOT from USA
SELECT username, country
FROM USERS
WHERE country != 'USA';

-- Example: Movies NOT in these genres
SELECT title, genre
FROM MOVIES
WHERE genre NOT IN ('Sci-Fi', 'Drama');

-- 📝 YOUR TURN: Streaming views NOT on Mobile devices





-- 📝 YOUR TURN: Movies with rating NOT between 7.0 and 8.0





/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Find all Drama movies from 2023 with rating above 8.0





-- Challenge 2: Find Premium users from USA or UK who joined in 2022
-- Hint: Use join_date BETWEEN '2022-01-01' AND '2022-12-31'





-- Challenge 3: Find streaming views on Smart TV or Laptop with duration between 100 and 130 minutes





-- Challenge 4: Find movies that:
-- - Are either Sci-Fi or Adventure
-- - Have rating of 8.0 or higher
-- - Were released in 2022 or 2023





-- Challenge 5: Find users whose username contains "a" and are from Canada or Germany





-- Challenge 6: Find movies that are NOT (Drama OR Romance) and have rating above 8.0
-- Hint: Use NOT with parentheses





-- Challenge 7: Complex filter - Find streaming views where:
-- - Device is NOT Mobile
-- - Duration is greater than 100 minutes
-- - User_id is between 101 and 105
SELECT *
FROM STREAMING_VIEWS
WHERE device_type != 'Mobile'
  AND watch_duration_minutes > 100
  AND user_id BETWEEN 101 AND 105;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 3: Filtering Data

KEY TAKEAWAYS:
- WHERE filters rows based on conditions
- Comparison operators: =, !=, >, <, >=, <=
- Logical operators: AND, OR, NOT
- IN checks multiple values
- BETWEEN checks ranges
- LIKE finds patterns (% = any characters)
- Use parentheses () to group conditions

QUERY STRUCTURE:
SELECT columns
FROM table
WHERE condition
ORDER BY column
LIMIT number;

NEXT: Move on to Exercise 4 - Aggregations and Grouping
================================================================================
*/
