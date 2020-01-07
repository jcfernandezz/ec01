IF OBJECT_ID (N'dbo.gersFnDatosFacturaLocAndina') IS NOT NULL
   DROP FUNCTION dbo.gersFnDatosFacturaLocAndina
GO

create FUNCTION dbo.gersFnDatosFacturaLocAndina(@VENDORID varchar(15), @DOCNUMBR varchar(21))
RETURNS TABLE 
AS
--Propósito. Obtiene datos de la factura de compra de localización andina (Ecuador)
--30/3/15 jcf Creación
--24/12/19 jcf Corrige tipoIdProv
--
   RETURN
   (
   select df.nsa_cod_transac, df.nsa_tipo_comprob, df.nsa_serie, df.nsacoa_secuencial, df.nsa_autorizacion,
		left(ltrim(df.nsa_serie), 3) establecimiento,		--'Establecimiento',
		right(rtrim(df.nsa_serie), 3) puntoEmision,
		case when dp.doctype = 3 then '01'	--ruc
			when dp.doctype = 1 then '02'	--ci
			when dp.doctype = 2 then '03'	--pasaporte
		else	''
		end tipoIdProv, 
		-- case when dp.doctype = 3 then 
		-- 	case when right(left(dp.nsa_RUC_Prov, 3), 1) in ('1', '2', '3', '4', '5') then 
		-- 		'02'		--cédula
		-- 	else '01'		--ruc
		-- 	end
		-- else
		-- 	'03'			--pasaporte o tarjeta de id
		-- end tipoIdProv, 
		dp.nsa_RUC_Prov,
		
		case when isnull(au.mexFolioFiscal, '') = '' then
			df.nsa_autorizacion
		else au.mexFolioFiscal
		end numAutorizacion,	-- 'Número de Autorizacion',

		dbo.gersFnGetSegmentoX(1, cr.eBizS_NextDocumentNumber) cRetEstablecimiento,
		dbo.gersFnGetSegmentoX(2, cr.eBizS_NextDocumentNumber) cRetPuntoEmision,
		dbo.gersFnGetSegmentoX(3, cr.eBizS_NextDocumentNumber) cRetSecuencial,
		rtrim(cr.cmpyadd1) cRetNumAutorizacion
		
   from NSACOA_GL00021 df			--comprobantes
	inner join NSACOA_GL00011 dp	--proveedores loc andina
		on dp.vendorid = df.VENDORID
		and dp.nsa_RUC_Prov = df.nsa_RUC_Prov
	left join eBizSCR_30001	cr		--comprobante retención
		on cr.VCHRNMBR = df.DOCNUMBR
		and cr.DOCTYPE = df.DOCTYPE
	left join ACA_IETU00400 au		--núm. autorización
		on au.vchrnmbr = df.DOCNUMBR
		and au.doctype = df.DOCTYPE
	where df.VENDORID = @VENDORID 
	and df.DOCNUMBR = @DOCNUMBR
   )

GO

IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnDatosFacturaLocAndina'
ELSE PRINT 'Error en la creación de: gersFnDatosFacturaLocAndina'
GO

----------------------------------------------------------------------------------------------
