# Nashville Housing Data Cleaning & Dashboard (MySQL + Tableau)

## Overview
This project demonstrates systematic data cleaning, normalization, and dashboard preparation of the Nashville Housing dataset using MySQL.  
It covers:
- Cleaning and structuring raw housing data
- Standardizing date formats and categorical values
- Splitting and normalizing address fields
- Removing duplicates and unused columns
- Exporting analysis-ready CSVs for Tableau dashboards

## Data Cleaning Steps

### 1. Standardize Date Format
- Converted `SaleDate` from text into proper `DATE` type using `STR_TO_DATE`.
- Ensured consistent date storage for analysis.

### 2. Normalize Blanks to NULL
- Updated all text columns to replace empty strings with `NULL`.
- Improved consistency for filtering and aggregation.

### 3. Populate Missing Property Addresses
- Used self-joins on `ParcelID` to fill missing `PropertyAddress` values from duplicate records.

### 4. Split Address Fields
- Applied `SUBSTRING_INDEX` to break `PropertyAddress` into `StreetAddress` and `City`.
- Applied `REGEXP_SUBSTR` to split `OwnerAddress` into `Address`, `City`, and `State`.
- Added new columns (`PropertySplitAddress`, `PropertySplitCity`, `OwnerSplitAddress`, `OwnerSplitCity`, `OwnerSplitState`).

### 5. Normalize Categorical Values
- Standardized `SoldAsVacant` field from `Y/N` to `Yes/No`.

### 6. Remove Duplicates
- Identified duplicates using `ROW_NUMBER()` partitioned by key fields (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`).
- Deleted duplicate rows, keeping only the first occurrence.

### 7. Drop Unused Columns
- Removed redundant fields (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) after splitting and normalization.

## Dashboard Data Exports
To feed the Tableau dashboard, reproducible SQL queries were written and saved in  
[`dashboard_data_exports.sql`](dashboard_data_exports.sql).  

These queries generate CSVs for the following panels:
1. **Property Type Distribution** – property counts and average sale price by `LandUse`
2. **Geographic Breakdown** – sales volume and average price by `PropertySplitCity`
3. **Vacancy Analysis** – sales volume and average price by `SoldAsVacant`
4. **Price vs Features** – average sale price by number of bedrooms
5. **Year Built Analysis** – average sale price by construction year
6. **Sales Trends** – monthly average sale price and transaction volume (from raw table)

Each query is designed to be exported as a CSV and consumed directly in Tableau.

## Outcome
- A clean, analysis-ready `NashvilleHousing_Staging` table with standardized dates, normalized categorical fields, deduplicated records, and properly structured address data.
- A reproducible SQL script (`dashboard_data_exports.sql`) that generates all CSVs used in the Tableau dashboard.
- A complete portfolio project demonstrating both **data engineering** and **data visualization** skills.

## Tools
- **MySQL 8.0** for cleaning and query exports
- **Tableau** for dashboard visualization
- **GitHub** for portfolio documentation and reproducibility
