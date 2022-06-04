--Part 5: Sample Transactions
--For this part, you will submit five example transactions (use cases). 
--These transactions should demonstrate "interesting" interactions with your database. 
--An "interesting query" should JOIN multiple tables (preferably 3+) 
--and use one or more concepts such as WHERE filtering, GROUP BY, ORDER BY,
--HAVING, UNION, aggregation, and/or nested queries.

-- Select all at-treeline forcasts from Jan 1, 2022. 
SELECT danger_at_treeline FROM Forecast WHERE issue_date is "1/1/2022" LIMIT 5;

-- Find all eastern aspect forecasts from Colorado and Utah 
SELECT DISTINCT *
FROM Forecast
NATURAL JOIN Problem
NATURAL JOIN Aspect
NATURAL JOIN Forecaster
NATURAL JOIN Agency
WHERE Aspect.aspect = "E" AND Agency.agency_id=1 OR Agency.agency_id=6
LIMIT 5;

-- Select a complete forecast with it's associated problems
SELECT * FROM Forecast NATURAL JOIN Problem LIMIT 5;

-- Select