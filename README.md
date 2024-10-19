# MDB -> SQL -> PSQL

This script is designed to facilitate the database setup FROM A MDB  DATABASE process by auto-generating tables and columns based on the content of provided SQL files. It specifically targets SQL files that contain `INSERT` statements.

## Preliminary Steps

Before using this script, it's recommended to:

1. **Load Your Database into DBeaver**: Import your database into the DBeaver tool.
2. **Export to SQL Format**: Using DBeaver, export your database structure and data to SQL format. This will produce SQL files that are used as input for this script.

## Features

- **Adapt SQL Files**: Modifies SQL files in the specified directory by replacing square brackets (`[`, `]`) with double quotes (`"`), making them compatible with PostgreSQL's naming conventions.
  
- **Auto-Create Tables**: For each SQL file, the script checks if a table with the corresponding name exists in the database. If not, it creates an empty table.

- **Auto-Generate Columns**: Before executing the `INSERT` statements from each SQL file, the script checks for the existence of each column mentioned. If a column doesn't exist, it's added to the table with the data type `TEXT`.

- **Execute SQL Files**: After ensuring that the necessary tables and columns exist, the script executes the SQL files to populate the database.

## Usage

1. Update the `DATABASE`, `USER`, and directory path variables in the script to match your PostgreSQL setup.
2. Place your SQL files (generated from DBeaver) in the specified directory.
3. Run the script.

## Warning

- By default, newly created columns are of type `TEXT`. If your database requires different data types, adjustments to the script will be necessary.
- Ensure you have a backup of your SQL files before running the script, as it modifies them in-place.
