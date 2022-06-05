--CS340 Databases
--Spring 2022
--Final Project - SQL Schema
--Seth Weiss, Orion Junkins
--weissse@oregonstate.edu
--junkinso@oregonstate.edu

--this file builds the schema for an avlanche forecasting network in SQLite

--before running the file from the command line, enter the following command:
--$ sqlite3 FILENAME.db < FILENAME.sql

--Alternatively, use the provided build script and enter the following commands:
--$ bash build_db.sh
--$ sqlite3 test.db

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
INSERT INTO Agency VALUES (3, "Wallowa Avalanche Center", "https://wallowaavalanchecenter.org/");
INSERT INTO Agency VALUES (4, "Sawtooth Avalanche Center", "https://www.sawtoothavalanche.com/");
INSERT INTO Agency VALUES (5, "Northwest Avalanche Center", "https://nwac.us/");
INSERT INTO Agency VALUES (6, "Colorado Avalanche Information Center", "https://www.avalanche.state.co.us/");


-- Forecaster ----------------------------------------------------------------
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

--Populate the Forecaster table
INSERT INTO Forecaster VALUES (0, "Joe", "Smith", 0);
INSERT INTO Forecaster VALUES (1, "Jane", "Jones", 6);
INSERT INTO Forecaster VALUES (2, "John", "Lee", 1);
INSERT INTO Forecaster VALUES (3, "Jessica", "Thompson", 2);
INSERT INTO Forecaster VALUES (4, "Jimmy", "Thompson", 2);
INSERT INTO Forecaster VALUES (5, "Jane", "Jenkins", 5);
INSERT INTO Forecaster VALUES (6, "Jorge", "Lopez", 3);
INSERT INTO Forecaster VALUES (7, "Joe", "Watkins", 4);
INSERT INTO Forecaster VALUES (8, "Joey JoJo Jr.", "Shabadoo", 6);
INSERT INTO Forecaster VALUES (9, "Big", "Foot", 5);
INSERT INTO Forecaster VALUES (10, "Healy", "Fettuccine", 4);



-- Forecast ----------------------------------------------------------------
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
    corresponds_to TEXT NOT NULL,
    FOREIGN KEY (issued_by) REFERENCES Forecaster(frcstr_id),
    FOREIGN KEY (corresponds_to) REFERENCES Zone(zone_name),
    CHECK (danger_below_treeline>=0 AND danger_below_treeline<=5 ), 
    CHECK (danger_at_treeline>=0 AND danger_at_treeline<=5 ), 
    CHECK (danger_above_treeline>=0 AND danger_above_treeline<=5 ), 
);

--Populate the Forecast table
INSERT INTO Forecast VALUES (0, "12-2-21", 0, 1, 1, 0, "Central Cascades");
INSERT INTO Forecast VALUES (1, "12-26-21", 1, 1, 1, 1, "Southern Mountains");
INSERT INTO Forecast VALUES (2, "1/1/2022", 2, 2, 3, 2, "Uintas");
INSERT INTO Forecast VALUES (3, "1/1/2022", 2, 2, 2, 3, "Central Sierra Nevada");
INSERT INTO Forecast VALUES (4, "1/1/2022", 1, 2, 3, 4, "Central Sierra Nevada");
INSERT INTO Forecast VALUES (5, "1/2/2022", 1, 1, 1, 5, "West Slopes South");
INSERT INTO Forecast VALUES (6, "1/2/2022", 2, 2, 2, 6, "Northern Wallowas");
INSERT INTO Forecast VALUES (7, "1/2/2022", 2, 2, 3, 7, "Sawtooth and Western Smoky Mtns");
INSERT INTO Forecast VALUES (8, "1/2/2022", 3, 4, 4, 8, "Southern Mountains");
INSERT INTO Forecast VALUES (9, "1/2/2022", 2, 2, 2, 9, "West Slopes South");
INSERT INTO Forecast VALUES (10, "1/3/2022", 1, 1, 1, 10, "Sawtooth and Western Smoky Mtns");
INSERT INTO Forecast VALUES (11, "1/3/2022", 0, 1, 1, 1, "Southern Mountains");
INSERT INTO Forecast VALUES (12, "1/3/2022", 0, 1, 1, 2, "Uintas");
INSERT INTO Forecast VALUES (13, "1/3/2022", 2, 2, 3, 3, "Central Sierra Nevada");
INSERT INTO Forecast VALUES (15, "1/3/2022", -1, 1, 1, 4, "Central Sierra Nevada");
INSERT INTO Forecast VALUES (16, "1/3/2022", 1, -2, 1, 4, "Central Sierra Nevada");
INSERT INTO Forecast VALUES (16, "1/3/2022", 1, 1, 7, 4, "Central Sierra Nevada");




