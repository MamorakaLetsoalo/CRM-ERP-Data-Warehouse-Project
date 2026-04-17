# Turning Fragmented Data into Decision-Ready Intelligence

> An end-to-end data platform that transforms siloed ERP and CRM operational data into a trusted, scalable, insight-driven analytics layer engineered for decision-making, not just storage.

---

## Tech Stack

![Microsoft SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=databricks&logoColor=white)
![Azure](https://img.shields.io/badge/Azure%20Data%20Platform-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

| Layer | Technology | Purpose |
|---|---|---|
| Ingestion | CSV / ERP & CRM exports | Raw source data |
| Storage & Compute | Microsoft SQL Server | Data warehouse engine |
| Transformation | T-SQL stored procedures | ETL pipeline logic |
| Modeling | Star Schema (Fact + Dimensions) | Analytics-ready layer |
| Visualization | Power BI / Excel | Business reporting |
| Version Control | Git / GitHub | Code and pipeline versioning |

---

## Problem Statement

Organizations commonly operate with disconnected data sources — ERP for operations, CRM for customers — with no single source of truth. The result:

- **Inconsistent entity definitions** — the word "customer" means something different in every system
- **Poor data quality** — missing values, duplicates, and format mismatches accumulate silently
- **Slow, unreliable reporting** — analysts spend more time cleaning data than generating insight
- **Low trust in data** — leadership makes decisions on gut feel because the numbers don't add up

This project was designed to solve that systematically, at every layer.

---

## Solution: Medallion Architecture (Bronze → Silver → Gold)

Rather than applying a single monolithic transformation, this platform processes data through three discrete, auditable layers ,each with a clear contract and responsibility.

```
┌─────────────────────────────────────────────────────────────────┐
│                     MEDALLION ARCHITECTURE                      │
├───────────────┬───────────────────┬─────────────────────────────┤
│  🟫 BRONZE    │  🩶 SILVER        │  🏆 GOLD                   │
│  Raw Ingestion│  Cleansed & Valid │  Analytics-Ready            │
│               │                  │                             │
│  • ERP CSV    │  • Null handling  │  • Star schema              │
│  • CRM CSV    │  • Deduplication  │  • Fact + dimensions        │
│  • Immutable  │  • Standardized   │  • Optimized for BI         │
│  • Traceable  │    formats/types  │  • Minimal joins            │
└───────────────┴───────────────────┴─────────────────────────────┘
```

### Why three layers instead of one?

| Concern | Single-Step ETL | Medallion |
|---|---|---|
| Debugging a bad transformation | Hard — no intermediate state | Easy — isolate at layer boundary |
| Reusing clean data across teams | Not possible | Silver layer is shared and reusable |
| Auditability / compliance | No raw record preserved | Bronze layer is immutable source of truth |
| Iterating on analytics logic | Risky — touches raw data | Safe — Gold layer only |

<img width="765" height="561" alt="image" src="https://github.com/user-attachments/assets/12389a67-b54b-499d-9d36-7ee4bffac565" />

---

## Key Engineering Decisions

### 1. Separation of Concerns
Instead of a single transformation pass, each layer owns a specific contract. This improves debugging, enables reuse of clean datasets across teams.
### 2. Data Quality as a First-Class Concern
Data quality is enforced at the Silver layer — not bolted on after the fact. Embedded strategies include:

- **Null handling** — explicit rules per column (default, drop, flag, or impute)
- **Duplicate detection** — deterministic deduplication using business keys
- **Standardization** — consistent formats, naming conventions, and data types across ERP and CRM sources

### 3. Star Schema Modeling (Analytical Data Modeling)
The Gold layer is structured as a fact-dimension model to:

- Reduce query complexity for analysts
- Accelerate aggregation performance
- Align natively with BI tooling (Power BI, Excel, Tableau)

### 4. Performance-Oriented Gold Layer
Designed to minimize joins on the most common query patterns ,customer performance, product mix, and time-series analysis so reporting is fast at scale.

---

## Data Model

```
                    ┌──────────────┐
                    │  dim_dates   │
                    └──────┬───────┘
                           │
┌──────────────┐    ┌──────▼───────┐    ┌───────────────┐
│ dim_customers├────►  fact_sales  ◄────┤  dim_products │
└──────────────┘    └──────┬───────┘    └───────────────┘
                           │
                    ┌──────▼───────┐
                    │ dim_location│
                    └──────────────┘



```

| Table | Type | Description |
|---|---|---|
| `fact_sales` | Fact | Core sales transactions — grain: one row per line item |
| `dim_customers` | Dimension | Cleansed customer master from CRM |
| `dim_products` | Dimension | Standardized product catalog from ERP |
| `dim_dates` | Dimension | Calendar spine for time-series analysis |
| `dim_location` | Dimension | Region and territory hierarchy |

<img width="858" height="499" alt="image" src="https://github.com/user-attachments/assets/d149a5e2-e2a7-4dcc-953e-5ae24a4475b7" />

---

## Implementation Overview

<img width="793" height="586" alt="image" src="https://github.com/user-attachments/assets/8aa6695e-f13a-449a-84a5-b8031a51915c" />


## ssis Orchestration
<img width="371" height="507" alt="execute_master" src="https://github.com/user-attachments/assets/e23bca29-68f6-4286-bd61-88bdf4d47259" />


<img width="463" height="368" alt="event_handler" src="https://github.com/user-attachments/assets/d6224175-0075-4ab4-a972-5a3ef75087c3" />

---

## Skills Demonstrated

### Engineering
| Skill | Description |
|---|---|
| Data Architecture Design | Medallion architecture with clear layer contracts |
| ETL Pipeline Development | T-SQL stored procedures with error handling and logging |
| Data Quality Engineering | Embedded null, duplicate, and standardization strategies |

### Analytical
| Skill | Description |
|---|---|
| Business-to-Data Translation | Converted ambiguous business questions into precise SQL |
| Problem Decomposition | Broke a complex data mess into a layered, auditable solution |
| Insight Generation | Produced actionable CLV, product mix, and time-series analytics |

### Technical
| Skill | Description |
|---|---|
| SQL (Advanced T-SQL) | Window functions, CTEs, conditional aggregation, dynamic SQL |
| Data Modeling | Star schema design optimized for BI and aggregation workloads |
| Query Optimization | Minimized joins, used appropriate indexing for Gold layer queries |

---

## Project Structure

```
data-platform/
├── bronze/
│   ├── ingest_erp_sales.sql
│   └── ingest_crm_customers.sql
├── silver/
│   ├── clean_sales.sql
│   ├── clean_customers.sql
│   └── clean_products.sql
├── gold/
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   ├── dim_dates.sql
│   └── fact_sales.sql
├── analytics/
│   ├── top_customers.sql
│   ├── product_revenue.sql
│   └── sales_trends.sql
└── README.md
```

---

## What This Project Demonstrates

This is not a data storage project. It is a **decision support system**.

Every engineering choice ,layered architecture, embedded quality rules, star schema design exists to solve one business problem: *how do you make data trustworthy enough that leaders will act on it?*

The answer is systematic. It requires treating quality as infrastructure, not cleanup. It requires modeling data for how it will be *used*, not just how it was *stored*. And it requires the discipline to separate concerns so that when something breaks, you can find it, fix it, and trust the rest.

---

## Author

**Letsoalo M** — Business Data Analyst / Data Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://linkedin.com)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=flat&logo=github&logoColor=white)](https://github.com)

---

