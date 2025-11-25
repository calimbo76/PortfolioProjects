SELECT * FROM coviddeaths
order by 3,4;

-- select * from covidvaccinations
-- order by 3,4

-- Select Data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1, 2;

-- Quick check to ensure all values are valid
SELECT date
FROM coviddeaths
WHERE STR_TO_DATE(date, '%m/%d/%Y') IS NULL;

-- Need to convert text to proper date format
ALTER TABLE coviddeaths
MODIFY COLUMN date DATE; -- MySQL is rejecting value

-- Fix with Two-Step Conversion
-- Add a new column
ALTER TABLE coviddeaths
ADD COLUMN date_clean DATE;

-- Populate with converted values
UPDATE coviddeaths
SET date_clean = STR_TO_DATE(date, '%m/%d/%Y');

-- Drop old date column
ALTER TABLE coviddeaths DROP COLUMN date;

-- Re-add new date column in the correct position
ALTER TABLE coviddeaths ADD COLUMN date DATE AFTER location;

-- Copy values from date_clean into new date
UPDATE coviddeaths SET date = date_clean;

-- Drop temp column
ALTER TABLE coviddeaths DROP COLUMN date_clean;

-- Need to convert most columns to FLOAT
ALTER TABLE coviddeaths
MODIFY COLUMN total_cases FLOAT,
MODIFY COLUMN new_cases FLOAT,
MODIFY COLUMN new_deaths_smoothed FLOAT,
MODIFY COLUMN total_cases_per_million FLOAT,
MODIFY COLUMN new_cases_per_million FLOAT,
MODIFY COLUMN new_cases_smoothed_per_million FLOAT,
MODIFY COLUMN total_deaths_per_million FLOAT,
MODIFY COLUMN new_deaths_per_million FLOAT,
MODIFY COLUMN new_deaths_smoothed_per_million FLOAT,
MODIFY COLUMN reproduction_rate FLOAT,
MODIFY COLUMN icu_patients FLOAT,
MODIFY COLUMN icu_patients_per_million FLOAT,
MODIFY COLUMN hosp_patients FLOAT,
MODIFY COLUMN hosp_patients_per_million FLOAT,
MODIFY COLUMN weekly_icu_admissions FLOAT,
MODIFY COLUMN weekly_icu_admissions_per_million FLOAT,
MODIFY COLUMN weekly_hosp_admissions FLOAT,
MODIFY COLUMN weekly_hosp_admissions_per_million FLOAT;  -- Issues

UPDATE coviddeaths
SET new_cases_smoothed = NULL
WHERE new_cases_smoothed REGEXP '[^0-9.]';

UPDATE coviddeaths
SET 
  new_cases_smoothed = NULLIF(TRIM(new_cases_smoothed), '');

ALTER TABLE coviddeaths
MODIFY COLUMN new_cases_smoothed FLOAT;

SELECT DISTINCT new_deaths
FROM coviddeaths
WHERE new_deaths REGEXP '[^0-9.]';

UPDATE coviddeaths
SET new_deaths = NULL
WHERE TRIM(new_deaths) = ''
   OR new_deaths IS NULL
   OR new_deaths NOT REGEXP '^[-]?[0-9]+(\.[0-9]+)?$';
   
UPDATE coviddeaths
SET total_deaths = NULL
WHERE TRIM(total_deaths) = ''
   OR total_deaths IS NULL
   OR total_deaths REGEXP '[^0-9.]'
   OR total_deaths = ' ';

ALTER TABLE coviddeaths
MODIFY COLUMN new_deaths FLOAT;

ALTER TABLE coviddeaths
MODIFY COLUMN total_deaths FLOAT;

UPDATE coviddeaths
SET 
  new_cases_smoothed_per_million = NULLIF(TRIM(new_cases_smoothed_per_million), ''),
  total_deaths_per_million = NULLIF(TRIM(total_deaths_per_million), ''),
  new_deaths_per_million = NULLIF(TRIM(new_deaths_per_million), ''),
  new_deaths_smoothed_per_million = NULLIF(TRIM(new_deaths_smoothed_per_million), ''),
  reproduction_rate = NULLIF(TRIM(reproduction_rate), ''),
  icu_patients = NULLIF(TRIM(icu_patients), ''),
  icu_patients_per_million = NULLIF(TRIM(icu_patients_per_million), ''),
  hosp_patients = NULLIF(TRIM(hosp_patients), ''),
  hosp_patients_per_million = NULLIF(TRIM(hosp_patients_per_million), ''),
  weekly_icu_admissions = NULLIF(TRIM(weekly_icu_admissions), ''),
  weekly_icu_admissions_per_million = NULLIF(TRIM(weekly_icu_admissions_per_million), ''),
  weekly_hosp_admissions = NULLIF(TRIM(weekly_hosp_admissions), ''),
  weekly_hosp_admissions_per_million = NULLIF(TRIM(weekly_hosp_admissions_per_million), ''),
  new_deaths_smoothed = NULLIF(TRIM(new_deaths_smoothed), '');
  
  ALTER TABLE coviddeaths
