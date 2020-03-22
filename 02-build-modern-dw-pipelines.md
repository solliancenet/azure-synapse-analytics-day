# Build Modern Data Warehouse pipelines

In this exercise, you examine various methods for ingesting data into Azure Synapse Analytics and Azure Data Lake Storage Gen2. You use notebooks and Data Flows to ingest, transform, and load data.

## Task 1 - Explore and modify a notebook

In this task, you will see how easy it is to write into a SQL Pool table with Spark thanks to the SQL Analytics Connector.

1. In Synapse Analytics Studio, select **Develop** from the left-hand menu.

   ![Develop is selected and highlighted in the Synapse Analytics menu.](media/studio-menu-develop.png "Synapse Analytics menu")

2. In the Develop menu, expand **Notebooks** and select the notebook named **Exercise 2 - Ingest Sales Data**.

   ![The Exercise 2 - Ingest Sales Data notebook is selected and highlighted in the list of notebooks.](media/studio-notebooks-ex2-ingest.png "Synapse Analytics Notebooks")

3. Attach your Spark Compute by selecting it from the **Attach to** drop-down list.

   ![The Spark pool is selected in the Attach to drop-down.](media/studio-notebooks-toolbar-attach-to.png "Synapse Analytics Notebooks")

4. Ensure Spark (Scala) is selected in the Language drop-down list.

   ![Spark (Scala) is selected in the Language drop-down.](media/studio-notebooks-toolbar-language.png "Synapse Analytics Notebooks")

5. At the bottom left corner of the open notebook, select **Configure session**.

   ![The Configure session link is highlighted.](media/studio-notebooks-configure-session-link.png "Synapse Analytics Notebooks")

6. In the Configure session dialog, enter the following:

   - **Executors**: Enter 3.
   - **Executor size**: Select Medium (8 vCPU, 56GB memory).

   ![In the Configure session dialog, Step 1 indicated to set Executors 3, Step 2 indicates to set Executor size to Medium, and Step 3 says to select the Apply button.](media/studio-notebooks-configure-session.png "Synapse Analytics Notebooks")

7. Select **Apply** in the Configure session dialog.

8. Publish the notebook to save the changes by selecting **Publish** on the notebook toolbar.

   ![The Publish button on the notebook toolbar is highlighted.](media/studio-notebooks-toolbar-publish.png "Synapse Analytics Notebooks")

9. Select **Run all** from the notebook toolbar to execute each cell within the notebook.

   ![The Run all button on the notebook toolbar is highlighted.](media/studio-notebooks-toolbar-run-all.png "Synapse Analytics Notebooks")

10. While the notebook is running, let's take a look at what is happening in each cell.

    - **Cell 1** sets the required configuration to connect to an Azure Blob Storage account. A SAS token is used to restrict the notebook to only read and list actions on the storage account container.

    ![Cell 1 of the notebook is displayed.](media/studio-notebooks-ex2-ingest-cell-1.png "Synapse Analytics Notebooks")

    - **Cell 2** loads data from CSV files in the Blob Storage account into a DataSet. Note the `option` parameters indicate that the first row of the files containers the column headers and that we want Spark to infer the schema of the files based on an analysis of the contents of each column. Finally, we display the first five records of the data retrieved and print the inferred schema to the screen.

    ![Cell 2 of the notebook is displayed.](media/studio-notebooks-ex2-ingest-cell-2.png "Synapse Analytics Notebooks")

    - **Cell 3** writes the data retrieve from Blob Storage into a staging table in Azure Synapse Analytics using the SQL Analytics connector.

    ![Cell 3 of the notebook is displayed.](media/studio-notebooks-ex2-ingest-cell-3.png "Synapse Analytics Notebooks")

11. When Cell 2 finishes running, take a moment to review the associated output.

    ![The output from the execution of Cell 2 is displayed, with the result of the show(5) command shown first, followed by the output from the printSchema() command.](media/studio-notebooks-ex2-ingest-cell-2-output.png "Synapse Analytics Notebooks")

    > The output of Cell 2 provides some insight into the structure of the data and the data types that have been inferred. The `show(5)` command results in the first five rows of the data read being output, allowing you to see the columns and a sample of data contained within each. The `printSchema()` command outputs a list of columns and their inferred types.

