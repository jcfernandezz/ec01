IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'gersVwVentasEstablecimiento') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.gersVwVentasEstablecimiento;
GO


create VIEW dbo.gersVwVentasEstablecimiento AS  
-- Prop�sito. Obtiene datos para reporte Ventas Establecimiento del ATS Ecuador
-- 1/4/15 jcf Creaci�n

select substring(dbo.gersFnGetSegmentoX(1, so.sopnumbe), 3, 3) codEstablecimiento, 
	YEAR(docdate) anio, MONTH(docdate) mes,
	SUM(case when so.soptype = 3 then 1 else -1 end * DOCAMNT) docamnt
from 	SOP30200 so
where so.soptype in (3, 4)
group by YEAR(docdate), MONTH(docdate), substring(dbo.gersFnGetSegmentoX(1, so.sopnumbe), 3, 3)

GO

  IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: gersVwVentasEstablecimiento'
ELSE PRINT 'Error en la creaci�n de la vista: gersVwVentasEstablecimiento'
GO

--select '001' 'C�digo del Establecimiento (conforme inscripci�n en el RUC)',
-- 'Ventas por establecimiento'

