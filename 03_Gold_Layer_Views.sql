USE autoshield_risk_db;

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