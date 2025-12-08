-- STEP 1: Calculate average ride length (in minutes) for July 2020
-- This provides a single-month snapshot of member vs casual rider behavior
SELECT member_casual,
       AVG(TIME_TO_SEC(TIMEDIFF(ended_at, started_at)) / 60) AS ride_length_mins
FROM `202007-divvy-tripdata`
GROUP BY member_casual;

-- STEP 2: Combine selected months into one dataset
-- Here we union Q1, April–July, and December data for broader comparison
SELECT * FROM divvy_trips_2020_q1
UNION ALL
SELECT * FROM `202004-divvy-tripdata`
UNION ALL
SELECT * FROM `202005-divvy-tripdata`
UNION ALL
SELECT * FROM `202006-divvy-tripdata`
UNION ALL
SELECT * FROM `202007-divvy-tripdata`
UNION ALL
SELECT * FROM `202012-divvy-tripdata`;

-- STEP 3: Calculate average ride length by user type across combined dataset
-- This confirms the business insight that casual riders tend to take longer trips
SELECT member_casual,
       AVG(TIME_TO_SEC(TIMEDIFF(ended_at, started_at)) / 60) AS avg_ride_length_mins
FROM (
  SELECT * FROM divvy_trips_2020_q1
  UNION ALL
  SELECT * FROM `202004-divvy-tripdata`
  UNION ALL
  SELECT * FROM `202005-divvy-tripdata`
  UNION ALL
  SELECT * FROM `202006-divvy-tripdata`
  UNION ALL
  SELECT * FROM `202007-divvy-tripdata`
  UNION ALL
  SELECT * FROM `202012-divvy-tripdata`
) AS combined_trips
GROUP BY member_casual;