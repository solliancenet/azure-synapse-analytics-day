# Setup the Azure Synapse Analytics (ASA) workspace

## Task 1 - Create resources

1. Create a new resource group

2. In the resource group, create a regular blob storage account. Create in it two private containers named `staging` and `models`.

3. In the resource group, create an empty ASA workspace.

4. Create the following file systems in the primary storage account of the workspace: `dev`, `staging`, and `wwi`.

5. Create a linked service to the first pool of the workspace. Configure it to connect with username and password, and use the credentials of the workspace's SQL admin account. It is recommended to name the linked service `sqlpool01` to simplify the import of datasets, data flows, and pipelines later.

6. Create a linked service to the primary storage account. Configure it to connect with the account key. It is recommended to name the linked service `asadatalake01` to simplify the import of datasets, data flows, and pipelines later.

7. Create a linked service to the blob storage account. Configure it to connect with the account key. It is recommended to name the linked service `asastore01` to simplify the import of datasets, data flows, and pipelines later.

8. For the remainder of this guide, the following terms will be used for various ASA-related resources (make sure you replace them with actual names and values):

    ASA resource | To be referred to as
    --- | ---
    Workspace resource group | `WorkspaceResourceGroup`
    Workspace | `Workspace`
    Identity used to create `Workspace` | `MasterUser`
    Primary storage account | `PrimaryStorage`
    Blob storage account | `BlobStorage`
    First Spark pool | `SparkPool01`
    First SQL pool | `SQLPool01`
    SQL admin account | `asa.sql.admin`
    Linked service to first SQL pool | `sqlpool01`
    Linked service to primary storage account | `asadatalake01`
    Linked service to blob storage account | `asastore01`

9.  Ensure the `Workspace` security principal (which has the same name as the `Workspace`) and the `MasterUser` (the one used to create the `Workspace`) are added with the `Storage Blob Data Owner` role to the `PrimaryStorage`.

## Task 2 - Upload the data used in the lab

1. Create a folder named `bronze` in the `dev` file system of `PrimaryStorage`.

2. Upload the following data files to the `dev` folder created above:

    File name | Size | Download from
    --- | --- | ---
    `postalcodes.csv` | 1.8 MB | https://solliancepublicdata.blob.core.windows.net/wwi-01/postalcodes.csv
    `wwi-dimcity.csv` | 17.5 MB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimcity.csv
    `wwi-dimcustomer.csv` | 67.3 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimcustomer.csv
    `wwi-dimdate.csv` | 146.3 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimdate.csv
    `wwi-dimemployee.csv` | 18.7 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimemployee.csv
    `wwi-dimpaymentmethod.csv` | 514 B | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimpaymentmethod.csv
    `wwi-dimstockitem.csv` | 114.6 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimstockitem.csv
    `wwi-dimsupplier.csv` | 3.8 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimsupplier.csv
    `wwi-dimtransactiontype.csv` | 1.3 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-dimtransactiontype.csv
    `wwi-factmovement.csv` | 11.1 MB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factmovement.csv
    `wwi-factorder.csv` | 31.3 MB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factorder.csv
    `wwi-factpurchase.csv` | 461.1. KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factpurchase.csv
    `wwi-factsale-big-1.csv` | 3.0 GB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factsale-big-1.csv
    `wwi-factsale-big-2.csv` | 3.0 GB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factsale-big-2.csv
    `wwi-factsale-big-3.csv` | 3.0 GB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factsale-big-3.csv
    `wwi-factsale-big-4.csv` | 3.0 GB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factsale-big-4.csv
    `wwi-factsale.csv` | 1.8 GB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factsale.csv
    `wwi-factstockholding.csv` | 8.9 KB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-factstockholding.csv
    `wwi-facttransaction.csv` | 7.2 MB | https://solliancepublicdata.blob.core.windows.net/wwi-01/wwi-facttransaction.csv

## Task 3 - Import datasets, data flows, and pipelines

### Import datasets pointing to `PrimaryStorage`

Perform the following steps for each dataset to be imported:

1. Create a new, empty dataset with the same name as the one to be imported.

2. Switch to code view and replace the code with the content of the associated JSON file.

3. If the name used for the linked service to `PrimaryStorage` is not `asadatalake01`, replace the `properties.linkedServiceName.referenceName` value in JSON with the actual name of the linked service.

4. Save and publish the dataset. Optionally, you can publish all datasets at once, at the end of the import procedure.

