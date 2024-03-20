/*
Combine information from Person.Address, Person.StateProvince, and Person.CountryRegion
Use two INNER JOINs to piece related data together so that you can read the city, state, and country names for each address.
*/
SELECT * from Person.Address; -- whole table
	SELECT Address.AddressID, Address.AddressLine1, Address.AddressLine2 from Person.Address; --city

SELECT * FROM Person.StateProvince;
	SELECT StateProvince.StateProvinceID, StateProvince.Name FROM Person.StateProvince; --state

SELECT 
	Address.AddressID
	, Address.AddressLine1
	, Address.AddressLine2
	, StateProvince.StateProvinceID AS StateID
	, StateProvince.Name AS 'State'
	, StateProvince.CountryRegionCode AS CountryCode 
FROM Person.Address INNER JOIN Person.StateProvince 
	ON Address.AddressID = StateProvince.StateProvinceID
	INNER JOIN Person.CountryRegion ON StateProvince.CountryRegionCode = CountryRegion.CountryRegionCode
Order by AddressID


SELECT * FROM Person.CountryRegion;
	SELECT CountryRegion.CountryRegionCode, CountryRegion.Name FROM Person.CountryRegion;

