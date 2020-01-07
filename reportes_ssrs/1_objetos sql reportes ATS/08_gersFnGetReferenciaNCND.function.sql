IF OBJECT_ID (N'dbo.gersFnGetReferenciaNCND') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetReferenciaNCND
GO

create function dbo.gersFnGetReferenciaNCND (@VCHRNMBR varchar(21), @DOCTYPE smallint, @tipoComprobante varchar(2)) 
-- Propósito. Obtiene datos de referencia para Compras detalladas del ATS Ecuador
-- 30/3/15 jcf Creación
RETURNS table
AS
return(
	select fc.nsa_tipo_comprob, fc.establecimiento, fc.puntoEmision, fc.nsacoa_secuencial, fc.nsa_autorizacion, fc.numAutorizacion
	  from tii_vwPmAplicadas a
	  outer apply dbo.gersFnDatosFacturaLocAndina(a.vendorid, a.APTVCHNM ) fc
	where a.VCHRNMBR = @VCHRNMBR
	  and a.DOCTYPE  = @DOCTYPE
	  and @tipoComprobante = '04'	--nota de crédito		
	  union all
	select fc.nsa_tipo_comprob, fc.establecimiento, fc.puntoEmision, fc.nsacoa_secuencial, fc.nsa_autorizacion, fc.numAutorizacion
	  from tii_vwPmAplicadas a
	  outer apply dbo.gersFnDatosFacturaLocAndina(a.vendorid, a.VCHRNMBR) fc
	where a.APTVCHNM = @VCHRNMBR
		and APTODCTY = @DOCTYPE
	  and @tipoComprobante = '05'	--nota de débito
	  
	   )

GO

IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnGetReferenciaNCND'
ELSE PRINT 'Error en la creación de: gersFnGetReferenciaNCND'
GO


