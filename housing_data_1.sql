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