MODIFY COLUMN new_cases_smoothed_per_million FLOAT,
MODIFY COLUMN total_deaths_per_million FLOAT,
MODIFY COLUMN new_deaths_per_million FLOAT,
MODIFY COLUMN new_deaths_smoothed_per_million FLOAT,
MODIFY COLUMN reproduction_rate FLOAT,
MODIFY COLUMN icu_patients FLOAT,
MODIFY COLUMN icu_patients_per_million FLOAT,
MODIFY COLUMN hosp_patients FLOAT,
MODIFY COLUMN hosp_patients_per_million FLOAT,
MODIFY COLUMN weekly_icu_admissions FLOAT,
MODIFY COLUMN weekly_icu_admissions_per_million FLOAT,
MODIFY COLUMN weekly_hosp_admissions FLOAT,
MODIFY COLUMN weekly_hosp_admissions_per_million FLOAT,
MODIFY COLUMN new_deaths_smoothed FLOAT;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%states%'
ORDER BY 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE location like '%states%'
ORDER BY 1, 2;

-- Looking at Countries with highest infection rate compared to population
SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 AS HighestInfectionRate
FROM coviddeaths
-- WHERE location like '%states%'
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT
SELECT location,
		MAX(NULLIF(total_deaths, '')) AS TotalDeathCount
FROM coviddeaths
WHERE continent = ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Global death count
SELECT SUM(latest_deaths) AS global_total
FROM (
  SELECT location, MAX(total_deaths) AS latest_deaths
  FROM coviddeaths
  GROUP BY location
) AS sub;

-- Showing Countries with Highest Death Count per Population
SELECT location, 
		MAX(NULLIF(total_deaths, '')) AS TotalDeathCount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent IS NOT NULL AND continent <> ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Checking for missing rows
SELECT iso_code FROM coviddeaths
WHERE iso_code = "OWID_AFR";

SHOW COLUMNS FROM coviddeaths;

-- Created separate table and imported missing rows
SHOW COLUMNS FROM CDmissingrows;
SHOW COLUMNS FROM coviddeaths;

-- Cleaning up table
ALTER TABLE CDmissingrows
DROP COLUMN MyUnknownColumn,
DROP COLUMN `MyUnknownColumn_[0]`,
DROP COLUMN `MyUnknownColumn_[1]`,
DROP COLUMN `MyUnknownColumn_[2]`;

ALTER TABLE CDmissingrows
CHANGE COLUMN `ï»¿iso_code` iso_code TEXT;

UPDATE CDmissingrows
SET date = DATE_FORMAT(STR_TO_DATE(date, '%m/%d/%Y'), '%Y-%m-%d')
WHERE STR_TO_DATE(date, '%m/%d/%Y') IS NOT NULL;

-- Fixing column name
ALTER TABLE coviddeaths CHANGE COLUMN `ï»¿iso_code` iso_code VARCHAR(10);

-- Trying to merge into coviddeaths
INSERT INTO coviddeaths (
  iso_code, continent, location, date, population, total_cases, new_cases, new_cases_smoothed,
  total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million,
  new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million,
  new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million,
  hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
  weekly_hosp_admissions, weekly_hosp_admissions_per_million
)
SELECT
  iso_code,
  continent,
  location,
  date,  -- already in 'YYYY-MM-DD' format
  population,
  total_cases,
  new_cases,
  CAST(new_cases_smoothed AS FLOAT),
  CAST(total_deaths AS FLOAT),
  CAST(new_deaths AS FLOAT),
  CAST(new_deaths_smoothed AS FLOAT),
  total_cases_per_million,
  new_cases_per_million,
  CAST(new_cases_smoothed_per_million AS FLOAT),
  CAST(total_deaths_per_million AS FLOAT),
  CAST(new_deaths_per_million AS FLOAT),
  CAST(new_deaths_smoothed_per_million AS FLOAT),
  CAST(reproduction_rate AS FLOAT),
  CAST(icu_patients AS FLOAT),
  CAST(icu_patients_per_million AS FLOAT),
  CAST(hosp_patients AS FLOAT),
  CAST(hosp_patients_per_million AS FLOAT),
  CAST(weekly_icu_admissions AS FLOAT),
  CAST(weekly_icu_admissions_per_million AS FLOAT),
  CAST(weekly_hosp_admissions AS FLOAT),
  CAST(weekly_hosp_admissions_per_million AS FLOAT)
FROM CDmissingrows AS m
WHERE NOT EXISTS (
  SELECT 1
  FROM coviddeaths AS c
  WHERE c.iso_code = m.iso_code
    AND c.location = m.location
    AND c.date = m.date  -- no need to parse again
); -- issues with this..

-- Working the problem
SHOW COLUMNS FROM coviddeaths;

UPDATE CDmissingrows
SET icu_patients = NULL
WHERE icu_patients REGEXP '[^0-9.-]' AND icu_patients IS NOT NULL;

