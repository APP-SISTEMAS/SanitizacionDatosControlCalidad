use APP_SISTEMAS

/*NOTA:los comentarios con una tabulacion indican que son casos ya tratados y resueltos*/
/*Ignorar*/
SELECT ANCHO_MATERIAL, ESPESOR, ISNUMERIC(ANCHO_MATERIAL),  ISNUMERIC(ESPESOR)
FROM SIQM_ENC_AUDI_LAMI
group by ANCHO_MATERIAL, ESPESOR

--/*Total de casos campo Ancho_Material"*/
--SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
--FROM SIQM_ENC_AUDI_LAMI
--group by ANCHO_MATERIAL


-------------------------------------------------------------------
/*Consulta guia de casos en general sin tratar que sean valores no numericos*/
--SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
--FROM SIQM_ENC_AUDI_LAMI
--where ISNUMERIC(ANCHO_MATERIAL)=0 and ANCHO_MATERIAL is not null
--group by ANCHO_MATERIAL

SELECT ANCHO_MATERIAL
FROM SIQM_ENC_AUDI_LAMI
group by ANCHO_MATERIAL
