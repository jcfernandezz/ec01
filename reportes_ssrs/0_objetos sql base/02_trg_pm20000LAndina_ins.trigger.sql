
IF OBJECT_ID ('trg_pm20000LAndina_ins','TR') IS NOT NULL
   DROP TRIGGER dbo.trg_pm20000LAndina_ins
GO
CREATE TRIGGER dbo.trg_pm20000LAndina_ins ON dbo.pm20000
AFTER INSERT
AS
--Prop�sito. Luego que una recepci�n/factura POP se contabiliza, sincroniza la informaci�n adicional de compras de loc. Andina
--Referencia. 
--Requisito. Debe estar instalado Loc. Andina
--18/04/13 JCF Creaci�n. 
--
begin try
	DECLARE @BCHSOURC char(15), @TranName VARCHAR(20);
	SELECT @TranName = 'infoAdicional', @BCHSOURC = '';
	
    SELECT @BCHSOURC = rtrim(BCHSOURC)
     FROM inserted 

	if @BCHSOURC = 'Rcvg Trx Entry'
	begin
		BEGIN TRANSACTION @TranName;
		update ia set docnumbr = pr.VCHRNMBR
		--select *
		from nsacoa_gl00021	ia	--[nsa_RUC_Prov VENDORID DOCNUMBR]
			inner join inserted pr
				on pr.doctype = 1
				and pr.vendorid = ia.vendorid
				and pr.docnumbr = ia.docnumbr
				and pr.BCHSOURC = @BCHSOURC
		
		IF @@ROWCOUNT > 1			--si modifica m�s de una factura rollback
			ROLLBACK TRANSACTION @TranName;
		ELSE
			COMMIT TRANSACTION @TranName;
	end 

end try

BEGIN catch
	declare @l_error varchar(100)
	select @l_error = 'Error al sincronizar datos adicionales de factura. (trg_pm20000LAndina_ins)'
	RAISERROR (@l_error , 16, 1)
end catch
go
-------------------------------------------------------------------------------------------------------
