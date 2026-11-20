# Retail Sales Analysis using SQL Server

## Project Overview

This project explores SQL subqueries through practical business scenarios using a retail sales dataset.

The objective is to retrieve, analyse and manipulate sales data to answer business questions related to product performance, revenue and data management.

## Business Context

A retail company wants to better understand its product sales, identify products that have never been sold, highlight high-revenue transactions and maintain accurate reporting records.

SQL Server is used to explore these scenarios through different types of subqueries and data manipulation operations.

## Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

## Database and Tables

Database: `MyFirstDatabase`

| Table | Purpose |
|---|---|
| `DailySales` | Contains sales transaction records |
| `ProductCatalogue` | Stores the product catalogue |
| `HighRevenueSales` | Stores selected high-revenue transactions |
| `ProductReviewTest` | Used to practise UPDATE and DELETE operations |

## SQL Concepts Practised

- Single-row and multiple-row subqueries
- `IN` and `NOT IN`
- `EXISTS` and correlated subqueries
- `ANY` and `ALL`
- Aggregate functions using `COUNT(*)`
- `INSERT ... SELECT`
- `UPDATE` using subqueries
- `DELETE` using subqueries

## Project Exercises

## Project Exercises

| Exercise | Business Question | SQL Concepts |
|---|---|---|
| 1. Products Never Sold | Which catalogue products have never been sold? | `NOT IN` |
| 2. High-Revenue Products | Which products have at least one sales record above $500? | Correlated subquery, `EXISTS` |
| 3A. Price Comparison | Which sales records have a price greater than at least one cash-sale price? | `ANY` |
| 3B. Price Comparison | Which sales records have a price greater than every cash-sale price? | `ALL` |
| 4. Sales Count by Product | How many sales transactions exist for each catalogue product? | Correlated subquery, `COUNT(*)` |
| 5. High-Revenue Reporting | How can qualifying sales records be copied into a separate reporting table? | `INSERT ... SELECT` |
| 6A. Product Priority | Which products should receive High Priority status? | `UPDATE` with subquery |
| 6B. Catalogue Validation | Which products in the review list are absent from the official catalogue? | `DELETE` with subquery |

## Key Findings

- Identified products in the catalogue with no matching sales records.
- Identified Laptop as the product with qualifying high-revenue transactions.
- Compared ANY and ALL to understand how SQL evaluates a value against at least one value versus every value in a subquery result.
- Calculated transaction counts for each catalogue product, including products with zero sales.
- Created a separate table for high-revenue sales records.
- Practised updating and deleting records using subqueries.

## Repository Contents

- `Retail_Sales_Subqueries.sql` — SQL queries, table creation and practice exercises.

## Learning Outcome

This project strengthened my understanding of SQL subqueries and their practical application in business reporting and data management.

It also provided hands-on practice in writing correlated subqueries, filtering records, aggregating data and performing data manipulation operations.
