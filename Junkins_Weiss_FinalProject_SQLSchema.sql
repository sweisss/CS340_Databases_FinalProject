--CS340 Databases
--Spring 2022
--Final Project - SQL Schema
--Seth Weiss, Orion Junkins
--weissse@oregonstate.edu
--junkinso@oregonstate.edu

--this file builds the schema for an avlanche forecasting network in SQLite

--before running the file from the command line, enter the following command:
--$ sqlite3 FILENAME.db < FILENAME.sql


--For each table created, you should include: 
    --name (be descriptive) of each attribute
    --type of each attribute (consider the storage space implications of each choice)
    --attribute constraints (e.g., NOT NULL, uniqueness, default value)
    --primary key
    --foreign keys (all of them)
    --referential integrity constraints
    --CHECK clauses (if needed)
    --short comment linking the table creation command to the entity name of your ER diagram
    --include a DROP TABLE command before each CREATE TABLE command, to facilitate quick database re-generation


--Clear the way for the Agency table.
DROP TABLE IF EXISTS Agency;
--