-- Find the most prescribed medicine.
SELECT 
    medicine,
    COUNT(*) AS number_of_times_prescribed
FROM Hospital_Prescriptions
GROUP BY medicine
ORDER BY number_of_times_prescribed DESC;

-- Show which doctor prescribes which medicine the most.
WITH CTE_RankedMedicines AS (    
    SELECT
        HD.name AS name,
        HP.medicine AS medicine,
        COUNT(HP.medicine) AS medicine_count,
        ROW_NUMBER() OVER(PARTITION BY HD.name ORDER BY COUNT(*) DESC) AS rn
    FROM Hospital_Appointments HA
    INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
    INNER JOIN Hospital_Prescriptions HP ON HP.appointment_id = HA.appointment_id
    GROUP BY HD.name, HP.medicine
)
SELECT
    name, medicine, medicine_count
FROM CTE_RankedMedicines
WHERE rn = 1;

-- Get patients who received more than 2 prescriptions in a month.
WITH CTE_PrescriptionNumbers AS (
    SELECT
        HPa.name,
        EXTRACT(YEAR FROM HA.appointment_date) AS year,
        EXTRACT(MONTH FROM HA.appointment_date) AS month,
        COUNT(HPr.prescription_id) AS number_of_prescriptions
    FROM Hospital_Appointments HA
    INNER JOIN Hospital_Patients HPa ON HPa.patient_id = HA.patient_id
    INNER JOIN Hospital_Prescriptions HPr ON HPr.appointment_id = HA.appointment_id
    GROUP BY HPa.name, EXTRACT(YEAR FROM HA.appointment_date), EXTRACT(MONTH FROM HA.appointment_date)
)
SELECT 
    name,
    year,
    month,
    number_of_prescriptions
FROM CTE_PrescriptionNumbers
WHERE number_of_prescriptions > 2 
ORDER BY name, year, month;