ALTER TABLE CDmissingrows
MODIFY COLUMN date DATE;

-- Fixing the types for a clean merge
ALTER TABLE CDmissingrows
MODIFY COLUMN icu_patients_per_million FLOAT,
MODIFY COLUMN hosp_patients FLOAT,
MODIFY COLUMN hosp_patients_per_million FLOAT,
MODIFY COLUMN weekly_icu_admissions FLOAT,
MODIFY COLUMN weekly_icu_admissions_per_million FLOAT,
MODIFY COLUMN weekly_hosp_admissions FLOAT,
MODIFY COLUMN weekly_hosp_admissions_per_million FLOAT,
MODIFY COLUMN reproduction_rate FLOAT,
MODIFY COLUMN icu_patients FLOAT;

-- Inserting data into coviddeaths
INSERT INTO coviddeaths (
  iso_code, continent, location, date, population, total_cases, new_cases, new_cases_smoothed,
  total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million,
  new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million,
  new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million,
  hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
  weekly_hosp_admissions, weekly_hosp_admissions_per_million
)
SELECT *
FROM CDmissingrows AS m
WHERE NOT EXISTS (
  SELECT 1
  FROM coviddeaths AS c
  WHERE c.iso_code = m.iso_code
    AND c.location = m.location
    AND c.date = m.date
);

-- Success

SELECT count(*) FROM coviddeaths;

DROP TABLE CDmissingrows;

DELETE FROM coviddeaths
WHERE date IS NULL;

-- Showing continents with the highest death count per population
SELECT continent,
       MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
  AND TRIM(continent) != ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global numbers
SELECT SUM(new_cases) as total_cases, 
	   SUM(new_deaths) as total_deaths, 
	   (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL;

-- Check covidvaccinations table
SELECT *
 FROM covidvaccinations;
 
 -- Fixing column name
ALTER TABLE covidvaccinations CHANGE COLUMN `ï»¿iso_code` iso_code VARCHAR(10);

-- Join tables
SELECT *
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date;
    
-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL
  AND CAST(vac.new_vaccinations AS UNSIGNED) > 0
ORDER BY 2,3;

-- USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL
  AND CAST(vac.new_vaccinations AS UNSIGNED) > 0
)
SELECT * , (RollingPeopleVaccinated/population)*100 
FROM PopvsVac
ORDER BY location, date;

-- TEMP TABLE

DROP TABLE IF exists PercentPopulationVaccinated;

CREATE TABLE PercentPopulationVaccinated (
Continent VARCHAR(225),
Location VARCHAR(225),
Date DATETIME,
Population DECIMAL(20,2),
New_vaccinations DECIMAL(20,2),
RollingPeopleVaccinated DECIMAL(20,2)
);
INSERT INTO PercentPopulationVaccinated
SELECT 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (
	Partition by dea.location 
    order by dea.location, dea.date
) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL
  AND vac.new_vaccinations <> ''
  AND CAST(vac.new_vaccinations AS UNSIGNED) > 0;

SELECT * , 
	(RollingPeopleVaccinated/population)*100 AS VaccinationRate
FROM PercentPopulationVaccinated
ORDER BY location, date;

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (
	Partition by dea.location 
    order by dea.location, dea.date
) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL
  AND vac.new_vaccinations <> ''
  AND CAST(vac.new_vaccinations AS UNSIGNED) > 0;
  
CREATE VIEW DeathPercentage AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%states%'
ORDER BY 1, 2;
  
CREATE VIEW PercentPopulationInfected AS
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE location like '%states%'
ORDER BY 1, 2;

CREATE VIEW HighestInfectionRate AS
SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 AS HighestInfectionRate
FROM coviddeaths
-- WHERE location like '%states%'
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;

CREATE VIEW TotalDeathCountByContinent AS
SELECT location,
		MAX(NULLIF(total_deaths, '')) AS TotalDeathCount
FROM coviddeaths
WHERE continent = ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

CREATE VIEW GlobalDeathCount AS
SELECT SUM(latest_deaths) AS global_total
FROM (
  SELECT location, MAX(total_deaths) AS latest_deaths
  FROM coviddeaths
  GROUP BY location
) AS sub;

CREATE VIEW HighestDeathCountPerPopulation AS
SELECT location, 
		MAX(NULLIF(total_deaths, '')) AS TotalDeathCount
FROM coviddeaths
-- WHERE location like '%states%'
WHERE continent IS NOT NULL AND continent <> ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Settled on these for visualization
-- Tableau Table 1 
SELECT 
  SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
  AND location NOT IN ('World', 'European Union', 'International', 'Asia', 'Europe', 'Africa', 'Oceania', 'North America', 'South America');

-- Tableau Table 2
SELECT location, SUM(new_deaths) as TotalDeathCount
FROM coviddeaths
WHERE location IN ('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Tableau Table 3
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Tableau Table 4
SELECT location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;

