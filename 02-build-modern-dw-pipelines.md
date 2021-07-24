# Exercise 2 - Working with Azure Synapse Pipelines

In this exercise, you examine various methods for ingesting data into Azure Synapse Analytics and Azure Data Lake Storage Gen2. You use notebooks and Data Flows to ingest, transform, and load data.

The tasks you will perform in this exercise are:

- Working with Azure Synapse Pipelines
  - Task 1 - Explore and modify a notebook
    - Bonus Challenge
  - Task 2 - Explore, modify, and run a Pipeline containing a Data Flow
  - Task 3 - Monitor pipelines
    - Bonus Discovery
  - Task 4 - Monitor Spark applications

---

**Important**:

In the tasks below, you will be asked to enter a unique identifier in several places. You can find your unique identifier by looking at the username you were provided for logging into the Azure portal. Your username is in the format `odl_user_UNIQUEID@msazurelabs.onmicrosoft.com`, where the _UNIQUEID_ component looks like `206184`, `206137`, or `205349`, as examples.

Please locate this value and note it for the steps below.

---

## Task 1 - Explore and modify a notebook

In this task, you see how easy it is to write into a dedicated SQL pool table with Spark thanks to the SQL Analytics Connector. Notebooks are used to write the code required to write to dedicated SQL pool tables using Spark.

1. **Note:** If you still have your notebook open from the end of Exercise 1, **skip ahead** to step 3 below. Otherwise, in Synapse Studio, select **Develop** from the left-hand menu.

   ![Develop is selected and highlighted in the Synapse Analytics menu.](media/develop-hub.png "Develop hub")

2. Select **+**, then **Notebook** to add a new notebook.

   ![The new notebook menu item is highlighted.](media/new-notebook.png "New notebook")

3. If not already attached, attach your Apache Spark pool by selecting it from the **Attach to (1)** drop-down list, then select **{} Add code (3)** to create a new cell.

   ![The Spark pool is selected in the Attach to drop-down.](media/new-notebook-add-code.png "Add code")

   **Note:** If you are using your notebook from the end of Exercise 1, hover over the area just below the cell in the notebook, then select **{} Add code** to add a new cell.

   ![The add code button is highlighted.](media/add-cell.png "Add code")

4. Paste the following into the new cell, and **replace** `YOUR_DATALAKE_NAME` with the name of your **Storage Account Name** provided in the environment details section on Lab Environment tab on the right. You can also copy it from the first cell of the notebook if you are using the same one from Exercise 1.

    ```scala
    %%spark

    // Set the path to read the WWI Sales files
    import org.apache.spark.sql.SparkSession

    // Set the path to the ADLS Gen2 account
    val adlsPath = "abfss://wwi@YOUR_DATALAKE_NAME.dfs.core.windows.net"
    ```

    Select the **Run cell** button to execute the new cell:

    ![The new cell is displayed.](media/ex02-notebook-cell1.png "Run cell")

    > This cell imports required libraries and sets the `adlsPath` variable, which defines the path used to connect to an Azure Data Lake Storage (ADLS) Gen2 account. Connecting to ADLS Gen2 from a notebook in Azure Synapse Analytics uses the power of Azure Active Directory (AAD) pass-through between compute and storage. The `%%spark` "magic" sets the cell language to Scala, which is required to use the `SparkSession` library.

5. Hover over the area just below the cell in the notebook, then select **{} Add code** to add a new cell.

    ![The add code button is highlighted.](media/add-cell.png "Add code")

6. Paste the following and run the new cell:

    ```scala
    %%spark

    // Read the sales into a dataframe
    val sales = spark.read.format("csv").option("header", "true").option("inferSchema", "true").option("sep", "|").load(s"$adlsPath/factsale-csv/2012/Q4")
    sales.show(5)
    sales.printSchema()
    ```

    This code loads data from CSV files in the data lake into a DataSet. Note the `option` parameters in the `read` command. These options specify the settings to use when reading the CSV files. The options tell Spark that the first row of each file containers the column headers, the separator in the files in the `|` character, and that we want Spark to infer the schema of the files based on an analysis of the contents of each column. Finally, we display the first five records of the data retrieved and print the inferred schema to the screen.

7. When the cell finishes running, take a moment to review the associated output.

    > The output of this cell provides some insight into the structure of the data and the data types that have been inferred. The `show(5)` command results in the first five rows of the data read being output, allowing you to see the columns and a sample of data contained within each. The `printSchema()` command outputs a list of columns and their inferred types.

    ![The output from the execution of the cell is displayed, with the result of the show(5) command shown first, followed by the output from the printSchema() command.](media/ex02-notebook-ingest-cell-2-output.png "Cell output")

8. Hover over the area just below the cell in the notebook, then select **{} Add code** to add a new cell.

    ![The add code button is highlighted.](media/add-cell.png "Add code")

