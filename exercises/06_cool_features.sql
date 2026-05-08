/*
================================================================================
EXERCISE 6: COOL SNOWFLAKE FEATURES
================================================================================

In this exercise, you'll learn Snowflake-specific features:
- Time Travel (query past data!)
- Zero-Copy Cloning (instant table copies!)
- Result Caching (lightning-fast repeated queries)
- Data Sampling
- Query History and Profiling

These features make Snowflake special and powerful!

================================================================================
*/

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

/*
--------------------------------------------------------------------------------
PART 1: TIME TRAVEL - Query Data from the Past!
--------------------------------------------------------------------------------

Time Travel lets you query data as it existed in the past.
You can go back up to 90 days (depending on your edition)!

Use cases:
- "What did this table look like yesterday?"
- "I accidentally deleted data - can I get it back?"
- "Compare current data with last week's data"
*/

-- First, let's see our current MOVIES table
SELECT * FROM MOVIES ORDER BY movie_id;

-- Now let's make a change - add a new movie
INSERT INTO MOVIES VALUES
(11, 'Time Travel Tales', 'Sci-Fi', 2024, 8.9, 'Future Director');

-- Verify the new movie is there
SELECT * FROM MOVIES WHERE movie_id = 11;

-- TIME TRAVEL: Query the table as it was 5 minutes ago (before we added the movie)
-- Note: This might not show the difference if you just ran setup, but demonstrates the syntax
SELECT * FROM MOVIES AT(OFFSET => -60*5) ORDER BY movie_id;
-- OFFSET => -60*5 means "5 minutes ago" (in seconds)

-- TIME TRAVEL: Query at a specific timestamp
SELECT * FROM MOVIES AT(TIMESTAMP => DATEADD(minute, -10, CURRENT_TIMESTAMP()))
ORDER BY movie_id;

-- 📝 YOUR TURN: Let's modify the USERS table and use Time Travel
-- First, see current users
SELECT * FROM USERS ORDER BY user_id;

-- Add a new user
INSERT INTO USERS VALUES
(111, 'time_traveler', 'Antarctica', 'Premium', CURRENT_DATE());

-- Verify the new user exists
SELECT * FROM USERS WHERE user_id = 111;

-- Now query the table from 2 minutes ago (before adding the user)
SELECT * FROM USERS AT(OFFSET => -60*2) 
WHERE user_id = 111;
-- This should return no results if the insert was recent!




/*
--------------------------------------------------------------------------------
PART 2: UNDROP - Recover Deleted Objects
--------------------------------------------------------------------------------

Accidentally dropped a table? No problem! Snowflake keeps it for you.
*/

-- Let's create a test table
CREATE OR REPLACE TABLE test_table AS
SELECT * FROM MOVIES WHERE genre = 'Sci-Fi';

-- Verify it exists
SELECT * FROM test_table;

-- Oops! Accidentally drop it
DROP TABLE test_table;

-- Try to query it - this will error
-- SELECT * FROM test_table;  -- Uncomment to see the error

-- UNDROP to the rescue!
UNDROP TABLE test_table;

-- Now it's back!
SELECT * FROM test_table;

-- Clean up
DROP TABLE test_table;

/*
--------------------------------------------------------------------------------
PART 3: ZERO-COPY CLONING - Instant Table Copies!
--------------------------------------------------------------------------------

Cloning creates an instant copy of a table WITHOUT copying the actual data!
- Takes seconds, even for huge tables
- Uses minimal storage (only stores changes)
- Perfect for testing, development, backups
*/

-- Create a clone of the MOVIES table
CREATE TABLE MOVIES_BACKUP CLONE MOVIES;

-- Verify the clone
SELECT * FROM MOVIES_BACKUP ORDER BY movie_id;

-- The clone is independent - changes to one don't affect the other
INSERT INTO MOVIES_BACKUP VALUES
(12, 'Clone Wars', 'Sci-Fi', 2024, 8.0, 'Clone Director');

-- Check: MOVIES_BACKUP has the new movie
SELECT * FROM MOVIES_BACKUP WHERE movie_id = 12;

-- But original MOVIES table doesn't
SELECT * FROM MOVIES WHERE movie_id = 12;

-- 📝 YOUR TURN: Create a clone of the USERS table called USERS_BACKUP
CREATE TABLE USERS_BACKUP CLONE USERS;

-- Verify it worked
SELECT COUNT(*) FROM USERS_BACKUP;




-- 📝 YOUR TURN: Create a clone of STREAMING_VIEWS for testing
CREATE TABLE STREAMING_VIEWS_TEST CLONE STREAMING_VIEWS;

-- Add a test record to the clone (not the original)
INSERT INTO STREAMING_VIEWS_TEST VALUES
(9999, 99, 999, CURRENT_DATE(), 45, 'Test Device');

