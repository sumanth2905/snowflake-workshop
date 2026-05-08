/*
================================================================================
EXERCISE 1: INTRODUCTION TO SNOWFLAKE
================================================================================

Welcome to the Snowflake Workshop! 🎉

In this exercise, you'll:
- Learn about the Snowflake interface
- Understand basic database concepts
- Learn about Virtual Warehouses (Snowflake's compute power)
- Run your first queries

WHAT IS SNOWFLAKE?
Snowflake is a cloud-based data warehouse that helps companies store and 
analyze massive amounts of data quickly and efficiently.

WHAT IS A DATA WAREHOUSE?
Think of it as a giant, organized library for a company's data. Instead of 
books, it stores information about customers, sales, products, etc.

================================================================================
*/

/*
--------------------------------------------------------------------------------
UNDERSTANDING SNOWFLAKE ARCHITECTURE
--------------------------------------------------------------------------------

Snowflake separates STORAGE from COMPUTE - this is what makes it special!

1. STORAGE LAYER
   - Where your data is actually stored
   - Automatically managed and optimized
   - You pay for data stored

2. COMPUTE LAYER (Virtual Warehouses)
   - The "engine" that runs your queries
   - You can have multiple warehouses for different tasks
   - You pay only when they're running
   - Can be started/stopped/resized instantly

3. CLOUD SERVICES LAYER
   - Manages authentication, security, metadata
   - Optimizes queries automatically

Think of it like a library:
- Storage = The bookshelves (where books are kept)
- Compute (Warehouse) = The librarians (who fetch and process your requests)
- Cloud Services = The library management system

*/

/*
--------------------------------------------------------------------------------
PART 1: VIRTUAL WAREHOUSES - YOUR COMPUTE POWER
--------------------------------------------------------------------------------

A VIRTUAL WAREHOUSE is Snowflake's compute resource that executes queries.

Key Points:
- Warehouses DON'T store data - they only process queries
- You can start/stop them anytime
- Multiple users can share one warehouse
- Different warehouses can run simultaneously without affecting each other
- Sizes: X-Small, Small, Medium, Large, X-Large, etc.
  (Larger = more compute power = faster queries = higher cost)

*/

-- Let's see what warehouses are available
SHOW WAREHOUSES;

/*
You should see at least one warehouse (probably COMPUTE_WH).
Notice the columns:
- name: Warehouse name
- state: STARTED or SUSPENDED
- size: X-Small, Small, Medium, etc.
- running: How many queries are currently executing
*/

-- Check which warehouse you're currently using
SELECT CURRENT_WAREHOUSE();

-- Set your warehouse (if not already set)
USE WAREHOUSE COMPUTE_WH;

/*
IMPORTANT CONCEPTS:

AUTO-SUSPEND: Warehouse automatically stops after period of inactivity
- Saves money! You're not charged when suspended
- Default is usually 10 minutes of inactivity

AUTO-RESUME: Warehouse automatically starts when you run a query
- Convenient! No need to manually start it
- First query after resume might take a few seconds longer

WAREHOUSE STATES:
- STARTED: Running and ready to execute queries (you're being charged)
- SUSPENDED: Stopped, not running queries (not being charged)
- RESIZING: Changing size

*/

-- Let's see detailed information about your warehouse
SHOW WAREHOUSES LIKE 'COMPUTE_WH';

/*
--------------------------------------------------------------------------------
PART 2: UNDERSTANDING YOUR WORKSPACE
--------------------------------------------------------------------------------

In Snowflake, data is organized in a hierarchy:

1. ACCOUNT (Your Snowflake account)
   └── 2. DATABASE (Like a filing cabinet - WORKSHOP_DB)
       └── 3. SCHEMA (Like a drawer in the cabinet - STUDENT_SCHEMA)
           └── 4. TABLES (Like folders with actual data)

And separately:
   └── VIRTUAL WAREHOUSES (The compute engines)

*/

-- Let's set our context (tell Snowflake where we're working)
USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;
USE WAREHOUSE COMPUTE_WH;

-- Verify your current context
SELECT 
    CURRENT_DATABASE() AS my_database,
    CURRENT_SCHEMA() AS my_schema,
    CURRENT_WAREHOUSE() AS my_warehouse,
    CURRENT_USER() AS my_username,
    CURRENT_ROLE() AS my_role;