The following datasets pointing to `PrimaryStorage` must be imported:

Dataset | Source code
--- | ---
`external_postalcode_adls` | [external_postalcode_adls.json](artifacts/00/datasets/adls/external_postalcode_adls.json)
`staging_enrichedcustomer_adls` | [staging_enrichedcustomer_adls.json](artifacts/00/datasets/adls/staging_enrichedcustomer_adls.json)
`wwi_dimcity_adls` | [wwi_dimcity_adls.json](artifacts/00/datasets/adls/wwi_dimcity_adls.json)
`wwi_dimcustomer_adls` | [wwi_dimcustomer_adls.json](artifacts/00/datasets/adls/wwi_dimcustomer_adls.json)
`wwi_dimdate_adls` | [wwi_dimdate_adls.json](artifacts/00/datasets/adls/wwi_dimdate_adls.json)
`wwi_dimemployee_adls` | [wwi_dimemployee_adls.json](artifacts/00/datasets/adls/wwi_dimemployee_adls.json)
`wwi_dimpaymentmethod_adls` | [wwi_dimpaymentmethod_adls.json](artifacts/00/datasets/adls/wwi_dimpaymentmethod_adls.json)
`wwi_dimstockitem_adls` | [wwi_dimstockitem_adls.json](artifacts/00/datasets/adls/wwi_dimstockitem_adls.json)
`wwi_dimsupplier_adls` | [wwi_dimsupplier_adls.json](artifacts/00/datasets/adls/wwi_dimsupplier_adls.json)
`wwi_dimtransactiontype_adls` | [wwi_dimtransactiontype_adls.json](artifacts/00/datasets/adls/wwi_dimtransactiontype_adls.json)
`wwi_factmovement_adls` | [wwi_factmovement_adls.json](artifacts/00/datasets/adls/wwi_factmovement_adls.json)
`wwi_factorder_adls` | [wwi_factorder_adls.json](artifacts/00/datasets/adls/wwi_factorder_adls.json)
`wwi_factpurchase_adls` | [wwi_factpurchase_adls.json](artifacts/00/datasets/adls/wwi_factpurchase_adls.json)
`wwi_factsale_adls` | [wwi_factsale_adls.json](artifacts/00/datasets/adls/wwi_factsale_adls.json)
`wwi_factsale_big_1_adls` | [wwi_factsale_big_1_adls.json](artifacts/00/datasets/adls/wwi_factsale_big_1_adls.json)
`wwi_factsale_big_2_adls` | [wwi_factsale_big_2_adls.json](artifacts/00/datasets/adls/wwi_factsale_big_2_adls.json)
`wwi_factsale_big_3_adls` | [wwi_factsale_big_3_adls.json](artifacts/00/datasets/adls/wwi_factsale_big_3_adls.json)
`wwi_factsale_big_4_adls` | [wwi_factsale_big_4_adls.json](artifacts/00/datasets/adls/wwi_factsale_big_4_adls.json)
`wwi_factstockholding_adls` | [wwi_factstockholding_adls.json](artifacts/00/datasets/adls/wwi_factstockholding_adls.json)
`wwi_facttransaction_adls` | [wwi_facttransaction_adls.json](artifacts/00/datasets/adls/wwi_facttransaction_adls.json)

### Import datasets pointing to `SQLPool1`

Perform the following steps for each dataset to be imported:

1. Create a new, empty dataset with the same name as the one to be imported.

2. Switch to code view and replace the code with the content of the associated JSON file.

3. If the name used for the linked service to `SQLPool01` is not `sqlpool01`, replace the `properties.linkedServiceName.referenceName` value in JSON with the actual name of the linked service.

4. Save and publish the dataset. Optionally, you can publish all datasets at once, at the end of the import procedure.

The following datasets pointing to `SQLPool01` must be imported:

