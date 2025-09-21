-- Calculate the total revenue generated each month.
SELECT 
    EXTRACT(MONTH FROM HA.appointment_date) AS month_num,
    TO_CHAR(HA.appointment_date, 'MONTH') AS month_name,
    SUM(HB.amount) AS revenue
FROM Hospital_Appointments HA
INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
WHERE HB.payment_status = 'Paid'
GROUP BY EXTRACT(MONTH FROM HA.appointment_date), TO_CHAR(HA.appointment_date, 'MONTH')
ORDER BY EXTRACT(MONTH FROM HA.appointment_date), TO_CHAR(HA.appointment_date, 'MONTH');

-- Find patients with the highest total billing amount.
SELECT
--    HA.appointment_id,
    HP.patient_id,
    HP.name,
    SUM(HB.amount) AS total_billing_amount
FROM Hospital_Appointments HA
LEFT JOIN Hospital_Patients HP ON HP.patient_id = HA.patient_id
LEFT JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
GROUP BY HP.patient_id, HP.name
ORDER BY total_billing_amount DESC NULLS LAST;

-- Show bills that are pending for more than 400 days.
SELECT
    HB.bill_id,
    HB.amount,
    HB.payment_status,
    HA.appointment_date,
    TRUNC(SYSDATE - HA.appointment_date) AS days 
FROM Hospital_Appointments HA
INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
WHERE payment_status = 'Pending' AND (SYSDATE - HA.appointment_date > 500);

-- Calculate the average bill amount per department.
SELECT
    HD.dept,
    ROUND(AVG(HB.amount),2) AS average_bill
FROM Hospital_Appointments HA
INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
GROUP BY HD.dept;
