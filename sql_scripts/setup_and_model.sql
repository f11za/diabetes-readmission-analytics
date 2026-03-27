/* step 0: Import raw CSV (101,766 rows) into a table named 'Staging_Diabetes' 
using the SQL Server Import and Export Wizard.
*/
ALTER TABLE Staging_Diabetes ALTER COLUMN diag_1 nvarchar(50) NULL;
ALTER TABLE Staging_Diabetes ALTER COLUMN diag_2 nvarchar(50) NULL;
ALTER TABLE Staging_Diabetes ALTER COLUMN diag_3 nvarchar(50) NULL;


ALTER TABLE Staging_Diabetes ALTER COLUMN race nvarchar(50) NULL;
ALTER TABLE Staging_Diabetes ALTER COLUMN medical_specialty nvarchar(50) NULL;
ALTER TABLE Staging_Diabetes ALTER COLUMN weight nvarchar(50) NULL;
ALTER TABLE Staging_Diabetes ALTER COLUMN payer_code nvarchar(50) NULL;

UPDATE Staging_Diabetes
SET race = NULLIF(race, '?'),
    medical_specialty = NULLIF(medical_specialty, '?'),
    diag_1 = NULLIF(diag_1, '?'),
    diag_2 = NULLIF(diag_2, '?'),
    diag_3 = NULLIF(diag_3, '?'),
    weight = NULLIF(weight, '?'),
    payer_code = NULLIF(payer_code, '?');


SELECT COUNT(*) FROM Staging_Diabetes WHERE diag_2 IS NULL;

SELECT DISTINCT 
    patient_nbr, 
    race, 
    gender, 
    age
INTO Dim_Patients 
FROM Staging_Diabetes;

SELECT DISTINCT
    encounter_id, 
    medical_specialty, 
    diag_1, 
    diag_2, 
    diag_3,
    admission_type_id,
    discharge_disposition_id,
    admission_source_id
INTO Dim_ClinicalDetails 
FROM Staging_Diabetes;


SELECT 
    encounter_id, 
    patient_nbr, 
    time_in_hospital, 
    num_lab_procedures, 
    num_procedures, 
    num_medications, 
    number_emergency, 
    number_inpatient, 
    number_diagnoses,
    A1Cresult, 
    [change], 
    diabetesMed, 
    readmitted
INTO Fact_Encounters 
FROM Staging_Diabetes;

SELECT 
    (SELECT COUNT(*) FROM Fact_Encounters) AS TotalEncounters,
    (SELECT COUNT(DISTINCT patient_nbr) FROM Dim_Patients) AS UniquePatients;

DROP TABLE Dim_Patients;


SELECT 
    patient_nbr, 
    MAX(race) as race, 
    MAX(gender) as gender, 
    MAX(age) as age
INTO Dim_Patients
FROM Staging_Diabetes
GROUP BY patient_nbr;
