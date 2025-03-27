Select *
From housingdata;

-- Standardize Date Format

ALTER TABLE housingdata 
MODIFY SaleDate DATE;

-- Breaking Out PropertyAddress into Individual Columns (Adress, City)

Select PropertyAddress
From housingdata;

SELECT 
    SUBSTR(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS Property_Address,
    LTRIM(SUBSTR(PropertyAddress, LOCATE(',', PropertyAddress) + 1)) AS Property_City
FROM housingdata;

ALTER TABLE housingdata 
ADD StreetAddress CHAR(255);

UPDATE housingdata
SET StreetAddress = SUBSTR(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

ALTER TABLE housingdata 
ADD CityAddress CHAR(255);

UPDATE housingdata
SET CityAddress = LTRIM(SUBSTR(PropertyAddress, LOCATE(',', PropertyAddress) + 1));

--  Out Address into Individual Columns (Adress, City, State)

Select OwnerAddress
From housingdata;

SELECT 
    SUBSTR(OwnerAddress, 1, LOCATE(',', OwnerAddress) - 1) AS Owner_Address,
    SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress) + 2, 
              LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) - LOCATE(',', OwnerAddress) - 2) AS City,
    LTRIM(SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) + 1)) AS State
FROM housingdata;

ALTER TABLE housingdata 
ADD Owner_Address CHAR(255);

UPDATE housingdata
SET Owner_Address = SUBSTR(OwnerAddress, 1, LOCATE(',', OwnerAddress) - 1);

ALTER TABLE housingdata 
ADD Owner_City CHAR(255);

UPDATE housingdata
SET Owner_City = SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress) + 2, 
              LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) - LOCATE(',', OwnerAddress) - 2);
              
ALTER TABLE housingdata 
ADD Owner_State CHAR(255);

UPDATE housingdata
SET Owner_State = LTRIM(SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) + 1));              

Select *
From housingdata;

-- Replace Y & N with Yes and No in SoldAsVacant

Select distinct(SoldAsVacant)
From housingdata;

SELECT 
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant IN('Y' , 'Yes') THEN 'Yes'
        WHEN SoldAsVacant IN('N' , 'No' ) THEN 'No'
        ELSE 'SoldAsVacant'
    END
FROM housingdata;

UPDATE housingdata
SET SoldAsVacant =
    CASE 
        WHEN SoldAsVacant IN('Y' , 'Yes') THEN 'Yes'
        WHEN SoldAsVacant IN('N' , 'No' ) THEN 'No'
        ELSE 'SoldAsVacant'
    END;
    
-- Remove duplicates

DELETE FROM housingdata
WHERE UniqueID IN (
    SELECT UniqueID
    FROM (SELECT UniqueID, ROW_NUMBER() 
    OVER (
			PARTITION BY PARCELID, PropertyAddress, SalePrice, SaleDate, LegalReference
                   ORDER BY UniqueID
										) AS row_num
        FROM housingdata
    ) AS RowNum
    WHERE row_num > 1
);

-- USE CTE to check whether all duplicates have been removed
WITH RowNumCTE as (
SELECT *,
ROW_Number() OVER(
PARTITION BY PARCELID,
			 PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
             ORDER BY UniqueID
             ) AS row_num
FROM housingdata
)
SELECT *
FROM RowNumCTE
Where row_num >1;

-- DELETE Unused Columns

SELECT *
FROM housingdata;

ALTER TABLE housingdata
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN OwnerAddress,
DROP COLUMN SaleDate;





