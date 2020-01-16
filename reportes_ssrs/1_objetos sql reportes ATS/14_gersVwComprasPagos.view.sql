IF (OBJECT_ID ('dbo.gersVwComprasPagos', 'V') IS NULL)
   exec('create view dbo.gersVwComprasPagos as SELECT 1 as t');
go

alter view dbo.gersVwComprasPagos as
-- Prop�sito. Obtiene datos para reporte Compras formas de pago del ATS Ecuador
--31/03/15 jcf Creaci�n
--02/09/15 jcf REplanteo de consulta para mostrar pagos mayores a 1000
--06/01/20 jcf Muestra los pagos incluso si no tienen c�digo de medio de pago asociado
--16/01/20 jcf Quita espacios a la derecha en los campos string
--
select rtrim(pm.APTVCHNM) VCHRNMBR, pm.PSTGDATE, 
       left(dm.pmtdocid, 2) formaPago
  from dbo.tii_vwPmAplicadosExtendido pm
  left join dbo.vwPmPaymentDocumentMgmt dm
		on dm.docnumbr = pm.VCHRNMBR
		and dm.doctype = pm.DOCTYPE
 where --pm.doctype <= 3 
	pm.pordnmbr = ''
   and pm.docamnt_apfr > 1000
group by pm.APTVCHNM, pm.PSTGDATE, left(dm.pmtdocid, 2)
       
go

  IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: gersVwComprasPagos'
ELSE PRINT 'Error en la creaci�n de la vista: gersVwComprasPagos'
GO

------------------------------------------------------------------------------------------------

