# Portfolio Projects

## Overview
This repository contains curated SQL portfolio projects demonstrating end-to-end data cleaning, normalization, and analysis workflows.  
Each project showcases best practices for preparing raw datasets into analysis-ready tables suitable for dashboards and visualization tools like Tableau.

---

## Projects

### 1. [Covid Cleaning & Analysis](./covid-cleaning-analysis)
- **Focus:** Cleaning, merging, and analyzing Covid-19 datasets.
- **Highlights:**
  - Standardized date formats
  - Merged deaths and vaccinations data
  - Created analysis-ready views
  - Prepared outputs for Tableau dashboards

---

### 2. [Nashville Housing Cleaning & Analysis](./nashville-housing-analysis)
- **Focus:** Normalization and cleaning of Nashville Housing dataset.
- **Highlights:**
  - Standardized date formats
  - Normalized blanks to NULL
  - Split and structured address fields
  - Deduplicated records
  - Dropped unused columns

---

### 3. [Cyclistic Bike-Share Case Study (Google Data Analytics Capstone)](./cyclistic-bike-share-case-study)
- **Focus:** Analyzing Cyclistic’s 2020 bike-share data to understand differences between casual riders and annual members.
- **Highlights:**
  - Cleaned and combined monthly trip data into quarterly and annual tables
  - Removed duplicates and validated ride IDs
  - Summarized seasonal ride counts and average ride durations
  - Enriched seasonal data with calculated metrics (ratios, duration differences, seasonal index)
  - Confirmed key insight: **casual riders consistently take longer trips than members**

#### 📊 Tableau Dashboard
The cleaned and enriched dataset was visualized in Tableau to highlight:
- Seasonal ride volume trends
- Member vs casual usage patterns
- Differences in ride duration across user types
- Strategic insights for converting casual riders into members

👉 [View Tableau dashboard here](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/CyclisticAnalysis_17609913408520/Dashboard2)

---

## Tools & Skills
- **SQL (MySQL 8.0):** Data cleaning, transformation, deduplication, normalization
- **ETL Best Practices:** Staging tables, reproducible workflows
- **Portfolio Presentation:** Clear documentation, recruiter-friendly structure
- **Visualization:** Tableau dashboards for business insights

---

## Purpose
These projects demonstrate technical rigor, reproducible workflows, and professional documentation.  
They are designed to highlight SQL proficiency and portfolio-ready practices for recruiters, collaborators, and hiring managers.
