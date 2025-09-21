-- Get the top 5 patients who spent the most money, along with their doctors.
SELECT
    HP.name AS patient_name,
    HD.name AS doctor_name,
    SUM(HB.amount) AS spent_money
FROM Hospital_Appointments HA 
INNER JOIN Hospital_Patients HP ON HP.patient_id = HA.patient_id
INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
WHERE HB.payment_status = 'Paid'
GROUP BY HP.name, HD.name
FETCH FIRST 5 ROWS ONLY;

-- Find the most profitable doctor (sum of billing).
SELECT
    HD.name AS doctor_name,
    SUM(HB.amount) AS billing_sum
FROM Hospital_Appointments HA
INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
WHERE HB.payment_status = 'Paid'
GROUP BY HD.name
ORDER BY billing_sum DESC;

-- Find patients who consulted doctors from multiple departments.
SELECT
    HP.patient_id,
    HP.name AS patient_name,
    COUNT(DISTINCT HD.dept) AS dept_count
FROM Hospital_Appointments HA
INNER JOIN Hospital_Patients HP ON HP.patient_id = HA.patient_id
INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
GROUP BY HP.patient_id, HP.name
HAVING COUNT(DISTINCT HD.dept) > 1
ORDER BY dept_count DESC;