# European Football Leagues Data Cleaning & Dashboard (SQL + Tableau Portfolio Project)

## Overview
This project demonstrates systematic schema validation, normalization, and dashboard preparation of European football league data (2023–2024 season) using MySQL and Tableau.  
It highlights both **data engineering** and **data visualization** skills, showing the full workflow from raw schema → validated tables → reproducible exports → interactive dashboard.

👉 [View the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/EuropeanFootballLeaguesDashboard20232024/Dashboard1?publish=yes)

---

## Data Cleaning & Validation Steps

### 1. Schema Integrity Checks
- Verified coaches, players, teams, referees, stadiums, and matches all linked to valid IDs.
- Ensured league/team relationships were consistent across tables.

### 2. League Rules Normalization
- Created a `league_rules` table to define Champions League, Europa League, Conference League, relegation, and playoff spots.
- Updated `leagues` table from rules to enforce consistency across Bundesliga, Premier League, La Liga, Serie A, and Ligue 1.

### 3. Player Data Cleanup
- Converted `date_of_birth` from text to proper `DATE` type.
- Sanity‑checked ages and flagged invalid or missing DOBs.

### 4. Standings Validation
- Recalculated points (`3 per win, 1 per draw`) to correct discrepancies.
- Verified played games = won + draw + lost.
- Checked goal difference = goals_for − goals_against.

### 5. Match & Score Consistency
- Ensured home/away teams exist in `teams`.
- Confirmed full‑time goals ≥ half‑time goals.
- Linked scores to valid matches.

### 6. Stadiums & Capacity
- Validated stadium capacity values were numeric and > 0.

---

## Dashboard Panels
The validated dataset was exported into CSVs via reproducible SQL queries (`football_data_for_dashboard.sql`) and visualized in Tableau.  
The dashboard contains five panels:

1. **Average Player Age** – Ligue 1 youngest; La Liga/Bundesliga older  
2. **Goals per Match** – Bundesliga tops scoring (~3.2); others ~2.6–2.9  
3. **European Competition Progression** – Premier League & La Liga lead UEFA spots  
4. **Goal Difference vs Points** – top clubs show strong correlation between GD and points  
5. **Points Distribution** – Premier League widest spread; Serie A/Ligue 1 tighter  

---

## Outcome
- A clean, analysis‑ready football schema with validated relationships, normalized rules, and corrected standings.
- A reproducible SQL script (`data_validation.sql`) that enforces schema integrity and rules.
- A reproducible SQL script (`football_data_for_dashboard.sql`) that generates all CSVs used in the Tableau dashboard.
- A complete portfolio project demonstrating both **data engineering** and **data visualization storytelling**.

---

## How to Reproduce
1. Clone this repo.
2. Run `data_validation.sql` in MySQL 8.0 to validate and clean the schema.
3. Run `football_data_for_dashboard.sql` to export CSVs for Tableau.
4. Open Tableau → connect to CSVs → load the dashboard.
5. Or explore the hosted version here:  
   👉 [European Football Leagues Dashboard (2023–2024)](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/EuropeanFootballLeaguesDashboard20232024/Dashboard1?publish=yes)

---

## Tools
- **MySQL 8.0** for schema validation and query exports
- **Tableau** for dashboard visualization
- **GitHub** for portfolio documentation and reproducibility
