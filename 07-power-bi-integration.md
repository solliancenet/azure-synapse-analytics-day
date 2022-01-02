# Exercise 7 - Power BI integration

In this exercise, you will realize another benefit of the fully integrated environment provided by Azure Synapse Analytics. Here, you will create a Power BI Report and build a visualization within Synapse Analytics Studio. Once you have published a dataset, you will not have to leave this environment to log into a separate Power BI website to view and edit reports.

The Power BI Workspace has already been created for you.

The tasks you will perform in this exercise are:

- Exercise 7 - Power BI integration
  - Task 1 - Create a Power BI dataset in Synapse
  - Task 2 - Create a Power BI report in Synapse

---

**Important**:

In the tasks below, you will be asked to enter a unique identifier in several places. You can find your unique identifier by looking at the username you were provided for logging into the Azure portal. Your username is in the format `odl_user_UNIQUEID@msazurelabs.onmicrosoft.com`, where the _UNIQUEID_ component looks like `206184`, `206137`, or `205349`, as examples.

Please locate this value and note it for the steps below.

---

## Task 1 - Create a Power BI dataset in Synapse

In this task, you will use Power BI Desktop to create the dataset used by the report.

> Note: Power BI desktop will already be installed in the virtual machine provided with the lab environment.

1. Open Synapse Analytics Studio, and then navigate to the `Develop hub`.

   ![Develop hub.](media/develop-hub.png "Develop hub")

2. Expand **Power BI**, expand the first node under it, and then select **Power BI datasets**.

   ![Selecting Power BI datasets in the Develop panel](media/ex07-pbi-menu.png "Select Power BI datasets")

   > The second node, named `PowerBIWorkspace<UniqueId>`, is the Power BI workspace added to your Synapse workspace as a linked service.

3. Select **New Power BI dataset** within the panel that appears.

   ![New Power BI dataset](media/ex07-new-pbi-dataset.png "Select New Power BI dataset")

4. In the panel that appears, if a prompt appears to Install Power BI Desktop, select **Start**.

   ![Select Start in the first screen of wizard](media/ex07-pbids-install-pbidesktop.png "Select Start")

5. In the step by step dialog that appears, select `SQLPool01` and then select **Continue**.

   ![The SQLPool01 data source is selected.](media/ex07-pbid-select-data-source.png "Select a data source")

6. Select **Download** to download and save the suggested `pbids` file.

   ![Selecting Download](media/ex07-download-pbid.png "Download file")

7. Open the downloaded .pbids file. This will launch Power BI desktop.

8. When Power BI Desktop loads, select **Microsoft account**, then select **Sign in**. Follow the login prompts to login with the credential provided to you. When you return to the SQL Server database dialog, select **Connect**.

   ![Signing in with a Microsoft account](media/ex07-login-pbi.png "Sign in")

9. In the Navigator dialog, within the list of tables select **wwi.FactSale**, confirm the preview shows some data, and then select **Load**.

   ![Selecting the wwi.FactSale table and viewing the preview](media/ex07-load-table-pbi.png "Select table")

10. When prompted, set the query type to **Direct Query** and select **OK**.

    ![Selecting the wwi.FactSale table and viewing the preview](media/ex07-pbi-directquery.png "Set query type")

11. From the **File** menu, select **Publish** and then select **Publish to Power BI**. If prompted to save your changes, select Save and provide `wwifactsales` as the name. This will also be the name used for the dataset. You may be prompted to login a second time. Follow the login prompts to login with the credentials provided to you.

    ![Selecting Publish to Power BI from the File menu](media/ex07-publish-menu.png "Publish to Power BI")

12. In the dialog that appears, select the provided Power BI workspace (the first one that appears under the `Power BI` section in the `Develop` hub). Do not select the item labeled My workspace. Choose **Select**.

    ![Selecting the correct Power BI workspace](media/ex07-select-workspace.png "Select workspace")

13. Wait until the publishing dialog shows a status of **Success**, then click **Got it** to close the dialog.

    ![The publishing succeeded.](media/ex07-publishing-succeeded.png "Publishing to Power BI")

14. Return to your browser where you have Azure Synapse Studio open. Select **Close and refresh** in the New Power BI dataset dialog that should still be open.

    ![Closing the wizard dialog](media/ex07-close-and-refresh-pbids.png "Close the wizard")

15. You should see your new Power BI dataset appear in the listing on the Power BI datasets panel. If not, select **Refresh**.

    ![Viewing the dataset listing](media/ex07-view-new-dataset.png "Browse datasets")

## Task 2 - Create a Power BI report in Synapse

In this task, you will learn how to use a collaborative approach to create a new Power BI report within Synapse Analytics Studio. To do this, you will use a dataset that was not created by you.

1. Select the `wwifactsales` dataset within the panel that appears. When you hover over the dataset, a button for creating a new Power BI report will appear. Select that button.

   ![Selecting new Power BI report from dataset](media/ex07-select-new-power-bi-report.png "Select dataset")

