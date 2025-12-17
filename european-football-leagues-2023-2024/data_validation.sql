-- Football Schema Validation Checklist

-- coaches - Ensures every coach is linked to a valid team
SELECT coach_id
FROM coaches
WHERE team_id NOT IN (SELECT team_id FROM teams);

-- leagues - Check that cl_spot + uel_spot + relegation_spot doesn't exceed total temas in the league
SELECT league_id, cl_spot, uel_spot, relegation_spot
FROM leagues
WHERE (cl_spot + uel_spot + relegation_spot) > 
      (SELECT COUNT(*) FROM teams WHERE league_id = leagues.league_id);

-- Create a rules table
CREATE TABLE league_rules (
  league_id INT PRIMARY KEY,
  cl_spot INT NOT NULL,
  uel_spot INT NOT NULL,
  uecl_spot INT NOT NULL,
  relegation_spot INT NOT NULL,
  playoff_spot INT NOT NULL
);

-- Insert correct rules
INSERT INTO league_rules (league_id, cl_spot, uel_spot, uecl_spot, relegation_spot, playoff_spot) VALUES
-- Bundesliga (18 teams)
(1, 4, 1, 1, 2, 1),
-- Premier League (20 teams)
(2, 4, 2, 1, 3, 0),
-- La Liga (20 teams)
(3, 4, 2, 1, 3, 0),
-- Serie A (20 teams)
(4, 4, 2, 1, 3, 0),
-- Ligue 1 (currently 18 teams)
(5, 4, 2, 1, 2, 0);

-- Update leagues from rules
UPDATE leagues l
JOIN league_rules r ON r.league_id = l.league_id
SET l.cl_spot = r.cl_spot,
    l.uel_spot = r.uel_spot,
    l.relegation_spot = r.relegation_spot;

-- Drop or null the bad column
-- Option A: Keep but null out until rules are confirmed everywhere
UPDATE leagues SET relegation_spot = NULL;

-- Option B: Drop and rely on league_rules for queries
ALTER TABLE leagues DROP COLUMN relegation_spot;

-- Validation after fix
SELECT l.league_id, l.name,
       COUNT(t.team_id) AS team_count,
       r.cl_spot + r.uel_spot + r.uecl_spot + r.relegation_spot + r.playoff_spot AS total_spots
FROM leagues l
JOIN league_rules r ON r.league_id = l.league_id
LEFT JOIN teams t ON t.league_id = l.league_id
GROUP BY l.league_id, l.name,
         r.cl_spot, r.uel_spot, r.uecl_spot, r.relegation_spot, r.playoff_spot
HAVING total_spots > COUNT(t.team_id)
LIMIT 0, 1000;

-- matches - Verify home/away teams exist
SELECT match_id
FROM matches
WHERE home_team_id NOT IN (SELECT team_id FROM teams)
   OR away_team_id NOT IN (SELECT team_id FROM teams);
   
-- Check season/league linkage
SELECT match_id
FROM matches
WHERE season_id NOT IN (SELECT season_id FROM seasons)
   OR league_id NOT IN (SELECT league_id FROM leagues);

-- players - Ensure players are tied to valid teams
SELECT player_id
FROM players
WHERE team_id NOT IN (SELECT team_id FROM teams);

-- Sanity check DOBs
SELECT player_id, date_of_birth
FROM players
WHERE STR_TO_DATE(date_of_birth, '%Y-%m-%d') IS NULL;

-- Convert DOB column from tex to date
ALTER TABLE players
ADD COLUMN dob DATE;

UPDATE players
SET dob = STR_TO_DATE(date_of_birth, '%m/%d/%Y')
WHERE date_of_birth IS NOT NULL;

SELECT player_id, date_of_birth
FROM players
WHERE dob IS NULL;

ALTER TABLE players DROP COLUMN date_of_birth;
ALTER TABLE players CHANGE dob date_of_birth DATE;

SELECT name, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM players
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 21;

-- Sanity check DOBs again
SELECT player_id, date_of_birth
FROM players
WHERE STR_TO_DATE(date_of_birth, '%Y-%m-%d') IS NULL;

-- referees - Check nationality is not missing
SELECT referee_id
FROM referees
WHERE nationality IS NULL OR nationality = '';

-- scores - Ensure scores link to valid matches
SELECT score_id
FROM scores
WHERE match_id NOT IN (SELECT match_id FROM matches);

-- Check full-time goals >= half-time goals
SELECT score_id
FROM scores
WHERE full_time_home < half_time_home
   OR full_time_away < half_time_away;
   
-- stadiums - Capacity must be numeric and > 0
SELECT stadium_id, capacity
FROM stadiums
WHERE capacity <= 0 OR capacity NOT REGEXP '^[0-9]+$';

-- standings - Points consistency (3 per win, 1 per draw)
SELECT standing_id
FROM standings
WHERE points <> (won*3 + draw);

-- Discrepancy (checking)
SELECT standing_id, won, draw, points, (won*3 + draw) AS calc_points
FROM standings
WHERE standing_id IN (15, 17, 92);

-- Updating points
UPDATE standings
SET points = (won*3 + draw)
WHERE standing_id IN (15, 17, 92);

-- Played games consistency
SELECT standing_id
FROM standings
WHERE played_games <> (won + draw + lost);

-- Goal difference check
SELECT standing_id
FROM standings
WHERE goal_difference <> (goals_for - goals_against);

-- teams - League linkage
SELECT team_id
FROM teams
WHERE league_id NOT IN (SELECT league_id FROM leagues);

-- Stadium linkage
SELECT team_id
FROM teams
WHERE stadium_id NOT IN (SELECT stadium_id FROM stadiums);

-- Coach linkage
SELECT team_id
FROM teams
WHERE coach_id NOT IN (SELECT coach_id FROM coaches);