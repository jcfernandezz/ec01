IF (OBJECT_ID ('dbo.gersVwVentasCliente', 'V') IS NULL)
   exec('create view dbo.gersVwVentasCliente as SELECT 1 as t');
go

alter VIEW dbo.gersVwVentasCliente AS  
-- Propósito. Obtiene datos para reporte Ventas Cliente del ATS Ecuador
--01/04/15 jcf Creación
--06/01/20 jcf Agrega sopnumbe, montoIce, tipoEmision. Elimina group by
--
  select 
    year(so.docdate) anio, month(so.docdate) mes,
    so.sopnumbe, fla.tipoIdCli, fla.nsa_ruc_cliente, fla.nsa_tipo_comprob, fla.tipoCliente, fla.parteRelacionada, fla.custname,
    exe.tdttxSLS baseNoObjetoIva,
    icr.tdttxSLS baseCeroIva,	--'Base Imponible tarifa 0% IVA',
    iva.tdttxSLS baseIva,		  -- 'Base Imponible tarifa IVA diferente de 0%',
    iva.staxamnt iva,			    --'Monto IVA',
    riv.staxamnt retIva,			  -- 'Valor de IVA que le han retenido',
    rin.staxamnt retIng,
    0 montoIce,
    'F' tipoEmision,
    1 numEmitidos
		-- count(so.sopnumbe) numEmitidos, 
    --    sum(exe.tdttxSLS) baseNoObjetoIva,
    --    sum(icr.tdttxSLS) baseCeroIva,	--'Base Imponible tarifa 0% IVA',
    --    sum(iva.tdttxSLS) baseIva,		-- 'Base Imponible tarifa IVA diferente de 0%',
    --    sum(iva.staxamnt) iva,			--'Monto IVA',
    --    sum(riv.staxamnt) retIva,			-- 'Valor de IVA que le han retenido',
    --    sum(rin.staxamnt) retIng
  from SOP30200 so
       outer apply dbo.gersFnDatosFacturaVentasLocAndina(so.SOPTYPE, so.SOPNUMBE, so.CUSTNMBR) fla
	   outer apply dbo.gersFnGetImpuestosSOP (so.SOPNUMBE, so.SOPTYPE, 'EXEMPT') exe
	   outer apply dbo.gersFnGetImpuestosSOP (so.SOPNUMBE, so.SOPTYPE, 'P-IVACERO') icr
	   outer apply dbo.gersFnGetImpuestosSOP (so.SOPNUMBE, so.SOPTYPE, 'P-IVA') iva
	   outer apply dbo.gersFnGetImpuestosSOP (so.SOPNUMBE, so.SOPTYPE, 'P-RETIVA') riv
	   outer apply dbo.gersFnGetImpuestosSOP (so.SOPNUMBE, so.SOPTYPE, 'P-RETIN') rin
--group by fla.tipoIdCli, fla.nsa_ruc_cliente, fla.nsa_tipo_comprob, year(so.docdate), month(so.docdate) 

GO

  IF (@@Error = 0) PRINT 'Creación exitosa de la vista: gersVwVentasCliente'
ELSE PRINT 'Error en la creación de la vista: gersVwVentasCliente'
GO

----------------------------------------------------------------------------------------------------------
