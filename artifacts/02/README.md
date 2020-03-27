# Exercise 2 setup

## Notebooks

The two Jupyter notebooks for Exercise 2 should be configured as follows:

[Exercise 2 - Ingest Sales Data](Exercise%202%20-%20Ingest%20Sales%20Data.ipynb)

- In **Cell 1**, update the `adlsPath` variable on line 5 with the proper path to the ADLS Gen2 account. **Note**, the path should include a container name, such as `wwi`. For example:

  ```scala
  val adlsPath = "abfss://wwi@asadatalake02.dfs.core.windows.net"
  ```

[Exercise 2 - Bonus Notebooks with CSharp](Exercise%202%20-%20Bonus%20Notebook%20with%20CSharp.ipynb)

- In **Cell 1**, update the `adlsPath` variable on line 2 with the proper path to the ADLS Gen2 account. **Note**, the path should include a container name, such as `wwi`. For example:

  ```scala
  val adlsPath = "abfss://wwi@asadatalake02.dfs.core.windows.net"
  ```

- In **Cell 3**, update the following:

  - **Line 5**: Update the value of the `jdbcUserName` variable with the name of an account which has data reader, data writer, and table creation permissions on the SQL Pool database. For example:

  ```scala
  var jdbcUsername = "asa.sql.staging@asaworkspace02";
  ```

  - **Line 6**: Update the value of the `jdbcPassword` variable with the password of the account provided above. For example:

  ```scala
  var jdbcPassword = "account-password-here";
  ```

  - **Line 5**: Update the value of the `jdbcConnectionString` variable with the name of the Azure Synapse Analytics workspace and appropriate SQL Pool database name. For example:

  ```scala
  var jdbcConnectionString = $"jdbc:sqlserver://asaworkspace02.sql.azuresynapse.net:1433;database=SQLPool01;";
  ```
