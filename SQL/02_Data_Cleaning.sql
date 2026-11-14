USE autoshield_risk_db;

-- Create Silver table from Bronze raw ingestion table
DROP TABLE IF EXISTS silver_insurance_data;
CREATE TABLE silver_insurance_data AS
SELECT 
    *,
    CAST('Unknown' AS CHAR(50)) AS COVERAGE_TYPE
FROM raw_insurance_data;

SET SQL_SAFE_UPDATES = 0;

-- Derive coverage type from insured vehicle value
UPDATE silver_insurance_data
SET COVERAGE_TYPE = 'Third-Party Liability'
WHERE TRIM(INSURED_VALUE) = '0' OR TRIM(INSURED_VALUE) = '' OR INSURED_VALUE IS NULL;

UPDATE silver_insurance_data
SET COVERAGE_TYPE = 'Comprehensive'
WHERE TRIM(INSURED_VALUE) != '0' AND TRIM(INSURED_VALUE) != '' AND INSURED_VALUE IS NOT NULL;

-- Remove non-numeric characters from EFFECTIVE_YR
UPDATE silver_insurance_data
SET EFFECTIVE_YR = REGEXP_REPLACE(EFFECTIVE_YR, '[^0-9]', '')
WHERE EFFECTIVE_YR REGEXP '[^0-9]';

-- Replace blank or NULL claims with 0
UPDATE silver_insurance_data
SET CLAIM_PAID = '0'
WHERE TRIM(CLAIM_PAID) = '' OR CLAIM_PAID IS NULL;

-- Standardize invalid or non-manufacturer entries in MAKE
UPDATE silver_insurance_data
SET MAKE = 'UNKNOWN'
WHERE TRIM(MAKE) IN ('', '*', '1984', 'ETHIOPIA', 'KORIA') 
   OR MAKE REGEXP '^[0-9]+$' 
   OR MAKE IS NULL;

SET SQL_SAFE_UPDATES = 1;