9. Paste the following and run the new cell:

    ```scala
    %%spark

    // Import libraries for the SQL Analytics connector
    import com.microsoft.spark.sqlanalytics.utils.Constants
    import org.apache.spark.sql.SqlAnalyticsConnector._
    import org.apache.spark.sql.SaveMode

    // Set target table name
    var tableName = s"SQLPool01.wwi_staging.Sale"

    // Write the retrieved sales data into a staging table in Azure Synapse Analytics.
    sales.limit(10000).write.mode(SaveMode.Append).sqlanalytics(tableName, Constants.INTERNAL)
    ```

    This code writes the data retrieved from Blob Storage into a staging table in Azure Synapse Analytics using the SQL Analytics connector. Using the connector simplifies connecting to Azure Synapse Analytics because it uses AAD pass-through. There is no need to create a password, identity, external table, or format sources, as it is all managed by the connector.

10. As the cell runs, select the arrow icon below the cell to expand the details for the Spark job.

    > This pane allows you to monitor the underlying Spark jobs and observe the status of each. As you can see, the cell is split into two Spark jobs, and the progress of each can be observed. We will take a more in-depth look at monitoring Spark applications in Task 4 below.

    ![The Spark job status pane is displayed below the cell, with the progress of each Spark job visible.](media/ex02-notebook-ingest-cell-3-spark-job.png "Spark Job status")

11. After approximately 1-2 minutes, the execution of Cell 3 will complete. Once it has finished, select **Data** from the left-hand menu.

    ![Data is selected and highlighted in the Synapse Analytics menu.](media/data-hub.png "Data hub")

12. **Important**: Close the notebook by selecting the **X** in the top right of the tab and then select **Close + discard changes**. Closing the notebook will ensure you free up the allocated resources on the Spark Pool.

    ![The Close + discard changes button is highlighted.](media/notebook-close-discard-changes.png "Discard changes?")

13. Under **Workspace** tab **(1)**, expand **Databases** **(2)** and then expand the **SQLPool01** database **(3)**.

    ![The Databases folder is expanded, showing a list of databases within the Azure Synapse Analytics workspace. SQLPool01 is expanded and highlighted.](media/ex02-databasesqlpool.png "Synapse Analytics Databases")

14. Expand **Tables** and locate the table named `wwi_staging.Sale`.

    > If you do not see the table, select the Actions ellipsis next to Tables and then select **Refresh** from the fly-out menu.

    ![The new wwi_staging.Sale table is displayed.](media/data-staging-sales.png "New Sale table")

15. To the right of the `wwi_staging.Sale` table, select the Actions ellipsis.

    ![The Actions ellipsis button is highlighted next to the wwi_staging.Sale_UNIQUEID table.](media/ex02-data-sqlpool01-tables-staging-wwi-sales-data-actions.png "Synapse Analytics Databases")

16. In the Actions menu, select **New SQL script > Select TOP 100 rows**.

    ![In the Actions menu for the wwi_staging.Sale table, New SQL script > Select TOP 100 rows is highlighted.](media/ex02-data-sqlpool01-tables-staging-wwi-sales-data-actions-select.png "Synapse Analytics Databases")

17. Select **Run** to execute the query. Observe the results in the output pane, and notice how easy it was to use Spark notebooks to write data from Blob Storage into Azure Synapse Analytics in Steps 9 and 10.

    ![The output of the SQL statement is displayed.](media/staging-sale-output.png "Sale script output")

18. Close the SQL script generated by `wwi_staging.Sale`.

### Bonus challenge

Now, take some time to review the **Exercise 2 - Bonus Notebook with CSharp** notebook.

1. In Synapse Studio, select **Develop** from the left-hand menu. Expand **Notebooks** and select the notebook named `Exercise 2 - Bonus Notebook with CSharp`.

   ![Open bonus notebook with CSharp from Develop hub](./media/ex02-csharp-for-spark-notebook.png "Open bonus notebook with CSharp from Develop hub")

2. Notice the language of choice being .NET Spark C# **(1)**:

   ![CSharp for Spark](./media/ex02-csharp-for-spark.png)

    This notebook demonstrates how easy it is to create and run notebooks using C# for Spark. The notebook shows the code for retrieving Azure Blob Storage data and writing that into a staging table in Azure Synapse Analytics using a JDBC connection.

    You can run each cell in this notebook and observe the output. Be aware, however, that writing data into a staging table in Azure Synapse Analytics with this notebook takes several minutes, so you don't need to wait on the notebook to finish before attempting to query the `wwi_staging.Sale_CSharp` table to observe the data being written or to move on to the next task.

3. Select **Run all (2)** and start the notebook.

To observe the data being written into the table:

1. Select **Data** from the left-hand menu, select the Workspace tab, then expand Databases, SQLPool01, and Tables.

2. Right-click the table named `wwi_staging.Sale_CSharp` **(1)**, and choose **New SQL Script (2)** then **SELECT TOP 100 rows (3)**.

   ![A new Select Top 100 rows window command is selected for wwi_staging.Sale_CSharp.](media/sale-csharp-new-script.png "New Script Window")
   > If you do not see the table, select the Actions ellipsis next to Tables, and then select **Refresh** from the fly-out menu.