12. Next scroll down to Cell 3 and select the arrow icon below the cell to expand the details for the Spark job.

    ![The Spark job status pane is displayed below Cell 3, with the progress of each Spark job visible.](media/studio-notebooks-ex2-ingest-cell-3-spark-job.png "Synapse Analytics Notebooks")

    > This pane allows you to monitor the underlying Spark jobs, and observe the status of each. As you can see, Cell 3 is split into two Spark jobs and the progress of each can be observed. We will take a deeper look at monitoring Spark applications in Task 4 below.

13. When the execution of Cell 3 completes, select **Data** from the left-hand menu.

    ![Data is selected and highlighted in the Synapse Analytics menu.](media/studio-menu-data.png "Synapse Analytics menu")

14. Expand **Databases** and then expand the **SQLPool01** database.

    ![The Databases folder is expanded, showing a list of databases within the Azure Synapse Analytics workspace. SQLPool01 is expanded and highlighted.](media/studio-data-sqlpool01.png "Synapse Analytics Databases")

15. Expand **Tables** and locate the table named `staging.WwiSalesData`.

    ![The list of tables in the SQLPool01 database is expanded and the staging.WwiSalesData table is highlighted.](media/studio-data-sqlpool01-tables-staging-wwi-sales-data.png "Synapse Analytics Databases")

16. To the right of the `staging.WwiSalesData` table, select the Actions ellipsis.

    ![The Actions ellipsis button is highlighted next to the staging.WwiSalesData table.](media/studio-data-sqlpool01-tables-staging-wwi-sales-data-actions.png "Synapse Analytics Databases")

17. In the Actions menu, select **New SQL script > Select TOP 1000 rows**.

    ![In the Actions menu for the staging.WwiSalesData table, New SQL script > Select TOP 1000 rows is highlighted.](media/studio-data-sqlpool01-tables-staging-wwi-sales-data-actions-select.png "Synapse Analytics Databases")

18. Observe the results in the output pane, and see how easy it was to use Spark notebooks to write data from Blob Storage into Azure Synapse Analytics.

### Bonus Challenge

Now, take some time to review the **Exercise 2 - Bonus Notebook with CSharp** notebook. This notebook demonstrates how easy it is create and run notebooks using C# for Spark. The notebook shows the code for retrieving data from Azure Blob Storage and writing that into a staging table in Azure Synapse Analytics using a JDBC connection.

Run each cell in this notebook and observe the output. Be aware, however, that writing data into a staging table in Azure Synapse Analytics with this notebook takes a long time, so you don't need to wait on the notebook to finish before attempting to query the `staging.WwiSalesDataCSharp` table to observe the data being written or to move on to the next task.

## Task 2 - Explore, modify, and run a Data Flow

In this task, you use a Pipeline containing a Data Flow to explore, transform and load data into an Azure Synapse Analytics table. Using pipelines and data flows allows you to perform data ingestion and transformations, like you did in Task 1, without having to write any code.

TODO: Start by adding the Ingest notebook to a pipeline? And then, build out a data flow by adding it to that pipeline

1. In Synapse Analytics Studio, select **Develop** from the left-hand menu.

   ![Develop is selected and highlighted in the Synapse Analytics menu.](media/studio-menu-develop.png "Synapse Analytics menu")

2. In the Develop menu, expand **Data flows** and select the data flow named **EnrichCustomerData**.

   studio-data-flows--enrich-customer-data

TODO: Add the notebook from Task 1 to the pipeline? This would require adding something to drop the staging table, since it is currently failing if the table exists.

## Task 3 - Monitor pipelines

In this task, you review the pipeline monitoring functionality in Azure Synapse Analytics.

1. Select **Monitor** from the left-hand menu.

   ![Monitor is selected and highlighted in the Synapse Analytics menu.](media/studio-menu-monitor.png "Synapse Analytics menu")

2. Under Orchestration, select **Pipeline runs**.

   ![Pipeline runs is selected and highlighted under the Orchestration section of the monitor resource list.](media/studio-monitor-pipeline-runs.png "Synapse Analytics Monitor")

## Task 4 - Monitor Spark applications

In this task, you examine the Apache Spark application monitoring capabilities built into Azure Synapse Analytics. The Spark application monitoring screens provides a view into the logs for the Spark application, including a graphical view of those logs.

1. As you did in the previous task, select **Monitor** from the left-hand menu.

   ![Monitor is selected and highlighted in the Synapse Analytics menu.](media/studio-menu-monitor.png "Synapse Analytics menu")

2. Next, select **Apache Spark applications** under Activities.

   ![Apache Spark applications is selected and highlighted under the Activities section of the monitor resource list.](media/studio-monitor-activities-spark.png "Synapse Analytics Monitor")

