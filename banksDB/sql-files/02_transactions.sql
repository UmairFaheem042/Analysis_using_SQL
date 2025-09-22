-- Count the total number of transactions in the last 6 months.
SELECT 
    COUNT(*) total_transactions_in_last_6_months
FROM banks.transactions
WHERE transaction_date >= ADD_MONTHS(SYSDATE, -6);

-- Find the highest transaction amount per account.
SELECT * FROM banks.transactions; -- account_id, amount

SELECT
    account_id,
    MAX(amount) AS max_transaction_amount
FROM banks.transactions
GROUP BY account_id
ORDER BY max_transaction_amount DESC;

-- Show the total credits vs debits per account.
WITH CTE_transaction_type AS (
    SELECT
        account_id,
        SUM(CASE WHEN transaction_type = 'Credit' THEN 1 ELSE 0 END) AS total_credits,
        SUM(CASE WHEN transaction_type = 'Debit' THEN 1 ELSE 0 END) AS total_debits
    FROM banks.transactions
    GROUP BY account_id
)
SELECT 
    *
FROM CTE_transaction_type;

-- Get the top 10 accounts with the highest transaction volume.
SELECT
    account_id,
    COUNT(*) AS transaction_volume
FROM banks.transactions
GROUP BY account_id
ORDER BY transaction_volume DESC, account_id ASC
FETCH FIRST 10 ROWS ONLY;


-- Find the day of the week with the most transactions.
SELECT 
    TO_CHAR(transaction_date, 'day') AS transaction_day,
    COUNT(*) AS transactions
FROM banks.transactions
GROUP BY TO_CHAR(transaction_date, 'day')
ORDER BY transactions DESC;