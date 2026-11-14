USE autoshield_risk_db;

-- 1. Policy-level Gold view consumed by Power BI
CREATE OR REPLACE VIEW gold_insurance_metrics AS
SELECT 
    OBJECT_ID AS policy_id,
    STR_TO_DATE(INSR_BEGIN, '%d-%b-%y') AS policy_start_date,
    STR_TO_DATE(INSR_END, '%d-%b-%y') AS policy_end_date,
    COVERAGE_TYPE AS coverage_type,
    CAST(EFFECTIVE_YR AS UNSIGNED) AS vehicle_year,
    TYPE_VEHICLE AS vehicle_type,
    MAKE AS vehicle_make,
    USAGE_TYPE AS vehicle_usage,
    CAST(PREMIUM AS DECIMAL(15,2)) AS premium_earned,
    CAST(CLAIM_PAID AS DECIMAL(15,2)) AS claim_incurred,
    CASE 
        WHEN CAST(PREMIUM AS DECIMAL(15,2)) = 0 THEN 0 
        ELSE (CAST(CLAIM_PAID AS DECIMAL(15,2)) / CAST(PREMIUM AS DECIMAL(15,2))) 
    END AS loss_ratio
FROM silver_insurance_data;

-- 2. Manufacturer risk segmentation view (separates micro-samples from major fleets)
CREATE OR REPLACE VIEW gold_manufacturer_risk_tiers AS
SELECT
    vehicle_make,
    COUNT(policy_id) AS total_policies,
    SUM(premium_earned) AS total_premium,
    SUM(claim_incurred) AS total_claims,
    ROUND((SUM(claim_incurred) / NULLIF(SUM(premium_earned), 0)) * 100, 2) AS aggregate_loss_ratio_pct,
    CASE
        WHEN SUM(premium_earned) >= 50000000 THEN 'Major Fleet (>= 5 Cr Premium)'
        WHEN SUM(premium_earned) >= 100000 THEN 'Mid-Tier Portfolio (1L - 5 Cr)'
        ELSE 'Micro-Exposure Outlier (< 1L Premium)'
    END AS portfolio_tier
FROM gold_insurance_metrics
WHERE vehicle_make != 'UNKNOWN'
GROUP BY vehicle_make;