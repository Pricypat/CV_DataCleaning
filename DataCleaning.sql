--Cleaning Data in Sql Queries
Select * from [National Housing]

---Standardise Date Format

Alter table [National Housing]
add Saledateconverted date

update [National Housing]
set Saledateconverted=CONVERT(date,saledate)

Select SaleDateconverted from [National Housing]

---Populate,Propertyaddress Data
Select * from [National Housing]
where PropertyAddress is null
order by ParcelID


---where property address is null


Select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.propertyAddress,b.PropertyAddress) from [National Housing]a
Join  [National Housing]b
on a.parcelId=b.parcelID
and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.propertyAddress,b.PropertyAddress)
from [National Housing]a
join [National Housing]b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

--Breaking out address into individual columns(Address,city,state)

 Select  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, len(propertyAddress)) as Address
 from [National Housing]

 Alter table [National Housing]
add PropertysplitAddress nvarchar(255)

update [National Housing]
set PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table [National Housing]
add Propertysplitcity nvarchar(255)

update [National Housing]
set Propertysplitcity = substring(propertyAddress,CHARINDEX(',',PropertyAddress) +1, len(propertyAddress))

select * from [National Housing]

Select OwnerAddress from [National Housing]


select  distinct PARSEname(replace(Owneraddress, ',','.'), 3) as Address
,PARSEname(replace(Owneraddress, ',','.'), 2) as City
,PARSEname(replace(Owneraddress,',','.'), 1) as State from
[National Housing]

 Alter table [National Housing]
add OwnersplitAddress nvarchar(255)

update [National Housing]
set OwnersplitAddress = PARSEname(replace(Owneraddress, ',','.'), 3)

Alter table [National Housing]
add Ownersplitcity nvarchar(255)

update [National Housing]
set Ownersplitcity = PARSEname(replace(Owneraddress, ',','.'), 2)

Alter table [National Housing]
add OwnersplitState nvarchar(255)

update [National Housing]
set OwnersplitState = PARSEname(replace(Owneraddress, ',','.'), 1)

Select distinct * from [National Housing]

----Change Y and N to Yes and No in SoldAsVacant
Select distinct(SoldAsVacant),COUNT(SoldAsVacant) from [National Housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,Case when SoldASVacant ='Y'Then 'Yes'
      When SoldAsVacant ='N' Then 'No'
      Else SoldAsVacant
End
From [National Housing]

Update [National Housing]
Set SoldAsVacant= Case when SoldAsVacant = 'Y' then 'Yes'
                       When SoldAsVacant = 'N' then 'No'
					   Else SoldAsVacant
					   End

Select distinct(SoldAsVacant),count(SoldAsVacant) 
From [National Housing]
Group by SoldAsVacant
Order by 2

Select * from [National Housing]
----Remove Duplicates
use [Portfolio Projects]


With rownumCTE as (
Select *, ROW_NUMBER() over(
Partition by parcelId,PropertyAddress,SaleDate,SalePrice,LegalReference
order by uniqueId
) row_num
from [Portfolio Projects]..[National Housing]
)

Select * from rownumCTE 
where row_num > 1
Order by PropertyAddress

-----Delete unused Columns
 
Alter table [National Housing]

Drop Column Propertyaddress, OwnerAddress, Taxdistrict

Alter table [National Housing]

Drop Column saleDate

Select * from [National Housing]
