IF OBJECT_ID (N'dbo.gersFnGetReferenciaNCND') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetReferenciaNCND
GO

create function dbo.gersFnGetReferenciaNCND (@VCHRNMBR varchar(21), @DOCTYPE smallint, @tipoComprobante varchar(2)) 
--Propósito. Obtiene datos de referencia para Compras detalladas del ATS Ecuador
--30/3/15 jcf Creación
--16/01/20 jcf Quita espacios a la derecha de los campos string
--
RETURNS table
AS
return(
	select rtrim(fc.nsa_tipo_comprob) nsa_tipo_comprob, rtrim(fc.establecimiento) establecimiento, rtrim(fc.puntoEmision) puntoEmision, rtrim(fc.nsacoa_secuencial) nsacoa_secuencial, rtrim(fc.nsa_autorizacion) nsa_autorizacion, rtrim(fc.numAutorizacion) numAutorizacion
	  from tii_vwPmAplicadas a
	  outer apply dbo.gersFnDatosFacturaLocAndina(a.vendorid, a.APTVCHNM ) fc
	where a.VCHRNMBR = @VCHRNMBR
	  and a.DOCTYPE  = @DOCTYPE
	  and @tipoComprobante = '04'	--nota de crédito		

	  union all

	select rtrim(fc.nsa_tipo_comprob) nsa_tipo_comprob, rtrim(fc.establecimiento) establecimiento, rtrim(fc.puntoEmision) puntoEmision, rtrim(fc.nsacoa_secuencial) nsacoa_secuencial, rtrim(fc.nsa_autorizacion) nsa_autorizacion, rtrim(fc.numAutorizacion) numAutorizacion
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


