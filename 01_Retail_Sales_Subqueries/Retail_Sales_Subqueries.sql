/*
--------------------------------------------------
--------------------------------------------------
PROJECT: Retail Sales Analysis using SQL Server 
DATABASE: MyFirstDatabase

PURPOSE:
Practice SQL subqueries through business scenarios 
involving product sales, revenue and data management.

SKILLS:
- Single-row 
- IN and NOT IN
- EXISTS
- ANY and ALL
- Correlated subqueries
- INSERT, UPDATE and DELETE using subqueries

NOTE:
Run the table creation and initial INSERT setup sections only once.
Re-running the entire script may cause table-exists errors
or duplicate records.

--------------------------------------------------
--------------------------------------------------
*/

USE MyFirstDatabase;
GO

/*
--------------------------------------------------
DATA VALIDATION: PAYMENT METHODS
PURPOSE:
Verify available payment methods and check for NULL values.
--------------------------------------------------
*/
SELECT 
	PaymentMethod,
	COUNT(*) AS NumberOfSales
FROM dbo.DailySales
GROUP BY PaymentMethod; 

SELECT *
FROM dbo.DailySales
WHERE PaymentMethod IS NULL;

/* 
--------------------------------------------------
PROJECT SETUP: PRODUCT CATALOGUE
--------------------------------------------------
*/
-- Create product catalogue table
CREATE TABLE dbo.ProductCatalogue
(
	ProductID INT IDENTITY (1,1) PRIMARY KEY,
	ProductName VARCHAR(150) NOT NULL
);

-- Insert product records
INSERT INTO dbo.ProductCatalogue (ProductName)
VALUES
	('Laptop'),
	('Mouse'),
	('Keyboard'),
	('Monitor'),
	('Headphone'),
	('Webcam'),
	('Printer'),
	('Scanner');

-- Verify the records

SELECT *
FROM dbo.ProductCatalogue;

/*
-----------------------------------------------
EXERCISE 1: PRODUCTS NEVER SOLD
CONCEPT: Multiple-row subquery using the NOT IN 

Business Question:
Which Products in our catalogue have never been sold?

-----------------------------------------------
*/

SELECT * 
FROM dbo.ProductCatalogue
	WHERE ProductName NOT IN
(
    SELECT ProductName
    FROM dbo.DailySales
    WHERE ProductName IS NOT NULL
);
/* 
LEARNING:
NOT IN excludes values that appear in the result returned 
by the inner query.

The inner query retrieves product names from DailySales. 
The outer query returns catalogue products that are absent 
from those sales records.
*/
/* 
--------------------------------------------------
EXERCISE 2 : PRODUCTS WITH HIGH_REVENUE SALES 

CONCEPT: Correlated subquery using EXISTS

BUSINESS QUESTION:
Which products have at least one sales record with 
TotalRevenue greater than $500?

--------------------------------------------------
*/

SELECT *
FROM dbo.ProductCatalogue AS p
WHERE EXISTS
	(
	SELECT 1
	FROM dbo.DailySales AS d
	Where d.ProductName= p.ProductName
		AND D.TotalRevenue> 500
	);

-- EXISTS returns products with at least one 
-- matching sales record where TotalRevenue > 500.

/* 
------------------------------------------------------
------------------------------------------------------
EXERCISE 3A: SALES RECORDS WITH HIGHER PRICES
CONCEPT: Subquery using ANY
BUSINESS QUESTION:
Which sales record have a UnitPrice greater than at least
one cash-sale UnitPrice?
-------------------------------------------------------
-------------------------------------------------------
*/
SELECT *
FROM dbo.DailySales
WHERE UnitPrice > ANY
	(
	SELECT UnitPrice
	FROM dbo.DailySales
	Where PaymentMethod = 'Cash' 
	);

-- ANY returns records where the comparison is true 
-- for atleast one value returned by the subquery.

/* 
------------------------------------------------------
------------------------------------------------------
EXERCISE 3B: SALES RECORDS WITH HIGHER PRICES
CONCEPT: Subquery using ALL
BUSINESS QUESTION:
Which sales record have a UnitPrice greater than all
cash-sale UnitPrice?
-------------------------------------------------------
-------------------------------------------------------
*/
SELECT *
FROM dbo.DailySales
WHERE UnitPrice > ALL
	(
	SELECT UnitPrice
	FROM dbo.DailySales
	Where PaymentMethod = 'Cash' 
	);
