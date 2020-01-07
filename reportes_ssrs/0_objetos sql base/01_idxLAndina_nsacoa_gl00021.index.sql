--Propósito. No permitir repetidos en factura de compra: vendorid, nsaCoa_Secuencial, nsa_serie
--			No permitir repetidos en factura de venta: DOCNUMBR, DOCTYPE, nsa_RUC_Cliente, CUSTNMBR
--Utilizado por. Localización Andina Ecuador
--28/1/15 jcf Creación
--
CREATE unique NONCLUSTERED INDEX idxLAndina_nsacoa_gl00021
    ON dbo.nsacoa_gl00021 (vendorid, nsaCoa_Secuencial, nsa_serie, nsa_Autorizacion);


create unique nonclustered index idxLAndina_nsacoa_gl00014
	on dbo.nsacoa_gl00014 (DOCNUMBR, DOCTYPE, nsa_RUC_Cliente, CUSTNMBR);