-- Problem ----------------------------------------------------------------
--Clear the way for the Problem table.
DROP TABLE IF EXISTS Problem;

--Create the Problem table
CREATE TABLE Problem (
	pid INTEGER NOT NULL,
    fid INTEGER NOT NULL,
	problem_type TEXT NOT NULL,
    size INTEGER,
    likelihood INTEGER,
    PRIMARY KEY (pid),
    FOREIGN KEY (fid) REFERENCES Forecast(fid)
);

--Populate the Problem table
INSERT INTO Problem VALUES (0, 0, 'Loose Dry', 1, 1);
INSERT INTO Problem VALUES (1, 0, 'Wind Slab', 2, 1);
INSERT INTO Problem VALUES (2, 1, 'Storm Slab', 3, 4);
INSERT INTO Problem VALUES (3, 1, 'Wind Slab', 3, 4);
INSERT INTO Problem VALUES (4, 2, 'Wind Slab', 3, 4);
INSERT INTO Problem VALUES (5, 2, 'Cornice Collapse', 2, 3);
INSERT INTO Problem VALUES (6, 3, 'Wind Slab', 3, 2);
INSERT INTO Problem VALUES (7, 4, 'Cornice Collapse', 2, 2);
INSERT INTO Problem VALUES (8, 4, 'Wind Slab', 2, 2);
INSERT INTO Problem VALUES (9, 5, 'Cornice Collapse', 2, 2);
INSERT INTO Problem VALUES (10, 5, 'Wind Slab', 1, 1);
INSERT INTO Problem VALUES (11, 6, 'Loose Dry', 1, 1);
INSERT INTO Problem VALUES (12, 7, 'Persistent Slab', 1, 1);
INSERT INTO Problem VALUES (13, 7, 'Loose Dry', 1, 2);
INSERT INTO Problem VALUES (14, 8, 'Wind Slab', 2, 4);
INSERT INTO Problem VALUES (15, 8, 'Cornice Collapse', 2, 3);
INSERT INTO Problem VALUES (16, 9, 'Wind Slab', 2, 3);
INSERT INTO Problem VALUES (17, 9, 'Loose Dry', 1, 3);
INSERT INTO Problem VALUES (18, 10, 'Wind Slab', 1, 3);
INSERT INTO Problem VALUES (19, 10, 'Cornice Collapse', 2, 2);
INSERT INTO Problem VALUES (20, 11, 'Wind Slab', 2, 2);
INSERT INTO Problem VALUES (21, 11, 'Persistent Slab', 1, 2);
INSERT INTO Problem VALUES (22, 12, 'Wind Slab', 1, 3);
INSERT INTO Problem VALUES (23, 12, 'Persistent Slab', 1, 1);
INSERT INTO Problem VALUES (24, 13, 'Wet Slab', 2, 3);
INSERT INTO Problem VALUES (25, 13, 'Loose Wet', 1, 3);
INSERT INTO Problem VALUES (26, 14, 'Loose Wet', 1, 1);



-- Elevation ----------------------------------------------------------------
--Clear the way for the Elevation table.
DROP TABLE IF EXISTS Elevation;

--Create the Elevation table
CREATE TABLE Elevation (
    pid INTEGER NOT NULL,
    elevation INTEGER NOT NULL,
    PRIMARY KEY (pid, elevation)
    FOREIGN KEY (pid) REFERENCES Problem (pid)
);

