# Explore the Data Lake with SQL Analytics on-demand and Spark

In this exercise you will explore data using the engine of your choices (SQL or Spark).

Understanding data through data exploration is one of the core challenges faced today by data engineers and data scientists as well. Depending on the underlying structure of the data as well as the specific requirements of the exploration process, different data processing engines will offer varying degrees of performance, complexity, and flexibility.

In Azure Synapse Analytics, you have the possibility of using either the on-demand SQL engine, the big-data Spark engine, or both.

- [Explore the Data Lake with SQL Analytics on-demand and Spark](#explore-the-data-lake-with-sql-analytics-on-demand-and-spark)
  - [Task 1 - Explore the Data Lake with SQL Analytics on-demand](#task-1---explore-the-data-lake-with-sql-analytics-on-demand)
  - [Task 2 - Explore the Data Lake with Spark](#task-2---explore-the-data-lake-with-spark)

## Task 1 - Explore the Data Lake with SQL Analytics on-demand

In this task, you will browse your data lake using SQL on-demand.

1. Open the [Azure Portal](https://portal.azure.com) and sign in

1. Browse to the `Synapse-Analytics-xx` resource group

1. Select the Synapse workspace, then select the Workspace web URL.

1. Open Synapse Analytics Studio, and then navigate to the `Data` hub.

1. Under `Storage accounts`, expand the storage account node, then expand the storage account and select the `wwi` file system.

1. Inside the selected file system, navigate to `factsale-parquet` -> `2012` -> `Q1` -> `InvoiceDateKey=2012-01-01` folder

1. Right-click the Parquet file, and select `New SQL script - Select TOP 100 rows`.  A script is automatically generated.

   ![Start new SQL script from data lake file](./media/ex01-sql-on-demand-01.png "Create a new SQL script from the file")

1. Ensure the newly created script is connected to the `SQL on-demand` pool and then select `Run`. Data is loaded by the on-demand SQL pool and processed as if was coming from any regular relational database.

   ![Run SQL script on data lake file](./media/ex01-sql-on-demand-02.png "Execute the script")

1. Let's change the initial script to load multiple Parquet files at once. In line 2, replace `TOP 100 *` with `COUNT(*)`.

1. In line 5, replace the path to the individual file with `https://asadatalake02.dfs.core.windows.net/wwi/factsale-parquet/2012/Q1/*/*`.

> **Note** Be sure to update with your workspace number.

1. Select `Run` to re-run the script.

   ![Run SQL on-demand script loading multiple Parquet data lake files](./media/ex01-sql-on-demand-03.png "Run the modified script")

1. In Azure Synapse Analytics Studio, in the left navigation, navigate to the `Develop` hub, select the `Exercise 1 - Read with SQL on-demand` SQL script, and then select `Run`.

   ![Run SQL on-demand script loading multiple CSV data lake files](./media/ex01-sql-on-demand-04.png "Run the CSV based script")

   > This query demonstrates the same functionality, except this time it loads CSV files instead of Parquet ones (notice the `factsale-csv` folder in the path).

## Task 2 - Explore the Data Lake with Spark

1. Navigate to the `Data` hub, browse to the storage account folder `wwi/factsale-parquet/2012/Q1/InvoiceDateKey=2012-01-01`, right click the Parquet file and select `New notebook`.

   ![Start new Spark notebook from data lake file](./media/ex01-spark-notebook-01.png "Create a new Spark notebook")

2. This will generate a notebook with PySpark code to load the data in a dataframe and display 100 rows with the header.

   ![New Spark notebook from data lake file](./media/ex01-spark-notebook-02.png "Review the notebook")

3. If not already attached, attach the notebook to a Spark pool and run the command.

   ![Run Spark notebook on data lake file](./media/ex01-spark-notebook-03.png "If needed, attach the notebook to a Spark pool")

   > **Note** The first time you run a notebook in a Spark pool, Synapse creates a new session. It can take a few minutes to start the session.

4. As you can see, the output is not formatted very well. To change this, replace the last line of code with the following:

   ```python
   display(data_path.limit(100))
   ```

5. Run the notebook again to see the improved display.

   ![Improve dataset formatting in Spark notebook](./media/ex01-spark-notebook-04.png "Execute the improved notebook")

6. Select the **Chart** toggle. Notice the included charting capabilities that enable visual exploration of your data.

   ![View charts on data in Spark notebook](./media/ex01-spark-notebook-05.png "Review the charted data")

7. In Azure Synapse Analytics Studio, navigate to the `Develop` hub, select the `Exercise 1 - Read with Spark` notebook, and then select `Run`. It can take a minute or two to start the session and execute the notebook.

   ![Run Spark notebook loading multiple CSV data lake files](./media/ex01-spark-notebook-06.png "Run the Spark notebook")

   > This notebook demonstrates the same functionality, except this time it loads CSV files instead of Parquet ones (notice the `factsale-csv` folder in the path).

8. Close the recently opened `Notebook 1` tab, select **Discard changes**.

9. Close the `Exercise 1 - Read with Spark` tab, select **Discard changes**.
