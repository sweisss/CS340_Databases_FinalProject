--Part 5: Sample Transactions
--For this part, you will submit five example transactions (use cases). 
--These transactions should demonstrate "interesting" interactions with your database. 
--An "interesting query" should JOIN multiple tables (preferably 3+) 
--and use one or more concepts such as WHERE filtering, GROUP BY, ORDER BY,
--HAVING, UNION, aggregation, and/or nested queries.

-- 1) Select all at-treeline forcasts from Jan 1, 2022.
-- !!!THIS MIGHT BE TOO SIMPLE!!!
SELECT danger_at_treeline FROM Forecast WHERE issue_date is "1/1/2022" LIMIT 5;

-- 2) Find all eastern aspect forecasts from Colorado and Utah 
SELECT DISTINCT *
FROM Forecast
NATURAL JOIN Problem
NATURAL JOIN Aspect
NATURAL JOIN Forecaster
NATURAL JOIN Agency
WHERE Aspect.aspect = "E" AND Agency.agency_id=1 OR Agency.agency_id=6
LIMIT 5;

-- 3) Select a complete forecast with it's associated problems 
-- !!!THIS MIGHT BE TOO SIMPLE (maybe put and order by or group by in it)
SELECT * FROM Forecast NATURAL JOIN Problem LIMIT 5;

-- 4) Find all observation data from Oregon
SELECT DISTINCT o.observation_date, z.zone_name, o.observation_location, o.avalanche, o.obs_description FROM Observation AS o
NATURAL JOIN Zone AS z
NATURAL JOIN Agency AS a 
WHERE agency_id IN (0, 3)
LIMIT 5;

-- 5) Find the first and last name of forecasters who have not contributed an observation
SELECT f.fname, f.lname FROM Forecaster AS f LEFT JOIN Observer AS o ON f.fname = o.fname WHERE o.fname iS NULL;
