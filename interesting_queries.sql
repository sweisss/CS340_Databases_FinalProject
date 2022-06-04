--Part 5: Sample Transactions
--For this part, you will submit five example transactions (use cases). 
--These transactions should demonstrate "interesting" interactions with your database. 
--An "interesting query" should JOIN multiple tables (preferably 3+) 
--and use one or more concepts such as WHERE filtering, GROUP BY, ORDER BY,
--HAVING, UNION, aggregation, and/or nested queries.

-- 1) Find the agency with the most Wind Slab problems in the forecasts.
-- SELECT COUNT(problem_type) FROM Problem WHERE problem_type="Wind Slab"; -- gets the total amount of Wind Slab Problems

SELECT a.agency_name, a.website_url, p.problem_type, COUNT(p.problem_type) AS prob
FROM Agency AS a
NATURAL JOIN Forecaster
NATURAL JOIN Forecast
NATURAL JOIN Problem AS p
WHERE p.problem_type="Wind Slab"
GROUP BY a.agency_name
ORDER BY prob DESC LIMIT 1;


-- 2) Find all eastern aspect forecasts from Colorado and Utah 
SELECT DISTINCT *
FROM Forecast
NATURAL JOIN Problem
NATURAL JOIN Aspect
NATURAL JOIN Forecaster
NATURAL JOIN Agency
WHERE Aspect.aspect = "E" AND Agency.agency_id=1 OR Agency.agency_id=6
LIMIT 5;

-- 3) Find all forecasts that involve a Wind Slab problem, order first by region then by issue date.  
SELECT * 
FROM Forecast 
NATURAL JOIN Problem 
WHERE problem.problem_type = "Wind Slab"
ORDER BY corresponds_to, issue_date
LIMIT 5;

-- 4) Find all observation data from Oregon
SELECT DISTINCT 
    o.observation_date, 
    z.zone_name, 
    o.observation_location,
    CASE WHEN avalanche = 0 THEN 'No' ELSE 'Yes' END AS avalanche, 
    o.obs_description 
FROM Observation AS o
NATURAL JOIN Zone AS z
NATURAL JOIN Agency AS a 
WHERE agency_id IN (0, 3)
LIMIT 5;

-- 5) Find the first and last name of forecasters who have not contributed an observation
SELECT f.fname, f.lname FROM Forecaster AS f LEFT JOIN Observer AS o ON f.fname = o.fname WHERE o.fname iS NULL;
