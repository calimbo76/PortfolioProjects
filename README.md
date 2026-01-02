# Portfolio Projects

## Overview
This repository contains curated SQL‑driven portfolio projects demonstrating end‑to‑end data cleaning, normalization, transformation, and dashboard development.  
Each project showcases best practices for preparing raw datasets into analysis‑ready tables and building recruiter‑ready visualizations in Tableau.

---

# Projects

---

## 1. [Stock Market Performance & Technical Analysis (2015–2024)](./Stock-Market-Performance-Technical-Analysis)
- **Focus:** Multi‑year financial data cleaning, return calculations, volatility analysis, and technical indicators.  
- **Highlights:**
  - Combined 10 years of OHLCV data using Power Query  
  - Cleaned and normalized datasets in MySQL (date fixes, schema cleanup)  
  - Calculated daily returns, cumulative returns, volatility, intraday spread, and moving averages  
  - Built a multi‑panel Tableau dashboard covering performance, risk, liquidity, and trend signals  

#### 📊 Tableau Dashboard
The dashboard visualizes:
- Cumulative returns across five tickers  
- Volatility vs return (risk profile)  
- Intraday spread (7‑day MA)  
- Moving average crossovers for AAPL, AMZN, MSFT, TSLA, and SPX  

👉 **[View the interactive dashboard](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/StockMarketPerformanceTechnicalAnalysis2015-2024/StockMarketPerformanceTechnicalAnalysis2015-2024?publish=yes)**

---

## 2. [Covid Cleaning & Analysis](./covid-cleaning-analysis)
- **Focus:** Cleaning, merging, and analyzing global COVID‑19 datasets.  
- **Highlights:**
  - Standardized date formats  
  - Merged deaths and vaccinations data  
  - Created analysis‑ready SQL views  
  - Prepared outputs for Tableau dashboards  

#### 📊 Tableau Dashboard
Visualizes:
- Global infection and death trends  
- Death counts by continent  
- Infection rates by country  
- Vaccination progress vs population  

👉 **[View Tableau dashboard](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/CovidDashboard_17637380851660/Dashboard1)**

---

## 3. [Nashville Housing Cleaning & Analysis](./nashville-housing-analysis)
- **Focus:** Normalization and cleaning of the Nashville Housing dataset.  
- **Highlights:**
  - Standardized date formats  
  - Normalized blanks to NULL  
  - Split and structured address fields  
  - Deduplicated records  
  - Dropped unused columns  

#### 📊 Tableau Dashboard
Visualizes:
- Housing price distribution  
- Trends across property types  
- Impact of address normalization  
- Effects of deduplication on dataset integrity  

👉 **[View Tableau dashboard](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/NashvilleHousingMarketDashboard2013-2019/Dashboard1?publish=yes)**

---

## 4. [Cyclistic Bike‑Share Case Study (Google Data Analytics Capstone)](./cyclistic-bike-share-case-study)
- **Focus:** Understanding behavioral differences between casual riders and annual members.  
- **Highlights:**
  - Cleaned and combined monthly trip data  
  - Removed duplicates and validated ride IDs  
  - Summarized seasonal ride counts and durations  
  - Enriched data with ratios, duration differences, and seasonal indexes  
  - Confirmed key insight: **casual riders consistently take longer trips than members**  

#### 📊 Tableau Dashboard
Visualizes:
- Seasonal ride volume  
- Member vs casual usage patterns  
- Ride duration differences  
- Strategic insights for rider conversion  

👉 **[View Tableau dashboard](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/CyclisticAnalysis_17609913408520/Dashboard2)**

---

## 5. [European Football Leagues Cleaning & Analysis (2023–2024)](./european-football-leagues-2023-2024)
- **Focus:** Schema validation, normalization, and comparative analysis of Europe’s top 5 leagues (2023–2024).  
- **Highlights:**
  - Created `league_rules` table to enforce UEFA qualification and relegation logic  
  - Converted player DOBs to proper `DATE` type and validated ages  
  - Corrected standings (points, goal difference, played games consistency)  
  - Ensured valid relationships across matches, teams, coaches, referees, and stadiums  
  - Exported clean, analysis‑ready tables for Tableau  

#### 📊 Tableau Dashboard
Visualizes:
- Average player age by league  
- Goals per match (Bundesliga highest scoring)  
- UEFA competition qualification  
- Goal difference vs points  
- Points distribution across leagues  

👉 **[View Tableau dashboard](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/EuropeanFootballLeaguesDashboard20232024/Dashboard1?publish=yes)**

---

# Tools & Skills
- **SQL (MySQL 8.0):** Data cleaning, transformation, normalization, validation  
- **ETL Best Practices:** Staging tables, reproducible workflows, schema integrity  
- **Excel:** Financial calculations, validation, moving averages, volatility  
- **Power Query:** Multi‑file consolidation and preprocessing  
- **Tableau:** Dashboard design, storytelling, multi‑panel visual analysis  
- **GitHub:** Documentation, version control, portfolio presentation  

---

# Purpose
These projects demonstrate technical rigor, reproducible workflows, and professional documentation.  
They are designed to highlight SQL proficiency, analytical thinking, and recruiter‑ready dashboard development for hiring managers, collaborators, and data teams.
