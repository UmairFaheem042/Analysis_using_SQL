-- Find the total number of customers.
SELECT COUNT(*) AS total_customers FROM banks.customers;

-- List customers who opened an account in the last 12 months.
SELECT 
    customer_id,
    name,
    join_date
FROM banks.customers
WHERE join_date >= ADD_MONTHS(SYSDATE, -12)
ORDER BY join_date DESC;

-- Show customers who have multiple accounts.
SELECT 
    c.customer_id,
    c.name,
    COUNT(a.account_id) AS total_accounts
FROM banks.customers c
INNER JOIN banks.accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_accounts DESC;

-- Find the average balance per account type (Savings, Current, Loan).
SELECT 
    account_type,
    ROUND(AVG(balance),1) AS average_balance
FROM banks.accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- Get the top 5 customers with the highest account balances.
SELECT
    c.customer_id,
    c.name,
    SUM(a.balance) AS total_account_balances
FROM banks.customers c
INNER JOIN banks.accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_account_balances DESC
FETCH FIRST 5 ROWS ONLY;