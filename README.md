# AutoShield Insurance: Risk & Profitability Analysis 🛡️

### The Business Problem
Auto insurance companies bleed revenue when they misprice policies for high-risk vehicles. The goal of this project was to transform messy, granular motor policy data into an executive-level dashboard that tracks year-over-year profitability, identifies high-risk vehicle manufacturers, and monitors aggregate loss ratios.

### The Solution & Key Insights
I engineered a custom SQL data pipeline and an interactive Power BI dashboard to give underwriters and risk managers immediate visibility into portfolio performance. 

By filtering the data across policy years and coverage types, the analysis revealed:
* **Severe Risk Outliers:** Uncovered specific manufacturers (e.g., "LIZE") generating massive claims against minimal premium collection, resulting in unsustainable loss ratios. 
* **100% Profit Retention Assets:** Identified vehicle categories (like specific motorcycle models) that generated consistent premium revenue with zero claims filed, highlighting areas for aggressive market expansion.
* **Coverage Profitability:** Quantified the exact margin differences between Comprehensive and Third-Party policies to guide future pricing strategies.

---

<img width="1329" height="767" alt="image" src="https://github.com/user-attachments/assets/e6e96c25-d124-4933-b8d7-7c1f6a543cac" />

---

### ⚙️ Technical Architecture & Execution
This project goes beyond basic drag-and-drop visuals. I built the back-end architecture to ensure data integrity and scalable performance.

**1. The ETL Pipeline (MySQL)**
Rather than relying on Power BI's front-end for heavy transformations, I built a modular 3-step SQL pipeline:
* `01_Create_Schema.sql`: Architected the database foundation with strict data typing for millions of rows.
* `02_Data_Cleaning.sql`: Standardized inconsistent coverage types and handled null values to ensure accurate actuarial math.
* `03_Gold_Layer_Views.sql`: Engineered a final, business-ready "Gold View" so Power BI queries clean, pre-joined data, drastically improving load speeds.

**2. Data Modeling & DAX (Power BI)**
* **Star Schema:** Built a relational model utilizing Fact tables (metrics) and Dimension tables (filters) to optimize cross-filtering.
* **Currency Localization:** Engineered custom DAX format strings to convert raw billion-rupee figures into the Indian numbering system (Crores/Cr) for high-level executive KPIs.
* **Solving the Granularity Conflict:** Created parallel "Raw" DAX measures specifically for the matrix visual. This allowed the high-level cards to show formatted Crores, while the drill-down matrix retained exact rupee granularity for low-premium vehicle models, preventing mathematical rounding errors (0.00 Cr).
* **Context Resolution:** Re-engineered the raw `vehicle_year` column (which represented the physical age of the car) into a custom `Policy_Year` column, allowing financial executives to correctly filter the dashboard by financial year.

---

### 📂 Repository Navigation
* **`AutoShield_Executive_Dashboard.pdf`**: A high-quality static export for quick executive review.
* **`AutoShield_Risk_Analysis.pbix`**: The fully interactive Power BI source file containing the data model and DAX measures.
* **`01` to `03` SQL Scripts**: The modular ETL pipeline used to clean and structure the raw data.
