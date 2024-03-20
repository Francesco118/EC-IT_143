SELECT City, StateProvinceID, Count(*) AS CountofAddresses
FROM Person.Address
group by City, StateProvinceID
order by CountofAddresses DESC;