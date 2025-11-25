# Nashville Housing Data Cleaning (MySQL)

## Overview
This project demonstrates systematic data cleaning and normalization of the Nashville Housing dataset using MySQL.  
It covers:
- Standardizing date formats
- Normalizing blanks to NULL
- Populating missing property addresses
- Splitting address fields into separate columns
- Normalizing categorical values
- Removing duplicates
- Dropping unused columns

## Steps

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

## Outcome
A clean, analysis-ready `NashvilleHousing_Staging` table with standardized dates, normalized categorical fields, deduplicated records, and properly structured address data.  
This dataset is now suitable for dashboards, portfolio analysis, and further exploration.

## Tools
- **MySQL 8.0**
- SQL functions: `STR_TO_DATE`, `SUBSTRING_INDEX`, `REGEXP_SUBSTR`, `ROW_NUMBER()`, `CASE`, `ALTER TABLE`, `UPDATE`, `DELETE`