2. This will launch a new tabbed document with the Power BI report designer. Also note, that your new report appears under the Power BI reports folder in the `Develop` hub.

   ![Viewing the new Power BI report](media/ex07-new-report-document.png "View report")

---

**Important**:

If you do not see a list of data fields under Fields, follow the steps below for a fix.

1. Navigate to [www.powerbi.com](https://www.powerbi.com) on a new browser tab. Select **Sign In** and use the credential provided to you.

2. Select `Workspaces` from the left menu and select the `PowerBIWorkspace` as shown in the screenshot.

   ![Selecting the right workspace to work on](media/ex07-selecting-workspace.png "Selecting the right workspace to work on")

3. Navigate to **Settings (2)**, then select **Settings (3)** from the menu.

   ![The Settings menu is displayed.](media/pbi-settings.png "Settings")

4. Select the **Datasets** tab. From the list of datasets select `wwifactsales`, then select **Edit credentials** underneath the **Data Source credentials** section.

   ![Changing settings for the wwifactsales dataset](media/ex07-setting-dataset-credentials.png "Changing settings for the wwifactsales dataset")

5. Under **Authentication Method** select `OAuth2` and select **Sign In**.

   ![Selecting the right workspace to work on](media/ex07-enter-dataset-credentials.png "Selecting the right workspace to work on")

6. Navigate back to your Synapse workspace in the previous tab and select the **refresh** button above the Fields list in the Power BI report. After a few seconds, you should see the list of fields below. Alternatively, you may refresh your browser window.

   ![The refresh button above the fields list is highlighted.](media/ex07-pbi-refresh.png "Refresh")

7. Within the Power BI Designer, select **Line and clustered column chart** under Visualizations.

   ![The visualization is highlighted.](media/ex07-pbi-line-clustered-column-chart-vis.png "Line and clustered column chart")

8. Drag the **SalespersonKey** field into **Shared axis** for the visualization. Then drag the **TotalExcludingTax** field into **Column values**. Finally, drag the **Profit** field into **Line values**.

   ![The field values are displayed as described above.](media/ex07-visualization-fields.png "Visualization fields")

9. Resize the line and clustered column chart visualization to fit the report area. Your visualization should look like the following:

   ![The visualization is highlighted on the report canvas.](media/ex07-pbi-visualization-no-filter.png "Completed visualization")

10. Under the **Filters** pane, expand the **Profit** filter **(1)**. Select **is greater than** under `Show items when the value:` **(2)**, then enter **50000000** for the value. Select **Apply filter (3)**.

    ![The filter is configured as described above.](media/ex07-pbi-apply-filter.png "Profit filter")

11. After a few seconds, you should see the visualization change based on the filter. In this case, we narrow down the results to only those where the total profit amount is greater than $50 million. Since we are using Direct Query, Power BI pushed down the filter to the dedicated SQL pool (SQLPool01) to execute a new query based on the filter parameters. The pool sent back the results to Power BI to re-render the chart. Since we are dealing with a vast number of records (over 12 million), harnessing the dedicated SQL pool's power to aggregate and filter the data rather than importing them and using the Power BI engine to do the work is much more efficient.

    ![The filtered visualization is displayed.](media/ex07-pbi-filtered-visualization.png "Filtered visualization")

12. From the file menu within the designer, select **Save As**.

    ![Selecting Save As from the File menu](media/ex07-file-save-as.png "Save As")

13. In the dialog that appears, enter **Key Sales by Person** for the name, then select **Save**.

    ![The save dialog is displayed.](media/ex07-pbi-save-report.png "Save your report")

14. This report is now available to all authorized users within Synapse Analytics Studio and the Power BI workspace.

## Task 3 - View the SQL query

1. Navigate to the **Monitor** hub.

   ![Monitor hub.](media/monitor-hub.png "Monitor hub")

2. Select **SQL requests** in the left-hand menu **(1)**, then select **SQLPool01** under the Pool filter **(2)**. Look at the list of recent queries executed by your lab username as the Submitter. Hover over one of these queries to see the **Request content** button next to the `SQL request ID` value **(3)** to view the executed query.

   ![The list of SQL requests is displayed.](media/ex07-sql-requests.png "SQL requests")

3. View the queries' request content until you find one that contains the SQL SELECT statement executed by your filter in the Power BI report. Here you can see the `Profit` and `TotalExcludingTax` fields have the SUM aggregate, and the `wwi.FactSale` table is grouped by `SalespersonKey`. A WHERE clause filters the rows by `Profit` (aliased as `a0`) where the value is greater than or equal to `50000000` ($50 million). Power BI generated the SQL script, then used the dedicated SQL pool to execute the query and send back the results.

   ![The SQL query is displayed as described above.](media/ex07-pbi-sql-statement.png "Request content")
