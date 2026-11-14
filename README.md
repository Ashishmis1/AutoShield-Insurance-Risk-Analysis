# AutoShield Insurance: Risk & Profitability Analysis

Analysis of **5,08,499 motor insurance policies (2014–2018)** using MySQL and Power BI to identify why the portfolio is running an underwriting loss and which vehicle segments are driving claim payouts.

![AutoShield Executive Dashboard](Assets/screenshot.png)

## Portfolio Summary (2014–2018)

| Segment | Policies | Earned Premium | Claims Paid | Loss Ratio | Avg Premium / Policy | Claim Cost / Policy |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Total Portfolio** | **5,08,499** | **₹403.96 Cr** | **₹918.08 Cr** | **227.27%** | **₹7,944** | **₹18,055** |
| Comprehensive | 2,77,107 | ₹371.63 Cr | ₹890.88 Cr | 239.72% | ₹13,411 | ₹32,149 |
| Third-Party Liability | 2,31,392 | ₹32.33 Cr | ₹27.19 Cr | 84.12% | ₹1,397 | ₹1,175 |

## Key Findings

* **Comprehensive policies are causing the entire portfolio loss:** Comprehensive coverage brings in 92% of total premium (₹371.63 Cr) but accounts for 97% of all claims (₹890.88 Cr), creating a ₹519.25 Cr deficit (₹13,411 collected per policy vs. ₹32,149 paid out).
* **Third-Party Liability is profitable:** Third-Party policies run at an 84.12% loss ratio (+₹5.14 Cr surplus), led by commercial manufacturers like Isuzu (56.91% loss ratio on ₹10.21 Cr premium) and Bajaji (24.10% loss ratio on ₹2.04 Cr premium).
* **Small-sample outliers vs. high-volume fleet losses:**
  * Low-volume General Cartage segments distort percentage rankings. For example, **LIZE** shows an 11,715.43% loss ratio from ₹4,39,606 in claims against just ₹3,752 in collected premium, and **JERMEN** shows 7,746.04% (₹9,31,523 claims vs. ₹12,026 premium).
  * In terms of actual rupee volume, heavy commercial manufacturers like **Toyota**, **Isuzu**, **Iveco**, **Nissan**, **Mesfin**, **Sino Howo**, and **Bishoftu** account for the largest claim payouts.
* **Private vehicles stabilized by 2018:** Across all 5 years, private vehicles (1,22,220 policies) had a 150.86% loss ratio (₹69.81 Cr premium vs. ₹105.32 Cr claims), but improved to a profitable 59.37% loss ratio in 2018 (12,677 policies; ₹5.82 Cr premium vs. ₹3.45 Cr claims).

## Recommendations

1. **Re-price Comprehensive policies:** Increase base Comprehensive premiums or introduce higher deductibles on commercial usage categories, where claim payouts are more than double the collected premium.
2. **Audit low-volume General Cartage segments:** Flag niche manufacturers with fewer than 50 policies (such as LIZE and JERMEN) for manual underwriting review before issuing coverage.
3. **Expand Third-Party commercial volume:** Grow Third-Party Liability underwriting for lower-risk commercial brands like Isuzu and Bajaji, where loss ratios stay well below the 100% break-even threshold.

## How It Was Built

### 1. MySQL Data Cleaning & Views (`SQL/`)
* `SQL/01_Create_Schema.sql`: Creates the `raw_insurance_data` staging table and bulk-loads the CSV using `LOAD DATA LOCAL INFILE`. All columns are initially loaded as `VARCHAR(255)` so formatting errors in the raw file do not break ingestion.
* `SQL/02_Data_Cleaning.sql`: Builds `silver_insurance_data` and cleans the raw fields:
  * Maps policies with `INSURED_VALUE = 0` to `Third-Party Liability` and all others to `Comprehensive`.
  * Strips non-numeric characters from `EFFECTIVE_YR` using `REGEXP_REPLACE()`.
  * Replaces blank/NULL `CLAIM_PAID` values with `0` and standardizes invalid entries in `MAKE` (`*`, `1984`, `ETHIOPIA`, `KORIA`) to `UNKNOWN`.
* `SQL/03_Gold_Layer_Views.sql`: Creates two SQL views:
  * `gold_insurance_metrics`: Converts date strings via `STR_TO_DATE()`, casts financial columns to `DECIMAL(15,2)`, and feeds the Power BI dashboard.
  * `gold_manufacturer_risk_summary`: Groups manufacturers by earned premium size (`< ₹1 Lakh`, `₹1 Lakh – ₹1 Cr`, and `>= ₹1 Cr`) to separate small-sample rate spikes from major fleet brands.

### 2. Power BI Dashboard (`dashboard/`)
* **DAX Measures (`_Key Measures`):** Calculated `Total Premium`, `Total Claims`, `Total Policies`, `Aggregate Loss Ratio`, `Avg Premium Per Policy`, and `Claim Burning Cost`.
* **Crore vs. Exact-Rupee Formatting:** Built Crore-formatted measures (`₹ #,0.00 "Cr"`) for the top KPI cards and separate unscaled measures (`Raw Premium`, `Raw Claims`) for the drill-down table so small-premium brands do not show up as `₹0.00 Cr`.
* **Interactive Drill-Down:** Added a `Policy_Year` calculated column (`YEAR(policy_start_date)`) for year-over-year tracking and a `vehicle_make -> vehicle_usage` hierarchy in the bottom-left matrix.

## Project Files

* `SQL/01_Create_Schema.sql` - Raw table setup and CSV load script
* `SQL/02_Data_Cleaning.sql` - Data cleaning and standardization queries
* `SQL/03_Gold_Layer_Views.sql` - Analytical views for Power BI and risk grouping
* `dashboard/AutoShield_Risk_Analysis.pbix` - Power BI report file
* `dashboard/AutoShield_Executive_Dashboard.pdf` - PDF export of the dashboard
* `Assets/screenshot.png` - Dashboard preview image
