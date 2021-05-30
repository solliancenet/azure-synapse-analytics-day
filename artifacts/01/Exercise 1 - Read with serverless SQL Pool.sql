SELECT
    COUNT(*)
FROM
    OPENROWSET(
        BULK 'https://<primary_storage>.dfs.core.windows.net/wwi/factsale-csv/2012/Q1/*/*',
 		FORMAT = 'CSV', 
		FIELDTERMINATOR ='|', 
        FIELDQUOTE = '',
		FIRSTROW = 2
    ) 
WITH 
    (
        SalesKey BIGINT,
        CityKey INT,
        CustomerKey INT,
        BillToCustomerKey INT,
        StockItemKey INT,
        DeliveryDateKey DATE,
        SalesPersonKey INT,
        WWIInvoiceID INT,
        Description VARCHAR(200),
        Package VARCHAR(10),
        Quantity INT,
        UnitPrice DECIMAL(6,2),
        TaxRate DECIMAL(6,2),
        TotalExcludingTax DECIMAL(6,2),
        TaxAmount DECIMAL(6,2),
        Profit DECIMAL(6,2),
        TotalIncludingTax DECIMAL(6,2),
        TotalDryItems INT,
        TotalChillerItems INT,
        LineageKey INT
    ) as S