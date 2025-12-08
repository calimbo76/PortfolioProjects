
# Cyclistic Bike-Share Case Study (Google Data Analytics Capstone)

This project is part of the **Google Data Analytics Certificate** capstone. The goal is to analyze Cyclistic’s 2020 bike-share data to understand differences between **casual riders** and **annual members**, and provide insights that can guide marketing strategies.

## 📂 Project Structure

Cyclistic_SQL/
  ├── cyclistic_data_cleaning_and_summary.sql
  ├── cyclistic_seasonal_enrichment.sql
  ├── cyclistic_ride_length_analysis.sql
  └── README.md

## 🛠️ SQL Workflow

### 1. `cyclistic_data_cleaning_and_summary.sql`
- Combines monthly trip data into quarterly tables and a full‑year view (`all_trips_2020`).
- Identifies and removes duplicate ride IDs using `ROW_NUMBER()` and validation checks.
- Summarizes seasonal ride counts and average ride durations.
- Breaks down member vs casual ride counts and calculates seasonal membership percentages.
- Creates a `seasonal_summary` table with total rides, member vs casual counts, and percentages.

### 2. `cyclistic_seasonal_enrichment.sql`
- Extends the `seasonal_summary` schema with additional calculated metrics:
  - Average ride duration by user type per season.
  - Casual‑to‑member ratio.
  - Difference in average ride duration between casuals and members.
  - Seasonal index (ride volume relative to annual average).
- Provides enriched insights for visualization and business recommendations.

### 3. `cyclistic_ride_length_analysis.sql`
- Analyzes average ride length for July 2020 as a monthly snapshot.
- Combines selected months (Q1, April–July, December) for broader comparison.
- Confirms the key business insight: **casual riders consistently take longer trips than members**.

---

## 📊 Tableau Dashboard

The cleaned and enriched dataset was visualized in Tableau to highlight:
- Seasonal ride volume trends.
- Member vs casual usage patterns.
- Differences in ride duration across user types.
- Strategic insights for converting casual riders into members.

👉 [View Tableau dashboard here](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/CyclisticAnalysis_17609913408520/Dashboard2)

---

## 💡 Key Insights
- **Casual riders take longer trips** but ride less frequently than members.
- **Seasonal variation** is strong: summer has the highest ride volume, with casual riders making up a larger share.
- **Member loyalty** is evident in winter, where members dominate usage despite lower overall volume.
- These insights support marketing strategies focused on converting casual riders into annual members by emphasizing value for longer trips and seasonal promotions.

---

## 🎯 Skills Demonstrated
- SQL data cleaning, deduplication, and aggregation.
- Schema evolution and enrichment with calculated metrics.
- Business‑oriented analysis of user behavior.
- Data visualization in Tableau.
- End‑to‑end workflow documentation for recruiter‑friendly presentation.

---
