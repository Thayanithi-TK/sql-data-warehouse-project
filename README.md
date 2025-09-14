

# SQL Data Warehouse Project

Welcome to my **Data Warehouse Project**! 🚀
This is a SQL-based Data Warehouse built using the Medallion Architecture (Bronze–Silver–Gold layers) and Star Schema modeling. It integrates raw data from sources(crm & erp)
The main goal is to show how raw data can be organized, cleaned, and transformed into a structure that helps in business reporting and analytics.

## Data Architecture

This project follows the **Bronze–Silver–Gold (Medallion) Architecture**:

* **Bronze Layer** → Raw data from **CSV files** (CRM & ERP).
* **Silver Layer** → Cleaned and transformed data (fix missing values, remove duplicates, standardize formats).
* **Gold Layer** → Final **Star Schema** with **Fact** and **Dimension** tables for analytics.

Example Star Schema:

* **Fact Table:** `fact_sales`
* **Dimension Tables:** `dim_customer`, `dim_product`, `dim_date`, `dim_region`

---

## What I Did

1. **Data Architecture** – Designed Bronze, Silver, and Gold layers.
2. **ETL** – Loaded raw CSV data into SQL tables, cleaned it, and transformed it step by step.
3. **Data Modeling** – Built a **Star Schema** (Fact + Dimension tables).
4. **Analytics** – Wrote SQL queries to answer business questions like sales by region, top products, and revenue trends.

---

## Why I Built This

I made this project to:

* Learn how **data warehouses work**
* Practice **SQL** for real-world data engineering tasks
* Show a **portfolio project** that I can share with recruiters and in interviews

---

## Tools I Used

* **Data Source:** CSV files (CRM & ERP data)
* **Database:** MySQL (you can also use SQLServer/Postgres)
* **Design Tool:** Draw\.io (for ER diagram & architecture)
* **GitHub:** To store and share my code

---

## Project Structure

```bash
sql-warehouse-project/
│
├── datasets/           # Raw CSV files (ERP + CRM)
│
├── docs/               # Documentation (diagrams, notes)
│   ├── architecture.png
│   ├── star_schema.png
│
├── scripts/            # SQL scripts
│   ├── bronze/         # Load raw data
│   ├── silver/         # Clean/transform data
│   ├── gold/           # Build Fact + Dimensions
│
├── queries/            # Example analytics queries
│
└── README.md           # This file
```


## License

This project is under the **MIT License** – feel free to use it and learn from it!


👉 Would you like me to also **draw a simple Star Schema diagram (Fact + Dimensions)** for you, so you can upload it under `docs/architecture.png` and show it in your README?