/*
This shows you:
- Which database you're using
- Which schema you're using
- Which warehouse will run your queries
- Your username
- Your role (permissions level)
*/

/*
--------------------------------------------------------------------------------
PART 3: EXPLORING YOUR TABLES
--------------------------------------------------------------------------------

Let's see what tables we have in our workshop database.
*/

-- This query shows all tables in your current schema
SHOW TABLES;

-- You should see three tables:
-- 1. MOVIES - Information about movies
-- 2. USERS - Information about streaming service users
-- 3. STREAMING_VIEWS - Records of who watched what

/*
--------------------------------------------------------------------------------
PART 4: YOUR FIRST QUERY
--------------------------------------------------------------------------------

Let's look at the data! We'll start with the MOVIES table.
When you run this query, your warehouse will execute it.
*/

-- This query retrieves all data from the MOVIES table
SELECT * FROM MOVIES;

/*
What happened behind the scenes?
1. You submitted the query
2. Your warehouse (COMPUTE_WH) started processing it (if it was suspended)
3. The warehouse fetched data from storage
4. Results were returned to you
5. After 10 minutes of inactivity, the warehouse will auto-suspend

What do you see?
- movie_id: A unique number for each movie
- title: The name of the movie
- genre: What type of movie it is
- release_year: When it came out
- rating: How good it is (out of 10)
- director: Who made it
*/

-- 📝 YOUR TURN: View all data from the USERS table
-- Hint: Replace MOVIES with USERS in the query above





-- 📝 YOUR TURN: View all data from the STREAMING_VIEWS table





/*
--------------------------------------------------------------------------------
PART 5: UNDERSTANDING TABLE STRUCTURE
--------------------------------------------------------------------------------

You can see detailed information about a table's structure
*/

-- This shows the structure of the MOVIES table
DESCRIBE TABLE MOVIES;

-- You'll see:
-- - Column names
-- - Data types (INT = integer/number, VARCHAR = text, DATE = date, etc.)
-- - Whether columns can be empty (nullable)

-- 📝 YOUR TURN: Describe the USERS table





/*
--------------------------------------------------------------------------------
PART 6: COUNTING ROWS
--------------------------------------------------------------------------------

How much data do we have? Let's count!
*/

-- Count how many movies we have
SELECT COUNT(*) FROM MOVIES;

-- The result shows the total number of rows (records) in the MOVIES table

-- 📝 YOUR TURN: Count how many users we have





-- 📝 YOUR TURN: Count how many streaming views we have





/*
--------------------------------------------------------------------------------
PART 7: WAREHOUSE SIZING - UNDERSTANDING PERFORMANCE
--------------------------------------------------------------------------------

Let's understand how warehouse size affects query performance.

WAREHOUSE SIZES (each size is 2x the compute power of the previous):
- X-Small: 1 credit/hour  (Good for small queries, learning, testing)
- Small:   2 credits/hour
- Medium:  4 credits/hour
- Large:   8 credits/hour
- X-Large: 16 credits/hour
- 2X-Large: 32 credits/hour
- ... and so on

For our workshop data (very small), X-Small is perfect!

WHEN TO USE LARGER WAREHOUSES:
- Complex queries on large datasets
- Many concurrent users
- Time-sensitive reports
- Heavy data loading

WHEN TO USE SMALLER WAREHOUSES:
- Development and testing
- Small datasets (like our workshop)
- Infrequent queries
- Single user workloads

COST OPTIMIZATION TIPS:
✓ Use the smallest warehouse that meets your performance needs
✓ Enable auto-suspend (stop warehouse when not in use)
✓ Enable auto-resume (start only when needed)
✓ Use separate warehouses for different workloads
  (e.g., one for reports, one for data loading)
*/

-- Check your warehouse configuration
SHOW PARAMETERS IN WAREHOUSE COMPUTE_WH;

/*
You should see:
- AUTO_SUSPEND: Usually 600 seconds (10 minutes)
- AUTO_RESUME: Usually TRUE
*/

/*
--------------------------------------------------------------------------------
PART 8: SIMPLE CALCULATIONS
--------------------------------------------------------------------------------

SQL can do math! Let's try some simple calculations.
These calculations happen in your warehouse.
*/

-- Example: Calculate a simple number
SELECT 10 + 5 AS addition_result;

