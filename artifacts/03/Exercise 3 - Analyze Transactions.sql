SELECT 
    CustomerKey, 
    SUM(Quantity) as Quantity
FROM 
    wwi.FactSale
GROUP BY 
    CustomerKey