-- Find customers who have both a loan and a credit card.
SELECT
    cu.customer_id, cu.name,
    ca.card_type
FROM banks.accounts a
INNER JOIN banks.customers cu ON cu.customer_id = a.customer_id
INNER JOIN banks.loans l ON l.customer_id = a.customer_id
INNER JOIN banks.cards ca ON ca.account_id = a.account_id
WHERE ca.card_type = 'Credit';


-- Show the total money flow (credits - debits) per customer.
WITH CTE_transactions_per_customer AS (
    SELECT
        a.customer_id,
        SUM(amount) AS total_amount,
        SUM(CASE WHEN transaction_type = 'Credit' THEN t.amount ELSE 0 END) AS credit_amount,
        SUM(CASE WHEN transaction_type = 'Debit' THEN t.amount ELSE 0 END) AS debit_amount
    FROM banks.transactions t
    INNER JOIN banks.accounts a ON a.account_id = t.account_id
    GROUP BY a.customer_id
)
SELECT
    cte.customer_id,
    cu.name,
    cte.credit_amount - cte.debit_amount AS total_money_flow
FROM CTE_transactions_per_customer cte
INNER JOIN banks.customers cu ON cu.customer_id = cte.customer_id
ORDER BY cte.customer_id;

-- Find customers by their overall financial value (balance + loan amount).
WITH CTE_account_balance AS (
    SELECT 
        customer_id,
        SUM(balance) AS total_balance
    FROM banks.accounts
    GROUP BY customer_id
),
CTE_loan_amount AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_loan
    FROM banks.loans
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.name,
    COALESCE(a.total_balance,0) AS account_balance,
    COALESCE(l.total_loan,0) AS loan_amount,
    COALESCE(a.total_balance,0) + NVL(l.total_loan,0) AS financial_value
FROM banks.customers c
LEFT JOIN CTE_account_balance a ON c.customer_id = a.customer_id
LEFT JOIN CTE_loan_amount l ON c.customer_id = l.customer_id
ORDER BY financial_value DESC;


-- Those customers that have more account balance than loan amount but still have taken loan
WITH CTE_account_balance AS (
    SELECT 
        customer_id,
        SUM(balance) AS total_balance
    FROM banks.accounts
    GROUP BY customer_id
),
CTE_loan_amount AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_loan
    FROM banks.loans
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.name,
    a.total_balance AS account_balance,
    l.total_loan AS loan_amount
FROM banks.customers c
INNER JOIN CTE_account_balance a ON c.customer_id = a.customer_id
INNER JOIN CTE_loan_amount l ON c.customer_id = l.customer_id
WHERE a.total_balance > l.total_loan
ORDER BY a.total_balance - l.total_loan DESC;