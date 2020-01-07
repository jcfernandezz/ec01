
IF OBJECT_ID ('trg_POP10300LAndina_del','TR') IS NOT NULL
   DROP TRIGGER dbo.trg_POP10300LAndina_del
GO
CREATE TRIGGER dbo.trg_POP10300LAndina_del ON dbo.POP10300
AFTER DELETE
AS
--Propósito. Luego de eliminar una recepción/factura POP, elimina la información adicional de compras de loc. Andina
--Referencia. 
--Requisito. Debe estar instalado Loc. Andina
--18/04/13 JCF Creación. 
--
begin try
	DECLARE @POPTYPE smallint, @TranName VARCHAR(20);
	SELECT @TranName = 'infoAdicional', @POPTYPE = 0;
	

    SELECT @POPTYPE = POPTYPE
     FROM deleted 

	if @POPTYPE = 3	--factura
	begin
		BEGIN TRANSACTION @TranName;
		DELETE ia
		from nsacoa_gl00021	ia	--[nsa_RUC_Prov VENDORID DOCNUMBR]
			inner join deleted pr
				on pr.poptype = @POPTYPE
				and pr.vendorid = ia.vendorid
				and pr.VNDDOCNM = ia.docnumbr
		
		IF @@ROWCOUNT > 1			--si elimina más de una factura rollback
			ROLLBACK TRANSACTION @TranName;
		ELSE
			COMMIT TRANSACTION @TranName;
	end 

end try

BEGIN catch
	declare @l_error varchar(100)
	select @l_error = 'Error al eliminar datos adicionales de factura. (trg_POP10300LAndina_del)'
	RAISERROR (@l_error , 16, 1)
end catch
go
-------------------------------------------------------------------------------------------------------