Dataset | Source code
--- | ---
`wwi_dimcity_asa` | [wwi_dimcity_asa.json](artifacts/00/datasets/asa/wwi_dimcity_asa.json)
`wwi_dimcustomer_asa` | [wwi_dimcustomer_asa.json](artifacts/00/datasets/asa/wwi_dimcustomer_asa.json)
`wwi_dimdate_asa` | [wwi_dimdate_asa.json](artifacts/00/datasets/asa/wwi_dimdate_asa.json)
`wwi_dimemployee_asa` | [wwi_dimemployee_asa.json](artifacts/00/datasets/asa/wwi_dimemployee_asa.json)
`wwi_dimpaymentmethod_asa` | [wwi_dimpaymentmethod_asa.json](artifacts/00/datasets/asa/wwi_dimpaymentmethod_asa.json)
`wwi_dimstockitem_asa` | [wwi_dimstockitem_asa.json](artifacts/00/datasets/asa/wwi_dimstockitem_asa.json)
`wwi_dimsupplier_asa` | [wwi_dimsupplier_asa.json](artifacts/00/datasets/asa/wwi_dimsupplier_asa.json)
`wwi_dimtransactiontype_asa` | [wwi_dimtransactiontype_asa.json](artifacts/00/datasets/asa/wwi_dimtransactiontype_asa.json)
`wwi_factmovement_asa` | [wwi_factmovement_asa.json](artifacts/00/datasets/asa/wwi_factmovement_asa.json)
`wwi_factorder_asa` | [wwi_factorder_asa.json](artifacts/00/datasets/asa/wwi_factorder_asa.json)
`wwi_factpurchase_asa` | [wwi_factpurchase_asa.json](artifacts/00/datasets/asa/wwi_factpurchase_asa.json)
`wwi_factsale_asa` | [wwi_factsale_asa.json](artifacts/00/datasets/asa/wwi_factsale_asa.json)
`wwi_factstockholding_asa` | [wwi_factstockholding_asa.json](artifacts/00/datasets/asa/wwi_factstockholding_asa.json)
`wwi_facttransaction_asa` | [wwi_facttransaction_asa.json](artifacts/00/datasets/asa/wwi_facttransaction_asa.json)
`wwi_perf_factsale_fast_asa` | [wwi_perf_factsale_fast_asa.json](artifacts/00/datasets/asa/wwi_perf_factsale_fast_asa.json)
`wwi_perf_factsale_slow_asa` | [wwi_perf_factsale_slow_asa.json](artifacts/00/datasets/asa/wwi_perf_factsale_slow_asa.json)
`wwi_staging_dimcustomer_asa` | [wwi_staging_dimcustomer_asa.json](artifacts/00/datasets/asa/wwi_staging_dimcustomer_asa.json)
`wwi_staging_enrichedcustomer_asa` | [wwi_staging_enrichedcustomer_asa.json](artifacts/00/datasets/asa/wwi_staging_enrichedcustomer_asa.json)

### Import data flows

Perform the following steps for each data flow to be imported:

1. Create a new, empty data flow with the same name as the one to be imported.

2. Switch to code view and replace the code with the content of the associated JSON file.

3. Save and publish the data flow. Optionally, you can publish all data flows at once, at the end of the import procedure.

The following data flows must be imported:

Data flow | Source code
--- | ---
`EnrichCustomerData` | [EnrichCustomerData.json](./artifacts/00/dataflows/EnrichCustomerData.json)

### Import pipelines

Perform the following steps for each pipeline to be imported:

1. Create a new, empty pipeline with the same name as the one to be imported.

2. Switch to code view and replace the code with the content of the associated JSON file.

3. Save and publish the pipeline. Optionally, you can publish all pipelines at once, at the end of the import procedure.

The following pipelines must be imported:

Pipeline | Source code
--- | ---
`Exercise 2 - Enrich Data` | [Exercise 2 - Enrich Data.json](./artifacts/00/pipelines/Exercise%202%20-%20Enrich%20Data.json)
`Import WWI Data` | [Import WWI Data.json](./artifacts/00/pipelines/Import%20WWI%20Data.json)
`Import WWI Data - Fact Sale Full` | [Import WWI Data - Fact Sale Full.json](./artifacts/00/pipelines/Import%20WWI%20Data%20-%20Fact%20Sale%20Full.json)
`Import WWI Perf Data - Fact Sale Fast` | [Import WWI Perf Data - Fact Sale Fast.json](./artifacts/00/pipelines/Import%20WWI%20Perf%20Data%20-%20Fact%20Sale%20Fast.json)
`Import WWI Perf Data - Fact Sale Slow` | [Import WWI Perf Data - Fact Sale Slow.json](./artifacts/00/pipelines/Import%20WWI%20Perf%20Data%20-%20Fact%20Sale%20Slow.json)

## Task 3 - Populate `PrimaryStorage` with data

1. Import the [Setup - Export Sales to Data Lake](./artifacts/00/notebooks/Setup%20-%20Export%20Sales%20to%20Data%20Lake.ipynb) notebook.

