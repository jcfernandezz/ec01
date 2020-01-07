--GA ECUADOR
--REPORTES ATS
--
--30/3/15 JCF Creación
-----------------------------------------------------------------------------------
--use [bd compañía]
EXEC sp_addrolemember 'rol_ats', 'GADVENTURES\greatplains' ;

EXEC sp_addrolemember 'rol_ats', 'GADVENTURES\daniel_ceron' ;

--atención!!
--dar acceso a los reportes SSRS de la carpeta GAPEC
