-- Customers who own only a Credit Card (no Debit Card)
SELECT 
    cu.customer_id,
    cu.name
FROM banks.customers cu
JOIN banks.accounts a ON cu.customer_id = a.customer_id
JOIN banks.cards ca ON a.account_id = ca.account_id
GROUP BY cu.customer_id, cu.name
HAVING 
    SUM(CASE WHEN ca.card_type = 'Credit' THEN 1 ELSE 0 END) > 0   -- must have Credit
    AND SUM(CASE WHEN ca.card_type = 'Debit' THEN 1 ELSE 0 END) = 0;  -- must not have Debit


-- Find the number of active cards (expiry date > today).
SELECT 
    COUNT(*) AS total_cards,
    SUM(CASE WHEN expiry_date <= SYSDATE THEN 1 ELSE 0 END) AS expired_cards,
    SUM(CASE WHEN expiry_date > SYSDATE THEN 1 ELSE 0 END) AS active_cards
FROM banks.cards;