-- Verify it's only in the test table
SELECT * FROM STREAMING_VIEWS_TEST WHERE view_id = 9999;
SELECT * FROM STREAMING_VIEWS WHERE view_id = 9999;  -- Should return nothing




/*
--------------------------------------------------------------------------------
PART 4: RESULT CACHING - Lightning Fast Queries
--------------------------------------------------------------------------------

Snowflake automatically caches query results for 24 hours.
If you run the same query again, it returns instantly from cache!
*/

-- Run this query and note the execution time
SELECT 
    m.genre,
    COUNT(*) AS view_count,
    AVG(sv.watch_duration_minutes) AS avg_duration
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY view_count DESC;

-- Run the EXACT same query again - notice it's much faster!
-- Look for "Query returned results from cached data" in the query details
SELECT 
    m.genre,
    COUNT(*) AS view_count,
    AVG(sv.watch_duration_minutes) AS avg_duration
FROM STREAMING_VIEWS sv
INNER JOIN MOVIES m ON sv.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY view_count DESC;

/*
The second query uses cached results - no computation needed!
This works even if other users run the same query.
*/

/*
--------------------------------------------------------------------------------
PART 5: DATA SAMPLING - Analyze Subsets Quickly
--------------------------------------------------------------------------------

SAMPLE lets you query a random subset of data - great for large tables!
*/

-- Get 50% of rows randomly
SELECT * FROM MOVIES SAMPLE (50);

-- Get approximately 5 rows
SELECT * FROM MOVIES SAMPLE (5 ROWS);

-- Useful for quick analysis on huge tables
SELECT 
    genre,
    COUNT(*) AS sample_count
FROM MOVIES SAMPLE (70)
GROUP BY genre;

-- 📝 YOUR TURN: Sample 60% of STREAMING_VIEWS





/*
--------------------------------------------------------------------------------
PART 6: QUERY HISTORY AND PROFILING
--------------------------------------------------------------------------------

Snowflake tracks all your queries and provides detailed execution stats.
*/

-- View your recent queries
-- Go to: Activity > Query History in the Snowflake UI

-- You can also query the QUERY_HISTORY view
-- This shows your last 10 queries
SELECT 
    query_id,
    query_text,
    database_name,
    execution_status,
    total_elapsed_time / 1000 AS seconds,
    start_time
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE user_name = CURRENT_USER()
ORDER BY start_time DESC
LIMIT 10;

/*
In the UI, you can click any query to see:
- Execution time breakdown
- Data scanned
- Rows produced
- Query profile (visual execution plan)
*/

/*
--------------------------------------------------------------------------------
PART 7: TRANSIENT TABLES - Save on Storage Costs
--------------------------------------------------------------------------------

Transient tables don't have full Time Travel (only 1 day) and no Fail-safe.
Good for temporary data where you don't need recovery options.
*/

-- Create a transient table
CREATE TRANSIENT TABLE temp_analysis AS
SELECT 
    u.country,
    COUNT(*) AS view_count,
    SUM(sv.watch_duration_minutes) AS total_minutes
FROM STREAMING_VIEWS sv
INNER JOIN USERS u ON sv.user_id = u.user_id
GROUP BY u.country;

-- Use it like any other table
SELECT * FROM temp_analysis ORDER BY total_minutes DESC;

-- Clean up
DROP TABLE temp_analysis;

/*
--------------------------------------------------------------------------------
PART 8: INFORMATION SCHEMA - Metadata About Your Database
--------------------------------------------------------------------------------

Query metadata about your database objects.
*/

-- List all tables in your schema
SELECT 
    table_name,
    table_type,
    row_count,
    bytes,
    created
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'STUDENT_SCHEMA'
ORDER BY table_name;

-- List all columns in MOVIES table
SELECT 
    column_name,
    data_type,
    is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'MOVIES'
ORDER BY ordinal_position;

-- 📝 YOUR TURN: Find all columns in the USERS table





/*
--------------------------------------------------------------------------------
PART 9: SHOW COMMANDS - Quick Information
--------------------------------------------------------------------------------

SHOW commands give you quick info about database objects.
*/

-- Show all tables
SHOW TABLES;

-- Show all databases
SHOW DATABASES;

-- Show all schemas in current database
SHOW SCHEMAS;

-- Show all warehouses (compute resources)
SHOW WAREHOUSES;

-- Show table details
SHOW TABLES LIKE 'MOVIES';

/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Create a complete backup of all workshop tables
-- Hint: Clone each table with a _BACKUP suffix
CREATE TABLE MOVIES_BACKUP_FINAL CLONE MOVIES;
CREATE TABLE USERS_BACKUP_FINAL CLONE USERS;
CREATE TABLE STREAMING_VIEWS_BACKUP_FINAL CLONE STREAMING_VIEWS;

