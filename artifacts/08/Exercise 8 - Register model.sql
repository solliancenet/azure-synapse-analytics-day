-- Use poly to load model into the model table
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'fQv2fKq#FN7r'

-- Create a database scoped credential with Azure storage account key (not a Shared Access Signature) as the secret.
CREATE DATABASE SCOPED CREDENTIAL StorageCredential
WITH
IDENTITY = 'SHARED ACCESS SIGNATURE'
, SECRET = '<blob_storage_account_key>'
;

-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE ModelStorage
WITH
( LOCATION = 'wasbs://models@<blob_storage>.blob.core.windows.net'
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


CREATE EXTERNAL TABLE [wwi_ml].[MLModelExt]
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
FROM wwi_ml.MLModelExt


CREATE TABLE [wwi_ml].[MLModel]
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

INSERT INTO [wwi_ml].[MLModel]
SELECT Model, 'A linear regression model.'
FROM [wwi_ml].[MLModelExt]