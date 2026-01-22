# **Nashville Housing Data Cleaning & Dashboard (SQL + Tableau Portfolio Project)**

## **Overview**  
This project demonstrates systematic data cleaning, normalization, and dashboard preparation of the Nashville Housing dataset using MySQL and Tableau.  
It highlights both **data engineering** and **data visualization** skills, showing the full workflow from raw data → clean staging table → reproducible exports → interactive dashboard.

👉 **[View the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/NashvilleHousingMarketDashboard2013-2019/Dashboard1?publish=yes)**

---

## **Data Cleaning Steps**

### **1. Standardize Date Format**
- Converted `SaleDate` from text into proper `DATE` type using `STR_TO_DATE`.  
- Ensured consistent date storage for analysis.

### **2. Normalize Blanks to NULL**
- Updated all text columns to replace empty strings with `NULL`.  
- Improved consistency for filtering and aggregation.

### **3. Populate Missing Property Addresses**
- Used self‑joins on `ParcelID` to fill missing `PropertyAddress` values from duplicate records.

### **4. Split Address Fields**
- Applied `SUBSTRING_INDEX` to break `PropertyAddress` into `StreetAddress` and `City`.  
- Applied `REGEXP_SUBSTR` to split `OwnerAddress` into `Address`, `City`, and `State`.  
- Added new columns (`PropertySplitAddress`, `PropertySplitCity`, `OwnerSplitAddress`, `OwnerSplitCity`, `OwnerSplitState`).

### **5. Normalize Categorical Values**
- Standardized `SoldAsVacant` field from `Y/N` to `Yes/No`.

### **6. Remove Duplicates**
- Identified duplicates using `ROW_NUMBER()` partitioned by key fields (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`).  
- Deleted duplicate rows, keeping only the first occurrence.

### **7. Drop Unused Columns**
- Removed redundant fields (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) after splitting and normalization.

---

## **Dashboard Panels**  
The cleaned dataset was exported into CSVs via reproducible SQL queries (`dashboard_data_exports.sql`) and visualized in Tableau.  
The dashboard contains six panels:

1. **Property Type Distribution** – property counts and average sale price by `LandUse`  
2. **Geographic Breakdown** – treemap of sales volume and average price by `PropertySplitCity`  
3. **Vacancy Analysis** – sales volume and average price by `SoldAsVacant`  
4. **Price vs Features** – average sale price by number of bedrooms  
5. **Year Built Analysis** – average sale price by construction year  
6. **Sales Trends** – monthly average sale price and transaction volume  

---

## **Overall Conclusion**  
Across the Nashville housing market (2013–2019), the data shows clear structural patterns in how property characteristics, geography, and time influence sale prices. Single‑family homes dominate both volume and value, while certain cities consistently command higher average prices. Vacancy status has limited impact on pricing compared to core features such as bedroom count and construction year, where newer and larger homes trend higher. Market activity shows seasonal fluctuations, with recurring peaks in both sales volume and average price. Together, these panels highlight a market shaped by property type, location, and home features, with predictable seasonal trends driving transaction behavior.

---

## **Outcome**
- A clean, analysis‑ready `NashvilleHousing_Staging` table with standardized dates, normalized categorical fields, deduplicated records, and properly structured address data.  
- A reproducible SQL script (`dashboard_data_exports.sql`) that generates all CSVs used in the Tableau dashboard.  
- A complete portfolio project demonstrating both **data engineering** and **data visualization storytelling**.

---

## **How to Reproduce**
1. Clone this repo.  
2. Run `dashboard_data_exports.sql` in MySQL 8.0.  
3. Export CSVs from the queries.  
4. Open Tableau → connect to CSVs → load the dashboard.  
5. Or explore the hosted version here:  
   👉 **[Nashville Housing Market Dashboard (2013–2019)](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/NashvilleHousingMarketDashboard2013-2019/Dashboard1?publish=yes)**

