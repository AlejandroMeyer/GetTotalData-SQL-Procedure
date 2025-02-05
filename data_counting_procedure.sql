CREATE PROCEDURE GetTotalData
AS
BEGIN
	
   DROP TABLE IF EXISTS #TempResult
   -- Create a temporary table to store the results
   CREATE TABLE #TempResult(
	[table_final]		VARCHAR(200)
	,[date_master]		VARCHAR(50)
	,[job]			VARCHAR(200)
	,[id]			VARCHAR(50)
	,[type_catalog]		VARCHAR(15)
	,[source_information]	VARCHAR(500)
	,[server_id]		VARCHAR(30)
	,[total_data]		INT
    );

    -- Declare variables
    DECLARE @TableFinal VARCHAR(200),
            @DateMaster VARCHAR(50),
            @Job VARCHAR(200),
            @Id VARCHAR(50),
            @TypeCatalog VARCHAR(15),
            @SourceInformation VARCHAR(500),
            @ServerId VARCHAR(30),
            @TotalData INT;

    -- Assign the current date to the @RowDate variable
    DECLARE @RowDate DATE;
    SET @RowDate = GETDATE();

    -- Declare a cursor to iterate through the existing table
    DECLARE cursorTable CURSOR FOR
        SELECT [table_final], [date_master], [job], [id], [type_catalog], [source_information], [server_id]
        FROM [Test].[dbo].[extraccions_test];

    -- Open the cursor
    OPEN cursorTable;

    -- Initialize variables
    FETCH NEXT FROM cursorTable INTO @TableFinal, @DateMaster, @Job, @Id, @TypeCatalog, @SourceInformation, @ServerId;

    -- Loop through the table
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Initialize total to 0
        SET @TotalData = 0;

        -- Construct the dynamic query
        DECLARE @SqlQuery NVARCHAR(MAX);
        SET @SqlQuery = 
            N'SELECT @TotalOut = COUNT(*) FROM ' + @TableFinal +
            N' WHERE ' + @DateMaster + ' = @RowDate';

        -- Execute the dynamic query
        EXEC sp_executesql @SqlQuery, N'@RowDate DATE, @TotalOut INT OUTPUT', @RowDate, @TotalData OUTPUT;

        -- Insert the result into the temporary table
        INSERT INTO #TempResult ([table_final], [date_master], [job], [id], [type_catalog], [source_information], [server_id], [total_data])
        VALUES (@TableFinal, @DateMaster, @Job, @Id, @TypeCatalog, @SourceInformation, @ServerId, @TotalData);

        -- Fetch the next record from the cursor
        FETCH NEXT FROM cursorTable INTO @TableFinal, @DateMaster, @Job, @Id, @TypeCatalog, @SourceInformation, @ServerId;
    END

    -- Close and deallocate the cursor
    CLOSE cursorTable;
    DEALLOCATE cursorTable;

    -- Select the final results
    SELECT DISTINCT [table_final], [date_master], [job], [id], [type_catalog], [source_information], [server_id], [total_data] FROM #TempResult;

    -- Drop the temporary table
    --DROP TABLE #TempResult;
END;
