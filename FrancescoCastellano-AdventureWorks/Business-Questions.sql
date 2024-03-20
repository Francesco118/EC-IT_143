-- Write your own SQL object definition here, and it'll be included in your package.

--Business User questions - MARGINAL complexity

/* How many total orders were placed in AdventureWorks? */
SELECT COUNT(DISTINCT SalesOrderID) AS TotalOrders
FROM SalesLT.SalesOrderHeader;

/* What is the average selling price of AdventureWorks products? */
SELECT AVG(DISTINCT ListPrice) AS AverageSellingPrice
FROM SalesLT.Product;

--//--//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/--/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

--Business User questions - MODERATE complexity:

/* Can you provide a breakdown of total sales revenue by product category and customer region? */
SELECT 
    P.ProductCategoryID,
    PC.Name AS ProductCategoryName,
    ST.TerritoryID,
    ST.Name AS SalesTerritoryName,
    ROUND(SUM(SD.LineTotal), 2) AS TotalSalesRevenue
FROM 
    Sales.SalesOrderHeader AS SOH
INNER JOIN 
    Sales.SalesOrderDetail AS SD ON SOH.SalesOrderID = SD.SalesOrderID
INNER JOIN 
    Production.Product AS P ON SD.ProductID = P.ProductID
INNER JOIN 
    Production.ProductSubcategory AS PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN 
    Production.ProductCategory AS PC ON PS.ProductCategoryID = PC.ProductCategoryID
INNER JOIN 
    Sales.Customer AS C ON SOH.CustomerID = C.CustomerID
INNER JOIN 
    Sales.SalesTerritory AS ST ON C.TerritoryID = ST.TerritoryID
GROUP BY 
    P.ProductCategoryID,
    PC.Name,
    ST.TerritoryID,
    ST.Name
ORDER BY 
    TotalSalesRevenue DESC;

/* I'm interested in analyzing our top-selling products. 
Can you list the top three products in terms of revenue and quantity sold, including customer details?
 */
SELECT TOP 10
     sod.ProductID
    ,prd.Name
    ,SUM(OrderQty) AS SumOfUnitVolume
FROM Sales.SalesOrderDetail AS SOD
JOIN Sales.SalesOrderHeader AS SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
JOIN Production.Product prd
    ON prd.ProductID  = sod.ProductID
WHERE SOH.OrderDate > '01/01/2013' AND SOH.OrderDate < '12/31/2013'
GROUP BY sod.ProductID, prd.Name
ORDER BY SumOfUnitVolume DESC;

--//--//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/--/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

-- Business User questions - INCREASED complexity:

/* I need insights into our sales performance for the past year. 
Please provide a report detailing monthly sales trends, including revenue, quantity sold, 
and average selling price, broken down by product category. */
SELECT 
    DATEPART(YEAR, SOH.OrderDate) AS Year,
    DATEPART(MONTH, SOH.OrderDate) AS Month,
    P.ProductCategoryID,
    PC.Name AS ProductCategoryName,
    SUM(SD.LineTotal) AS Revenue,
    SUM(SD.OrderQty) AS QuantitySold,
    AVG(SD.UnitPrice) AS AverageSellingPrice
FROM 
    Sales.SalesOrderHeader AS SOH
INNER JOIN 
    Sales.SalesOrderDetail AS SD ON SOH.SalesOrderID = SD.SalesOrderID
INNER JOIN 
    Production.Product AS P ON SD.ProductID = P.ProductID
INNER JOIN 
    Production.ProductSubcategory AS PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN 
    Production.ProductCategory AS PC ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE 
    SOH.OrderDate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY 
    DATEPART(YEAR, SOH.OrderDate),
    DATEPART(MONTH, SOH.OrderDate),
    P.ProductCategoryID,
    PC.Name
ORDER BY 
    Year, Month, P.ProductCategoryID;

/* Our marketing team wants to target specific customer segments. 
Can you analyze customer demographics, including age, gender, and location, 
to identify potential target markets for our new product line? */
SELECT 
    Customer.Title,
    Customer.FirstName,
    Customer.LastName,
    DATEDIFF(YEAR, Customer.BirthDate, GETDATE()) AS Age,
    Customer.EmailAddress,
    Customer.Phone,
    Address.AddressLine1,
    Address.AddressLine2,
    City.EnglishName AS City,
    StateProvince.Name AS StateProvince,
    CountryRegion.Name AS CountryRegion,
    Customer.Gender
FROM 
    Sales.Customer AS Customer
INNER JOIN 
    Person.Address AS Address ON Customer.PrimaryAddressID = Address.AddressID
INNER JOIN 
    Person.StateProvince AS StateProvince ON Address.StateProvinceID = StateProvince.StateProvinceID
INNER JOIN 
    Person.CountryRegion AS CountryRegion ON Address.CountryRegionCode = CountryRegion.CountryRegionCode
INNER JOIN 
    Sales.SalesPerson AS SalesPerson ON Customer.SalesPersonID = SalesPerson.BusinessEntityID
WHERE 
    Customer.ModifiedDate >= DATEADD(YEAR, -3, GETDATE())
    AND SalesPerson.TerritoryID IS NOT NULL
ORDER BY 
    Age DESC,
    CountryRegion,
    StateProvince,
    City,
    AddressLine1;

--//--//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/--/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

--Metadata questions:

/* Could you generate a list of tables in AdventureWorks that contain 
columns named "ProductSubcategoryID" or "ProductID"?*/
SELECT 
    t.name AS TableName,
    c.name AS ColumnName
FROM 
    sys.tables AS t
INNER JOIN 
    sys.columns AS c ON t.object_id = c.object_id
WHERE 
    (c.name = 'ProductSubcategoryID' OR c.name = 'ProductID')
    AND t.is_ms_shipped = 0
ORDER BY 
    TableName,
    ColumnName;


/* I'm conducting a data audit and need to identify tables in AdventureWorks with more than 100,000 records.
Can you provide a list of such tables along with their record counts? */
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    p.rows AS RecordCount
FROM 
    sys.tables AS t
INNER JOIN 
    sys.partitions AS p ON t.object_id = p.object_id
WHERE 
    p.index_id IN (0,1)
    AND p.rows > 100000
ORDER BY 
    RecordCount DESC;

