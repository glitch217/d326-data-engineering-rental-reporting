# D326 — Advanced Data Management (WGU)

This repository contains my completed work for **D326: Advanced Data Management**, including all SQL objects used to build a monthly revenue reporting pipeline for the DVD Rental database.

## Contents
- `D326_Report.pdf` — Full written submission with business analysis and explanations.
- `/sql`
  - `00_schema.sql` — Creates the reporting schema.
  - `01_udf_price_tier.sql` — Price tier classification function.
  - `02_tables.sql` — Detailed and summary reporting tables.
  - `03_load_detail_and_summary.sql` — SQL to extract and load reporting tables.
  - `04_trigger.sql` — AFTER INSERT trigger to update summary metrics.
  - `05_refresh_procedure.sql` — Stored procedure to fully refresh all reporting data.

## Project Summary
The SQL in this project:
- Extracts raw rental, film, category, and payment data  
- Builds a **detailed event-level table** and a **monthly summary table**
- Includes a **UDF**, **trigger**, and a **refresh stored procedure**
- Supports automated scheduling via **pgAgent**

This repo demonstrates practical data engineering skills using PostgreSQL and PL/pgSQL.
