SELECT Name/*,ISNULL(PurchasingWebServiceURL, 0) AS url*/ FROM Purchasing.Vendor
	WHERE (Name LIKE 'C%') AND (Name LIKE '%Bike%') OR
	(Name LIKE 'C%') AND (Name LIKE  '%Bicycle%')
	;