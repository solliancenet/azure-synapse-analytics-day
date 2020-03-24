# Explore the Data Lake with SQL Analytics on-demand and Spark

In this exercise you will explore data using the engine of your choices (SQL or Spark).

## Task 1 - Explore the Data Lake with SQL Analytics on-demand

1. In this task, you will browse your data lake. Go into the ```wwi``` folder, select the year and month folders of your choice, then select a file, right click and select **New SQL script**. A script is automatically generated. Run this script to see how SQL on demand queries the file and returns the first 100 rows of that file with the header allowing you to easily explore data in the file.

## Task 2 - Explore the Data Lake and create a table with Spark

1. Similarly, go to the folder ```wwi/factsale/2012/01```.

    ![Navigate to data lake file](./media/ex01-spark-notebook-01.png)

2. Select the file ```InvoiceDateKey=2012-01-01.csv``` and **New Notebook**.

    ![Start new Spark notebook from data lake file](./media/ex01-spark-notebook-02.png)

3. This will generate a notebook with PySpark code to load the data in a dataframe and display 100 rows with the header.

    ![New Spark notebook from data lake file](./media/ex01-spark-notebook-03.png)

4. Change the code to include headers as follows:

```python
%%pyspark
data_path = spark.read.load(
    'abfss://wwi@asadatalake01.dfs.core.windows.net/factsale/2012/01/InvoiceDateKey=2012-01-01.csv',
    format='csv',
    header=True)

data_path.show(100)
```

5. Attach the notebook to a Spark pool and run the command.

    ![Run Spark notebook on data lake file](./media/ex01-spark-notebook-04.png)

6. As you can see, the output is not formatted very well. To change this, replace the last line of code with the following:

```python
display(data_path.limit(100))
```

7. Run the notebook again to see the improved display.

    ![Improve dataset formatting in Spark notebook](./media/ex01-spark-notebook-05.png)

8. Notice the included charting capabilities that enable visual exploration of your data.

    ![View charts on data in Spark notebook](./media/ex01-spark-notebook-06.png)
