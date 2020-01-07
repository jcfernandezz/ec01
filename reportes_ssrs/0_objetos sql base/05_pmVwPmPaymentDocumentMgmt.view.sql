create view vwPmPaymentDocumentMgmt as
SELECT pmtdocid, docnumbr, doctype, vendorid
FROM RVLPD025
union all
SELECT pmtdocid, docnumbr, doctype, vendorid
FROM RVLPD026

---------------------------------------------------------------------------
select *
from vwPmPaymentDocumentMgmt
