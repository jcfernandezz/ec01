--GA ECUADOR
--REPORTES ATS
--
--30/3/15 JCF Creaci�n
-----------------------------------------------------------------------------------
--use [bd compa��a]
EXEC sp_addrolemember 'rol_ats', 'GADVENTURES\greatplains' ;

EXEC sp_addrolemember 'rol_ats', 'GADVENTURES\daniel_ceron' ;

--atenci�n!!
--dar acceso a los reportes SSRS de la carpeta GAPEC
