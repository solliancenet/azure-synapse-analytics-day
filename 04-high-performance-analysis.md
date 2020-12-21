# Exercise 4 - High-Performance Analysis with Azure Synapse Dedicated SQL Pools

In this exercise, you will use several of the capabilities associated with dedicated SQL Pools to analyze the data.

SQL data warehouses have been for a long time the centers of gravity in data platforms. Modern data warehouses can provide high performance, distributed, and governed workloads, regardless of the data volumes at hand.

The dedicated SQL pool in Azure Synapse is the new incarnation of the former Azure SQL Data Warehouse. It provides all the modern SQL data warehousing features while benefiting from the advanced integration with all the other Synapse services.

The tasks you will perform in this exercise are:

- Exercise 4 - High-Performance Analysis with Azure Synapse Dedicated SQL Pools
  - Task 1 - Use a dedicated SQL pool query to understand a dataset
  - Task 2 - Investigate query performance and table design
    - Bonus Challenge

> **Note**: The tasks in this exercise must be run against the dedicated SQL pool (as opposed to the ones from exercise 1, which were run against the serverless SQL pool
named "built-in" pool). Make sure you have `SQLPool01` selected before running each query:

![Run queries against a dedicated SQL pool](./media/ex04-run-on-sql-pool.png)

## Task 1 - Use a SQL Synapse Pool query to understand a dataset

In this task, you will try to understand who your best customers are.

**Challenge:** Can you author and run a query that will aggregate the total quantity of items purchased by the customer and then visualize the result with a chart similar to the following?

![Example Chart](media/ex05-chart-sample.png "Example chart")

**Solution:**

1. Open Synapse Analytics Studio, and then navigate to the `Develop` hub.
2. Under `SQL scripts`, select the script called `Exercise 4 - Analyze Transactions`.
3. Change the **Connect to** drop-down to the **SQLPool01** database.
4. Select **Run** to execute the script against the SQL Pool database.
5. When the results appear, for the **View** toggle, select **Chart**.
6. For the Chart type, select `Column`.
7. For the Category column, leave the selection at `(none)`.
8. For the Legend (series) column, select `CustomerKey`.

![Example Chart](media/ex05-chart.png "Example chart")

## Task 2 - Investigate query performance and table design

In this task, you will try to understand the implications of the table design at a general level. You will run the same set of queries against two fact tables (`FactSale_Fast` and `FactSale_Slow`). The two fact tables have (with one notable exception) the same structure and contain identical data.

First, let us set the stage by performing the following steps:

1. Under **SQL Scripts** in the `Develop` hub within Synapse Analytics Studio, select the script called `Exercise 4 - Investigate query performance`.
2. Change the **Connect to** drop-down to the **SQLPool01** database.
3. Select line 1 and then select `Run`.

   ![Run a count on FactSale_Slow](./media/ex04-query-selection-01.png "Run script")

   Notice the quick response time (usually under 3 seconds) and the result - 83.4 million records. If SQLPool was configured with DW500c, then it would be under 1 second.

4. Select line 3 and then select `Run`.

   ![Run a count on FactSale_Fast](./media/ex04-query-selection-02.png "Run script")

  Notice the quick response time (usually under 3 seconds) and the result - 83.4 million records. If SQLPool was configured with DW500c, then it would be under 1 second.

5. Select lines 5 to 20 and then select `Run`.

   ![Run a complex query on FactSale_Slow](./media/ex04-query-selection-03.png "Run script")

   Re-run the query 3 to 5 times until the execution time stabilizes (usually, the first "cold" execution takes longer than subsequent ones who benefit from the initialization of various internal data and communications buffers). Make a note of the amount of time needed to run the query (typically 15 to 30 seconds).

6. Select lines 22 to 37 and then select `Run`.

   ![Run a complex query on FactSale_Fast](./media/ex04-query-selection-04.png "Run script")

   Re-run the query 3 to 5 times until the execution time stabilizes (usually, the first "cold" execution takes longer than subsequent ones who benefit from the initialization of various internal data and communications buffers). Make a note on the amount of time needed to run the query (typically 3 to 5 seconds).

## Bonus Challenge

Can you explain the significant difference in performance between the two seemingly identical tables? Furthermore, can you explain why the first set of queries (the simple counts) were not that further apart in execution times?

**Solution:**

1. In Synapse Analytics Studio, navigate to the `Data` hub.
2. Under Databases, expand the `SQLPool01` node, expand `Tables`, and locate the `wwi_perf.FactSale_Slow` table.
3. Right-click the table **(1)** and then select `New SQL script` **(2)**, `CREATE` **(3)**.

   ![View table structure](./media/ex04-view-table-definition.png "Table structure")

4. In the CREATE script, note the `DISTRIBUTION = ROUND_ROBIN` option used to distribute the table.

   ![View Round-Robin Distribution](./media/ex04-view-round-robin.png "Round-Robin Distribution")

5. Repeat the same actions for the `wwi_perf.FactSale_Fast` table and note the `DISTRIBUTION = HASH ( [CustomerKey] )` option used to distribute the table.

   ![View Hash Distribution](./media/ex04-view-hash-distribution.png "Hash Distribution")
 
This is the critical difference that has such a significant impact on the last two queries' performance. Because `wwi_perf.FactSale_Slow` is distributed in a round-robin fashion, each customer's data will end up living in multiple (if not all) distributions. When our query needs to consolidate each customer's data, a lot of data movement will occur between the distributions. This is what slows down the query significantly.

On the other hand, `wwi_perf.FactSale_Fast` is distributed using the hash of the customer identifier. This means that each customer's data will end up living in a single distribution. When the query needs to consolidate each customer's data, virtually no data movement occurs between distributions, which makes the query very fast.

> By default, tables are Round Robin-distributed, enabling users to create new tables without deciding on the distribution. In some workloads, Round Robin tables have acceptable performance. However, in many cases, selecting a distribution column will perform much better.
>
> A round-robin distributed table distributes table rows evenly across all distributions. The assignment of rows to distributions is random. Unlike hash-distributed tables, rows with equal values are not guaranteed to be assigned to the same distribution. As a result, the system sometimes needs to invoke a data movement operation to better organize your data before resolving a query. This extra step can slow down your queries. For example, joining a round-robin table usually requires reshuffling the rows, which is a performance hit.

Finally, the first two queries (the counts) were not that far apart performance-wise because none of them incurred any data movement (each distribution just reported its local counts, and then the results were aggregated).

This simple example demonstrates one of the core challenges of modern, massively distributed data platforms - solid design. You witnessed first-hand how one decision taken at table design time can significantly influence the performance of queries. You also got a glimpse of Azure Synapse Analytics' raw power: the more efficient table design enabled a non-trivial query involving more than 80 million records to execute in just a few seconds.
