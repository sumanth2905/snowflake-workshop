/*
================================================================================
SNOWFLAKE WORKSHOP - SETUP SCRIPT
================================================================================
This script will:
1. Create a dedicated database and schema for the workshop
2. Create sample tables
3. Load sample data
4. Set up your environment

INSTRUCTIONS:
1. Open Snowflake and go to "Worksheets"
2. Copy and paste this entire script
3. Click "Run All" or execute section by section
4. Wait for completion messages

Estimated time: 2-3 minutes
================================================================================
*/

-- Step 1: Create Workshop Database and Schema
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS WORKSHOP_DB;
CREATE SCHEMA IF NOT EXISTS WORKSHOP_DB.STUDENT_SCHEMA;

USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;

-- Confirmation message
SELECT 'Database and Schema created successfully!' AS status;

-- Step 2: Create Sample Tables

-- Table 1: Movies
CREATE OR REPLACE TABLE MOVIES (
    movie_id INT,
    title VARCHAR(200),
    genre VARCHAR(50),
    release_year INT,
    rating DECIMAL(3,1),
    director VARCHAR(100)
);

-- Table 2: Streaming Data
CREATE OR REPLACE TABLE STREAMING_VIEWS (
    view_id INT,
    movie_id INT,
    user_id INT,
    view_date DATE,
    watch_duration_minutes INT,
    device_type VARCHAR(50)
);

-- Table 3: Users
CREATE OR REPLACE TABLE USERS (
    user_id INT,
    username VARCHAR(50),
    country VARCHAR(50),
    subscription_type VARCHAR(20),
    join_date DATE
);

SELECT 'Tables created successfully!' AS status;

-- Step 3: Load Sample Data

-- Insert Movies
INSERT INTO MOVIES VALUES
(1, 'The Data Chronicles', 'Sci-Fi', 2023, 8.5, 'Jane Smith'),
(2, 'Query Quest', 'Adventure', 2022, 7.8, 'John Doe'),
(3, 'Cloud Nine', 'Drama', 2023, 9.0, 'Alice Johnson'),
(4, 'The Warehouse Mystery', 'Thriller', 2021, 7.5, 'Bob Williams'),
(5, 'Snowflake Falls', 'Romance', 2023, 8.2, 'Carol Davis'),
(6, 'Database Diaries', 'Documentary', 2022, 8.8, 'David Brown'),
(7, 'SQL Secrets', 'Mystery', 2023, 7.9, 'Emma Wilson'),
(8, 'The Analytics Adventure', 'Adventure', 2021, 8.1, 'Frank Miller'),
(9, 'Cloud Computing Chronicles', 'Sci-Fi', 2022, 8.6, 'Grace Lee'),
(10, 'Data Lake Dreams', 'Fantasy', 2023, 7.7, 'Henry Taylor');

-- Insert Users
INSERT INTO USERS VALUES
(101, 'alice_wonder', 'USA', 'Premium', '2022-01-15'),
(102, 'bob_builder', 'Canada', 'Basic', '2022-03-20'),
(103, 'charlie_chap', 'UK', 'Premium', '2021-11-10'),
(104, 'diana_prince', 'USA', 'Premium', '2023-01-05'),
(105, 'eve_online', 'Germany', 'Basic', '2022-07-18'),
(106, 'frank_castle', 'France', 'Premium', '2022-09-22'),
(107, 'grace_hopper', 'USA', 'Basic', '2023-02-14'),
(108, 'hank_pym', 'Australia', 'Premium', '2021-12-01'),
(109, 'iris_west', 'Canada', 'Basic', '2022-05-30'),
(110, 'jack_sparrow', 'UK', 'Premium', '2022-08-11');

-- Insert Streaming Views
INSERT INTO STREAMING_VIEWS VALUES
(1001, 1, 101, '2023-06-01', 95, 'Smart TV'),
(1002, 1, 102, '2023-06-01', 120, 'Laptop'),
(1003, 2, 103, '2023-06-02', 85, 'Mobile'),
(1004, 3, 101, '2023-06-02', 135, 'Smart TV'),
(1005, 3, 104, '2023-06-03', 140, 'Tablet'),
(1006, 4, 105, '2023-06-03', 90, 'Laptop'),
(1007, 5, 106, '2023-06-04', 110, 'Smart TV'),
(1008, 1, 107, '2023-06-04', 100, 'Mobile'),
(1009, 6, 108, '2023-06-05', 125, 'Laptop'),
(1010, 7, 109, '2023-06-05', 95, 'Smart TV'),
(1011, 8, 110, '2023-06-06', 115, 'Tablet'),
(1012, 9, 101, '2023-06-06', 130, 'Smart TV'),
(1013, 10, 102, '2023-06-07', 80, 'Mobile'),
(1014, 2, 103, '2023-06-07', 90, 'Laptop'),
(1015, 5, 104, '2023-06-08', 105, 'Smart TV');

SELECT 'Sample data loaded successfully!' AS status;

-- Step 4: Verify Setup
SELECT 'Setup Complete! You now have:' AS message;
SELECT COUNT(*) AS total_movies FROM MOVIES;
SELECT COUNT(*) AS total_users FROM USERS;
SELECT COUNT(*) AS total_views FROM STREAMING_VIEWS;

-- Step 5: Set default context for workshop
USE DATABASE WORKSHOP_DB;
USE SCHEMA STUDENT_SCHEMA;
USE WAREHOUSE COMPUTE_WH;

SELECT '🎉 You are ready for the workshop! 🎉' AS final_message;