3. Replace the `SELECT` query in the editor with the query below:

   ```sql
   SELECT COUNT(*) FROM [wwi_staging].[Sale_CSharp]
   ```

4. Select **Run** on the toolbar.

   > Re-run the query every 5-10 seconds to watch the record count in the table and how it changes as the notebook is adding new records. The script in the notebook limits the number of rows to 1500, so if you see a count of 1500, the notebook has completed processing.

5. **Important**: Close the notebook by selecting the **X** in the top right of the tab and then select **Discard Changes**. Closing the notebook will ensure you free up the allocated resources on the Spark Pool.

## Task 2 - Explore, modify, and run a Pipeline containing a Data Flow and Code-free AI

In this task, you use a Pipeline that implements Code-free AI to do sentiment analysis on customer feedback and contains a Data Flow to explore, transform, and load data into an Azure Synapse Analytics table. Using Cognitive Services and data flows in Pipelines allows you to handle code-free AI workloads, perform data ingestion and transformations, similar to what you did in Task 1, but without writing any code.

1. In Synapse Studio and select **Integrate** from the left-hand menu.

   ![Integrate hub.](media/integrate-hub.png "Integrate hub")

2. In the Integrate menu, expand **Pipelines**, then select **Exercise 2 - Enrich Data**.

   ![The Enrich Data pipeline is selected.](media/enrich-data-pipeline.png "Pipelines")

   > Selecting a pipeline opens the pipeline canvas, where you can review and edit the pipeline using a code-free, graphical interface. This view shows the various activities within the pipeline and the links and relationships between those activities. The `Exercise 2 - Enrich Data` pipeline contains four activities;
   >
   > - a Lookup activity named `ReadComments` reading customer comments
   > - a ForEach loop named `ForEachComment` iterating through comments and running Sentiment Analysis with Azure Cognitive Services
   > - a copy data activity named `Import Customer dimension`
   > - a mapping data flow activity named `Enrich Customer Data`.

3. Now, take a closer look at each of the activities within the pipeline. On the canvas graph, select the **Lookup** activity named `ReadComments` and switch to the **Settings** tab. The source dataset is set to a CSV files stored in the data lake.

    > A lookup activity reads and returns the content of a file which can be consumed in a subsequent copy, transformation, or control flow activities like ForEach activity. The Lookup activity output supports up to 4 MB in size. In this case, the source is set to a single CSV file that is much smaller. For larger data sets multiple source files can be used.

   ![The Settings tab of the ReadCOmments Lookup Activity is selected. Source dataset is highlighted.](media/enrich-data-pipeline-readcomments.png "Read Comments")

4. From the canvas graph, select the **ForEach (1)** activity named `ForEachComment` and switch to the **Settings (2)** tab. The **Items** property is set to receive the output of the previous `ReadComments` activity. You might have noticed the green connection line between the two activities that define a dependency between the two activities. The line makes sure comments are read before the ForEach loop can iterate it. Select the edit button **(4)** in the ForEach activity's Activities box to navigate into the loop.

   ![ForEachComments ForEach activity is selected. Settings tab is shown. Items property is highlighted.](media/enrich-data-pipeline-foreach.png "ForEach Loop")

5. Select **Copy data** activity named `Sentiment Analysis` and switch to the **Source** tab. The Copy Data activity's Source dataset is set to a REST resource **(3)** backed by Azure Cognitive Services. A POST **(4)** HTTP request will be made to the Azure Cognitive Services endpoint carrying a request body (5) that includes the text from the current iteration that will be analyzed for sentiments.

    ![Copy data activity named Sentiment Analysis is selected. Source tab is open. Source dataset is set to a REST Data Source. Request body and method are highlighted.](media/data-enrichment-pipeline-sentiment-analysis-activity.png "Copy Data REST Source")

6. Switch to the **Sink (1)** tab. Here, the sink dataset is set to a JSON file location in the data lake. Once the Copy data activity gets the result of the sentiment analysis from the remote REST resource endpoint, the result will be saved as separate JSON files into the Sink dataset **(2)**. The files will include a complete sentiment analysis for the customer comment that can be queried and analyzed further. Select **Exercise 2 - Enrich Data (3)** link to go back to the main pipeline canvas.

   ![Copy data activity named Sentiment Analysis is selected. Sink tab is open. Sink dataset is set to a JSON Data Source. ](media/data-enrichment-pipeline-sentiment-analysis-activity-sink.png "Sentiment Sink")

7. On the canvas graph, select the **Copy data** activity named `Import Customer dimension`.

    > Below the graph is a series of tabs, each providing additional details about the selected activity. The **General** tab displays the name and description assigned to the activity and a few other properties.

    ![A screenshot of Exercise 2 - Enrich Data pipeline canvas and properties pane is displayed.](media/ex02-orchestrate-copy-data-general.png "Pipeline canvas")

8. Select the **Source** tab. The source defines the location from which the activity will copy data. The **Source dataset** field is a pointer to the location of the source data.

    > Take a moment to review the various properties available on the Source tab. Data is being retrieved from files stored in a data lake.

    ![The Source tab for the Copy data activity is selected and highlighted.](media/ex02-orchestrate-copy-data-source.png "Pipeline canvas property tabs")

