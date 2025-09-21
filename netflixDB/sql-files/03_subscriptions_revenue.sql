-- Calculate total revenue of all months.
SELECT 
    EXTRACT(MONTH FROM start_date) AS subs_month,
    SUM(amount) AS monthly_revenue
FROM netflix.subscriptions
GROUP BY EXTRACT(MONTH FROM start_date)
ORDER BY EXTRACT(MONTH FROM start_date) ASC;

-- Show average subscription amount per plan.
SELECT 
    plan,
    AVG(amount) AS average_subs_amount
FROM netflix.subscriptions
GROUP BY plan;

-- Find users who renewed more than 2 times(if we are saying renewed 2 times meaning those who have 3 subs or more).
-- 1 original + 2 renewals = 3 total for 2 renewals
SELECT 
    s.user_id,
    u.name,
    COUNT(*) AS total_subscriptions
FROM netflix.subscriptions s
JOIN netflix.users u ON u.user_id = s.user_id
GROUP BY s.user_id, u.name
HAVING COUNT(*) > 3;