use APP_SISTEMAS

--SELECT ANCHO_MATERIAL, ESPESOR, ISNUMERIC(ANCHO_MATERIAL),  ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_LAMI
--group by ANCHO_MATERIAL, ESPESOR

SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
FROM SIQM_ENC_AUDI_LAMI
group by ANCHO_MATERIAL
----------------------------------------------------------------
/*En buen estado*/
--select ANCHO_MATERIAL,cast(ANCHO_MATERIAL as decimal(15,2)) as conversion 
--from SIQM_ENC_AUDI_LAMI 
--where ISNUMERIC(ANCHO_MATERIAL)<>0 and CAST(ANCHO_MATERIAL as decimal(15,2))>100
--group by ANCHO_MATERIAL
-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
--SELECT ANCHO_MATERIAL,cast((ANCHO_MATERIAL*25.4) as decimal(15,2))
--FROM SIQM_ENC_AUDI_LAMI
--where ISNUMERIC(ANCHO_MATERIAL)=1 and cast(ANCHO_MATERIAL as float)<100
--group by ANCHO_MATERIAL

/*Consulta guia de casos en general sin tratar que sean valores no numericos*/
SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
FROM SIQM_ENC_AUDI_LAMI
where ISNUMERIC(ANCHO_MATERIAL)=0 and ANCHO_MATERIAL is not null
group by ANCHO_MATERIAL
