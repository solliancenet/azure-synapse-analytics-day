Exercise 1: Add an Aggregation Table
In this exercise, you will configure dimension tables as dual storage mode table. You will then create an aggregation table to boost Power BI query performance for date, geography, and profit reporting.
Task 1: Configure Dual Storage
In this task, you will configure dual storage for all dimension tables.
1.	Switch to the Power BI Desktop solution you developed in Lab 02A.
2.	Switch to Model view.
3.	While pressing the Ctrl key, multi-select each of the five dimension tables:
•	Customer
•	Date
•	Geography
•	Product
•	Salesperson
4.	In the Properties pane, from within the Advanced section, in the Storage Mode dropdown list, select Dual.
 
It’s common to set dimension tables to use dual storage mode. This way, when used by report slicers, they deliver fast performance.
5.	When prompted to set the storage mode, click OK.
 
 
6.	When the refresh completes, save the Power BI Desktop solution.
The data model is now in mixed mode. It’s a composite model consisting of DirectQuery storage mode tables and import storage mode tables.
7.	In File Explorer, notice the file size has grown as a result of the imported data for the dimension tables.
When the model stores data, you need to ensure the cached data current. The model must be refreshed on a frequent basis to ensure import data is in sync with the source data.
8.	In Report view, in the status bar, at the bottom-right, notice that the storage mode is now mixed.
 
9.	In the Performance Analyzer pane, start recording, and then refresh visuals.
10.	Notice that the query result for the slicer is now sub-second.
Task 2: Create an Aggregation Table
In this task, you will create an aggregation table to accelerate Power BI report visuals that specifically query by date and geography, and summarize profit.
1.	To open the Power Query Editor window, on the Home ribbon tab, from inside the Queries group, click the Transform Data icon.
 
 
2.	In the Power Query Editor window, from inside the Queries pane, right-click the Sale query, and then select Duplicate.
 
3.	In the Queries pane, notice the addition of a new query.
 
You’ll apply a transformation to group by the CityKey and InvoiceDateKey columns, and aggregate the sum of Profit Amount column.
4.	Rename the query as Sale Agg.
 
 
5.	On the Transform ribbon tab, from inside the Table group, click Group By.
 
6.	In the Group By window, select the Advanced option.
 
The advanced option allows grouping by more than one column.
7.	In the grouping dropdown list, ensure that CityKey is selected.
 
8.	Click Add Grouping.
9.	In the second grouping dropdown list, select InvoiceDateKey.
10.	In the New Column Name box, replace the text with Profit Amount.
11.	In the Operation dropdown list, select Sum.
12.	In the Column dropdown list, select Profit Amount.
 
13.	Click OK.
 
14.	On the Home ribbon tab, from inside the Close group, click the Close & Apply icon.
 
A new table is added to the model.
15.	Save the Power BI Desktop solution.
Task 3: Configure Aggregations
In this task, you will switch the aggregation table to import data. You will then create model relationships to the aggregation table and manage aggregations.
1.	Switch to Model view.
2.	Position the Sale Agg table so that it is near the Geography and Date tables.
3.	Set the storage mode for the Sale Agg table as Import.
 
 
4.	Create two model relationships:
•	Relate the Sale Agg table CityKey column to the Geography table CityKey column
•	Relate the Sale Agg table InvoiceDateKey column to the Date table Date column
 
5.	Right-click the Sale Agg table, and then select Manage Aggregations.
 
6.	In the Manage Aggregations window, for the Profit Amount aggregation column, set the following properties:
•	Summarization: Sum
•	Detail table: Sale
•	Detail column: Profit Amount
 
7.	Notice the warning that describes the table will be hidden.
The table will be hidden in a different way to other hidden model objects (like the key columns you hid in Lab 02A). Aggregation tables are always hidden, and they can’t even be referenced in model calculations.
8.	Click Apply All.
 
9.	In the model diagram, notice that the Sale Agg table is now hidden.
 
10.	In the model diagram, select the Sale Agg table.
Because the Geography and Date tables use dual storage mode, when a report visual queries them at the same time as the aggregation table, Power BI will query the model cache. There’s no need to use DirectQuery to query the data.
11.	Switch to Report view.
12.	In the Performance Analyzer pane, start recording, and then refresh visuals.
13.	Notice that the query results for the table visual is now sub-second.
14.	In the Performance Analyzer pane, stop recording.
