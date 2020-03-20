SELECT CustomerKey, SUM(TRY_CONVERT(int, Quantity)) as Quantity
FROM wwi.FactSale2
GROUP BY CustomerKey