-- Verify all backups exist
SHOW TABLES LIKE '%BACKUP%';




-- Challenge 2: Create a test environment
-- Clone all tables with a _TEST suffix, then add test data to one
CREATE TABLE MOVIES_TEST CLONE MOVIES;
CREATE TABLE USERS_TEST CLONE USERS;
CREATE TABLE STREAMING_VIEWS_TEST_FINAL CLONE STREAMING_VIEWS;

-- Add test data
INSERT INTO USERS_TEST VALUES
(999, 'test_user', 'TestLand', 'Premium', CURRENT_DATE());

-- Verify test data is only in test table
SELECT * FROM USERS_TEST WHERE user_id = 999;
SELECT * FROM USERS WHERE user_id = 999;




-- Challenge 3: Use Time Travel to compare data
-- Modify a table, then compare current vs 5 minutes ago

-- Add a new movie
INSERT INTO MOVIES VALUES
(20, 'Future Film', 'Sci-Fi', 2024, 9.5, 'Tomorrow Director');

-- Compare current count vs 5 minutes ago
SELECT 'Current' AS time_period, COUNT(*) AS movie_count FROM MOVIES
UNION ALL
SELECT '5 min ago', COUNT(*) FROM MOVIES AT(OFFSET => -60*5);




-- Challenge 4: Create a sampled analysis
-- Use SAMPLE to quickly analyze STREAMING_VIEWS
SELECT 
    device_type,
    COUNT(*) AS sampled_count,
    AVG(watch_duration_minutes) AS avg_duration
FROM STREAMING_VIEWS SAMPLE (50)
GROUP BY device_type;




-- Challenge 5: Clean up all backup and test tables
-- Hint: Use DROP TABLE for each backup/test table you created
DROP TABLE IF EXISTS MOVIES_BACKUP;
DROP TABLE IF EXISTS USERS_BACKUP;
DROP TABLE IF EXISTS STREAMING_VIEWS_TEST;
DROP TABLE IF EXISTS MOVIES_BACKUP_FINAL;
DROP TABLE IF EXISTS USERS_BACKUP_FINAL;
DROP TABLE IF EXISTS STREAMING_VIEWS_BACKUP_FINAL;
DROP TABLE IF EXISTS MOVIES_TEST;
DROP TABLE IF EXISTS USERS_TEST;
DROP TABLE IF EXISTS STREAMING_VIEWS_TEST_FINAL;

-- Verify cleanup
SHOW TABLES;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 6: Cool Snowflake Features!

KEY TAKEAWAYS:
- TIME TRAVEL: Query data from the past (AT, OFFSET)
- UNDROP: Recover deleted objects
- CLONE: Create instant copies with zero data copying
- Result Caching: Automatic fast repeated queries
- SAMPLE: Analyze subsets of large tables
- Query History: Track and analyze all queries
- INFORMATION_SCHEMA: Query metadata about your database
- SHOW commands: Quick info about objects

SNOWFLAKE ADVANTAGES:
✓ Built-in data protection (Time Travel, Fail-safe)
✓ Zero-copy cloning saves time and storage
✓ Automatic optimization (caching, clustering)
✓ Easy to use - no infrastructure management
✓ Scales automatically

NEXT STEPS:
- Explore Snowflake documentation
- Try loading your own data
- Learn about Snowflake's data sharing features
- Explore advanced topics: stored procedures, tasks, streams

================================================================================
*/

-- 🎊 FINAL QUERY: Workshop Statistics
SELECT 
    'Total Movies' AS metric,
    COUNT(*)::VARCHAR AS value
FROM MOVIES
UNION ALL
SELECT 'Total Users', COUNT(*)::VARCHAR FROM USERS
UNION ALL
SELECT 'Total Views', COUNT(*)::VARCHAR FROM STREAMING_VIEWS
UNION ALL
SELECT 'Avg Movie Rating', ROUND(AVG(rating), 2)::VARCHAR FROM MOVIES
UNION ALL
SELECT 'Total Watch Hours', ROUND(SUM(watch_duration_minutes)/60, 2)::VARCHAR FROM STREAMING_VIEWS;

/*
================================================================================
🏆 YOU DID IT! 🏆

You've completed the Snowflake Workshop!

You now know:
✓ What data warehousing is
✓ How to write SQL queries
✓ How to filter, aggregate, and join data
✓ Snowflake's unique features

These skills are valuable in:
- Data Analysis
- Business Intelligence
- Data Engineering
- Data Science
- Analytics Engineering

Keep practicing and exploring!

Thank you for participating! 🎉

================================================================================
*/