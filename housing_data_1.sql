USE PortfolioProject
/*
--Data Cleaning Housing Data for Nashville
*/

SELECT *
FROM PortfolioProject.dbo.HousingData

-- Format date
ALTER TABLE HousingData
ADD NewSaleDate DATE

UPDATE HousingData
SET NewSaleDate = CONVERT(DATE, SaleDate)


--Updating Property Address Data w/ Null Values
SELECT x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject.dbo.HousingData x
JOIN PortfolioProject.dbo.HousingData y
	ON x.ParcelID = y.ParcelID
	AND x.[UniqueID] <> y.[UniqueID]
WHERE x.PropertyAddress IS NULL

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM PortfolioProject.dbo.HousingData x
JOIN PortfolioProject.dbo.HousingData y
	ON x.ParcelID = y.ParcelID
	AND x.[UniqueID] <> y.[UniqueID]
WHERE x.PropertyAddress IS NULL

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.HousingData

-- Adding the split columns into the table
ALTER TABLE HousingData
ADD PropertyAddress_Split NVARCHAR(255);

UPDATE HousingData
SET PropertyAddress_Split = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE HousingData
ADD Property_City NVARCHAR(255);

UPDATE HousingData
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- Splitting the owner address
SELECT OwnerAddress
FROM PortfolioProject.dbo.HousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.HousingData

ALTER TABLE HousingData
ADD OwnerAddressSplit NVARCHAR(255);

UPDATE HousingData
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE HousingData
ADD Owner_City NVARCHAR(255);

UPDATE HousingData
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE HousingData
ADD Owner_State NVARCHAR(255);

UPDATE HousingData
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

ALTER TABLE HousingData
DROP COLUMN OwnerAddress_Split;
GO

SELECT *
FROM PortfolioProject.dbo.HousingData

--Updating sold as vacant to have uniform response
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.HousingData

UPDATE HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END







