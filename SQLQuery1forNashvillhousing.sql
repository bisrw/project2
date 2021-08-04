/*

Cleaning data in sql queries

*/

SELECT * 
FROM 
[dbo].[Nashville Housing data]

--------------
---- Standardized the date format

SELECT 
SaleDate, CONVERT(date,SaleDate)
FROM 
[dbo].[Nashville Housing data]

UPDATE [dbo].[Nashville Housing data]
SET
SaleDate = CONVERT(date,SaleDate)

ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
SaleDateConverted date;


UPDATE [dbo].[Nashville Housing data]
SET
SaleDateConverted = CONVERT(date,SaleDate)



SELECT 
SaleDateConverted---, CONVERT(date,SaleDate)
FROM 
[dbo].[Nashville Housing data]


-------------------------------------------------------------------------------------------------------------------------

---Populate property address data

SELECT 
propertyaddress
FROM
[dbo].[Nashville Housing data]

SELECT *
FROM
[dbo].[Nashville Housing data]
WHERE propertyaddress is null

SELECT * 
FROM
[dbo].[Nashville Housing data]
ORDER BY
ParcelID

SELECT 
a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNull(a.PropertyAddress,b.PropertyAddress) as Newaddress
FROM
[dbo].[Nashville Housing data] a
JOIN
[dbo].[Nashville Housing data] B
ON
a.ParcelID = b.ParcelID



SELECT 
a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNull(a.PropertyAddress,b.PropertyAddress) as Newaddress
FROM
[dbo].[Nashville Housing data] a
JOIN
[dbo].[Nashville Housing data] B
ON
a.ParcelID = b.ParcelID
AND
a.[UniqueID ]<>b.[UniqueID ]
WHERE
a.PropertyAddress is null

update a
SET Propertyaddress = ISNull(a.PropertyAddress,b.PropertyAddress)  
FROM
[dbo].[Nashville Housing data] a
JOIN
[dbo].[Nashville Housing data] B
ON
a.ParcelID = b.ParcelID
AND
a.[UniqueID ]<>b.[UniqueID ]
WHERE
a.PropertyAddress is null

Select * 
FROM [dbo].[Nashville Housing data]
WHERE
propertyaddress is null

----------------------------------------------------------------------------------------------------------------------------
---- Breaking out address into individual columns (Address, City, State)

Select PropertyAddress 
FROM [dbo].[Nashville Housing data]
---WHERE propertyaddress is null
---ORDER BY
parcelID

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City

FROM
[dbo].[Nashville Housing data]


ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
propertysplitaddress nvarchar(255);


UPDATE [dbo].[Nashville Housing data]
SET
propertysplitaddress = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
propertysplitcity nvarchar(255);


UPDATE [dbo].[Nashville Housing data]
SET
propertysplitcity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT*
FROM
[dbo].[Nashville Housing data]
WHERE
Ownersplitaddress is not null and
Ownersplitcity is not null and
Ownersplitstate is not null

SELECT
PARSENAME (REPLACE(OwnerAddress,',','.'),3),
PARSENAME (REPLACE(OwnerAddress,',','.'),2),
PARSENAME (REPLACE(OwnerAddress,',','.'),1)
FROM
[dbo].[Nashville Housing data]
WHERE
OwnerAddress is not null

ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
Ownersplitaddress nvarchar(255);


UPDATE [dbo].[Nashville Housing data]
SET
Ownersplitaddress = PARSENAME (REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
Ownersplitcity nvarchar(255);


UPDATE [dbo].[Nashville Housing data]
SET
Ownersplitcity = PARSENAME (REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE 
[dbo].[Nashville Housing data]
ADD
Ownersplitstate nvarchar(255);

UPDATE
[dbo].[Nashville Housing data]
SET
Ownersplitstate = 
PARSENAME (REPLACE(OwnerAddress,',','.'),1)

---Change Y and N yes to yes and no in "sold as vacant" column

SELECT
DISTINCT(soldasvacant)
FROM [dbo].[Nashville Housing data]

SELECT
DISTINCT(soldasvacant),COUNT(soldasvacant)
FROM
[dbo].[Nashville Housing data]
GROUP BY (soldasvacant)
ORDER BY 2

SELECT soldasvacant,
CASE WHEN soldasvacant = 'Y' then 'Yes'
     WHEN soldasvacant = 'N'then 'No'
	 ELSE soldasvacant
	 END
FROM
[dbo].[Nashville Housing data]

UPDATE
[dbo].[Nashville Housing data]
SET SoldAsVacant =
CASE WHEN soldasvacant = 'Y' then 'Yes'
     WHEN soldasvacant = 'N'then 'No'
	 ELSE soldasvacant
	 END
     
----REMOVE DUPLICATE

SELECT *
FROM
[dbo].[Nashville Housing data]

----use CTE

WITH RowNumCTE AS (
Select *,
 ROW_NUMBER() OVER (PARTITION BY 
								ParcelID,
								PropertyAddress,
								SaleDate,
								SalePrice,
								LegalReference
								ORDER BY 
								UniqueID) row_num
FROM
[dbo].[Nashville Housing data]
)	
SELECT *
FROM RownumCTE
where row_num>1
order by propertyaddress

 
WITH RowNumCTE AS (
Select *,
 ROW_NUMBER() OVER (PARTITION BY 
								ParcelID,
								PropertyAddress,
								SaleDate,
								SalePrice,
								LegalReference
								ORDER BY 
								UniqueID) row_num
FROM
[dbo].[Nashville Housing data]
)	
DELETE
FROM RownumCTE
where row_num>1
----order by propertyaddress

---DELETE UNUSED DATA

SELECT * 
FROM
[dbo].[Nashville Housing data]


ALTER TABLE 
[dbo].[Nashville Housing data]
DROP COLUMN
PropertyAddress,TaxDistrict,OwnerAddress

ALTER TABLE 
[dbo].[Nashville Housing data]
DROP COLUMN
SaleDate






