-- Use poly to load model into the model table
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'fQv2fKq#FN7r'

-- Create a database scoped credential with Azure storage account key (not a Shared Access Signature) as the secret.
CREATE DATABASE SCOPED CREDENTIAL StorageCredential
WITH
IDENTITY = 'SHARED ACCESS SIGNATURE'
, SECRET = '<INSERT YOUR STORAGE ACCOUNT KEY>'
;

-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE ModelStorage
WITH
( LOCATION = 'wasbs://<container>@<accountName>.blob.core.windows.net'
, CREDENTIAL = StorageCredential
, TYPE = HADOOP
)
;
CREATE EXTERNAL FILE FORMAT csv
WITH (
FORMAT_TYPE = DELIMITEDTEXT,
FORMAT_OPTIONS (
FIELD_TERMINATOR = ',',
STRING_DELIMITER = '',
DATE_FORMAT = '',
USE_TYPE_DEFAULT = False
)
);


CREATE EXTERNAL TABLE [dbo].[ModelsExt]
(
[Model] [varbinary](max) NULL
)
WITH
(
LOCATION='/hex' ,
DATA_SOURCE = ModelStorage ,
FILE_FORMAT = csv ,
REJECT_TYPE = VALUE ,
REJECT_VALUE = 0
)
GO

-- Verify access by running query
SELECT Model, 'A simple model.'
FROM dbo.ModelsExt


CREATE TABLE [wwi].[Models]
(
[Id] [int] IDENTITY(1,1) NOT NULL,
[Model] [varbinary](max) NULL,
[Description] [varchar](200) NULL
)
WITH
(
DISTRIBUTION = REPLICATE,
heap
)
GO

INSERT INTO [wwi].[Models]
SELECT Model, 'A linear regression model.'
FROM [dbo].[ModelsExt]