-- Find the total number of patients registered.
SELECT 
    COUNT(*) AS "Number of Patients"
FROM Hospital_Patients;

-- List patients who had more than 1 appointments in the last 18 months.
SELECT
    patient_id,
    COUNT(appointment_id) AS Appointments
FROM Hospital_Appointments
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, appointment_date)) < 18
GROUP BY patient_id
HAVING COUNT(appointment_id) > 2
ORDER BY patient_id ASC;
-- Better and more accurate approach, use ADD_MONTHS()
SELECT
    HA.patient_id,
    HP.name,
    COUNT(HA.appointment_id) AS Appointments
FROM Hospital_Appointments HA
INNER JOIN Hospital_Patients HP ON HP.patient_id = HA.patient_id
WHERE HA.appointment_date >= ADD_MONTHS(SYSDATE, -18)
GROUP BY HA.patient_id, HP.name
HAVING COUNT(HA.appointment_id) > 1
ORDER BY HA.patient_id ASC;

-- Get the most common city patients come from.
SELECT 
    address as city,
    COUNT(*) AS Patients
FROM Hospital_Patients
GROUP BY address
ORDER BY Patients DESC;

-- Find patients who have unpaid bills.
SELECT 
    hp.name,
    hb.bill_id,
    hb.payment_status
FROM Hospital_Appointments ha
INNER JOIN Hospital_Billing hb ON hb.appointment_id = ha.appointment_id
INNER JOIN Hospital_Patients hp ON hp.patient_id = ha.patient_id
WHERE hb.payment_status = 'Unpaid'
ORDER BY hb.bill_id;