--Populate the Elevation table
INSERT INTO Elevation VALUES (0, 1);
INSERT INTO Elevation VALUES (1, 1);
INSERT INTO Elevation VALUES (2, 2);
INSERT INTO Elevation VALUES (3, 3);
INSERT INTO Elevation VALUES (4, 2);
INSERT INTO Elevation VALUES (5, 3);
INSERT INTO Elevation VALUES (6, 1);
INSERT INTO Elevation VALUES (7, 2);
INSERT INTO Elevation VALUES (8, 3);
INSERT INTO Elevation VALUES (9, 1);
INSERT INTO Elevation VALUES (10, 2);
INSERT INTO Elevation VALUES (11, 3);
INSERT INTO Elevation VALUES (12, 1);
INSERT INTO Elevation VALUES (13, 2);
INSERT INTO Elevation VALUES (14, 3);
INSERT INTO Elevation VALUES (15, 1);
INSERT INTO Elevation VALUES (16, 2);
INSERT INTO Elevation VALUES (17, 3);
INSERT INTO Elevation VALUES (18, 1);
INSERT INTO Elevation VALUES (19, 2);
INSERT INTO Elevation VALUES (20, 3);
INSERT INTO Elevation VALUES (21, 1);
INSERT INTO Elevation VALUES (22, 2);
INSERT INTO Elevation VALUES (23, 3);
INSERT INTO Elevation VALUES (24, 1);
INSERT INTO Elevation VALUES (25, 2);
INSERT INTO Elevation VALUES (26, 3);



-- Aspect ----------------------------------------------------------------
--Clear the way for the Aspect table.
DROP TABLE IF EXISTS Aspect;

--Create the Aspect table
CREATE TABLE Aspect (
    pid INTEGER NOT NULL,
    aspect VARCHAR(2) NOT NULL,
    PRIMARY KEY (pid, aspect)
    FOREIGN KEY (pid) REFERENCES Problem (pid)
);

--Populate the Aspect table
INSERT INTO Aspect VALUES (0, 'N');
INSERT INTO Aspect VALUES (1, 'NE');
INSERT INTO Aspect VALUES (2, 'E');
INSERT INTO Aspect VALUES (3, 'SE');
INSERT INTO Aspect VALUES (4, 'S');
INSERT INTO Aspect VALUES (5, 'SW');
INSERT INTO Aspect VALUES (6, 'W');
INSERT INTO Aspect VALUES (7, 'NW');
INSERT INTO Aspect VALUES (8, 'N');
INSERT INTO Aspect VALUES (9, 'NW');
INSERT INTO Aspect VALUES (10, 'NE');
INSERT INTO Aspect VALUES (11, 'N');
INSERT INTO Aspect VALUES (12, 'NE');
INSERT INTO Aspect VALUES (13, 'E');
INSERT INTO Aspect VALUES (14, 'NE');
INSERT INTO Aspect VALUES (15, 'E');
INSERT INTO Aspect VALUES (16, 'N');
INSERT INTO Aspect VALUES (17, 'NW');
INSERT INTO Aspect VALUES (18, 'NW');
INSERT INTO Aspect VALUES (19, 'W');
INSERT INTO Aspect VALUES (20, 'NE');
INSERT INTO Aspect VALUES (21, 'E');
INSERT INTO Aspect VALUES (22, 'N');
INSERT INTO Aspect VALUES (23, 'NW');
INSERT INTO Aspect VALUES (24, 'E');
INSERT INTO Aspect VALUES (25, 'S');
INSERT INTO Aspect VALUES (26, 'SE');


-- Observation ----------------------------------------------------------------
--Clear the way for the Observation table.
DROP TABLE IF EXISTS Observation;

--Create the Observation table
CREATE TABLE Observation (
    observation_id INTEGER NOT NULL PRIMARY KEY,
    observation_date TEXT NOT NULL,
    avalanche BOOLEAN NOT NULL,
    observation_location TEXT NOT NULL,
    zone_name TEXT NOT NULL,
    observer_id INTEGER,
    obs_description TEXT, 
    FOREIGN KEY (zone_name) REFERENCES Zone(zone_name),
    FOREIGN KEY (observer_id) REFERENCES Observer(observer_id)
);

