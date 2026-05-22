# 📊 E-Commerce Transactional Business Intelligence (SQL Project)

## 📌 Project Overview
This project focuses on transforming and analyzing transactional data from an international online retail store using SQL. The analysis is designed to answer real-world retail business questions, tracking customer behaviors, operational bottlenecks, and financial revenue indicators.

## 🛠️ Tech Stack & Database System
- **Language:** SQL (ANSI Standard)
- **Database Engine Used:** PostgreSQL
- **Core Concepts Used:** Common Table Expressions (CTEs), Aggregate Functions, Conditional logic (`CASE WHEN`), and Data Cleaning.

## 📈 Key Insights Discovered
1. **Revenue Baseline:** Successfully separated Gross Revenue from returns/cancellations to establish a clear Net Revenue metric.
2. **Order Basket Performance:** Built an operational summary CTE to discover the average financial value and item count per customer shopping basket.
3. **Customer Value Tiers:** Segmented active customer accounts into specific actionable marketing brackets ('High-Value VIP', 'Core Regular', 'Occasional Buyer') based on their overall lifetime expenditure.
4. **Revenue Leakage:** Isolated canceled invoices (transactions starting with 'C') to identify which products have high return rates, indicating potential product damage or description mismatches.

## 📂 How to View the Code
The complete clean SQL script containing all analytical queries can be found in the [retail_queries.sql](./retail_queries.sql) file in this repository.
