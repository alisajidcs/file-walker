SELECT 
    a.iban,
    SUM(CASE WHEN t.amount LIKE '(%' THEN -CAST(t.amount AS DECIMAL) ELSE 0 END) AS debit,
    SUM(CASE WHEN t.amount NOT LIKE '(%' THEN CAST(t.amount AS DECIMAL) ELSE 0 END) AS credit
FROM 
    accounts AS a
    LEFT JOIN transactions AS t ON a.id = t.account_id
GROUP BY 
    a.id, a.iban
ORDER BY 
    a.iban ASC;
