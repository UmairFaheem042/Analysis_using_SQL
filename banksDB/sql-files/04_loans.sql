-- Find customers who have taken more than one loan.
SELECT 
    customer_id,
    COUNT(*) AS number_of_loans
FROM banks.loans
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Show the total loan amount disbursed by loan type.
SELECT 
    loan_type,
    SUM(amount) AS total_loan_amount
FROM banks.loans
GROUP BY loan_type;

-- Find loans that are still active and past due date.
SELECT 
    loan_id,
    loan_type,
    amount,
    due_date
FROM banks.loans
WHERE status = 'Active' AND SYSDATE > due_date;

-- Show the top 3 customers with the highest loan amounts.
SELECT
    c.customer_id,
    c.name,
    SUM(l.amount) AS loan_amounts
FROM banks.customers c
INNER JOIN banks.loans l ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY loan_amounts DESC
FETCH FIRST 3 ROWS ONLY;
