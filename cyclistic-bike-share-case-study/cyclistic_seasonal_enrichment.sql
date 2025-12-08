-- STEP 1: Extend seasonal_summary schema to include average ride duration columns
ALTER TABLE seasonal_summary
ADD COLUMN member_avg_duration DECIMAL(5,2),
ADD COLUMN casual_avg_duration DECIMAL(5,2);

-- STEP 2: Populate average ride duration values for each season
UPDATE seasonal_summary
SET member_avg_duration = 12.19, casual_avg_duration = 95.33
WHERE season = 'Winter';

UPDATE seasonal_summary
SET member_avg_duration = 18.83, casual_avg_duration = 52.38
WHERE season = 'Spring';

UPDATE seasonal_summary
SET member_avg_duration = 15.85, casual_avg_duration = 48.69
WHERE season = 'Summer';

UPDATE seasonal_summary
SET member_avg_duration = 31.07, casual_avg_duration = 12.77
WHERE season = 'Fall';

-- STEP 3: Add casual-to-member ride ratio column
ALTER TABLE seasonal_summary ADD COLUMN casual_to_member_ratio FLOAT;

-- STEP 4: Calculate and update casual-to-member ratio for each season
UPDATE seasonal_summary
SET casual_to_member_ratio = casual_rides * 1.0 / member_rides;

-- STEP 5: Add column for difference in average ride duration (casual minus member)
ALTER TABLE seasonal_summary ADD COLUMN avg_duration_diff FLOAT;

-- STEP 6: Calculate and update duration difference for each season
UPDATE seasonal_summary
SET avg_duration_diff = casual_avg_duration - member_avg_duration;

-- STEP 7: Calculate annual average ride volume for comparison
SELECT ROUND(AVG(total_rides), 2) AS annual_avg FROM seasonal_summary;

-- STEP 8: Add seasonal index column (ride volume relative to annual average)
ALTER TABLE seasonal_summary ADD COLUMN seasonal_index FLOAT;

-- STEP 9: Update seasonal index values for each season
UPDATE seasonal_summary
SET seasonal_index = total_rides / 872015.25;