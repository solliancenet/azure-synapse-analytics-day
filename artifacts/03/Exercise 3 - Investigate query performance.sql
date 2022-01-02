SELECT  count(*) from wwi_perf.FactSale_Slow

SELECT  count(*) from wwi_perf.FactSale_Fast

SELECT
    FS.CustomerKey
    ,MIN(FS.Quantity) as MinQuantity
    ,MAX(FS.Quantity) as MaxQuantity
    ,AVG(FS.TaxRate) as AvgTaxRate
    ,AVG(FS.TaxAmount) as AvgTaxAmount
    ,AVG(FS.TotalExcludingTax) as AverageSaleWithoutTax
    ,AVG(FS.TotalIncludingTax) as AverageSaleWithTax
    ,COUNT(DISTINCT FS.StockItemKey) as DistinctStockItems
    ,COUNT(DISTINCT DC.Country) as DistinctCountries
FROM
    wwi_perf.FactSale_Slow FS
    join wwi.DimCity DC ON
        DC.CityKey = FS.CityKey
GROUP BY
    FS.CustomerKey

SELECT
    FS.CustomerKey
    ,MIN(FS.Quantity) as MinQuantity
    ,MAX(FS.Quantity) as MaxQuantity
    ,AVG(FS.TaxRate) as AvgTaxRate
    ,AVG(FS.TaxAmount) as AvgTaxAmount
    ,AVG(FS.TotalExcludingTax) as AverageSaleWithoutTax
    ,AVG(FS.TotalIncludingTax) as AverageSaleWithTax
    ,COUNT(DISTINCT FS.StockItemKey) as DistinctStockItems
    ,COUNT(DISTINCT DC.Country) as DistinctCountries
FROM
    wwi_perf.FactSale_Fast FS
    join wwi.DimCity DC ON
        DC.CityKey = FS.CityKey
GROUP BY
    FS.CustomerKey