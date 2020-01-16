IF OBJECT_ID (N'dbo.gersFnGetReferenciaNCND') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetReferenciaNCND
GO

create function dbo.gersFnGetReferenciaNCND (@VCHRNMBR varchar(21), @DOCTYPE smallint, @tipoComprobante varchar(2)) 
--Prop�sito. Obtiene datos de referencia para Compras detalladas del ATS Ecuador
--30/3/15 jcf Creaci�n
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
	  and @tipoComprobante = '04'	--nota de cr�dito		

	  union all

	select rtrim(fc.nsa_tipo_comprob) nsa_tipo_comprob, rtrim(fc.establecimiento) establecimiento, rtrim(fc.puntoEmision) puntoEmision, rtrim(fc.nsacoa_secuencial) nsacoa_secuencial, rtrim(fc.nsa_autorizacion) nsa_autorizacion, rtrim(fc.numAutorizacion) numAutorizacion
	  from tii_vwPmAplicadas a
	  outer apply dbo.gersFnDatosFacturaLocAndina(a.vendorid, a.VCHRNMBR) fc
	where a.APTVCHNM = @VCHRNMBR
		and APTODCTY = @DOCTYPE
	  and @tipoComprobante = '05'	--nota de d�bito
	  
	   )

GO

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: gersFnGetReferenciaNCND'
ELSE PRINT 'Error en la creaci�n de: gersFnGetReferenciaNCND'
GO


