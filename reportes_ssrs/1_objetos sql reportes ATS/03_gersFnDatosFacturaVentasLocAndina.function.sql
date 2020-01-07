IF OBJECT_ID (N'dbo.gersFnDatosFacturaVentasLocAndina') IS NOT NULL
   DROP FUNCTION dbo.gersFnDatosFacturaVentasLocAndina
GO

alter FUNCTION dbo.gersFnDatosFacturaVentasLocAndina(@SOPTYPE smallint, @SOPNUMBE varchar(21), @CUSTNMBR varchar(15))
RETURNS TABLE 
AS
-- Propósito. Obtiene datos de la factura de compra de localización andina (Ecuador)
-- 30/03/15 jcf Creación
-- 06/01/20 jcf Corrige tipoIdCli. Agrega tipo de cliente y parte relacionada
--
   RETURN
   (
	select
		-- case when cli.doctype = 3 then 
		-- 	case when right(left(doc.nsa_RUC_Cliente, 3), 1) in ('1', '2', '3', '4', '5') then 
		-- 		'05'		--cédula
		-- 	else '04'		--ruc
		-- 	end
		-- else
		-- 	'06'			--pasaporte o tarjeta de id
		-- end tipoIdCli,
		case when cli.doctype = 3 then '04'	--ruc
			when cli.doctype = 1 then '05'	--ci
			when cli.doctype = 2 then '06'	--pasaporte
		else	''
		end tipoIdCli,
		cli.DOCTYPE docTypeCli,
		cli.nsa_RUC_Cliente,
		upper(rtrim(mstr.userdef1)) tipoCliente,
		upper(rtrim(mstr.userdef2)) parteRelacionada,
		rtrim(mstr.custname) custname,
		doc.nsa_tipo_comprob, 
		doc.DOCNUMBR
	from nsacoa_gl00020 cli
		inner join rm00101 mstr 
		on mstr.custnmbr = cli.custnmbr
    	left join nsacoa_gl00014 doc
    	on doc.nsa_RUC_Cliente = cli.nsa_RUC_Cliente
		and doc.CUSTNMBR = cli.CUSTNMBR
	where doc.DOCNUMBR = @SOPNUMBE
	and doc.DOCTYPE = @SOPTYPE
	and doc.CUSTNMBR = @CUSTNMBR
   )

GO

IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnDatosFacturaVentasLocAndina'
ELSE PRINT 'Error en la creación de: gersFnDatosFacturaVentasLocAndina'
GO


