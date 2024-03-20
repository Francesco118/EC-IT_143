select BROKERTITLE, [TYPE], PRICE, BEDS, BATH, PROPERTYSQFT, LOCALITY, SUBLOCALITY, AVG(price) as Average_Price
from [EC_IT143_DA].dbo.[NY-House-Dataset]
--group by LOCALITY
order by PRICE desc;


select * from [EC_IT143_DA].dbo.[NY-House-Dataset]
where BATH = 50; --bring all

select BATH as Number_Bathrooms, count(ADDRESS) as Count_Places
from [EC_IT143_DA].dbo.[NY-House-Dataset] 
where BATH > 0
group by BATH
order by BATH desc;
