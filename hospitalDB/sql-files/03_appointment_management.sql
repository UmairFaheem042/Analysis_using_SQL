-- Get the percentage of appointments completed vs cancelled.
WITH CTE_appointments_counts AS (
    SELECT
        COUNT(*) AS total_appointments,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_count,
        SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END) AS scheduled_count,
        SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_count
    FROM Hospital_Appointments
)
SELECT
    total_appointments,
    (completed_count / total_appointments) * 100 || '%' AS completed_percentage,
    (scheduled_count / total_appointments) * 100 || '%' AS scheduled_percentage,
    (cancelled_count / total_appointments) * 100 || '%' AS cancelled_percentage
FROM CTE_appointments_counts;

SELECT
    COUNT(*),
    ((SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)) * 100)/COUNT(*) || '%' AS completed_percentage,
    ((SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END)) * 100)/COUNT(*) || '%' AS scheduled_percentage,
    ((SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END)) * 100)/COUNT(*) || '%' AS cancelled_percentage 
FROM Hospital_Appointments;

-- Find the most booked day of the week for appointments.
SELECT
    TO_CHAR(appointment_date, 'Day') AS appointment_day,
    COUNT(TO_CHAR(appointment_date, 'Day')) AS appointment_day_count
FROM Hospital_Appointments
GROUP BY TO_CHAR(appointment_date, 'Day')
ORDER BY appointment_day_count DESC;

-- Show which patient has the highest number of cancelled appointments.
SELECT
    HP.name,
    COUNT(HA.status) AS cancelled_appointments
FROM Hospital_Patients HP
INNER JOIN Hospital_Appointments HA ON HA.patient_id = HP.patient_id
WHERE HA.status = 'Cancelled'
GROUP BY HP.name
ORDER BY cancelled_appointments DESC;

-- List doctors with no appointments in a given month(October).
SELECT
    HD.doctor_id,
    HD.name,
    HD.specialization,
    HD.dept
FROM Hospital_Doctors HD
LEFT JOIN Hospital_Appointments HA ON HA.doctor_id = HD.doctor_id
    AND EXTRACT(MONTH FROM HA.appointment_date) = 10
WHERE HA.appointment_id IS NULL;