# Exercise 4 - High Performance Analysis with SQL Analytics pool

In this exercise you will use several of the capabilities associated with SQL Pools to analyze the data.

## Task 1 - Use SQL Analytics pool query to understand a dataset

In this task you will try to understand who your best customers are.

**Challenge:** Can you author and run a query that will aggregate the total quantity of items purchased by customer and then visualize the result with a chart similar to the following?

![Example Chart](media/ex05-chart-sample.png)

Solution:
1.	Open Synapse Analytics Studio, and then navigate to the `Develop hub`.
2. Under SQL scripts, select the script called `Exercise 4 - Analyze Transactions`. 
3. Run the script against the SQL Pool database. 
4. When the results appear, for the **View** toggle, select **Chart**.
5. For the Chart type, select `Column`.
6. For the Category column, leave the selection at `(none)`.
7. For the Legend (series) column, select `CustomerKey`.

![Example Chart](media/ex05-chart.png)


