-- Retrieve the latest hex encoded ONNX model from the table
DECLARE @model varbinary(max) = (SELECT Model FROM [wwi].[Models] WHERE Id = (SELECT Top(1) max(ID) FROM [wwi].[Models]));

-- Run a prediction query
SELECT d.*, p.*
FROM PREDICT(MODEL = @model, DATA = [wwi].[SampleData] AS d) WITH (prediction real) AS p;

-- Store a batch of predictions
INSERT INTO PredictionResults
SELECT d.*, p.Score
FROM PREDICT(MODEL = @model, DATA = [wwi].[SampleData] AS d) WITH (prediction real) AS p;