# **Stock Market Performance & Technical Analysis (SQL + Excel + Tableau Portfolio Project)**

## **Overview**  
This project analyzes ten years of historical stock data (2015–2024) for five major tickers — **AAPL, AMZN, MSFT, TSLA, and SPX** — using SQL, Excel, Power Query, and Tableau.  
It demonstrates a complete workflow from **raw multi‑year CSVs → consolidated datasets → SQL cleaning → Excel calculations → Tableau dashboard**.

👉 **[View the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/StockMarketPerformanceTechnicalAnalysis2015-2024/StockMarketPerformanceTechnicalAnalysis2015-2024?publish=yes)**

---

## **Data Cleaning & Preparation Steps**

### **1. Raw Data Download (MarketWatch)**  
- Downloaded OHLCV data for each ticker **year by year** (2015–2024).  
- Ensured consistent column structure across all yearly files.

### **2. Power Query Consolidation**  
- Combined all yearly CSVs into a single master dataset per ticker:  
  - `aapl_2015_2024_master`  
  - `amzn_2015_2024_master`  
  - `msft_2015_2024_master`  
  - `tsla_2015_2024_master`  
  - `spx_2015_2024_master`  
- Removed BOM artifacts (e.g., `ï»¿Date`) and standardized column names.

### **3. SQL Cleaning & Date Normalization**  
After importing the consolidated tables into MySQL:

#### **a. Fix corrupted Date column names**
```sql
ALTER TABLE aapl_2015_2024_master RENAME COLUMN ï»¿Date TO Date;
ALTER TABLE amzn_2015_2024_master RENAME COLUMN ï»¿Date TO Date;
ALTER TABLE msft_2015_2024_master RENAME COLUMN ï»¿Date TO Date;
ALTER TABLE spx_2015_2024_master RENAME COLUMN ï»¿Date TO Date;
ALTER TABLE tsla_2015_2024_master RENAME COLUMN ï»¿Date TO Date;
```

#### **b. Convert Date from text → DATE type (example: TSLA)**
```sql
ALTER TABLE tsla_2015_2024_master ADD COLUMN trade_date DATE;

UPDATE tsla_2015_2024_master
SET trade_date = STR_TO_DATE(Date, '%m/%d/%Y');

ALTER TABLE tsla_2015_2024_master DROP COLUMN Date;

ALTER TABLE tsla_2015_2024_master CHANGE COLUMN trade_date Date DATE;
```

#### **c. Reorder Date column**
```sql
ALTER TABLE tsla_2015_2024_master
MODIFY COLUMN Date DATE FIRST;
```

### **4. Excel Calculations**  
Exported the cleaned SQL tables back into Excel and computed:

- **Daily returns**  
- **Cumulative returns**  
- **7‑day moving average**  
- **30‑day moving average**  
- **30‑day rolling volatility**  
- **Intraday spread (High − Low)**  
- Validated formulas and ensured no missing trading days.

### **5. Tableau Dashboard Preparation**  
Loaded the Excel outputs into Tableau and built:

- Multi‑ticker cumulative return panel  
- Volatility vs return scatter  
- Intraday spread (7‑day MA)  
- Five moving‑average crossover charts (AAPL, AMZN, MSFT, TSLA, SPX)  
- Consistent captions, color schemes, and layout for recruiter‑ready polish  

---

## **Dashboard Panels**

### **1. Cumulative Return (2015–2024)**  
- TSLA shows extreme volatility and peak returns  
- SPX provides a stable benchmark  

### **2. Volatility vs Return**  
- Clear risk/return tradeoff across all tickers  
- TSLA sits in the high‑risk, high‑reward quadrant  

### **3. Intraday Spread (7‑Day MA)**  
- TSLA exhibits the widest liquidity swings  
- AAPL and MSFT show stable, narrow spreads  

### **4–8. Moving Average Crossovers**  
Five separate charts (AAPL, AMZN, MSFT, TSLA, SPX) showing:

- Short‑term vs long‑term trend signals  
- MA7 crossing above/below MA30  
- Trend shifts during major market events  

Each chart includes a caption explaining the crossover logic.

---

## **Outcome**
- A fully cleaned, analysis‑ready dataset covering **10 years of market behavior**.  
- Reproducible SQL script for:  
  - `data_cleaning.sql` (date fixes, normalization)   
- Excel calculations for returns, volatility, spreads, and moving averages.  
- A polished Tableau dashboard demonstrating:  
  - performance analysis  
  - risk profiling  
  - liquidity behavior  
  - technical trend signals  
- A complete portfolio project showcasing **data engineering**, **financial analysis**, and **visual storytelling**.

---

## **How to Reproduce**
1. Clone this repo.  
2. Run `data_cleaning.sql` in MySQL 8.0 to normalize and clean the raw tables.  
3. Export cleaned tables to Excel.  
4. Apply Excel formulas for returns, volatility, spreads, and moving averages.  
5. Load the Excel outputs into Tableau.  
6. Or explore the hosted dashboard here:  
   👉 **[Stock Market Performance & Technical Analysis (2015–2024)](https://public.tableau.com/app/profile/carlos.aguilar8205/viz/StockMarketPerformanceTechnicalAnalysis2015-2024/StockMarketPerformanceTechnicalAnalysis2015-2024?publish=yes)**

---

## **Tools**
- **MySQL 8.0** for data cleaning and normalization  
- **Power Query** for multi‑year consolidation  
- **Excel** for financial calculations  
- **Tableau** for dashboard visualization  
- **GitHub** for documentation and reproducibility  

---

