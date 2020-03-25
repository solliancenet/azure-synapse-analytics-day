# Exercise 3 - Power BI integration

In this exercise, you will realize another benefit of the fully integrated environment provided by Azure Synapse Analytics. Here, you will create a Power BI Report and build a visualization within Synapse Analytics Studio. Once you have published a dataset, you will not have to leave this environment to log into a separate Power BI web site in order to view and edit reports. 

The Power BI Workspace has already been created for you.

## Task 1 - Create a Power BI dataset in Synapse
In this task, you will use Power BI Desktop to create the dataset used by the report.

1. Open Synapse Analytics Studio, and then navigate to the `Develop hub`.
2. Expand **Power BI** and then select **Power BI datasets**.

    ![Selecting Power BI datasets in the Develop panel](media/ex03-pbi-menu.png)

3. Select **New Power BI dataset** within the panel that appears.

    ![New Power BI dataset](media/ex03-new-pbi-dataset.png)

4. In the panel that appears, if a prompt appears to Install Power BI Desktop, click Start. 

    ![Select Start in first screen of wizard](media/ex03-pbids-install-pbidesktop.png)

5. In the step by step dialog that appears, hover over your SQL Pool and select the link that appears labeled **Download .pbids file**. 

    ![Selecting Download](media/ex03-download-pbid.png)

6. Open the downloaded .pbid file that was downloaded. This will launch Power BI desktop.

7.  When Power BI Desktop loads, select **Microsoft account**, then select **Sign in**. Follow the login prompts to login with the credential provided to you. When you return to the SQL Server database dialog, select **Connect**.

    ![Signing in with a Microsoft account](media/ex03-login-pbi.png)

8.  In the Navigator dialog, within the list of tables select **wwi.FactSale**, confirm the preview shows some data and then select Load.

    ![Selecting the wwi.FactSale table and viewing the preview](media/ex03-load-table-pbi.png)

9.  When prompted, set the query type to **Direct Query** and select **OK**.

    ![Selecting the wwi.FactSale table and viewing the preview](media/ex03-pbi-directquery.png)

10. From the **File** menu, select **Publish** and then select **Publish to Power BI**. If prompted to save your changes, select Save and provide a unique name for your file. This will also be the name used for the dataset.

    ![Selecting Publish to Power BI from the File menu](media/ex03-publish-menu.png)

11. In the dialog that appears, select the provided Power BI workspace (it should be the second option in the list). Do not select the item labeled My workspace. Choose **Select**.

    ![Selecting the correct Power BI workspace](media/ex03-select-workspace.png)

12. Return to your browser where you have Azure Synapse Studio open. Select **Close and refresh** in the New Power BI dataset dialog that should still be open.

    ![Closing the wizard dialog](media/ex03-close-and-refresh-pbids.png)

13. You should see your new Power BI dataset appear in the listing on the Power BI datasets panel. If not, select **Refresh**.

    ![Viewing the dataset listing](media/ex03-view-new-dataset.png)

## Task 2 - Create a Power BI report in Synapse
In this task, you will use the dataset you recently published to create a new Power BI report within Synapse Analytics Studio. 

1. Select your newly created dataset within the panel that appears. When you hover over the dataset, a button for creating a new Power BI report will appear. Select that button.

    ![Selecting new Power BI report from dataset](media/ex03-select-new-power-bi-report.png)

2. This will launch a new tabbed document with the Power BI report designer. Also note, that your new report appears under the Power BI reports folder in the `Develop hub`.

    ![Viewing the new Power BI report](media/ex03-new-report-document.png)

3. Within the Power BI designer, under Fields, select the fields **SalespersonKey** and **TotalExcludingTax**.

    ![Selecting the fields from the Fields list](media/ex03-pbi-choose-fields.png)

4. Under the Visualizations, drag the **SalespersonKey** field and drop it into the **Legend** field.

    ![Setting the Legend field](media/ex03-pbi-set-legend.png)

5. Under Visualizations, select the `100% Stacked column chart` visualization. You should now have a chart that lets you quickly assess each sales person's contribution to the total.

    ![Selecting the 100% Stacked column chart](media/ex03-pbi-stacked-col-viz.png)

6. From the file menu within the designer, select **Save As**. 

    ![Selecting Save As from the File menu](media/ex03-file-save-as.png)

7. In the dialog that appears, provide a unique name for your report and then select **Save**.

    ![The Save your report dialog](media/ex03-save-your-report.png)

8. This report is now available to all authorized users within Synsapse Analytics Studio and the Power BI workspace. 