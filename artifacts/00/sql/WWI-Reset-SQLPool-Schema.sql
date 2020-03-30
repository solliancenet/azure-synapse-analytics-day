create schema wwi
go
create schema wwi_perf
go
create schema wwi_staging
go
create schema wwi_ml
go

IF OBJECT_ID('wwi.DimCity', 'U') IS NOT NULL
    DROP TABLE wwi.DimCity
GO

--Location was eliminated (data type geography not supported)

CREATE TABLE [wwi].[DimCity]
(
    [CityKey] [int] NOT NULL,
	[WWICityID] [int] NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[StateProvince] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](60) NOT NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[SalesTerritory] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[LatestRecordedPopulation] [bigint] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimCustomer', 'U') IS NOT NULL
    DROP TABLE wwi.DimCustomer
GO

CREATE TABLE [wwi].[DimCustomer](
	[CustomerKey] [int] NOT NULL,
	[WWICustomerID] [int] NOT NULL,
	[Customer] [nvarchar](100) NOT NULL,
	[BillToCustomer] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[BuyingGroup] [nvarchar](50) NOT NULL,
	[PrimaryContact] [nvarchar](50) NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimDate', 'U') IS NOT NULL
    DROP TABLE wwi.DimDate
GO

CREATE TABLE [wwi].[DimDate](
	[Date] [date] NOT NULL,
	[DayNumber] [int] NOT NULL,
	[Day] [nvarchar](10) NOT NULL,
	[Month] [nvarchar](10) NOT NULL,
	[ShortMonth] [nvarchar](3) NOT NULL,
	[CalendarMonthNumber] [int] NOT NULL,
	[CalendarMonthLabel] [nvarchar](20) NOT NULL,
	[CalendarYear] [int] NOT NULL,
	[CalendarYearLabel] [nvarchar](10) NOT NULL,
	[FiscalMonthNumber] [int] NOT NULL,
	[FiscalMonthLabel] [nvarchar](20) NOT NULL,
	[FiscalYear] [int] NOT NULL,
	[FiscalYearLabel] [nvarchar](10) NOT NULL,
	[ISOWeekNumber] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimEmployee', 'U') IS NOT NULL
    DROP TABLE wwi.DimEmployee
GO

-- Photo was eliminated (data type varbinary cannot participate in a columnstore index)

CREATE TABLE [wwi].[DimEmployee](
	[EmployeeKey] [int] NOT NULL,
	[WWIEmployeeID] [int] NOT NULL,
	[Employee] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimPaymentMethod', 'U') IS NOT NULL
    DROP TABLE wwi.DimPaymentMethod
GO

CREATE TABLE [wwi].[DimPaymentMethod](
	[PaymentMethodKey] [int] NOT NULL,
	[WWIPaymentMethodID] [int] NOT NULL,
	[PaymentMethod] [nvarchar](50) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimStockItem', 'U') IS NOT NULL
    DROP TABLE wwi.DimStockItem
GO

-- Photo was eliminated (data type varbinary cannot participate in a columnstore index)

CREATE TABLE [wwi].[DimStockItem](
	[StockItemKey] [int] NOT NULL,
	[WWIStockItemID] [int] NOT NULL,
	[Stock Item] [nvarchar](100) NOT NULL,
	[Color] [nvarchar](20) NOT NULL,
	[SellingPackage] [nvarchar](50) NOT NULL,
	[Buying Package] [nvarchar](50) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](20) NOT NULL,
	[LeadTimeDays] [int] NOT NULL,
	[QuantityPerOuter] [int] NOT NULL,
	[IsChillerStock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimSupplier', 'U') IS NOT NULL
    DROP TABLE wwi.DimSupplier
GO


CREATE TABLE [wwi].[DimSupplier](
	[SupplierKey] [int] NOT NULL,
	[WWISupplierID] [int] NOT NULL,
	[Supplier] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[PrimaryContact] [nvarchar](50) NOT NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[PaymentDays] [int] NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.DimTransactionType', 'U') IS NOT NULL
    DROP TABLE wwi.DimTransactionType
GO

CREATE TABLE [wwi].[DimTransactionType](
	[TransactionTypeKey] [int] NOT NULL,
	[WWITransactionTypeID] [int] NOT NULL,
	[TransactionType] [nvarchar](50) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = REPLICATE
)
GO

IF OBJECT_ID('wwi.FactMovement', 'U') IS NOT NULL
    DROP TABLE wwi.FactMovement
GO

CREATE TABLE [wwi].[FactMovement](
	[MovementKey] [bigint] IDENTITY(1,1) NOT NULL,
	[DateKey] [date] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[CustomerKey] [int] NULL,
	[SupplierKey] [int] NULL,
	[TransactionTypeKey] [int] NOT NULL,
	[WWIStockItemTransactionID] [int] NOT NULL,
	[WWIInvoiceID] [int] NULL,
	[WWIPurchaseOrderID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([CustomerKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi.FactOrder', 'U') IS NOT NULL
    DROP TABLE wwi.FactOrder
GO

CREATE TABLE [wwi].[FactOrder](
	[OrderKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CityKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[OrderDateKey] [date] NOT NULL,
	[PickedDateKey] [date] NULL,
	[SalespersonKey] [int] NOT NULL,
	[PickerKey] [int] NULL,
	[WWIOrderID] [int] NOT NULL,
	[WWIBackorderID] [int] NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([CustomerKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi.FactPurchase', 'U') IS NOT NULL
    DROP TABLE wwi.FactPurchase
GO

CREATE TABLE [wwi].[FactPurchase](
	[PurchaseKey] [bigint] IDENTITY(1,1) NOT NULL,
	[DateKey] [date] NOT NULL,
	[SupplierKey] [int] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[WWIPurchaseOrderID] [int] NULL,
	[OrderedOuters] [int] NOT NULL,
	[OrderedQuantity] [int] NOT NULL,
	[ReceivedOuters] [int] NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[IsOrderFinalized] [bit] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([SupplierKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi.FactSale', 'U') IS NOT NULL
    DROP TABLE wwi.FactSale
GO

CREATE TABLE [wwi].[FactSale](
	[SaleKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CityKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[BillToCustomerKey] [int] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[InvoiceDateKey] [date] NOT NULL,
	[DeliveryDateKey] [date] NULL,
	[SalespersonKey] [int] NOT NULL,
	[WWIInvoiceID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[Profit] [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([CustomerKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi_perf.FactSale_Slow', 'U') IS NOT NULL
    DROP TABLE wwi_perf.FactSale
GO

CREATE TABLE [wwi_perf].[FactSale_Slow](
	[SaleKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CityKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[BillToCustomerKey] [int] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[InvoiceDateKey] [date] NOT NULL,
	[DeliveryDateKey] [date] NULL,
	[SalespersonKey] [int] NOT NULL,
	[WWIInvoiceID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[Profit] [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi_perf.FactSale_Fast', 'U') IS NOT NULL
    DROP TABLE wwi_perf.FactSale_Fast
GO

CREATE TABLE [wwi_perf].[FactSale_Fast](
	[SaleKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CityKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[BillToCustomerKey] [int] NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[InvoiceDateKey] [date] NOT NULL,
	[DeliveryDateKey] [date] NULL,
	[SalespersonKey] [int] NOT NULL,
	[WWIInvoiceID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[Profit] [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([CustomerKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi.FactStockHolding', 'U') IS NOT NULL
    DROP TABLE wwi.FactStockHolding
GO

CREATE TABLE [wwi].[FactStockHolding](
	[StockHoldingKey] [bigint] IDENTITY(1,1) NOT NULL,
	[StockItemKey] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[BinLocation] [nvarchar](20) NOT NULL,
	[LastStocktakeQuantity] [int] NOT NULL,
	[LastCostPrice] [decimal](18, 2) NOT NULL,
	[ReorderLevel] [int] NOT NULL,
	[TargetStockLevel] [int] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([StockItemKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO

IF OBJECT_ID('wwi.FactTransaction', 'U') IS NOT NULL
    DROP TABLE wwi.FactTransaction
GO

CREATE TABLE [wwi].[FactTransaction](
	[TransactionKey] [bigint] IDENTITY(1,1) NOT NULL,
	[DateKey] [date] NOT NULL,
	[CustomerKey] [int] NULL,
	[BillToCustomerKey] [int] NULL,
	[SupplierKey] [int] NULL,
	[TransactionTypeKey] [int] NOT NULL,
	[PaymentMethodKey] [int] NULL,
	[WWICustomerTransaction ID] [int] NULL,
	[WWISupplierTransaction ID] [int] NULL,
	[WWIInvoiceID] [int] NULL,
	[WWIPurchaseOrderID] [int] NULL,
	[SupplierInvoiceNumber] [nvarchar](20) NULL,
	[TotalExcludingTax] [decimal](18, 2) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[TotalIncludingTax] [decimal](18, 2) NOT NULL,
	[OutstandingBalance] [decimal](18, 2) NOT NULL,
	[IsFinalized] [bit] NOT NULL,
	[LineageKey] [int] NOT NULL
)
WITH
(
    DISTRIBUTION = HASH ([CustomerKey]),
    CLUSTERED COLUMNSTORE INDEX
)
GO















