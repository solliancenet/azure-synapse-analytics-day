# Exercise 5 - Data Science with Spark

In this exercise, you will leverage a model that was previously trained to make predictions using the T-SQL `Predict` statement. For context, the following are the high level steps taken to get a model ready for use from T-SQL. All the steps are performed within your Azure Synapse Analytics Studio.

1.	Within a notebook, a data scientist will:
    
    a.	Train a model using Spark ML, the machine learning library included with Apache Spark.   
    
    b.	Convert the model to the ONNX format using the `onnxml` tools.  
    
    c.	Save the ONNX version of the model to a table in the SQL Pool database.
2.	To use the model for making predictions, in a SQL Script a data engineer will:
    
    a.	Read the model into a binary variable by querying it from the table in which it was stored.
    
    b.	Execute a query using the `FROM PREDICT` statement as you would a table. This statement defines both the model to use and the query to execute that will provide the data used for prediction. 

In this exercise, you will focus on step (2) from the above. 

## Task 1 - Making predictions with a trained model
In this task, you will author a T-SQL query that uses a pre-trained model to make predictions. 

1. Open Synapse Analytics Studio, and then navigate to the `Data hub`.
2. Under the Databases listing, right click `SQLPool01` and then select `New SQL Script`, and then `Empty script`.
3. Replace the contents of this script with following:

```
DECLARE @model varbinary(max) = (select Data from models where id = 1);

SELECT preds.quantity, inputs.*
FROM PREDICT(MODEL = @model, 
    DATA = wwi.FactSale inputs) WITH (quantity int) as preds

```
4. Select the Run icon.
5. View the results, notice that the `quantity` column is the model's prediction of how many items of the kind represented by `StockItemKey` that the customer identified by `CustomerKey` will purchase. 

## Task 2 - Examining the model training notebook (Optional)
If you are curious, you can see the notebook that was used to train this model. To do so, follow these steps:

1. Open Synapse Analytics Studio, and then navigate to the `Develop hub`.
2. Under Notebooks, select the notebook called `Exercise 6 Model Training`. 
3. Feel free to read thru the notebook, but do not execute it. The results of executing each cell in the notebook have been saved with the notebook so that you can see results, without having to run it.