2. Replace `<primary_storage>` with actual the data lake account name of `PrimaryStorage` in cells 1, 4, and 6.

3. Run the notebook to populate `PrimaryStorage` with data.

## Task 4 - Configure the SQL on-demand pool

1. Create a SQL on-demand database running the following script on the `master` database of the SQL on-demand pool:

    ```sql
    CREATE DATABASE SQLOnDemand01
    ```

2. Ensure the SQL on-demand pool can query the storage account using the following script:

    ```sql
    CREATE CREDENTIAL [https://<primary_storage>.dfs.core.windows.net]
    WITH IDENTITY='User Identity';
    ```

    In the script above, replace `<primary_storage>` with the name of `PrimaryStorage`.

## Task 4 - Configure `SQLPool01`

1. Connect with either the SQL Active Directory admin or the `asa.sql.admin` account to `SQLPool01` using the tool of your choice.

2. Run the [WWI-Reset-SQLPoolSchema](./artifacts/00/sql/WWI-Reset-SQLPool-Schema.sql) SQL script to initialize the schema of the SQL pool.

3. Create the `asa.sql.staging` login in the `master` database of `Workspace` using the following script:

    ```sql
    CREATE LOGIN [asa.sql.staging]
	WITH PASSWORD = '<password>'
    GO
    ```

    In the script above, replace `<password>` with the actual password of the login.

4. Create the `asa.sql.staging` user in `SQLPool01` using the following script:

    ```sql
    CREATE USER [asa.sql.staging]
        FOR LOGIN [asa.sql.staging]
        WITH DEFAULT_SCHEMA = dbo
    GO

    -- Add user to the required roles

    EXEC sp_addrolemember N'db_datareader', N'asa.sql.staging'
    GO

    EXEC sp_addrolemember N'db_datawriter', N'asa.sql.staging'
    GO

    EXEC sp_addrolemember N'db_ddladmin', N'asa.sql.staging'
    GO
    ```

5. Configure access control to workspace pipeline runs in `SQLPool01` using the following script:

    ```sql
    --Create user in DB
    CREATE USER [<workspace>] FROM EXTERNAL PROVIDER;

    --Granting permission to the identity
    GRANT CONTROL ON DATABASE::<sqlpool> TO [<workspace>];
    ```

    In the script above, replace `<workspace>` with the actual name of `Workspace` and `<sqlpool>` with the actual name of `SQLPool01`.

6. Run the `Import WWI Data` pipeline to import all data except the sale facts into `SQLPool01`.

7. Run the `Import WWI Data - Fact Sale Full` pipeline to import the sale facts into `SQLPool01`.

8. Run the `Import WWI Perf Data - Fact Sale Fast` and `Import WWI Perf Data - Fact Sale Slow` pipelines to import the large-sized sale facts into `SQLPool01`.

## Task 5 - Configure Power BI

1. Ensure the `MasterUser` has a Power BI Pro susbcription assigned.

