---------------------------------------------
--backup de la tabla
select * --into tmp_ACA_IETU00400_150225
from ACA_IETU00400


-----------------------------------------------------
--restaura datos luego de actualizar esctructura de tabla
insert into aca_ietu00400 (doctype, vchrnmbr, aca_gasto, aca_iva)
select doctype, vchrnmbr, aca_gasto, aca_iva
from tmp_ACA_IETU00400_150225


select *
from aca_ietu00400 