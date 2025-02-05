# GetTotals SQL Procedure

## About
This project contains an SQL stored procedure named `GetTotals`, which is designed to extract and count records from a specified table based on a date filter. The procedure dynamically constructs SQL queries to count records for each table and stores the results in a temporary table before returning the final dataset.

## Features
- Uses a cursor to iterate over a list of tables.
- Dynamically constructs and executes SQL queries.
- Filters records based on the current date.
- Stores and returns results in a temporary table.

## How It Works
1. Declares a temporary table `#TempResult` to store the results.
2. Declares necessary variables for processing.
3. Uses a cursor to iterate through the `extraccions_ppc` table to retrieve table names and related metadata.
4. Dynamically constructs and executes a SQL query to count records where the date field matches the current date.
5. Stores the results in the temporary table.
6. Returns the final dataset.
7. Cleans up by closing and deallocating the cursor.


## Usage
To execute the stored procedure, use the following command in SQL Server:
```sql
EXEC GetTotals;
