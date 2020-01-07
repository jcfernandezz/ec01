--Ecuador
--Reportes ATS
--Propósito. Rol que da accesos a objetos de reportes ATS
--Requisitos. Ejecutar en la compañía.
--30/3/15 JCF Creación
--
-----------------------------------------------------------------------------------
--use [COMPAÑIA]

IF DATABASE_PRINCIPAL_ID('rol_ats') IS NULL
	create role rol_ats;

--Objetos que usa factura electrónica
grant select on vwCompanyData to rol_ats;
grant select on dbo.gersVwComprasDetalladas to rol_ats;
grant select on dbo.gersVwComprasRetenciones to rol_ats;
grant select on dbo.gersVwComprasPagos to rol_ats;
grant select on gersVwVentasCliente to rol_ats;
grant select on gersVwVentasEstablecimiento to rol_ats;
grant select on gersVwFacturasVentaAnuladas to rol_ats;

use dynamics;
IF DATABASE_PRINCIPAL_ID('rol_ats') IS NULL
	create role rol_ats;

grant select on SY01500 to rol_ats;