-- Example: Multiple calculations at once
SELECT 
    10 + 5 AS addition,
    10 - 5 AS subtraction,
    10 * 5 AS multiplication,
    10 / 5 AS division;

-- 📝 YOUR TURN: Calculate your birth year
-- If you're 20 years old, what year were you born?
-- Hint: Use 2024 - your_age

SELECT 2024 - 20 AS birth_year;

-- Now calculate your actual birth year:





/*
--------------------------------------------------------------------------------
PART 9: SELECTING SPECIFIC INFORMATION
--------------------------------------------------------------------------------

We don't always need ALL the data. Let's be selective!
*/

-- Example: Show only movie titles
SELECT title FROM MOVIES;

-- Example: Show title and rating
SELECT title, rating FROM MOVIES;

-- 📝 YOUR TURN: Show only usernames from the USERS table





-- 📝 YOUR TURN: Show movie titles and their genres





/*
--------------------------------------------------------------------------------
PART 10: MONITORING YOUR QUERIES
--------------------------------------------------------------------------------

Snowflake tracks every query you run!
*/

-- See your recent queries
SELECT 
    query_id,
    query_text,
    warehouse_name,
    warehouse_size,
    execution_status,
    total_elapsed_time / 1000 AS execution_seconds,
    start_time
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE user_name = CURRENT_USER()
ORDER BY start_time DESC
LIMIT 5;

/*
This shows:
- What queries you ran
- Which warehouse executed them
- How long they took
- Whether they succeeded

You can also view this in the UI:
Go to: Activity > Query History
*/

/*
--------------------------------------------------------------------------------
CHALLENGE EXERCISES
--------------------------------------------------------------------------------
*/

-- Challenge 1: Show the first 3 movies
-- Hint: Use LIMIT 3 at the end of your query

SELECT * FROM MOVIES LIMIT 3;

-- Challenge 2: Show only movie titles and directors, limited to 5 results





-- Challenge 3: Count how many rows are in each table and show all counts together
-- Hint: You can count from multiple tables in one query

SELECT 
    (SELECT COUNT(*) FROM MOVIES) AS total_movies,
    (SELECT COUNT(*) FROM USERS) AS total_users,
    (SELECT COUNT(*) FROM STREAMING_VIEWS) AS total_views;

-- Challenge 4: Check if your warehouse is currently running or suspended
SHOW WAREHOUSES LIKE 'COMPUTE_WH';
-- Look at the 'state' column




-- Challenge 5: Find out your account information
SELECT 
    CURRENT_ACCOUNT() AS account_identifier,
    CURRENT_REGION() AS region,
    CURRENT_VERSION() AS snowflake_version;




/*
================================================================================
🎉 CONGRATULATIONS!
You've completed Exercise 1: Introduction to Snowflake

KEY TAKEAWAYS:

SNOWFLAKE ARCHITECTURE:
- Storage Layer: Where data is stored (pay for storage)
- Compute Layer (Warehouses): Where queries run (pay per second of use)
- Cloud Services: Manages everything automatically

VIRTUAL WAREHOUSES:
- Compute engines that execute your queries
- Can be started/stopped/resized instantly
- Auto-suspend saves money when not in use
- Size determines speed and cost
- Multiple warehouses can run independently

DATA ORGANIZATION:
- Account > Database > Schema > Tables
- Warehouses are separate from data storage

BASIC QUERIES:
- SELECT * shows all data from a table
- COUNT(*) tells you how many rows are in a table
- You can do calculations directly in SQL
- DESCRIBE TABLE shows the structure of a table

IMPORTANT COMMANDS:
- USE WAREHOUSE name; (set which warehouse to use)
- USE DATABASE name; USE SCHEMA name; (set your context)
- SHOW WAREHOUSES; (see all warehouses)
- SHOW TABLES; (see all tables)

NEXT: Move on to Exercise 2 - Basic Queries
================================================================================
*/

-- 🏆 BONUS: Fun Query
-- What's the highest-rated movie?
SELECT title, rating, genre, director
FROM MOVIES 
ORDER BY rating DESC 
LIMIT 1;

-- 🏆 BONUS: Warehouse resource monitor
-- See how much compute you've used (if available)
-- Note: This might not return results in trial accounts
SHOW RESOURCE MONITORS;