--Populate the Observation table
INSERT INTO Observation VALUES (0, '12-2-21', 0, "Tam McArthur Rim", "Central Cascades", 0, "Dug a hand pit, good bonding.");
INSERT INTO Observation VALUES (1, '12-15-21', 1, "Mineral Fork", "Uintas", 1, "Saw remenants of slide. No cracking or wumphing.");
INSERT INTO Observation VALUES (2, '12-26-21', 1, "Elephant's Hump", "Central Sierra Nevada", 2, "Huge slide off the hump, most likely human triggered.");
INSERT INTO Observation VALUES (3, '1-2-22', 0, "Jackson Peak", "Northern Wallowas", 3, "Great snow, no cracks or wumphing, pit revealed potential persistent weak layer.");
INSERT INTO Observation VALUES (4, '1-14-22', 1, "Avalanche Peak", "Sawtooth and Western Smoky Mtns", 4, "Observered an avalanche on Avalanceh Peak!");
INSERT INTO Observation VALUES (5, '2-2-22', 1, "Muir snowfield", "West Slopes South", 5, "Skier triggered small loose-wet slide. Large roller-balls.");
INSERT INTO Observation VALUES (6, '2-2-22', 1, "Mt Meeker", "Southern Mountains", 6, "Large scary cracks. Many avalanches in steeper terrain.");


-- Observer ----------------------------------------------------------------
--Clear the way for the Observer table.
DROP TABLE IF EXISTS Observer;

--Create the Observer table
CREATE TABLE Observer (
    observer_id INTEGER NOT NULL PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL,
    observer_type TEXT NOT NULL
);

--Populate the Observer table
INSERT INTO Observer VALUES (0, "Joe", "Smith", "Forecaster");
INSERT INTO Observer VALUES (1, "Jane", "Jones", "Forecaster");
INSERT INTO Observer VALUES (2, "John", "Lee", "Forecaster");
INSERT INTO Observer VALUES (3, "Jessica", "Thompson", "Forecaster");
INSERT INTO Observer VALUES (4, "Jimmy", "Thompson", "Forecaster");
INSERT INTO Observer VALUES (5, "James", "Jim", "Public");
INSERT INTO Observer VALUES (6, "Bruce", "Lee", "Public");
INSERT INTO Observer VALUES (7, "Snow", "Flake", "Guide");
INSERT INTO Observer VALUES (8, "Smith", "Optics", "Public");

-- Zone ----------------------------------------------------------------
--Clear the way for the Zone table.
DROP TABLE IF EXISTS Zone;

--Create the Zone table
CREATE TABLE Zone (
    zone_name TEXT NOT NULL,
    agency_id INTEGER NOT NULL,
    PRIMARY KEY (zone_name),
    FOREIGN KEY (agency_id) REFERENCES Agency(agency_id)
);

--Populate the Zone table
INSERT INTO Zone VALUES ('Central Cascades', 0);
INSERT INTO Zone VALUES ("Uintas", 1);
INSERT INTO Zone VALUES ("Central Sierra Nevada", 2);
INSERT INTO Zone VALUES ("Northern Wallowas", 3);
INSERT INTO Zone VALUES ("Sawtooth and Western Smoky Mtns", 4);
INSERT INTO Zone VALUES ("West Slopes South", 5);
INSERT INTO Zone VALUES ("Southern Mountains", 6);


-- Sample Queries ----------------------------------------------------------------
SELECT * FROM Agency LIMIT 5;
SELECT * FROM Forecast LIMIT 5;
SELECT * FROM Forecaster LIMIT 5;
SELECT * FROM Problem LIMIT 5;
SELECT * FROM Elevation LIMIT 5;
SELECT * FROM Aspect LIMIT 5;
SELECT * FROM Observation LIMIT 5;
SELECT * FROM Observer LIMIT 5;
SELECT * FROM Zone LIMIT 5;