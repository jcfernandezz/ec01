IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwCompanyData]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP view dbo.vwCompanyData;
GO

create view dbo.vwCompanyData as
	select 
		rtrim(cmpnynam) cmpnynam,
		rtrim(ci.TAXREGTN ) TAXREGTN, 
		rtrim(locatnnm) locatnnm,
		RTRIM(ci.ADRCNTCT) adrcntct, 
		rtrim(ci.ADDRESS1) address1, 
		rtrim(ci.ADDRESS2) address2, 
		rtrim(ci.ADDRESS3) address3, 
		RTRIM(ci.CITY) ciudad, 
		RTRIM(ci.COUNTY) municipio, 
		RTRIM(ci.[STATE]) estado,  
		RTRIM(ci.CMPCNTRY) pais, 
		RTRIM(ci.ZIPCODE) codigoPostal, 
		rtrim(ci.ADDRESS1)+' '+rtrim(ci.ADDRESS2)+' '+RTRIM(ci.ZIPCODE)+' '+RTRIM(ci.CITY)+' '+RTRIM(ci.CMPCNTRY) Direccion,
		ISNULL(nt.INET7, '') inet7,
		ISNULL(nt.INET8, '') inet8
	from DYNAMICS..SY01500 ci			--sy_company_mstr
	left join SY01200 nt				--coInetAddress
		on nt.Master_Type = 'CMP'
		and nt.Master_ID = ci.INTERID
		and nt.ADRSCODE = ci.LOCATNID
	where ci.INTERID = DB_NAME()

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwCompanyData'
ELSE PRINT 'Error en la creación de la vista: vwCompanyData'
GO
------------------------------------------------------------------------------
--test
--select cmpnynam,TAXREGTN,locatnnm,adrcntct,address1,address2,address3,ciudad,municipio,estado,pais,codigoPostal,Direccion,inet7,inet8
--from dbo.vwCompanyData
