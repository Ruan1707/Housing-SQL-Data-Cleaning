# Housing-SQL-Data-Cleaning
Nashville Housing Data Cleaning Project
📌 Project Overview
This project focuses on data cleaning using SQL to prepare Nashville housing data for analysis. It includes:
✅ Standardizing date formats
✅ Splitting address columns
✅ Removing duplicates
✅ Cleaning categorical data
✅ Dropping unnecessary columns

🛠 Tools Used
SQL (MySQL / PostgreSQL / SQL Server) – Data cleaning

Excel / Tableau / Power BI (optional for visualization)

📂 Dataset
The dataset contains real estate transactions from Nashville, including:
✅ Property and owner details
✅ Sale prices and dates
✅ Tax information

🔍 Key SQL Queries & Insights
1️⃣ Standardizing Date Format
The SaleDate column was modified to ensure a consistent date format:

sql
Copy
Edit
ALTER TABLE housingdata 
MODIFY SaleDate DATE;
📌 Insight: Ensures date values are stored properly for analysis.

2️⃣ Splitting PropertyAddress into Street & City
Extracting StreetAddress and CityAddress:

sql
Copy
Edit
ALTER TABLE housingdata ADD StreetAddress CHAR(255);
UPDATE housingdata
SET StreetAddress = SUBSTR(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

ALTER TABLE housingdata ADD CityAddress CHAR(255);
UPDATE housingdata
SET CityAddress = LTRIM(SUBSTR(PropertyAddress, LOCATE(',', PropertyAddress) + 1));
📌 Insight: Helps analyze properties by city.

3️⃣ Splitting OwnerAddress into Address, City & State
sql
Copy
Edit
ALTER TABLE housingdata ADD Owner_Address CHAR(255);
UPDATE housingdata
SET Owner_Address = SUBSTR(OwnerAddress, 1, LOCATE(',', OwnerAddress) - 1);

ALTER TABLE housingdata ADD Owner_City CHAR(255);
UPDATE housingdata
SET Owner_City = SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress) + 2, 
              LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) - LOCATE(',', OwnerAddress) - 2);
              
ALTER TABLE housingdata ADD Owner_State CHAR(255);
UPDATE housingdata
SET Owner_State = LTRIM(SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress, LOCATE(',', OwnerAddress) + 1) + 1));
📌 Insight: Organizing the owner’s address improves searchability.

4️⃣ Cleaning SoldAsVacant Column
Replacing inconsistent values (Y/N) with Yes/No:

sql
Copy
Edit
UPDATE housingdata
SET SoldAsVacant =
    CASE 
        WHEN SoldAsVacant IN ('Y', 'Yes') THEN 'Yes'
        WHEN SoldAsVacant IN ('N', 'No') THEN 'No'
        ELSE SoldAsVacant
    END;
📌 Insight: Makes values consistent for analysis.

5️⃣ Removing Duplicates
Deleting duplicate records based on key property attributes:

sql
Copy
Edit
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
📌 Insight: Ensures each transaction is unique.

✅ Check if duplicates are completely removed:

sql
Copy
Edit
WITH RowNumCTE AS (
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
WHERE row_num > 1;
📌 Insight: Helps validate data cleaning.

6️⃣ Dropping Unnecessary Columns
Removing redundant columns:

sql
Copy
Edit
ALTER TABLE housingdata
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN OwnerAddress,
DROP COLUMN SaleDate;
📌 Insight: Keeps only the most relevant columns.

🚀 How to Use This Project
1️⃣ Run the SQL queries to clean the dataset.
2️⃣ Verify results using SELECT * FROM housingdata;
3️⃣ Use the cleaned data for analysis and visualization.

📊 Dashboard & Visuals
📌 Power BI / Tableau Dashboard (Link to visualization if available)
Key visualizations:
✅ Property sales by location
✅ Trends in real estate pricing
✅ Market activity analysis

📌 Conclusion
This project prepares Nashville housing data for analysis by cleaning and structuring it.

Duplicates and inconsistencies are removed to improve data integrity.

The cleaned dataset is ready for visualization and further analysis.

📜 Author & Acknowledgments
👤 Inspired by Alex the Analyst
