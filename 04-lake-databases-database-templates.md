# Exercise 4 - Lake Databases and Database templates

In this exercise you will explore the concept of a lake database and you will learn how to use readily available database templates for lake databases.

The lake database in Azure Synapse Analytics enables you to bring together database design, meta information about the data that is stored and a possibility to describe how and where the data should be stored. Lake database addresses the challenge of today's data lakes where it is hard to understand how data is structured.

The tasks you will perform in this exercise are:

- Exercise 4 - Lake Databases and Database templates
  - Task 1 - Create and configure a lake database
  - Task 2 - Create a lake database table from data lake storage
  - Task 3 - Create a custom lake database table and map data into it
  - Task 4 - Create a complex lake database using database templates

## Task 1 - Create and configure a lake database

In this task you will create a new lake database.

1. In Synapse Studio, navigate to the `Data` hub, select the `Workspace` section and then select `+` followed by `Lake database (preview)` to trigger the creation of a new lake database.

   ![Initiate the creation of a lake database](./media/ex04-create-lake-database-1.png)

2. Configure the properties of the lake database as follows:

     - Name: `Database1`
     - Input folder: `database1/`
     - Data format: `Parquet`

    Select `Publish` to publish the new lake database.

    ![Configure lake database storage](./media/ex04-create-lake-database-2.png)

## Task 2 - Create a lake database table from data lake storage

In this task you will create a new lake database table using files from the data lake storage account.

1. In Synapse Studio, navigate to the `Data` hub and select the data lake account under `Linked`, `Azure Data Lake Storage Gen2`. Select the `database1` file system, and then select the `fact-sale` folder, followed by the `Day=20191201` folder. In this folder, locate the `sale-small-20191201-snappy.parquet` file.

   ![Explore data lake source data](./media/ex04-explore-data-lake-source-data.png)

2. In Synapse Studio, navigate to the `Data` hub, and select the `Workspace` section followed by `Lake database`. In the context menu associated with the `Database1` database, select `Open` to edit the lake database.

    In the database editor, select `+ Table` followed by `From data lake`.

   ![Create table from data lake storage](./media/ex04-create-table-from-data-lake.png)

3. Configure the properties of the new table as follows, then select `Continue`:

    - External table name: `FactSale`
    - Linked service: `asadatalake01`
    - Input file or folder: `database1/fact-sale`

   ![Configure table from data lake storage](./media/ex04-configure-table-from-data-lake.png)

3. Select `Preview Data`.

   ![Trigger data preview for table from data lake storage](./media/ex04-preview-table-from-data-lake-1.png)

4. Observe the data preview, then select `Create` to finalize the process.

   ![Preview data for table from data lake storage](./media/ex04-preview-table-from-data-lake-2.png)

5. In the table designer, select `Columns`, followed by `+ Column` and `Partition column`.

   ![Add partition column to table](./media/ex04-add-partition-column.png)

6. Use `Day` as the name of the partition column and `integer` as data type. Select `Publish` to publish the new table.

   ![Configure partition column](./media/ex04-configure-partition-column.png)

7. In Synapse Studio, navigate to the `Develop` hub and create a new SQL script. Make sure the `Built-in` serverless SQL pool is selected as well as the `Database1` database.

    Set the content of the script to the statement below and run the script.

    ```sql
    SELECT COUNT(*) FROM FactSale
    ```

   ![Query table from data lake](./media/ex04-query-table-from-data-lake.png)

## Task 3 - Create a manual lake database table and map data into it

In this task you will create manually a new lake database table and map data into it from the data lake storage account.

1. In Synapse Studio, navigate to the `Data` hub, and select the `Workspace` section followed by `Lake database`. In the context menu associated with the `Database1` database, select `Open` to edit the lake database.

   ![Open the lake database editor](./media/ex04-edit-lake-database.png)

2. In the database editor, select `+ Table` followed by `Custom`. Set the name of the table to `Customer`.

   ![Create a custom table](./media/ex04-custom-table-name.png)

3. In the table editor, select the `Columns` tab, add the following standard columns and then select `Publish`:

    - `CustomerId` (`PK`, type `integer`)
    - `FirstName` (type string)
    - `LastName` (type string)

   ![Create columns for the custom table](./media/ex04-custom-table-columns.png)

    >IMPORTANT
    >
    >The table must be published before advancing to the next step, otherwise the data flow debug session will not be able to start properly.

4. In the table editor, select `Map data (Preview)` to stard the Map Data tool. If this is the first time you are doing this, you might pe prompted to turn on data flow debug. If this happens, leave the default selections and select `OK` to start the data flow debug session.

   ![Start the Map Data tool](./media/ex04-start-map-data-tool.png)

   ![Start data flow debug session](./media/ex04-start-data-flow-debug-session.png)

5. In the `New data mapping` dialog, configure the following properties:

    - Source type: `Azure Data Lake Storage Gen2`
    - Source linked service: `asadatalake01`
    - Dataset type: `DelimitedText`
    - Folder path: `database1-staging1
    - Sources: select the `customer.csv` file

   ![Configure data mapping settings](./media/ex04-configure-data-mapping-1.png)

   Select `Continue` to proceed.

   ![Select source file for data mapping](./media/ex04-configure-data-mapping-2.png)

6. Configure the data mapping properties as follows:

    - Data mapping name: `Customer Mapping`
    - Target database: `Database1`

    Select `OK` to finalize the process.

   ![Configure data mapping target](./media/ex04-configure-data-mapping-3.png)

## Task 4 - Create a complex lake database using database templates

In this task you will use a lake database template from the Synapse Knowledge Center to create a complex lake database.

1. In Synapse Studio, navigate to the `Home` hub and then select `Knowledge center`.
  
   ![Open Synapse knowledge center](./media/ex04-open-knowledge-center.png)

2. In the Knowledge center, select `Browse gallery`.

   ![Browse gallery](./media/ex04-browse-gallery.png)

3. In the Gallery, select the `Database templates` tab and then select the `Banking` category.

   ![Create banking database](./media/ex04-create-banking-database.png)

4. Observe the set of tables and then select `Create database` to create a new lake database from the template.

   ![Preview the banking database](./media/ex04-create-banking-database-preview.png)

5. In Synapse Studio, open the newly created lake database in the editor and explore its content.

   ![Configure banking database](./media/ex04-configure-banking-database.png)
