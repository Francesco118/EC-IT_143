SELECT ProductID AS 'Product ID', 
	ScrappedQty AS 'Scrapped Quantity',
	StartDate AS 'Start Date',
	EndDate AS 'End Date'
FROM Production.WorkOrder
WHERE StartDate >= '2013-12-01' AND EndDate <= '2013-12-31' AND ScrappedQty > 0
	ORDER BY ScrappedQty desc;