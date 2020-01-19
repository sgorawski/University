USE List4DB;
GO

-- This will update table between reads
-- done by 01_2a.sql query, resulting
-- in differences in those reads.

BEGIN TRANSACTION;
	UPDATE People SET FirstName = 'Whatever'
		WHERE LastName = 'Andrews';
COMMIT;
GO
