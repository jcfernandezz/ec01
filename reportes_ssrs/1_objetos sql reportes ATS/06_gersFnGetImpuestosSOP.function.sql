IF OBJECT_ID (N'dbo.gersFnGetImpuestosSOP') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetImpuestosSOP
GO

create function [dbo].gersFnGetImpuestosSOP (@SOPNUMBE varchar(21), @SOPTYPE smallint, @constante varchar(15)) 
returns table
	return(
		SELECT SUM(tdttxSLS) tdttxSLS, SUM(staxamnt) staxamnt
   		  FROM sop10105 so
	           INNER JOIN TX00201 tx
	           ON so.Taxdtlid = tx.taxdtlid
	    where tx.txdtltyp  = 1
			and so.sopnumbe = @SOPNUMBE
			and so.soptype = @SOPTYPE
           and tx.cmnytxid = @CONSTANTE

	)
go

IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnGetImpuestosSOP'
ELSE PRINT 'Error en la creación de: gersFnGetImpuestosSOP'
GO



--sp_columns sop30200
--sp_statistics sop30200
