-- Goals per Match by League - Measures attacking quality
SELECT l.name AS league,
       ROUND(SUM(s.full_time_home + s.full_time_away) * 1.0 / COUNT(m.match_id), 2) AS avg_goals_per_match
FROM matches m
JOIN scores s ON m.match_id = s.match_id
JOIN leagues l ON m.league_id = l.league_id
JOIN seasons se ON m.season_id = se.season_id
WHERE se.year = '2023-2024'
GROUP BY l.name
ORDER BY avg_goals_per_match DESC;

-- Competitiveness: Title Race Gap - Difference in points between 1st and 2nd place
SELECT league, MAX(points) - MIN(points) AS title_gap
FROM (
    SELECT l.name AS league, s.points,
           ROW_NUMBER() OVER (PARTITION BY l.name ORDER BY s.points DESC) AS pos
    FROM standings s
    JOIN leagues l ON s.league_id = l.league_id
    JOIN seasons se ON s.season_id = se.season_id
    WHERE se.year = '2023-2024'
) ranked
WHERE pos <= 2
GROUP BY league;

-- European Spots Allocation - Shows UEFA recognition of each league's quality
SELECT l.name AS league,
       lr.cl_spot, lr.uel_spot, lr.uecl_spot, lr.relegation_spot, lr.playoff_spot
FROM league_rules lr
JOIN leagues l ON lr.league_id = l.league_id;

-- Player Development: Average Age by League - Highlights youth vs veteran reliance
SELECT l.name AS league,
       ROUND(AVG(TIMESTAMPDIFF(YEAR, p.date_of_birth, CURDATE())), 1) AS avg_player_age
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
GROUP BY l.name
ORDER BY avg_player_age;

-- High goal difference - Teams that dominate both ends of the pitch
SELECT t.name AS team_name,
	   l.name AS league,
       s.points,
       s.goal_difference
FROM teams t 
JOIN standings s ON t.team_id = s.team_id
JOIN leagues l ON s.league_id = l.league_id
ORDER BY s.goal_difference DESC
LIMIT 10;

-- European Competition Progression
SELECT l.name AS league,
       t.name AS team_name,
       s.position,
       CASE
           WHEN s.position <= lr.cl_spot THEN 'Champions League'
           WHEN s.position <= lr.cl_spot + lr.uel_spot THEN 'Europa League'
           WHEN s.position <= lr.cl_spot + lr.uel_spot + lr.uecl_spot THEN 'Conference League'
           ELSE 'Domestic Only'
       END AS european_competition
FROM standings s
JOIN teams t ON s.team_id = t.team_id
JOIN leagues l ON s.league_id = l.league_id
JOIN league_rules lr ON s.league_id = lr.league_id
JOIN seasons se ON s.season_id = se.season_id
WHERE se.year = '2023-2024'
ORDER BY l.name, s.position;

-- Points Distribution by League
SELECT l.name AS league,
       ROUND(AVG(s.points), 2) AS avg_points,
       MIN(s.points) AS min_points,
       MAX(s.points) AS max_points,
       (MAX(s.points) - MIN(s.points)) AS points_range,
       ROUND(STDDEV_SAMP(s.points), 2) AS points_stddev
FROM standings s
JOIN leagues l ON s.league_id = l.league_id
JOIN seasons se ON s.season_id = se.season_id
WHERE se.year = '2023-2024'
GROUP BY l.name
ORDER BY points_range DESC;

