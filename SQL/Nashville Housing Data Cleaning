-- Cleaning Data in SQL Querries

-- Standard Date Format

SELECT
	Saledate,
	Convert(Date,SaleDate)
FROM
	PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE	NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

SELECT
	SaleDateConverted,
	Convert(Date,SaleDate)
FROM
	PortfolioProject..NashvilleHousing

-- Populate Property Address data

SELECT
	*
FROM
	PortfolioProject..NashvilleHousing
--WHERE
	--PropertyAddress is null
ORDER BY
	ParcelID


SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortfolioProject..NashvilleHousing a
JOIN
	PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortfolioProject..NashvilleHousing a
JOIN
	PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


-- Breaking out Address into Invididual Columns (Address, City, State)

SELECT
	*
FROM
	PortfolioProject..NashvilleHousing

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM
	PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT 
	*
FROM
	PortfolioProject..NashvilleHousing



SELECT 
	OwnerAddress
FROM
	PortfolioProject..NashvilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
	PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT 
	*
FROM
	PortfolioProject..NashvilleHousing



-- Change Y and N to Yes and No in 'Sold as Vacant' field
SELECT
	Distinct(SoldAsVacant),
	Count(SoldAsVacant)
FROM
	PortfolioProject..NashvilleHousing
GROUP BY
	SoldAsVacant


SELECT
	SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
	END
FROM
	PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
	END


-- Remove Duplicates
WITH RowNumCTE as (
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY ParcelID,
									PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
									ORDER BY  
										UniqueID) row_num
FROM
	PortfolioProject..NashvilleHousing
)

SELECT
	*
FROM
	RowNumCTE
WHERE
	row_num >1


-- Delete Unused Cols

SELECT
	*
FROM
	PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
