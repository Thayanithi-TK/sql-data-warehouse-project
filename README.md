

# SQL Data Warehouse Project

Welcome to my **Data Warehouse Project**! 
This is a SQL-based Data Warehouse built using the Medallion Architecture (Bronze–Silver–Gold layers) and Star Schema modeling. It integrates raw data from sources CSV files (CRM + ERP data).

The main goal is to show how raw data can be **organized**, **cleaned**, and **transformed** into a structure that helps in business **reporting** and **analytics**.

## Data Architecture

This project follows the **Bronze–Silver–Gold (Medallion) Architecture**:

![Alt text](https://github.com/Thayanithi-TK/sql-data-warehouse-project/blob/main/doc/data_architucture.png?raw=true)

* **Bronze Layer** → Raw data from **CSV files** (CRM & ERP).
* **Silver Layer** → Cleaned and transformed data (fix missing values, remove duplicates, standardize formats).
* **Gold Layer** → Final **Star Schema** with **Fact** and **Dimension** tables for analytics.

Example Star Schema:

* **Fact Table:** `fact_sales`
* **Dimension Tables:** `dim_customer`, `dim_product`

---

## What I Did

1. **Data Architecture** – Designed Bronze, Silver, and Gold layers.
2. **ETL** – Loaded raw CSV data into SQL tables, cleaned it, and transformed it step by step.
3. **Data Modeling** – Built a **Star Schema** (Fact + Dimension tables).

---
 ## Why I Built This

I made this project to:

Understand how **data warehouses**are designed and work in practice

Practice **SQL** skills by working with real-world style datasets (CRM & ERP)

Build a portfolio project that demonstrates my learning and experience in **data engineering** and **analytics**

---

## Tools I Used

* **Data Source:** CSV files (CRM & ERP data)
* **Database:** MySQL 
* **Design Tool:** Draw\.io (for ER diagram & architecture)
* **GitHub:** To store and share my code

---

## Project Structure

```bash
sql-data-warehouse-project/
├── datasets/           # Raw CSV files (ERP + CRM) 
├── docs/              
│   ├── data_architecture.png 
│   └── data_flow_architucture
|   |__data_model
├── scripts/            # SQL scripts 
│   ├── bronze/         # Load raw data 
│   ├── silver/         # Clean / transform data 
│   └── gold/           # Build fact + dimension tables  
├── test/               # Chect quality of the data
├── README.md           # Project description, architecture, etc. 
└── LICENSE             # MIT License 

```


## License

This project is under the **MIT License** – feel free to use it and learn from it!


