-- Property Type Distribution
SELECT 
    LandUse,
    COUNT(*) AS TotalProperties,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice
FROM NashvilleHousing_Staging
WHERE LandUse IS NOT NULL
GROUP BY LandUse
ORDER BY TotalProperties DESC;

-- Geographic Breakdown
SELECT 
    PropertySplitCity,
    COUNT(*) AS TotalSales,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice
FROM NashvilleHousing_Staging
WHERE PropertySplitCity IS NOT NULL
GROUP BY PropertySplitCity
ORDER BY TotalSales DESC;

-- Vacancy Analysis
SELECT 
    SoldAsVacant,
    COUNT(*) AS TotalSales,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice
FROM NashvilleHousing_Staging
WHERE SoldAsVacant IS NOT NULL
GROUP BY SoldAsVacant;

-- Price vs Features
SELECT 
    Bedrooms,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice,
    COUNT(*) AS TotalSales
FROM NashvilleHousing_Staging
WHERE Bedrooms IS NOT NULL
GROUP BY Bedrooms
ORDER BY Bedrooms;

-- Year Built Analysis
SELECT 
    YearBuilt,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice,
    COUNT(*) AS TotalSales
FROM NashvilleHousing_Staging
WHERE YearBuilt IS NOT NULL
GROUP BY YearBuilt
ORDER BY YearBuilt;

-- Sales Trends (Raw Table)
SELECT 
    DATE_FORMAT(SaleDate, '%Y-%m') AS YearMonth,
    ROUND(AVG(SalePrice), 0) AS AvgSalePrice,
    COUNT(*) AS TotalSales
FROM NashvilleHousing_Raw
WHERE SaleDate IS NOT NULL
GROUP BY YearMonth
ORDER BY YearMonth;
