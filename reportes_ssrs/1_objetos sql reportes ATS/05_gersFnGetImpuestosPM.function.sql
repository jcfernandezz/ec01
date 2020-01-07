IF OBJECT_ID (N'dbo.gersFnGetImpuestosPM') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetImpuestosPM
GO

--21/01/16 jcf Reemplaza tabla de impuestos por vista
--
create function [dbo].gersFnGetImpuestosPM (@TRXSORCE varchar(13), @VCHRNMBR varchar(21), @DOCTYPE smallint, @constante varchar(15)) 
returns table
	return(
		SELECT SUM(tx.tdttxpur) tdttxpur, SUM(tx.taxamnt) taxamnt
--		select tx.tdttxpur, tx.taxamnt
   		  FROM dbo.vwPmImpuestos tx	
			INNER JOIN TX00201 td
			on tx.Taxdtlid = td.taxdtlid
		where
			td.txdtltyp = 2
			--and tx.VCHRNMBR = 'V00001695'
			--and tx.trxsorce =  'PMTRX00000266'
			--and tx.doctype = 1
			--and td.cmnytxid = 'P-IVA'
           and tx.VCHRNMBR = @VCHRNMBR
		   and tx.trxsorce = @TRXSORCE
           and tx.DOCTYPE = @DOCTYPE
           and td.cmnytxid = @CONSTANTE
	)
go


IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnGetImpuestosPM'
ELSE PRINT 'Error en la creación de: gersFnGetImpuestosPM'
GO


