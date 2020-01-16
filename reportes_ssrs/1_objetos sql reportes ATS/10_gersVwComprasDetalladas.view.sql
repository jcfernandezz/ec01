IF (OBJECT_ID ('dbo.gersVwComprasDetalladas', 'V') IS NULL)
   exec('create view dbo.gersVwComprasDetalladas as SELECT 1 as t');
go
-- IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'gersVwComprasDetalladas') AND OBJECTPROPERTY(id,N'IsView') = 1)
--     DROP view dbo.gersVwComprasDetalladas;
-- GO

alter view dbo.gersVwComprasDetalladas as
-- Propósito. Obtiene datos para reporte Compras detalladas del ATS Ecuador
--30/03/15 jcf Creación
--02/09/15 jcf Ajuste de campos nulos para que muestren cero o NA
--25/04/17 jcf Agrega vendorid
--24/12/19 jcf Agrega vendname. Agrega campos en caso de pago al exterior. Agrega caso de prueba: comprobante con impuesto no objeto de iva e iva 0. Si son iguales al total de compra, muestra la base imponible del segundo de forma predeterminada.
--10/01/20 jcf Filtra anulados
--16/01/20 jcf Quita espacios a la derecha en los campos string
--
select 
rtrim(pm.VCHRNMBR) VCHRNMBR,
df.nsa_cod_transac,
df.tipoIdProv,
df.nsa_RUC_Prov,
df.nsa_tipo_comprob,				--tipo de comprobante
rtrim(pm.userdef1) userdef1,		-- 'Tipo de Proveedor',
rtrim(pm.userdef2) userdef2,		-- 'Parte Relacionada',
pm.PSTGDATE,						-- 'Fecha Registro',
df.establecimiento,
df.puntoEmision,
df.nsacoa_secuencial,							--'Secuencial',
pm.docdate,										-- 'Fecha Emision',
df.numAutorizacion,								-- 'Número de Autorizacion',
case when noi.tdttxpur!=0 and icr.tdttxpur!=0 and noi.tdttxpur = icr.tdttxpur and pm.prchamnt = icr.tdttxpur then
	0
else
	isnull(noi.tdttxpur, 0) 
end baseImpoNoObjetoIva,						-- 'Base Imponible no objeto de IVA',
isnull(exe.tdttxpur, 0) baseImpoExento,			-- 'Base Imponible exenta de IVA,
isnull(icr.tdttxpur, 0) baseImpoCero,			-- 'Base Imponible tarifa 0% de IVA',
isnull(iva.tdttxpur, 0) baseImponible,			-- 'Base Imponible gravada',
0 ice,											-- 'Monto ICE',
isnull(iva.taxamnt, 0) iva,						--'Monto IVA',
abs(isnull(rt10.taxamnt, 0)) ret10,					--'Retención de IVA 10% bienes',
abs(isnull(rt20.taxamnt, 0)) ret20,					--'Retención de IVA 20% bienes',
abs(isnull(rtr.taxamnt, 0)) ret30,					--'Retención de IVA 30% bienes',
abs(isnull(rt50.taxamnt, 0)) ret50,					--'Retención de IVA 50% bienes',
abs(isnull(rst.taxamnt, 0)) ret70,					--'Retención de IVA 70% servicios',
abs(isnull(rcn.taxamnt, 0)) ret100,					--'100% Retención de IVA',
case left(pm.vndclsid, 2) 
    when 'FV' then '02'								--02: no residente, 01: residente FV: foreign vendors
    else '01'
end vndclsid,											--'Pago Local o al Exterior',			
case left(pm.vndclsid, 2) 
    when 'FV' then parm.param1
    else ''
end tipoRegimenFiscalDelExterior,
case when left(pm.vndclsid, 2) = 'FV' and parm.param1 = '01' then
	pm.ccode
    else ''
end paisPagoRegimenGeneral,
case when left(pm.vndclsid, 2) = 'FV' and parm.param1 = '02' then
	pm.ccode
    else ''
end paisPagoParaisoFiscal,
case when left(pm.vndclsid, 2) = 'FV' and parm.param1 = '03' then
	parm.param3
    else ''
end DenominacionOtroRegimen,
case when pm.ccode = '' then 'NA' else pm.ccode end ccode,	-- 'País al que se efectúa el pago',
upper(rtrim(isnull(parm.param2, 'NA'))) aplicaConvenioDobleTributo,
upper(rtrim(isnull(parm.param3, 'NA'))) pagoAplicaNormativaLegal,
df.cRetEstablecimiento,
df.cRetPuntoEmision,
df.cRetSecuencial,
df.cRetNumAutorizacion,

ref.nsa_tipo_comprob ref_nsa_tipo_comprob,	--'Código del tipo de documento '
ref.establecimiento ref_establecimiento,
ref.puntoEmision ref_puntoEmision,
ref.nsacoa_secuencial ref_nsacoa_secuencial,
ref.numAutorizacion ref_numAutorizacion,
rtrim(pm.pordnmbr) pordnmbr, rtrim(pm.vendorid) vendorid, rtrim(pm.vendname) vendname, rtrim(pm.prchamnt) prchamnt

FROM dbo.vwPmTransaccionesTodas pm
	outer apply dbo.gersFnDatosFacturaLocAndina(pm.VENDORID, pm.VCHRNMBR ) df
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'EXEMPT') noi
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-EXENTO') exe
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-IVACERO') icr
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-IVA') iva
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET10') rt10
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET20') rt20
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET30') rtr
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET50') rt50
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET70') rst
	outer apply dbo.gersFnGetImpuestosPM(pm.TRXSORCE, pm.VCHRNMBR, pm.DOCTYPE, 'P-RET100') rcn
	outer apply dbo.gersFnGetReferenciaNCND (pm.VCHRNMBR, pm.DOCTYPE, df.nsa_tipo_comprob) ref
	outer apply dbo.fGersParametrosProveedor(pm.VENDORID, 'TIPO_REGIMEN', 'DOBLE_TRIBUTO', 'NORMATIVA_LEGAL', 'DENOMINACION03', 'NA', 'NA', 'PREDETERMINADO') parm
WHERE pm.doctype  <= 5 
and pm.VOIDED = 0

go
  
  IF (@@Error = 0) PRINT 'Creación exitosa de la vista: gersVwComprasDetalladas'
ELSE PRINT 'Error en la creación de la vista: gersVwComprasDetalladas'
GO
