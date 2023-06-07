SELECT 
    wallet,
    COALESCE(outgoing, 0) AS outgoing,
    COALESCE(incoming, 0) AS incoming,
    COALESCE(incoming_amount, 0) - COALESCE(outgoing_amount, 0) AS balance
FROM (
    SELECT 
        wallet,
        SUM(CASE WHEN sender = wallet THEN 1 ELSE 0 END) AS outgoing,
        SUM(CASE WHEN recipient = wallet THEN 1 ELSE 0 END) AS incoming,
        SUM(CASE WHEN recipient = wallet THEN amount ELSE -amount END) AS balance,
        SUM(CASE WHEN recipient = wallet THEN amount ELSE 0 END) AS incoming_amount,
        SUM(CASE WHEN sender = wallet THEN amount ELSE 0 END) AS outgoing_amount
    FROM 
        (
            SELECT DISTINCT 
                sender AS wallet
            FROM 
                transactions
            WHERE 
                dt BETWEEN '2021-01-01' AND '2021-12-31'
            UNION
            SELECT DISTINCT 
                recipient AS wallet
            FROM 
                transactions
            WHERE 
                dt BETWEEN '2021-01-01' AND '2021-12-31'
        ) AS w
    LEFT JOIN 
        transactions AS t 
        ON w.wallet IN (t.sender, t.recipient)
    WHERE 
        t.dt BETWEEN '2021-01-01' AND '2021-12-31'
    GROUP BY 
        wallet
) AS s
ORDER BY 
    wallet ASC;