use APP_SISTEMAS

----------------------------------------------------------------
	/*En buen estado*/
select LARGO_BOLSA,
cast(LARGO_BOLSA as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_CONVE_B
where ISNUMERIC(LARGO_BOLSA)<>0 and CAST(LARGO_BOLSA as decimal(15,2))>100
group by LARGO_BOLSA
union all



-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT LARGO_BOLSA,
cast((LARGO_BOLSA*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_CONVE_B
where ISNUMERIC(LARGO_BOLSA)=1 and cast(LARGO_BOLSA as float)<100
group by LARGO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_B
set LARGO_BOLSA=cast((LARGO_BOLSA*25.4) as decimal(15,2))
where ISNUMERIC(LARGO_BOLSA)=1 and cast(LARGO_BOLSA as float)<100

go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_CONVE_B ALTER COLUMN LARGO_BOLSA DECIMAL(15,2)
GO 