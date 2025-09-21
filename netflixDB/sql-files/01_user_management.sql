-- List all users with their current subscription status.
SELECT 
    u.name,
    s.end_date,
    s.plan,
    s.amount,
    CASE
        WHEN s.end_date > SYSDATE THEN 'Ongoing'
        ELSE 'Expired'
    END AS subscription_status
FROM netflix.users u
INNER JOIN netflix.subscriptions s ON s.user_id = u.user_id;

-- Find users who joined in the last 4 years.
SELECT 
    name,
    start_date
FROM netflix.users
WHERE start_date >= ADD_MONTHS(SYSDATE, -48);

-- Count how many users are on each subscription plan.
SELECT 
    plan,
    COUNT(DISTINCT user_id) AS user_count
FROM netflix.subscriptions
GROUP BY plan;