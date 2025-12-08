-- STEP 1: Combine all monthly trip data into a single 2020 view
CREATE VIEW all_trips_2020 AS
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
SELECT * FROM `202008-divvy-tripdata`
UNION ALL
SELECT * FROM `202009-divvy-tripdata`
UNION ALL
SELECT * FROM `202010-divvy-tripdata`
UNION ALL
SELECT * FROM `202011-divvy-tripdata`
UNION ALL
SELECT * FROM `202012-divvy-tripdata`;

-- STEP 2: Quick validation checks on combined dataset
SELECT * FROM all_trips_2020 LIMIT 20;
SELECT COUNT(*) AS total_rides FROM all_trips_2020;

-- STEP 3: Identify duplicate ride IDs in the full dataset
SELECT ride_id, COUNT(*) AS count
FROM all_trips_2020
GROUP BY ride_id
HAVING COUNT(*) > 1;

SELECT ride_id, COUNT(*) AS count
FROM all_trips_2020
GROUP BY ride_id
HAVING COUNT(*) > 1
LIMIT 100;

-- STEP 4: Create quarterly tables for easier seasonal analysis
CREATE TABLE divvy_trips_2020_q2 AS
SELECT * FROM `202004-divvy-tripdata`
UNION ALL
SELECT * FROM `202005-divvy-tripdata`
UNION ALL
SELECT * FROM `202006-divvy-tripdata`;

CREATE TABLE divvy_trips_2020_q3 AS
SELECT * FROM `202007-divvy-tripdata`
UNION ALL
SELECT * FROM `202008-divvy-tripdata`
UNION ALL
SELECT * FROM `202009-divvy-tripdata`;

CREATE TABLE divvy_trips_2020_q4 AS
SELECT * FROM `202010-divvy-tripdata`
UNION ALL
SELECT * FROM `202011-divvy-tripdata`
UNION ALL
SELECT * FROM `202012-divvy-tripdata`;

-- STEP 5: Check duplicates specifically in Q4
SELECT ride_id, COUNT(*) AS count
FROM divvy_trips_2020_q4
GROUP BY ride_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS duplicate_count
FROM (
    SELECT ride_id
    FROM divvy_trips_2020_q4
    GROUP BY ride_id
    HAVING COUNT(*) > 1
) AS dupes;

-- STEP 6: Deduplicate Q4 using different approaches
-- Option A: GROUP BY ride_id
CREATE TABLE divvy_trips_2020_q4_clean AS
SELECT *
FROM divvy_trips_2020_q4
GROUP BY ride_id;

-- Option B: ROW_NUMBER window function
CREATE TABLE divvy_trips_2020_q4_clean AS
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
  FROM divvy_trips_2020_q4
) AS numbered
WHERE rn = 1;

-- Option C: Join earliest ride per ID
CREATE TABLE divvy_trips_2020_q4_clean AS
SELECT q4.*
FROM divvy_trips_2020_q4 q4
JOIN (
  SELECT ride_id, MIN(started_at) AS earliest_start
  FROM divvy_trips_2020_q4
  GROUP BY ride_id
) AS first_rides
ON q4.ride_id = first_rides.ride_id AND q4.started_at = first_rides.earliest_start;

-- STEP 7: Rebuild all_trips_2020 view excluding duplicates
CREATE OR REPLACE VIEW divvy_trips_2020_q4_nodupes AS
SELECT *
FROM divvy_trips_2020_q4
WHERE ride_id IN (
  SELECT ride_id
  FROM divvy_trips_2020_q4
  GROUP BY ride_id
  HAVING COUNT(*) = 1
);

CREATE OR REPLACE VIEW all_trips_2020 AS
SELECT * FROM divvy_trips_2020_q1
UNION ALL
SELECT * FROM divvy_trips_2020_q2
UNION ALL
SELECT * FROM divvy_trips_2020_q3
UNION ALL
SELECT * FROM divvy_trips_2020_q4_nodupes;

-- STEP 8: Seasonal ride counts and average duration
SELECT
  'Q1' AS quarter,
  COUNT(*) AS total_rides,
  AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) / 60 AS avg_duration_min
FROM divvy_trips_2020_q1
UNION ALL
SELECT 'Q2', COUNT(*), AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) / 60
FROM divvy_trips_2020_q2
UNION ALL
SELECT 'Q3', COUNT(*), AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) / 60
FROM divvy_trips_2020_q3
UNION ALL
SELECT 'Q4', COUNT(*), AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) / 60
FROM divvy_trips_2020_q4_nodupes;

-- STEP 9: Member vs casual ride counts
SELECT COUNT(*) FROM divvy_trips_2020_q4;
SELECT COUNT(ride_id) FROM divvy_trips_2020_q4 WHERE member_casual = "member";

SELECT COUNT(*) AS casual_rides
FROM (
    SELECT member_casual FROM divvy_trips_2020_q1
    UNION ALL
    SELECT member_casual FROM divvy_trips_2020_q2
    UNION ALL
    SELECT member_casual FROM divvy_trips_2020_q3
    UNION ALL
    SELECT member_casual FROM divvy_trips_2020_q4
) AS all_trips
WHERE member_casual = 'casual';

-- STEP 10: Seasonal membership percentages
SELECT ROUND(
    (SELECT COUNT(*) FROM divvy_trips_2020_q2 WHERE member_casual = 'casual')
    * 100.0 / (SELECT COUNT(*) FROM divvy_trips_2020_q2), 2
) AS spring_casual_percentage;

SELECT ROUND(
    (SELECT COUNT(*) FROM divvy_trips_2020_q3 WHERE member_casual = 'member')
    * 100.0 / (SELECT COUNT(*) FROM divvy_trips_2020_q3), 2
) AS summer_member_percentage;

SELECT ROUND(
    (SELECT COUNT(*) FROM divvy_trips_2020_q4 WHERE member_casual = 'member')
    * 100.0 / (SELECT COUNT(*) FROM divvy_trips_2020_q4), 2
) AS fall_member_percentage;

-- STEP 11: Create seasonal summary table with ride counts and percentages
CREATE TABLE seasonal_summary (
    season VARCHAR(10),
    total_rides INT,
    member_rides INT,
    casual_rides INT,
    member_pct DECIMAL(5,2),
    casual_pct DECIMAL(5,2)
);

INSERT INTO seasonal_summary VALUES
('Winter', 426886, 378407, 48479, 88.64, 11.36),
('Spring', 627167, 362307, 264860, 57.77, 42.23),
('Summer', 1691104, 908998, 782106, 53.75, 46.25),
('Fall', 742904, 494814, 248090, 66.61, 33.39);

SELECT * FROM seasonal_summary;

-- STEP 12: Average ride duration by user type per season
SELECT member_casual, ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS winter_avg_duration
FROM divvy_trips_2020_q1
GROUP BY member_casual;

SELECT member_casual, ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS spring_avg_duration
FROM divvy_trips_2020_q2
GROUP BY member_casual;

SELECT member_casual, ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS summer_avg_duration
FROM divvy_trips_2020_q3
GROUP BY member_casual;

SELECT member_casual, ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS fall_avg_duration
FROM divvy_trips_2020_q4
GROUP BY member_casual;

-- STEP 13: Investigate and exclude bad rows (negative durations)
SELECT COUNT(*) AS bad_rows
FROM divvy_trips_2020_q4
WHERE TIMESTAMPDIFF(MINUTE, started_at, ended_at) < 0;

SELECT member_casual,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS fall_avg_duration
FROM divvy_trips_2020_q4
WHERE TIMESTAMPDIFF(MINUTE, started_at, ended_at) > 0
GROUP BY member