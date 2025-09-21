-- Count how many appointments each doctor has handled.
SELECT 
    HD.name,
    COUNT(HA.appointment_id) AS Appointments
FROM Hospital_Doctors HD
LEFT JOIN Hospital_Appointments HA ON HA.doctor_id = HD.doctor_id
GROUP BY HD.name
ORDER BY HD.name ASC;

-- Find doctors with the highest number of completed appointments.
SELECT
    HD.doctor_id,
    HD.name,
    COUNT(HA.status) AS "Completed Appointments"
FROM Hospital_Doctors HD
LEFT JOIN Hospital_Appointments HA ON HA.doctor_id = HD.doctor_id
WHERE HA.status = 'Completed'
GROUP BY HD.doctor_id, HD.name
ORDER BY COUNT(HA.status) DESC;

-- List doctors by specialization and their average billing amount.
WITH CTE_doctor_details AS (
    SELECT 
        HA.appointment_id AS appointment_id,
        HD.doctor_id AS doctor_id,
        HD.name AS name,
        HD.specialization as specialization,
        HB.amount AS amount
    FROM Hospital_Appointments HA
    INNER JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
    INNER JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
),
CTE_average_billing AS (
    SELECT
        name,
        specialization,
        ROUND(AVG(amount)) AS Average_Billing_Amount
    FROM CTE_doctor_details
    GROUP BY name, specialization
)
SELECT
    name,
    specialization,
    Average_Billing_Amount
FROM CTE_average_billing
ORDER BY specialization;

-- Find which department generates the highest revenue.
WITH CTE_Dept_Info AS (
    SELECT
        HD.dept,
        HB.amount,
        HB.payment_status
    FROM Hospital_Appointments HA
    JOIN Hospital_Billing HB ON HB.appointment_id = HA.appointment_id
    JOIN Hospital_Doctors HD ON HD.doctor_id = HA.doctor_id
), CTE_Dept_Generated_Revenue AS (
    SELECT
        dept,
        ROUND(SUM(amount),2) AS Revenue
    FROM CTE_Dept_Info
    WHERE payment_status = 'Paid'
    GROUP BY dept
)
SELECT 
    dept, 
    Revenue 
FROM CTE_Dept_Generated_Revenue
ORDER BY Revenue DESC;