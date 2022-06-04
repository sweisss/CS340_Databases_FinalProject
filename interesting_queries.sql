--Part 5: Sample Transactions
--For this part, you will submit five example transactions (use cases). 
--These transactions should demonstrate "interesting" interactions with your database. 
--An "interesting query" should JOIN multiple tables (preferably 3+) 
--and use one or more concepts such as WHERE filtering, GROUP BY, ORDER BY,
--HAVING, UNION, aggregation, and/or nested queries.

-- 1) Find the most common avalnche problem in Utah (it should be Wind Slab with a count of 2)
-- SELECT a.agency_name, p.problem_type, MAX(prob_count) --COUNT(p.problem_type)
-- FROM (SELECT a.agency_name, p.problem_type, COUNT(p.problem_type) AS prob_count
--     FROM Problem AS p
--     NATURAL JOIN Forecast AS f
--     NATURAL JOIN Forecaster AS fr 
--     NATURAL JOIN Agency AS a 
--     --WHERE a.agency_id=1
--     ORDER BY COUNT(p.problem_type) DESC LIMIT 1)
-- GROUP BY a.agency_id;

-- SELECT a.agency_name, p.problem_type, COUNT(p.problem_type)
-- FROM Problem AS p
-- NATURAL JOIN Forecast AS f
-- NATURAL JOIN Forecaster AS fr 
-- NATURAL JOIN Agency AS a 
-- WHERE a.agency_id=1
-- GROUP BY a.agency_name, p.problem_type 
-- ORDER BY a.agency_name,COUNT(p.problem_type) DESC LIMIT 5;

-- This almost works, the count is still counting the overall total though. 
SELECT a.agency_name, p.problem_type, COUNT(p.problem_type) 
FROM Problem AS p  
NATURAL JOIN Forecast AS f
NATURAL JOIN Forecaster AS fr 
NATURAL JOIN Agency AS a 
WHERE a.agency_id=1
GROUP BY p.problem_type 
HAVING COUNT (p.problem_type)=( 
SELECT MAX(mycount) 
FROM ( 
SELECT p.problem_type, COUNT(p.problem_type) mycount 
FROM Problem AS p 
GROUP BY p.problem_type));




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
