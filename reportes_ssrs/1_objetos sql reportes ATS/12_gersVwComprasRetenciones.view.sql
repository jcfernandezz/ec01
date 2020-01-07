IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'gersVwComprasRetenciones') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.gersVwComprasRetenciones;
GO

create view dbo.gersVwComprasRetenciones as
-- Propósito. Obtiene datos para reporte Compras retenciones del ATS Ecuador
--31/03/15 jcf Creación
--11/02/16 jcf Reemplaza tabla de impuestos por vista
--24/04/17 jcf Filtrar anulados
--
select pm.VCHRNMBR, pm.pordnmbr, year(pm.PSTGDATE) anio, MONTH(pm.PSTGDATE) mes,
		dbo.gersFnGetSegmentoX(2, TX00201.taxdtlid) codRetencion,
       SUM(pim.tdttxpur) baseImponible,
       case when SUM(pim.tdttxpur) <> 0 then
	       (100 * SUM(pim.taxamnt) / SUM(pim.tdttxpur)) 
	   else 0
	   end tasaRetencion,
       SUM(pim.taxamnt) retencion
  from vwPmTransaccionesTodas pm
       inner join dbo.vwPmImpuestos pim
		on pm.VCHRNMBR = pim.VCHRNMBR
		and pm.doctype  = pim.doctype  
       inner join TX00201
	    on TX00201.taxdtlid = pim.taxdtlid     
		and TX00201.cmnytxid = 'P-RETIN'
		and TX00201.txdtltyp = 2  
where pm.doctype  <= 5 
	and pm.voided = 0

group by pm.VCHRNMBR, pm.pordnmbr, year(pm.PSTGDATE), MONTH(pm.PSTGDATE), dbo.gersFnGetSegmentoX(2, TX00201.taxdtlid)
go

  IF (@@Error = 0) PRINT 'Creación exitosa de la vista: gersVwComprasRetenciones'
ELSE PRINT 'Error en la creación de la vista: gersVwComprasRetenciones'
GO

------------------------------------------------------------------------------------------------

--select *
--from TX00201

--select *
--from PM10500

--select pm.doctype, pm.vchrnmbr, pm.DOCDATE, pm.pstgdate, t.TAXDTLID, b.*, r.*
--  from vwPmTransaccionesTodas pm
--  inner join PM10500 t
--	on pm.VCHRNMBR = t.VCHRNMBR
--  and pm.doctype  = t.doctype
--  inner join TX00201 b
--	on b.taxdtlid = t.taxdtlid     
--  --and b.cmnytxid = 'P-RETIN'
--  and b.txdtltyp = 2  
--  inner join eBizSCR_30001 r
--	on r.VCHRNMBR = pm.VCHRNMBR
--where 
----  and 
--pm.doctype  <= 5 
--  and year(pm.pstgdate) = 2015
--  and month(pm.pstgdate) = 6
  
  
--select *
--from   eBizSCR_30001