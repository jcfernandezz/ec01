-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.gersFnGetSegmentoX') IS NOT NULL
   DROP FUNCTION dbo.gersFnGetSegmentoX
GO

create function dbo.gersFnGetSegmentoX(@numSegmento smallint, @p_texto varchar(21))
returns varchar(21)
--Propósito. Obtiene el segmento x de una cadena separada por guión
--30/3/15 jcf Creación 
--
begin
	DECLARE @texto varchar(21) = rtrim(@p_texto)+'-',
			@i int = 0
	declare	@indiceFin int = charindex('-', @texto, 1), 
			@indiceIni int = 1,
			@segmento varchar(21)
	WHILE @i < @numSegmento and @indiceFin > 0 BEGIN
		SET @i = @i + 1
		select @segmento = substring(@texto, @indiceIni, @indiceFin-@indiceIni)
		select @indiceIni = @indiceFin+1
		select @indiceFin = charindex('-', @texto, @indiceIni)
	END
	if(@i <> @numSegmento)
		select @segmento = ''
	
	return @segmento
					
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de: gersFnGetSegmentoX()'
ELSE PRINT 'Error en la creación de: gersFnGetSegmentoX()'
GO
------------------------------------------------------------------------------------
--test
--select dbo.gersFnGetSegmentoX(3, '3838-38538')
