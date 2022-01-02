DROP TABLE [wwi].[SampleData]; 


CREATE TABLE [wwi].[SampleData] 
(
    [customerkey] REAL, 
    [stockitemkey] REAL
);


INSERT INTO [wwi].[SampleData] ([customerkey], [stockitemkey])
VALUES ( 11, 1 );


SELECT * FROM [wwi].[SampleData];


CREATE TABLE [wwi].[SampleData] 
(
    [features] REAL,
    [features2] REAL
);


INSERT INTO [wwi].[SampleData] ([features], [features2])
VALUES ( 11, 1 );


SELECT * FROM [wwi].[SampleData];