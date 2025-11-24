# PortfolioProjects
# COVID-19 Data Cleaning & Analysis (MySQL)

## Overview
This project demonstrates end-to-end data cleaning, normalization, and analysis of COVID-19 datasets using MySQL.  
It covers:
- Cleaning raw data (dates, numeric fields, invalid entries)
- Merging missing rows into the main dataset
- Analytical queries (infection rates, death percentages, global totals)
- Vaccination analysis (rolling totals, population coverage, temp tables)
- Creating views and Tableau-ready queries for visualization

## Steps

### 1. Cleaning Phase
- Converted text dates into proper `DATE` format using `STR_TO_DATE`.
- Normalized numeric fields (`total_cases`, `new_deaths`, hospitalizations, etc.) into `FLOAT`.
- Removed invalid entries with `REGEXP` and `NULLIF`.
- Dropped unused or malformed columns (e.g., `MyUnknownColumn`, `ï»¿iso_code`).

### 2. Merge Phase
- Imported missing rows from a staging table (`CDmissingrows`).
- Enforced proper data types before merging.
- Prevented duplicates with `NOT EXISTS`.
- Dropped staging table after successful merge.
- Deleted rows with `NULL` dates to ensure integrity.

### 3. Analysis Phase
- Calculated death percentages by country (`total_deaths / total_cases`).
- Measured infection rates relative to population.
- Aggregated global and continental death counts.
- Ranked countries by infection and death rates.

### 4. Vaccination Phase
- Joined `coviddeaths` and `covidvaccinations` on `location` + `date`.
- Calculated rolling vaccination totals using window functions (`SUM() OVER`).
- Built a CTE (`PopvsVac`) to measure vaccination progress vs population.
- Created a temp table (`PercentPopulationVaccinated`) for reusable queries.

### 5. Visualization Prep
- Created reusable views:
  - `PercentPopulationVaccinated`
  - `DeathPercentage`
  - `PercentPopulationInfected`
  - `HighestInfectionRate`
  - `GlobalDeathCount`
- Built Tableau-ready queries for:
  - Global totals
  - Death counts by continent
  - Infection rates by country
  - Infection rates by country over time

## Outcome
A clean, analysis-ready dataset (`coviddeaths` + `covidvaccinations`) with reusable views and queries, suitable for dashboards and further exploration in Tableau.

## Tools
- **MySQL 8.0**
- SQL functions: `ALTER TABLE`, `UPDATE`, `REGEXP`, `GROUP BY`, `ROW_NUMBER()`, `NOT EXISTS`, `SUM() OVER`, CTEs, temp tables, views
- **Tableau** for visualization
