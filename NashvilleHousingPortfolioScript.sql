SELECT *
FROM nashvillehousing_staging;

-- Standardize Date Format
SELECT 
    SaleDate,
    STR_TO_DATE(SaleDate, '%e-%b-%y')
FROM NashvilleHousing_Staging
LIMIT 20;

UPDATE NashvilleHousing_Staging
SET SaleDate = STR_TO_DATE(SaleDate, '%e-%b-%y');

ALTER TABLE NashvilleHousing_Staging
MODIFY COLUMN SaleDate DATE;

SELECT *
FROM nashvillehousing_staging;

-- Populate Property Address Data
SELECT PropertyAddress
FROM nashvillehousing_staging
WHERE PropertyAddress IS NULL 
OR PropertyAddress = '';

UPDATE nashvillehousing_staging
SET PropertyAddress = NULL
WHERE TRIM(PropertyAddress) = ''; 

-- Normalize blanks to NULL across all text columns

UPDATE NashvilleHousing_Staging SET ParcelID = NULL WHERE TRIM(ParcelID) = '';
UPDATE NashvilleHousing_Staging SET LandUse = NULL WHERE TRIM(LandUse) = '';
UPDATE NashvilleHousing_Staging SET PropertyAddress = NULL WHERE TRIM(PropertyAddress) = '';
UPDATE NashvilleHousing_Staging SET SaleDate = NULL WHERE TRIM(SaleDate) = '';
UPDATE NashvilleHousing_Staging SET SalePrice = NULL WHERE TRIM(SalePrice) = '';
UPDATE NashvilleHousing_Staging SET LegalReference = NULL WHERE TRIM(LegalReference) = '';
UPDATE NashvilleHousing_Staging SET SoldAsVacant = NULL WHERE TRIM(SoldAsVacant) = '';
UPDATE NashvilleHousing_Staging SET OwnerName = NULL WHERE TRIM(OwnerName) = '';
UPDATE NashvilleHousing_Staging SET OwnerAddress = NULL WHERE TRIM(OwnerAddress) = '';
UPDATE NashvilleHousing_Staging SET Acreage = NULL WHERE TRIM(Acreage) = '';
UPDATE NashvilleHousing_Staging SET TaxDistrict = NULL WHERE TRIM(TaxDistrict) = '';
UPDATE NashvilleHousing_Staging SET LandValue = NULL WHERE TRIM(LandValue) = '';
UPDATE NashvilleHousing_Staging SET BuildingValue = NULL WHERE TRIM(BuildingValue) = '';
UPDATE NashvilleHousing_Staging SET TotalValue = NULL WHERE TRIM(TotalValue) = '';
UPDATE NashvilleHousing_Staging SET YearBuilt = NULL WHERE TRIM(YearBuilt) = '';
UPDATE NashvilleHousing_Staging SET Bedrooms = NULL WHERE TRIM(Bedrooms) = '';
UPDATE NashvilleHousing_Staging SET FullBath = NULL WHERE TRIM(FullBath) = '';
UPDATE NashvilleHousing_Staging SET HalfBath = NULL WHERE TRIM(HalfBath) = '';

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing_staging a
JOIN nashvillehousing_staging b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE nashvillehousing_staging a
JOIN nashvillehousing_staging b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

SELECT ParcelID, PropertyAddress
FROM NashvilleHousing_Staging
WHERE PropertyAddress IS NULL
LIMIT 20;

-- Breaking out Address into Individual Columns (Address, City, State) using SUBSTRING_INDEX

SELECT *
FROM NashvilleHousing_Staging;

SELECT 
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS StreetAddress,
    SUBSTRING_INDEX(PropertyAddress, ',', -1) AS City
FROM NashvilleHousing_Staging
LIMIT 20;

ALTER TABLE NashvilleHousing_Staging
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));
    
-- Breaking out Address into Individual Columns (Address, City, State) using REGEXP_SUBSTR

SELECT REGEXP_SUBSTR(OwnerAddress, '[^,]+') AS Address,
	   REGEXP_SUBSTR(OwnerAddress, '[^,]+',1,2) AS City,
       REGEXP_SUBSTR(OwnerAddress, '[^,]+',1,3) AS State
FROM nashvillehousing_staging;

ALTER TABLE NashvilleHousing_Staging
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET OwnerSplitAddress = REGEXP_SUBSTR(OwnerAddress, '[^,]+'),
    OwnerSplitCity = REGEXP_SUBSTR(OwnerAddress, '[^,]+',1,2),
    OwnerSplitState = REGEXP_SUBSTR(OwnerAddress, '[^,]+',1,3);

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing_Staging
GROUP BY SoldAsVacant
ORDER BY 2 DESC;

UPDATE nashvillehousing_staging
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

-- Remove Duplicates

SELECT ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference, COUNT(*) AS cnt
FROM NashvilleHousing_Staging
GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
HAVING cnt > 1;

WITH Ranked AS (
    SELECT UniqueID,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS rn
    FROM NashvilleHousing_Staging
)
DELETE FROM NashvilleHousing_Staging
WHERE UniqueID IN (
    SELECT UniqueID FROM Ranked WHERE rn > 1
);

-- Delete Unused Columns

ALTER TABLE NashvilleHousing_Staging
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;

ALTER TABLE NashvilleHousing_Staging
DROP COLUMN SaleDate;

