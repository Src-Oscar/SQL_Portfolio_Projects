select * from [sql data cleaning]..NashvilleHousing


-- Cleaning timestamp from SaleDate

select SaleDate, convert(date,Saledate) as salesdates
from [sql data cleaning]..NashvilleHousing

alter table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDate = SaleDateConverted

-- _______________________________________________________
-- Populating Property Address

select PropertyAddress
from [sql data cleaning]..NashvilleHousing

select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, isnull(x.PropertyAddress,y.PropertyAddress) 
from [sql data cleaning]..NashvilleHousing x
join [sql data cleaning]..NashvilleHousing y
on x.ParcelID = y.ParcelID
and x.uniqueID <> y.uniqueID
where x.PropertyAddress is null 

update x
set PropertyAddress = isnull(x.PropertyAddress,y.PropertyAddress) 
from [sql data cleaning]..NashvilleHousing x
join [sql data cleaning]..NashvilleHousing y
on x.ParcelID = y.ParcelID
and x.uniqueID <> y.uniqueID
where x.PropertyAddress is null

-- ______________________________________________________________
-- Breaking out Address into Individual columns (Using SUBSTRING)

select PropertyAddress
from [sql data cleaning]..NashvilleHousing

select PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,len(PropertyAddress)) as Region
from [sql data cleaning]..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,len(PropertyAddress))


-- ________________________________________________________________
-- Breaking out OwnerAddress into Individual columns (Using PARSENAME)

select OwnerAddress,
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


alter table NashvilleHousing
Add OwnerSplitCty Nvarchar(255);

update NashvilleHousing
set OwnerSplitCty = PARSENAME(replace(OwnerAddress,',','.'),2)


alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

-- _____________________________________________________
-- Change Y and N to Yes & NO in "Sold as Vacant" field


select distinct(SoldAsVacant),count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


-- _________________
-- Remove Duplicates

WITH RowNumCTE AS(
select *,
ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
uniqueID
) row_num
from [sql data cleaning]..NashvilleHousing
)
DELETE
from RowNumCTE
where row_num > 1
--order by PropertyAddress


-- _____________________
-- DELETE unused Columns

select * from [sql data cleaning]..NashvilleHousing

ALTER TABLE [sql data cleaning]..NashvilleHousing
DROP Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate;

