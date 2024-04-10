use APP_SISTEMAS

----------------------------------------------------------------
	/*En buen estado*/
select ANCHO_BOLSA,
cast(ANCHO_BOLSA as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_CONVE_b
where ISNUMERIC(ANCHO_BOLSA)<>0 and CAST(ANCHO_BOLSA as decimal(15,2))>100
group by ANCHO_BOLSA
union all

-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ANCHO_BOLSA,
cast((ANCHO_BOLSA*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_CONVE_B
where ISNUMERIC(ANCHO_BOLSA)=1 and cast(ANCHO_BOLSA as float)<100
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_B
set ANCHO_BOLSA=cast((ANCHO_BOLSA*25.4) as decimal(15,2))
where ISNUMERIC(ANCHO_BOLSA)=1 and cast(ANCHO_BOLSA as float)<100



go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_CONVE_B ALTER COLUMN ANCHO_BOLSA DECIMAL(15,2)
GO 