--Compras detalladas
--Consulta para Reporting services
select 
VCHRNMBR [Código de compra],
nsa_cod_transac [Código de Sustento],
tipoIdProv [Tipo Identificación del Proveedor],
nsa_RUC_Prov [Número de Identificación del Proveedor],
nsa_tipo_comprob [Código del Tipo de comprobante],
userdef1 [Tipo de Proveedor],
userdef2 [Parte Relacionada],
vendname [Razón Social],
PSTGDATE [Fecha Registro],
establecimiento Establecimiento,
puntoEmision [Punto Emision],
nsacoa_secuencial [Secuencial],
docdate [Fecha Emision],
numAutorizacion [Número de Autorizacion],
baseImpoExento 		[Base Imponible Exenta],
baseImpoNoObjetoIva [Base Imponible no objeto de IVA],
baseImpoCero 		[Base Imponible tarifa 0% de IVA],
baseImponible 		[Base Imponible gravada],
baseImpoExento +baseImpoNoObjetoIva +baseImpoCero + baseImponible totalBasesImponibles,
ice [Monto ICE],
iva [Monto IVA],
ret10 [Retención de IVA 10],
ret20 [Retención de IVA 20],
ret30 [Retención de IVA 30% bienes],
ret50 [Retención de IVA 50],
ret70 [Retención de IVA 70% servicios],
ret100 [100% Retención de IVA],
vndclsid [Pago Local o al Exterior],	
tipoRegimenFiscalDelExterior,
paisPagoRegimenGeneral,
paisPagoParaisoFiscal,
DenominacionOtroRegimen,
ccode [País al que se efectúa el pago],
aplicaConvenioDobleTributo [Aplica convenio de doble tributación],
pagoAplicaNormativaLegal [Pago al exterior en aplicación a la Normativa Legal],
cRetEstablecimiento [Establecimiento2],
cRetPuntoEmision [Punto de Emisión2],
cRetSecuencial [Secuencial2],
cRetNumAutorizacion [Número Autorización2],
docdate [Fecha Emision2],

ref_nsa_tipo_comprob [Código del tipo de documento],
ref_establecimiento Establecimiento3,
ref_puntoEmision [Punto Emision3],
ref_nsacoa_secuencial [Secuencial3],
ref_numAutorizacion [Autorización3]
from dbo.gersVwComprasDetalladas 
where pordnmbr = ''
-- and year(PSTGDATE) = @p_Year
-- and month(PSTGDATE) = @p_Month
and year(PSTGDATE) = 2015
and month(PSTGDATE) = 11
------------------------------------------------------------------------------------------------
--Compras reembolsos
select 
	VCHRNMBR [Código de compra],
	nsa_tipo_comprob [Tipo de comprobante de reembolso],
	tipoIdProv [Tipo Identificación del Proveedor],
	nsa_RUC_Prov [Número de Identificación del Proveedor],
	establecimiento Establecimiento,
	puntoEmision PuntoEmision,
	nsacoa_secuencial [Secuencial],
	docdate [Fecha de emisión],
	numAutorizacion Autorizacion,
	
	baseImpoCero [Base Imponible tarifa 0% de IVA],
	case when nsa_tipo_comprob in ('41', '47', '48') then 0
		else baseImponible
	end	 [Base imponible gravada],
	case when nsa_tipo_comprob in ('41', '47', '48') then baseImponible
		else 0
	end	 [Base imponible gravada reembolso],
	baseImpoExento 		[Base Imponible Exenta],
	baseImpoNoObjetoIva [Base Imponible no objeto de IVA],

	ice [Monto ICE],
	ret10 + ret20 + ret30 + ret50 + ret70 + ret100 Retenciones
from dbo.gersVwComprasDetalladas 
where pordnmbr <> ''
-- and year(PSTGDATE) = @p_Year
-- and month(PSTGDATE) = @p_Month
and year(PSTGDATE) = 2015
and month(PSTGDATE) = 03
-------------------------------------------------------------------------------------------------
--Compras retenciones
select 
	VCHRNMBR [Código de compra],
	codRetencion [Código de retención],
    baseImponible [Base imponible],
    tasaRetencion [Porcentaje de retención],
    retencion [Valor retenido]
from dbo.gersVwComprasRetenciones 
where pordnmbr = ''
and anio = 2015
and mes = 3
-------------------------------------------------------------------------------------------------
--Compras formas de pago
select 
	VCHRNMBR [Código de compra],
	formaPago [Forma de pago]
from dbo.gersVwComprasPagos   
where year(pstgdate) = 2015
and month(PSTGDATE) = 03

-------------------------------------------------------------------------------------------------
--Ventas clientes
select 
	sopnumbe [Código Venta],
	tipoIdCli [Tipo Identificacion del Cliente],
	nsa_ruc_cliente [No. de Identificación del Cliente],
	parteRelacionada [Es Parte Relacionada],
	tipoCliente [Tipo de cliente],
	custName [Razón Social],
	tipoEmision [Tipo de emisión],
	nsa_tipo_comprob [Codigo tipo de comprobante],
	anio,mes,
	numEmitidos [No de Comprobantes emitidos],
	baseNoObjetoIva [Base Imponible No objeto de IVA],
	baseCeroIva [Base Imponible tarifa 0% IVA],
	baseIva [Base Imponible tarifa IVA diferente de 0%],
	iva [Monto IVA],
	montoIce,
	retIva [Valor de IVA que le han retenido],
	retIng [Valor de Renta que le han retenido]
from dbo.gersVwVentasCliente   
-- where anio = @p_Year
-- and mes = @p_Month
where anio = 2015
and mes = 03

-------------------------------------------------------------------------------------------------
--Ventas establecimiento
select codEstablecimiento [Código del Establecimiento], 
	docamnt [Ventas por establecimiento]
from dbo.gersVwVentasEstablecimiento
where anio = 2015
and mes = 03

-------------------------------------------------------------------------------------------------
--Ventas anuladas
select tipoComprobante [Código tipo de Comprobante anulado],
	Establecimiento ,
	puntoEmision [Punto Emisión],
	secuencial [Secuencial Inicio],
	secuencial [Secuencial Fin],
	PARAM1 [Autorización],
	DOCDATE
from dbo.gersVwFacturasVentaAnuladas

-------------------------------------------------------------------------------------------------
--sp_columns gersVwFacturasVentaAnuladas