2. Sign in to the [Power BI portal](https://powerbi.com) using the credentials of `MasterUser` and create a new Power BI workspace. In the remainder of this guide, this workspace will be referred to as `PowerBIWorkspace`.

3. Perform all the steps described in [Exercise 3 - Task 1](03-power-bi-integration.md##task-1---create-a-power-bi-dataset-in-synapse). In step 11, instead of using the suggested naming convention, name your dataset `wwifactsales`.

4. In the Power BI portal, edit the security settings of the `wwifactsales` dataset and configure it to authenticate to `SQLPool01` using the credentials of the `asa.sql.admin` account. This allows the `Direct Query` option to work correctly for all participants in the lab.

## Task 6 - Import all SQL scripts and Spark notebooks

Import the following SQL scripts into `Workspace`:

SQL script name | Source code | Replacements
--- | --- | ---
`Exercise 1 - Read with SQL on-demand` | [Exercise 1 - Read with SQL on-demand.sql](./artifacts/01/Exercise%201%20-%20Read%20with%20SQL%20on-demand.sql) | `<primary_storage>` with the actual name of `PrimaryStorage`
`Exercise 4 - Analyze Transactions` | [Exercise 4 - Analyze Transactions.sql](./artifacts/04/Exercise%204%20-%20Analyze%20Transactions.sql) | None
`Exercise 4 - Investigate query performance` | [Exercise 4 - Investigate query performance.sql](./artifacts/04/Exercise%204%20-%20Investigate%20query%20performance.sql) | None
`Exercise 5 - Create Sample Data for Predict` | [Exercise 5 - Create Sample Data for Predict.sql](./artifacts/05/Exercise%205%20-%20Create%20Sample%20Data%20for%20Predict.sql) | None
`Exercise 5 - Predict with model` | [Exercise 5 - Predict with model.sql](./artifacts/05/Exercise%205%20-%20Predict%20with%20model.sql) | None
`Exercise 5 - Register model` | [Exercise 5 - Register model.sql](./artifacts/05/Exercise%205%20-%20Register%20model.sql) | `<blob_storage_account_key>` with the storage account key of `BlobStorage`; `<blob_storage>` with the storage account name of `BlobStorage`

Import the following Spark notebooks into `Workspace`:

Spark notebook name | Source code | Replacements
--- | --- | ---
`Exercise 1 - Read with Spark` | [Exercise 1 - Read with Spark.ipynb](./artifacts/01/Exercise%201%20-%20Read%20with%20Spark.ipynb) | `<primary_storage>` with the actual name of `PrimaryStorage`
`Exercise 2 - Ingest Sales Data` | [Exercise 2 - Ingest Sales Data.ipynb](./artifacts/02/Exercise%202%20-%20Ingest%20Sales%20Data.ipynb) | In cell 1 - `<primary_storage>` with the actual name of `PrimaryStorage`
`Exercise 2 - Bonus Notebook with CSharp` | [Exercise 2 - Bonus Notebook with CSharp.ipynb](./artifacts/02/Exercise%202%20-%20Bonus%20Notebook%20with%20CSharp.ipynb) | In cell 1 - `<primary_storage>` with the actual name of `PrimaryStorage`; In cell 3 - `<sql_staging_password>` with the password of `asa.sql.staging` created above in Task 4, step 3; In cell 3 - `<workspace>` with the name of the `Workspace`; In cell 3 - `<sql_pool>` with the name of `SQLPool1`
`Exercise 5 - Model Training` | [Exercise 5 - Model Training.ipynb](./artefacts/../artifacts/05/Exercise%205%20-%20Model%20Training.ipynb) | In cell 3 - `<primary_storage>` with the actual name of `PrimaryStorage`; In cell 21 - `<blob_storage>` with the storage account name of `BlobStorage`; In cell 21 - `<blob_storage_account_key>` with the storage account key of `BlobStorage`

## Task 7 - Prepare a machine learning model

Prepare the `models` container in `BlobStorage` by creating two folders: `onnx` and `hex`.

To prepare the machine learning model for Exercise 5, you have two options:

- Use the already trained and converted machine learning model (available as a starter artifact)
- Train and convert a new machine learning model

### Import the already trained and converted machine learning model

1. Upload the [model.onnx.hex](./artifacts/00/ml/model.onnx.hex) file to the `hex` folder in the `models` container of `BlobStorage`.

2. Run the `Exercise 5 - Create Sample Data for Predict` SQL script to create sample data for machine learning predictions.

3. Run the `Exercise 5 - Register model` SQL script to register the model with the `SQLPool01` SQL pool.

### Train and convert a new machine learning model

1. Run the `Exercise 5 - Model training` Spark notebook to train the machine learning model and save it in ONNX format. The model will be saved as `model.onnx` in the `onnx` folder in the `models` container of `BlobStorage`.

2. Use the [convertion PowerShell script](./artifacts/00/ml/convert-to-hex.ps1) to transform `model.onnx` into `model.onnx.hex`.
   
3. Perform steps 1, 2, and 3 described in the previous section.

## Task 8 - Configure additional users to access the workspace

For each additional user that needs to have access to `Workspace` and run exercises 1 through 5, the following steps must be performed:

1. Assign the `Reader` role on the `WorkspaceResourceGroup` to the user.

2. Assign the `Reader` and `Blob Data Contributor` roles on the `PrimaryStorage` to the user.

3. Assign the `Workspace admin` role in the `Workspace` to the user.

4. Grant access to the `SQLPool01` to the user using the script below. You must be signed in with the `MasterUser` credentials (use SQL Server Management Studio if the script fails in Synapse Studio).

    ```sql
    CREATE USER [<user_principal_name>] FROM EXTERNAL PROVIDER;
    EXEC sp_addrolemember 'db_owner', '<user_principal_name>';
    ```

    In the script above, replace `<user_principal_name>` with Azure Active Directory user principal name of the user.

5. Assign the `Contributor` role on the Power BI workspace of the `MasterUser` created in Task 5, step 2.