9. Next, select the **Sink (1)** tab. The sink specifies where the copied data will be written. Like the Source, the sink uses a dataset to define a pointer to the target data store. Select **PolyBase (2)** for the `Copy method`. This improves the data loading speed as compared to the default setting of bulk insert.

    ![The Sink tab for the Copy data activity is selected and highlighted.](media/ex02-orchestrate-copy-data-sink.png "Pipeline canvas property tabs")

    > Reviewing the fields on this tab, you will notice that it is possible to define the copy method, table options, and to provide pre-copy scripts to execute. Also, take special note of the sink dataset, `wwi_staging_dimcustomer_asa`. The dataset requires a parameter named `UniqueId`, which is populated using a substring of the Pipeline Run Id. This dataset points to the `wwi_staging.DimCustomer_UniqueId` table in Synapse Analytics, which is one of the data sources for the Mapping Data Flow. We will need to ensure that the copy activity successfully populates this table before running the data flow.

10. Select the **Mapping** tab. On this tab, you can review and set the column mappings. As you can see on this tab, the spaces are being removed from the sink's column names.

    ![The Mappings tab for the Copy data activity is highlighted and displayed.](media/ex02-orchestrate-copy-data-mapping.png "Pipeline canvas property tabs")

11. Finally, select the **Settings (1)** tab. Check **Enable staging (2)** and expand `Staging settings`. Select **asadatalake01** under `Staging account linked service` **(3)**, then type **staging** into `Storage Path`. Finally, check **Enable Compression**.

    ![The staging settings are configured as described.](media/copy-data-settings.png "Settings")

    > Since we are using PolyBase with dynamic file properties, owing to the UniqueId values, we need to [enable staging](https://docs.microsoft.com/azure/data-factory/connector-azure-sql-data-warehouse#staged-copy-by-using-polybase). In cases of large file movement activities, configuring a staging path for the copy activity can improve performance.

12. Switch to the **Mapping Data Flow (1)** activity by selecting the `Enrich Customer Data` Mapping Data Flow activity on the pipeline design canvas, then select the **Settings (2)** tab.

    ![The data flow activity settings are displayed.](media/pipeline-data-flow-settings.png "Settings")

    > Observe the settings configurable on this tab. They include parameters to pass into the data flow, the Integration Runtime, and compute resource type and size to use. If you wish to use staging, you can also specify that here.

13. Next, select the **Parameters** tab in the configuration panel of the Mapping Data Flow activity.

    ![The Parameters table on the configuration panel of the Mapping Data Flow activity is selected and highlighted.](media/ex02-orchestrate-data-flow-parameters.png "Mapping Data Flow activity")

    Notice that the value contains:

    ```sql
    @substring(pipeline().RunId,0,8)
    ```

    > This sets the UniqueId parameter required by the `EnrichCustomerData` data flow to a unique substring extracted from the pipeline run ID.

14. Take a minute to look at the options available on the various tabs in the configuration panel. You will notice the properties here define how the data flow operates within the pipeline.

15. Now, let us look at the data flow definition the Mapping Data Flow activity references. Double-click the **Mapping Data Flow** activity on the pipeline canvas to open the underlying Data Flow in a new tab.

    > **Important**: Typically, when working with Data Flows, you would want to enable **Data flow debug**. [Debug mode](https://docs.microsoft.com/azure/data-factory/concepts-data-flow-debug-mode) creates a Spark cluster to use for interactively testing each step of the data flow and allows you to validate the output before saving and running the data flow. Enabling a debugging session can take up to 10 minutes, so you will not enable this for this workshop. Screenshots will be used to provide details that would otherwise require a debug session to view.

    ![The EnrichCustomerData Data Flow canvas is displayed.](media/ex02-orchestrate-data-flow.png "Data Flow canvas")

16. The [Data Flow canvas](https://docs.microsoft.com/azure/data-factory/concepts-data-flow-overview#data-flow-canvas) allows you to see the construction of the data flow and each component contained within it in greater detail.

    > From a high level, the `EnrichCustomerData` data flow is composed of two data sources, multiple transformations, and two sinks. The data source components, `PostalCodes` and `DimCustomer`, ingest data into the data flow. The `EnrichedCustomerData` and `EnrichedCustomerDataAdls` components on the right are sinks, used to write data to data stores. The remaining components between the sources and sinks are transformation steps, which can perform filtering, joins, select, and other transformational actions on the ingested data.

    ![On the data flow canvas, the components are broken down into three sections. Section number 1 is labeled data sources and contains the PostalCodes and DimCustomer components. Section number 2 is labeled Transformations, and contains the PostCodeFilter, JoinOnPostalCode, and SelectDesiredColumns components. Section number 3 is labeled sinks, and contains the EnrichedCustomerData and EnrichedCustomerDataAdls components.](media/ex02-orchestrate-data-flow-components.png "Data flow canvas")

17. To better understand how a data flow functions, let us inspect the various components. Select the `PostalCodes` data source on the data flow canvas.

    > On the **Source settings** tab, we see properties similar to what we saw on the pipeline activities property tabs. The name of the component can be defined, along with the source dataset and a few other properties. The `PostalCodes` dataset points to a CSV file stored in an Azure Data Lake Storage Gen2 account.

    ![The PostalCodes data source component is highlighted on the data flow canvas surface.](media/ex02-orchestrate-data-flow-sources-postal-codes.png "Data flow canvas")

18. Select the **Projection** tab.

    > The **Projections** tab allows you to define the schema of the data being ingested from a data source. A schema is required for each data source in a data flow to enable downstream transformations to perform actions against the data source fields. Note that selecting **Import schema** requires an active debug session to retrieve the schema data from the underlying data source, as it uses the Spark cluster to read the schema. In the screenshot above, notice the `Zip` column is highlighted. The schema inferred by the import process set the column type to `integer`. For US zip code data, the data type was changed to `string` so leading zeros are not discarded from the five-digit zip codes. It is essential to review the schema to ensure the correct types are set, both for working with the data and to ensure it is displayed and stored correctly in the data sink.

    ![The Projections tab for the PostalCodes data source is selected, and the Zip column of the imported schema is highlighted.](media/ex02-orchestrate-data-flow-sources-postal-codes-projection.png "Data flow canvas")

19. The **Data preview** tab allows you to ingest a small subset of data and view it on the canvas. This functionality requires an active debug session, so for this workshop, a screenshot that displays the execution results for that tab is provided below.

    > The `Zip` column is highlighted on the Data preview tab to show a sample of the values contained within that field. Below, you will filter the list of zip codes down to those that appear in the customer dataset.

    ![The Data preview tab is highlighted and selected. The Zip column is highlighted on the Data preview tab.](media/ex02-orchestrate-data-flow-sources-postal-codes-data-preview.png "Data flow canvas")

20. Before looking at the `PostalCodeFilter`, quickly select the `+` **(1)** button to the right of the `PostalCodes` data source to display a list of available transformations **(2)**.

    > Take a moment to browse the list of transformations available in Mapping Data Flows. From this list, you get an idea of the types of transformations possible using data flows. Transformations are broken down into three categories, **multiple inputs/outputs**, **schema modifiers**, and **row modifiers**. You can learn about each transformation in the docs by reading the [Mapping data flow transformation overview](https://docs.microsoft.com/azure/data-factory/data-flow-transformation-overview) article.

    ![The + button next to PostalCodes is highlighted, and the menu of available transformations is displayed.](media/ex02-orchestrate-data-flow-available-transformations.png "Data flow canvas")

21. Next, select the `PostalCodeFilter` transformation in the graph on the data flow canvas.

    ![The PostalCodeFilter transformation is highlighted on the data flow canvas graph.](media/ex02-orchestrate-data-flow-transformations-filter.png "Data flow canvas")

22. In the **Filter settings** tab of the configuration panel, click anywhere inside the **Filter on** box.

    ![The Filter on box is highlighted in the configuration panel for the PostalCodeFilter transformation.](media/ex02-orchestrate-data-flow-transformations-filter-on.png "Data flow canvas")

23. This will open the Visual expression builder.

    > In mapping data flows, many transformation properties are entered as expressions. These expressions are composed of column values, parameters, functions, operators, and literals that evaluate to a Spark data type at run time. To learn more, visit the [Build expressions in mapping data flow](https://docs.microsoft.com/azure/data-factory/concepts-data-flow-expression-builder) page in the documentation.

    ![The Visual expression builder is displayed.](media/ex02-orchestrate-data-flow-expression-builder.png "Visual expression builder")

24. The filter currently applied ensures all zip codes are between 90000 and 98000. Observe the different expression elements and values in the area below the expression box that help you create and modify filters and other expressions.

25. Select **Cancel** to close the visual expression builder.

26. Select the `DimCustomer` **(1)** data source on the data flow canvas graph.

    > Take a few minutes to review the various tabs in the configuration panel for this data source to better understand how it is configured, as you did above. Note that this data source relies on the `wwi_staging.DimCustomer_UniqueId` table from Azure Synapse Analytics for its data. `UniqueId` is supplied by a parameter to the data flow, which contains a substring of the Pipeline Run Id. Before running the pipeline, you will add a dependency to the Mapping Data Flow activity to ensure the Copy activity has populated the `wwi_staging.DimCustomer_UniqueId` in Azure Synapse Analytics before allowing the data flow to execute.

    ![The DimCustomer data source is highlighted on the data flow canvas graph.](media/ex02-orchestrate-data-flow-sources-dim-customer.png "Data flow canvas")

27. Next, select the `JoinOnPostalCode` **(1)** transformation and ensure the **Join settings** tab **(2)** is selected to see how you can join datasets using a simple and intuitive graphical interface.

    > The **Join settings** tab allows you to specify the data sources being joined and the join types and conditions. Notice the **Right stream** points to the `PostalCodeFilter` and not the `PostalCodes` data source directly. By referencing the filtered dataset, the join works with a smaller set of postal codes. For extensive datasets, this can provide performance benefits.

    ![The JoinOnPostalCode transformation is highlighted in the graph, and the Join settings tab is highlighted in the configuration panel.](media/ex02-orchestrate-data-flow-transformations-join.png "Data flow canvas")

28. Moving on to the next transformation, the `SelectDesiredColumns` transformation uses a **Select** schema modifier to allow choosing what columns to include.

    > You have probably noticed that the `SelectDesiredColumns` transformation appears twice in the graph. To enable writing the resulting dataset to two different sinks, Azure Synapse Analytics and Azure Data Lake Storage Gen2, a **Conditional split** multiple outputs transformation is required. This split is displayed in the graph as a repeat of the split item.

    ![The SelectDesiredColumns transformation is highlighted in the data flow graph.](media/ex02-orchestrate-data-flow-transformations-select.png "Data flow canvas")

29. The last two items in the data flow are the defined sinks. These provide the connection settings necessary to write the transformed data into the desired data sink. Select the `EnrichCustomerData` **(1)** sink and inspect the settings on the **Sink** tab **(2)**.

    ![The Sink tab is displayed for the EnrichCustomerData sink, which is highlighted in the graph.](media/ex02-orchestrate-data-flow-sink-sink.png "Data flow canvas")

30. Next, select the **Settings** tab and observe the properties set there.

    > The **Settings** tab defines how data is written into the target table in Azure Synapse Analytics. The Update method has been set only to allow inserts, and the table action is set to recreate the table whenever the data flow runs.

    ![The Settings tab is selected and highlighted in the configuration panel. On the tab, the Allow insert and Recreate table options are highlighted.](media/ex02-orchestrate-data-flow-sink-settings.png "Data flow canvas")

31. Now that you have taken the time to review the data flow, let us return to the pipeline. On the canvas, select the **Exercise 2 - Enrich Data** tab.

    ![The Exercise 2 - Enrich Data tab is highlighted on the canvas.](media/ex02-orchestrate-canvas-tabs-pipeline.png "Data pipeline canvas")

32. Before running the pipeline there is one more change we need to make. As mentioned above, the data flow depends on the data written by the copy activity, so you will add a dependency between the two activities.

33. In the data flow canvas graph, select the green box on the right-hand side of the **Copy data** activity and drag the resulting arrow up onto the **Mapping Data Flow** activity.

    ![The green box on the right-hand side of the Copy data activity is highlighted, and the arrow has been dragged onto the Mapping Data Flow.](media/ex02-orchestrate-pipelines-create-dependency.png "Data pipeline canvas")

34. This creates a requirement that the **Copy data** activity completes successfully before the **Mapping Data Flow** can execute and enforces our condition of the Synapse Analytics table being populated before running the data flow.

    ![The dependency arrow going from the Copy data activity to the Mapping Data Flow is displayed.](media/ex02-orchestrate-pipelines-create-dependency-complete.png "Data pipeline canvas")

35. The last step before running the pipeline is to publish the changes you have made. Select **Publish all** on the toolbar.

    ![The Publish all button is highlighted on the Synapse Studio toolbar.](media/ex02-orchestrate-pipelines-publish-all.png "Publish")

36. On the **Publish all** dialog, select **Publish**.

    > This Publish all dialog allows you to review the changes that will be saved.

37. Within a few seconds, you _may_ receive a notification that the publish is completed. If so, select **Dismiss** in the notification.

    ![The publishing completed notification is displayed.](media/ex02-publishing-completed.png "Publishing completed")

38. Your pipeline is now ready to run. Select **Add trigger (1)** then **Trigger now (2)** on the toolbar for the pipeline.

    ![Add trigger is highlighted on the pipeline toolbar, and Trigger now is highlighted in the fly-out menu.](media/ex02-orchestrate-pipelines-trigger-now.png "Trigger pipeline")

39. Select **OK** on the Pipeline run dialog to start the pipeline run.

    ![The OK button is highlighted in the Pipeline run dialog.](media/ex02-orchestrate-pipelines-trigger-run.png "Pipeline run trigger")

40. To monitor the pipeline run, move on to the next task.

## Task 3 - Monitor pipelines

After you finish building and debugging your data flow and its associated pipeline, you will want to monitor the execution of the pipeline and all of the activities contained within it, including the Data Flow activity. In this task, you review the [pipeline monitoring functionality in Azure Synapse Analytics](https://docs.microsoft.com/azure/data-factory/concepts-data-flow-monitoring) using the pipeline run you initiated at the end of the previous task.

1. In Synapse Studio, select **Monitor** from the left-hand menu.

   ![Monitor is selected and highlighted in the Synapse Analytics menu.](media/monitor-hub.png "Synapse Analytics menu")

2. Under Integration, select **Pipeline runs**.

   ![Pipeline runs is selected and highlighted under the Orchestration section of the monitor resource list.](media/ex02-monitor-pipeline-runs.png "Synapse Analytics Monitor")

3. Select the `Exercise 2 - Enrich Data_A03` pipeline the list. This will have a status of `In progress`.

   ![The first "Exercise 2 - Enrich Data" item in the list of pipeline runs is highlighted.](media/ex02-monitoring-pipeline-runs.png "Pipeline run list")

4. On the pipeline run details screen, you will see a graphical representation of the activities within the pipeline, as well as a list of the individual activity runs. Both provide status indicators for each activity.

   > This view allows you to monitor the overall status of the pipeline run, and observe each activity's status within the pipeline. The screen will auto-refresh for five minutes. If auto-refresh does not occur or your pipeline run takes longer than five minutes, you can get updates by selecting the Refresh button on the canvas toolbar.

   ![The pipeline run canvas is displayed, with activities list in the graph and in a list for in the Activity runs panel.](media/ex02-monitoring-pipeline-runs-details.png "Pipeline run details")

5. To get a better understanding of the types of information you can get from the monitoring capabilities, let us explore what information is available for each activity in the Activity runs list. Start by hovering your mouse cursor over the **Import Customer dimension** activity and select the **Output** icon that appears.

   ![The output icon is highlighted on the Import Customer dimension activity row.](media/ex02-monitoring-copy-activity-output.png "Copy activity output")

6. In the **Output** dialog, you will see details about the size of data read and written, the number of rows read and copied, the duration of the copy activity, and other information relating to the copy activity run. This information can be used for things like troubleshooting. For example, you could compare the copy run to data, such as the number of rows read and written, to expected numbers from the source and sink.

   ![The Output dialog for the Import Customer dimension activity is displayed.](media/ex02-monitoring-copy-activity-output-details.png "Copy activity output")

7. Close the Output dialog.

8. Next, hover your mouse cursor over the **Import Customer dimension** activity again, this time selecting the **Details** icon that appears.

   ![The Details icon is highlighted on the Import Customer dimension activity row.](media/ex02-monitoring-copy-activity.png "Copy activity run")

9. The **Details** dialog provides the data found on the Output dialog examine above but expands on that to include graphics for the source, staging storage, and sink, and a more detailed look at the activity run.

   ![The Details dialog for the copy activity is displayed.](media/ex02-monitoring-copy-activity-details.png "Copy activity details")

10. Close the Details dialog.

11. When the pipeline execution completes, all activity runs will reflect a status of Succeeded.

    ![A screenshot of the activity runs for the Exercise 2 - Enrich Data pipeline is displayed with all activities showing a status of Succeeded.](media/ex02-monitor-ex2-enrich-data-activity-runs-succeeded.png "Pipeline run monitoring")

12. When the **Enrich Customer Data** activity has a status of **Complete**, hover your mouse cursor over the **Enrich Customer Data** activity and select the **Details** icon that appears.

    > **Note**: It can take 5-7 minutes for the **Enrich Customer Data** activity to complete. You may need to select **Refresh** on the Monitoring toolbar to see the status update if your pipeline run takes longer than five minutes.

    ![The Details icon is highlighted on the Enrich Customer Data Mapping Data Flow activity row.](media/ex02-monitoring-data-flow.png "Data flow activity")

13. The Details dialog for data flow details takes you to a full-screen view of your data flow.

    > The initial view provides a details panel containing statistics for the sinks defined within the data flow. The information for these includes the number of rows written and the processing times for writing to each sink.

    ![The data flow Details dialog is displayed.](media/ex02-monitoring-data-flow-details.png "Data Flow activity details")

14. Select the **SelectDesiredColumns** transformation step of the data flow.

    > Selecting any component of the data flow opens a new panel with details about the processing that occurred for that component.

    ![The SelectDesiredColumns transformation step is highlighted in the graph on the details dialog.](media/ex02-monitoring-data-flow-select.png "Data Flow activity details")

15. Try selecting another component, such as the **EnrichCustomerData** sink, and view the information available.

    ![The EnrichCustomerData sink component is highlighted in the graph, and the associated details panel is displayed on the right-hand side of the screen.](media/ex02-monitoring-data-flow-sink.png "Data Flow activity details")

16. Close the data flow activity Details dialog by selecting the **X** on the right-hand side of the toolbar.

    ![The X (close) button is highlighted on the data flow Details dialog toolbar.](media/ex02-monitor-data-flow-close.png "Data flow details")

17. Back on Exercise 2 - Enrich Data pipeline run screen, switch to the Gantt view. This view provides a graphical representation of the run times of the various activities within the pipeline.

    ![The Gantt view option is selected and highlighted on the pipeline run dialog.](media/ex02-monitoring-ex2-enrich-data-activity-runs-gantt.png "Pipeline run Gantt view")

### Bonus discovery

Remember the sentiment analysis task we had in our Exercise 2 - Enrich Data pipeline? Once your pipeline's execution is complete we have some sentiment data we can look into.

1. Go to the **Data** Hub and navigate to the `dev > bronze > sentiment` **(2)** folder in the primary data lake account **(1)**. Select all the files and right click to select **New SQL script > Select TOP 100 rows**.

   ![dev > bronze > sentiment folder in the Workspace data lake account is shown. All files are selected. Right click context menu is open. New SQL script > Select TOP 100 rows command is highlighted.](media/query-sentiment-json-files.png "Sentiment Folder")

2. Replace the top part of the query **(1)** with the code below. Select **Run (2)** to execute the final query.

    ```sql
    SELECT 
        jsonContent,
        JSON_VALUE (jsonContent, '$.documents[0].sentiment') AS Sentiment,
        JSON_VALUE (jsonContent, '$.documents[0].id') AS CustomerId
    FROM
    ```

    ![A JSON SQL Query is shown. Sentiment Analysis results are listed.](media/sentiment-json-query-result.png "JSON Query for Sentiments")

    Your query targets the JSON files created as the result of the Sentiment analysis run through Azure Cognitive Services. Here you see a simple query that shows the list of Customer IDs and how their feedback is interpreted in the context of sentiment reflection.

## Task 4 - Monitor Spark applications

In this task, you examine the Apache Spark application monitoring capabilities built into Azure Synapse Analytics. The Spark application monitoring screens provide a view into the logs for the Spark application, including a graphical view of those logs.

1. As you did in the previous task, select **Monitor** from the left-hand menu.

   ![Monitor is selected and highlighted in the Synapse Analytics menu.](media/monitor-hub.png "Synapse Analytics menu")

2. Next, select **Apache Spark applications** under Activities.

   ![Apache Spark applications is selected and highlighted under the Activities section of the monitor resource list.](media/ex02-monitor-activities-spark.png "Synapse Analytics Monitor")

3. On the Apache Spark applications page, select the **Submit time** value and observe the available options for limiting the time range for Spark applications that are displayed in the list. In this case, you are looking at the current run, so ensure **Last 24 hours** is selected and then select **OK**.

   ![Last 24 hours is selected and highlighted in the Time range list.](media/ex02-monitor-activities-spark-time-range.png "Synapse Analytics Monitor")

4. From the list of Spark applications, select the first job, which should have a status of `In progress` or `Succeeded`.

   ![The current Spark application is highlighted in the applications list.](media/ex02-monitor-activities-spark-application-list.png "Synapse Analytics Monitor")

5. On the **Dataflow** screen, you will see a detailed view of the job, broken into three different sections.

   - The first section is a summary of the Spark application.
   - The second section is a graphical representation of the jobs that make up the Spark application.
   - The third section displays the diagnostics and logs associated with the Spark application.

   ![A screenshot of the Log query screen is displayed.](media/ex02-monitor-activities-spark-application-dataflow.png "Synapse Analytics Monitor")

6. Select the **Logs** tab to view the log output. You may switch between log sources and types using the dropdown lists below.

    ![The Spark application logs are displayed.](media/ex02-monitor-activities-spark-application-logs.png "Logs")

7. To look closer at any individual job, you can use the **Job IDs** drop-down to select the job number.

    ![Job 2 is highlighted in the Job IDs drop-down list.](media/ex02-monitor-activities-spark-applications-all-job-ids-2.png "Synapse Analytics Monitor")

8. This view isolates the specific job within the graphical view.

    ![Job 2 is displayed.](media/ex02-monitor-activities-spark-applications-job-2.png "Synapse Analytics Monitor")

9. Return the view to all jobs by selecting **All job IDs** in the job ID drop-down list.

    ![All job IDs is highlighted in the Job IDs drop-down list.](media/ex02-monitor-activities-spark-applications-all-job-ids.png "Synapse Analytics Monitor")

10. Within the graph section, you also have the ability to **Playback** the Spark application.

    ![The Playback button is highlighted.](media/ex02-monitor-activities-spark-applications-playback.png "Synapse Analytics Monitor")

    > **Note**: Playback functionality is not available until the job status changes out of the `In progress` status. The job's status will remain listed as `In progress` until the underlying Spark resources are cleaned up by Azure Synapse Analytics, which can take some time.

11. Running a Playback allows you to observe the time required to complete each job, as well as review the rows read or written as the job progresses.

    ![A screenshot of an in-progress playback is displayed. The playback is at 8s into the Spark application run, and Job 2 is showing progress.](media/ex02-monitor-activities-spark-applications-playback-progress.png "Synapse Analytics Monitor")

12. You can also perform playback on an individual job. Returning to a view of only Job 2, the **Playback** button shows the rows written at this job, and the progress of reads and writes.

    ![A screenshot of an in-progress playback for Job 2 is displayed.](media/ex02-monitor-activities-spark-applications-playback-job-2.png "Synapse Analytics Monitor")

13. You can also change the view to see which jobs involved read and write activities. Select **All job IDs** in the job dropdown, and in the **View** drop-down, select **Read**. You can see which jobs performed reads, with each color-coded by how much data was read.

    ![Read is selected and highlighted in the Display drop-down list.](media/ex02-monitor-activities-spark-applications-display-drop-down-read-graph.png "Synapse Analytics Monitor")
