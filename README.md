# Mecklenburg County Voter Database Project

## Project Overview
This project involves working with real-world voter data from Mecklenburg County, NC. The main objectives are to import a large CSV dataset into a MySQL database, perform data cleaning, conduct data analysis, and implement various database operations and analytics.

## Data Source
The data is sourced from the Mecklenburg County Board of Elections voter data file. The cleaned dataset is provided as a 160 MB CSV file.

## Project Objectives
1. Create a MySQL database and table structure to match the provided CSV data.
2. Import the CSV data into MySQL.
3. Perform data cleaning and handle data inaccuracies.
4. Implement database normalization based on functional dependencies.
5. Create stored procedures for various operations (e.g., search voter history, insert/update voter records).
6. Implement triggers for data integrity and auditing.
7. Develop views for analytics purposes.

## Key Features
- Database creation and data import
- Data cleaning and normalization
- Stored procedures for voter record operations
- Triggers for data integrity and auditing
- Analytical views for voter statistics

## Technical Details
- Database: MySQL
- Data Format: CSV (fields enclosed by '$' and separated by ';')
- File Size: Approximately 160 MB

## Project Structure
1. Data Import and Cleaning
2. Database Normalization
3. Stored Procedures Implementation
4. Trigger Creation
5. Analytical Views Development

## Implemented Features
- Voter record search
- Voter record insertion/update with auditing
- Voter record deletion with auditing
- Various analytical views (e.g., constituent stats, demographic stats)
- Custom analytics (e.g., party distribution by zip code, age distribution by race)

## Usage
Detailed instructions on how to set up the database, import data, and use the implemented features are provided in the SQL files.

## Notes
- The project requires careful consideration of data types and handling of data inaccuracies.
- Specific instructions for data import and error resolution are provided in the project document.

## Acknowledgements
This project is based on data from the Mecklenburg County Board of Elections and is part of a database management course assignment.
