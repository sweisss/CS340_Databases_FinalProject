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



-- Agency ----------------------------------------------------------------
--Clear the way for the Agency table.
DROP TABLE IF EXISTS Agency;

--Create the Agency table
CREATE TABLE Agency (
	agency_id INTEGER PRIMARY KEY,
	agency_name TEXT NOT NULL,
	website_url TEXT NOT NULL
);

--Populate the Agency table
INSERT INTO Agency VALUES (0, "Central Oregon Avalanche Center", "https://www.coavalanche.org/");
INSERT INTO Agency VALUES (1, "Utah Avalanche Center", "https://utahavalanchecenter.org/");
INSERT INTO Agency VALUES (2, "Sierra Avalanche Center", "https://www.sierraavalanchecenter.org/");
INSERT INTO Agency VALUES (3, "Wallawa Avalanche Center", "https://wallowaavalanchecenter.org/");
INSERT INTO Agency VALUES (4, "Sawtooth Avalanche Center", "https://www.sawtoothavalanche.com/");



--Clear the way for the Forecaster table.
DROP TABLE IF EXISTS Forecaster;

--Create the Forecaster table
CREATE TABLE Forecaster (
	frcstr_id INTEGER PRIMARY KEY,
	fname TEXT NOT NULL,
	lname TEXT NOT NULL,
    agency_id INTEGER NOT NULL,
    FOREIGN KEY (agency_id) REFERENCES Agency(agency_id)
);


--Clear the way for the Forecast table.
DROP TABLE IF EXISTS Forecast;

--Create the Forecast table
CREATE TABLE Forecast (
	fid INTEGER PRIMARY KEY,
	issue_date TEXT NOT NULL,
	danger_below_treeline INTEGER NOT NULL,
    danger_at_treeline INTEGER NOT NULL,
    danger_above_treeline INTEGER NOT NULL,
    issued_by INTEGER NOT NULL,
    corresponds_to INTEGER NOT NULL, -- TODO: Reference zone somehow
    FOREIGN KEY (issued_by) REFERENCES Forecaster(frcstr_id)
);


--Clear the way for the Problem table.
DROP TABLE IF EXISTS Problem;

--Create the Problem table
CREATE TABLE Problem (
	fid INTEGER,
	problem_number TEXT NOT NULL, --TODO use id instead of two part PK?
	problem_type TEXT NOT NULL,
    size INTEGER NOT NULL,
    likelihood INTEGER NOT NULL,
    PRIMARY KEY (fid, problem_number), --TODO use id instead of two part PK?
    FOREIGN KEY (fid) REFERENCES Forecast(fid)
);


--Clear the way for the Elevation table.
DROP TABLE IF EXISTS Elevation;

--Create the Elevation table
-- TODO: Potentially simplify FKs with new problem id attr?
CREATE TABLE Elevation (
    fid INTEGER NOT NULL,
    problem_number INTEGER NOT NULL,
    elevation INTEGER NOT NULL,
    PRIMARY KEY (fid, problem_number, elevation)
    FOREIGN KEY (fid, problem_number) REFERENCES Problem (fid, problem_number)
);


--Clear the way for the Aspect table.
DROP TABLE IF EXISTS Aspect;

--Create the Aspect table
CREATE TABLE Aspect (
    fid INTEGER NOT NULL,
    problem_number INTEGER NOT NULL,
    aspect INTEGER NOT NULL,
    PRIMARY KEY (fid, problem_number, aspect)
    FOREIGN KEY (fid, problem_number) REFERENCES Problem (fid, problem_number)
);


--Clear the way for the Observation table.
DROP TABLE IF EXISTS Observation;

--Create the Observation table
CREATE TABLE Observation (
    observation_id INTEGER NOT NULL PRIMARY KEY,
    observation_date TEXT NOT NULL,
    avalanche BOOLEAN NOT NULL,
    obseration_location TEXT NOT NULL,
    observer_id INTEGER NOT NULL,
    FOREIGN KEY (observer_id) REFERENCES Observer(observer_id)
);


--Clear the way for the Observer table.
DROP TABLE IF EXISTS Observer;

--Create the Observer table
CREATE TABLE Observer (
    observer_id INTEGER NOT NULL PRIMARY KEY,
    lname TEXT NOT NULL,
    fname TEXT NOT NULL,
    observer_type TEXT NOT NULL
);


--Clear the way for the Zone table.
DROP TABLE IF EXISTS Zone;

--Create the Zone table
CREATE TABLE Zone (
    zone_name TEXT NOT NULL,
    agency_id INTEGER NOT NULL,
    PRIMARY KEY (zone_name, agency_id),
    FOREIGN KEY (agency_id) REFERENCES Agency(agency_id)
);


--Clear the way for the Contribution table.
DROP TABLE IF EXISTS Contribution;

--Create the Contribution table
CREATE TABLE Contribution (
    agency_id INTEGER NOT NULL,
    observation_id INTEGER NOT NULL,
    observer_id INTEGER NOT NULL,
    PRIMARY KEY (agency_id, observation_id, observer_id),
    FOREIGN KEY (agency_id) REFERENCES Agency(agency_id),
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id),
    FOREIGN KEY (observer_id) REFERENCES Observer(observer_id)
);