-- All requires UnitPrice to be greater than 
-- every value returned by the inner query.

/*
--------------------------------------------------------
--------------------------------------------------------
EXERCISE 4: SALES COUNT BY PRODUCT
CONCEPT: Correlated subquery in SELECT
BUSINESS QUESTION:
How many sales records exist for each product in our catalogue?
--------------------------------------------------------
--------------------------------------------------------
*/

SELECT 
	ProductName, 
	(
		SELECT COUNT(*)
		FROM dbo.DailySales
		WHERE dbo.DailySales.ProductName = dbo.ProductCatalogue.ProductName
	) AS SalesCount	
FROM dbo.ProductCatalogue;

-- A correlated subquery calculates a result for each 
-- product in the outer query.
-- COUNT(*) counts matching sales records, not units sold.

/*
---------------------------------------------------------
EXERCISE 5:INSERT...SELECT
CONCEPT: INSERT using a subquery
BUSINESS QUESTION:
How can we copy sales records with revenue greater than $500
into a separate reporting table?
----------------------------------------------------------
*/

CREATE TABLE dbo.HighRevenueSales
	(
	SalesID INT NOT NULL,
	ProductName VARCHAR(150) NOT NULL,
	TotalRevenue DECIMAL (12,2) NOT NULL,

	CONSTRAINT PK_HighRevenueSales
		PRIMARY KEY (SalesID)
	);

INSERT INTO dbo.HighRevenueSales
	(SalesID, ProductName,TotalRevenue)
SELECT SalesID,ProductName, TotalRevenue
FROM dbo.DailySales
WHERE TotalRevenue > 500;

-- VERIFICATION
SELECt*                               
FROM dbo.HighRevenueSales;  

-- INSERT ...SELECT copies selected records into
-- another table without deleting the original records.

/*
-------------------------------------------------------
EXERCISE 6: UPDATE AND DELETE USING SUBQUERIES
CONCEPT: Subqueries with UPDATE and DELETE
-------------------------------------------------------
*/

-- 6A Create a product review test table

CREATE TABLE dbo.ProductReviewTest
	(
	ReviewID INT IDENTITY(1,1) PRIMARY KEY,
	ProductName VARCHAR(150) NOT NULL,
	ReviewStatus VARCHAR(30) NOT NULL
	);

INSERT INTO dbo.ProductReviewTest
(ProductName, ReviewStatus)
VALUES
('Laptop', 'Standard'),
('Mouse', 'Standard'),
('Keyboard', 'Standard'),
('Monitor', 'Standard'),
('Headphone', 'Standard'),
('Webcam', 'Standard'),
('Printer', 'Standard'),
('Scanner', 'Standard'),
('Tablet', 'Standard');

--Identify high-revenue Products
SELECT *
FROM dbo.ProductReviewTest
WHERE ProductName IN 
(
SELECT ProductName
FROM dbo.DailySales
WHERE TotalRevenue> 500
);
-- Update Product review status
UPDATE dbo.ProductReviewTest
SET ReviewStatus = 'High Priority'
WHERE ProductName IN 
	(SELECT ProductName
FROM dbo.DailySales
WHERE TotalRevenue> 500
);

-- Verify updated records

SELECt *                                
FROM dbo.ProductReviewTest;

-- UPDATE with a subquery modifies records matching
-- the values returned by the inner query.


-- 6B DELETE using a Subquery

-- IDENTIFY records to be deleted

SELECT *
FROM dbo.ProductReviewTest
WHERE ProductName NOT IN 
 (
 SELECT ProductName
 FROM dbo.ProductCatalogue
 );
 
 -- DELETE records not in ProductCatalogue
 DELETE
 FROM dbo.ProductReviewTest
 WHERE ProductName NOT IN 
	 (
 SELECT ProductName
 FROM dbo.ProductCatalogue
 );
 
-- DELETE with a subquery deletes records that do not
-- match the values returned by the inner query.