3. On the Apache Spark applications page, select the **Submit time** value and observe the available options for limiting the time range for Spark applications that are displayed in the list. In this case, you are looking at the current run, so ensure **Last 24 hours** is selected and then select **OK**.

   ![Last 24 hours is selected and highlighted in the Time range list.](media/studio-monitor-activities-spark-time-range.png "Synapse Analytics Monitor")

4. From the list of Spark applications, select the first job, which should have a status of `In progress`.

   TODO: Check on this status, as it should really be Complete or Success, but doesn't seem to update correctly.

   ![The current Spark application is highlighted in the applications list.](media/studio-monitor-activities-spark-application-list.png "Synapse Analytics Monitor")

5. On the **Log query** screen, you will see a detailed view of the job, broken into three different sections.

   - The first section is a graphical representation of the stages that make up the Spark application.
   - The second section is a summary of the Spark application.
   - The third section displays the logs associated with the Spark application.

   ![A screenshot of the Log query screen is displayed.](media/studio-monitor-activities-spark-application-log-query.png "Synapse Analytics Monitor")

6. In the graph section, the initial graph displayed is that of the overall job progress. Here, you can see the progress of each stage.

   ![The stage progress section of each Stage panel is highlighted.](media/studio-monitor-activities-spark-applications-progress.png "Synapse Analytics Monitor")

7. Selecting any individual stage from the graph opens a new browser window showing the selected stage in the Spark UI, where you can dive even deeper into the tasks that make up each stage. Select **Stage 5** and observe the information displayed in Spark UI.

   ![Details for Stage 5 are displayed in the Spark UI.](media/studio-monitor-activities-spark-application-stage-5-spark-ui.png "Spark UI")

8. Return to the Synapse Analytics Monitoring page for your Spark application.

9. To look closer at any individual stage, you can use the **Job IDs** drop-down to select the stage number. In this case, select the drop-down and choose **5** from the list.

   ![Stage 5 is highlighted in the Job IDs drop-down list.](media/studio-monitor-activities-spark-applications-all-job-ids-5.png "Synapse Analytics Monitor")

10. This view isolates the specific stage within the graphical view.

    ![Stage 5 is displayed.](media/studio-monitor-activities-spark-applications-stage-5.png "Synapse Analytics Monitor")

11. Return the view to all stages by selecting **All job IDs** in the job ID drop-down list.

    ![All job IDs is highlighted in the Job IDs drop-down list.](media/studio-monitor-activities-spark-applications-all-job-ids.png "Synapse Analytics Monitor")

12. Within the graph section, you also have the ability to **Playback** the Spark application.

    ![The Playback button is highlighted.](media/studio-monitor-activities-spark-applications-playback.png "Synapse Analytics Monitor")

    > **Note**: Playback functionality is not available until the job status changes out of the `In progress` status. The job's status will remain listed as `In progress` until the underlying Spark resources are cleaned up by Azure Synapse Analytics, which can take some time.

13. Running a Playback allows you to observe the time required to complete each stage, as well as review the rows read or written as the job progresses.

    ![A screenshot of an in-progress playback is displayed. The playback is at 1m 49s into the Spark application run, and Stage 6 is showing a Stage progress of 6.25%.](media/studio-monitor-activities-spark-applications-playback-progress.png "Synapse Analytics Monitor")

14. You can also preform a playback on an individual stage. Returning to a view of only Stage 5, the **Playback** button shows the rows written at this stage, along with the progress of reads and writes.

    ![A screenshot of an in-progress playback for Stage 5 is displayed, with the stage progress showing 43.75% complete.](media/studio-monitor-activities-spark-applications-playback-stage-5.png "Synapse Analytics Monitor")

15. You can also change the view to see which stages were involved in read and write activities. In the **Display** drop-down, select **Read**.

    ![Read is selected and highlighted in the Display drop-down list.](media/studio-monitor-activities-spark-applications-display-drop-down-read.png "Synapse Analytics Monitor")

16. In the read graph, stages that involved read tasks are highlighted in orange.

    ![In the graph, stages that involved read tasks are highlighted in orange.](media/studio-monitor-activities-spark-applications-display-read.png "Synapse Analytics Monitor")

17. Next, select **Written** from the Display drop-down list, and observe the stages where data was written.

    ![In the graph, stages where data was written are highlighted in orange.](media/studio-monitor-activities-spark-applications-display-written.png "Synapse Analytics Monitor")
