IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'gersVwFacturasVentaAnuladas') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.gersVwFacturasVentaAnuladas;
GO

create VIEW dbo.gersVwFacturasVentaAnuladas AS  
select 
	doc.nsa_tipo_comprob tipoComprobante,	--'Código tipo de Comprobante anulado',
	substring(dbo.gersFnGetSegmentoX(1, so.sopnumbe), 3, 3) Establecimiento,
	dbo.gersFnGetSegmentoX(2, so.sopnumbe) puntoEmision,
	dbo.gersFnGetSegmentoX(3, so.sopnumbe) secuencial,
	au.PARAM1,								--número de autorización de ventas
	so.DOCDATE
from 
	SOP30200 so
	left join nsacoa_gl00014 doc
		on doc.CUSTNMBR = so.CUSTNMBR
		and doc.DOCNUMBR = so.SOPNUMBE
	outer apply dbo.fLEcuParametros('NAUT', '-', '-', '-', '-', '-') au --'Autorización'

where so.soptype in (3, 4) 
	and so.voidstts = 1
GO

  IF (@@Error = 0) PRINT 'Creación exitosa de la vista: gersVwFacturasVentaAnuladas'
ELSE PRINT 'Error en la creación de la vista: gersVwFacturasVentaAnuladas'
GO

----------------------------------------------------------------------------------------------
--sp_columns nsacoa_gl00014
--sp_statistics nsacoa_gl00014

