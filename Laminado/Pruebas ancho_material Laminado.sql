use APP_SISTEMAS

/*NOTA:los comentarios con una tabulacion indican que son casos ya tratados y resueltos*/

/*Ignorar*/
--SELECT ANCHO_MATERIAL, ESPESOR, ISNUMERIC(ANCHO_MATERIAL),  ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_LAMI
--group by ANCHO_MATERIAL, ESPESOR

--/*Total de casos campo Ancho_Material"*/
--SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
--FROM SIQM_ENC_AUDI_LAMI
--group by ANCHO_MATERIAL

SELECT ANCHO_MATERIAL
FROM SIQM_ENC_AUDI_LAMI
group by ANCHO_MATERIAL
except

SELECT ANCHO_MATERIAL
FROM (



----------------------------------------------------------------
	/*En buen estado*/
select ANCHO_MATERIAL,cast(ANCHO_MATERIAL as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_LAMI 
where ISNUMERIC(ANCHO_MATERIAL)<>0 and CAST(ANCHO_MATERIAL as decimal(15,2))>100
group by ANCHO_MATERIAL
union all

-------------------------------------------------------------------
/*Consulta guia de casos en general sin tratar que sean valores no numericos*/
--SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
--FROM SIQM_ENC_AUDI_LAMI
--where ISNUMERIC(ANCHO_MATERIAL)=0 and ANCHO_MATERIAL is not null
--group by ANCHO_MATERIAL

---------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select ANCHO_MATERIAL,0 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL is null
group by ANCHO_MATERIAL
union all
-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ANCHO_MATERIAL,cast((ANCHO_MATERIAL*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_LAMI
where ISNUMERIC(ANCHO_MATERIAL)=1 and cast(ANCHO_MATERIAL as float)<100
group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------
	/*Caso numeros en la unidad correcta pero con su signo (mm) y caso mm/mm eligiendo el de la izquierda*/

SELECT ANCHO_MATERIAL, left(ANCHO_MATERIAL,charindex('mm',ANCHO_MATERIAL)-1)
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL like '%mm%' and 
ANCHO_MATERIAL not like '%(%' and
ANCHO_MATERIAL not like '%/%' and 
ANCHO_MATERIAL not like '%+%'
or ANCHO_MATERIAL like '% mm/%' or ANCHO_MATERIAL like '%mm /%' or ANCHO_MATERIAL like '%mm/_%' 
group by ANCHO_MATERIAL
union all

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO_MATERIAL, replace(replace(ANCHO_MATERIAL,'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL like '%"' and isnumeric(REPLACE(ANCHO_MATERIAL,'"',''))=1
group by ANCHO_MATERIAL
union all

---------------------------------------------------------------------------------
	/*Caso especial 1000 (MM), presentaba un conflicto para el caso de abajo*/
--SELECT ANCHO_MATERIAL, 1000
--FROM SIQM_ENC_AUDI_LAMI
--where ANCHO_MATERIAL='1000 (MM)'
--/*Solucion*/
--update SIQM_ENC_AUDI_LAMI
--set ANCHO_MATERIAL=1000
--where ANCHO_MATERIAL='1000 (MM)'

---------------------------------------------------------------------------------------
/*Caso de pulg y (mm)*/
SELECT ANCHO_MATERIAL,
replace(replace(replace(right(ANCHO_MATERIAL,len(ANCHO_MATERIAL)-CHARINDEX('(',ANCHO_MATERIAL)+1),' ',''),'mm)',''),'(','')
FROM SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%mm)%' --or ANCHO_MATERIAL like '%mm )%' 
group by ANCHO_MATERIAL
union all

---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO_MATERIAL,
LEFT(replace(ANCHO_MATERIAL,' ',''),CHARINDEX('mm',replace(ANCHO_MATERIAL,' ',''))-1)
FROM SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%mm(%' or ANCHO_MATERIAL like '%mm (%' or ANCHO_MATERIAL like '%mm  (%'
group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------------------------
/*Caso division de fracciones ya en milimetros, solo recortar los 4 primeros digitos*/
select ANCHO_MATERIAL,(left(ANCHO_MATERIAL,charindex('/',ANCHO_MATERIAL)-1))
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' 
and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and ANCHO_MATERIAL not like '%"'
and ANCHO_MATERIAL like '% / %'
and  len(substring(replace(ANCHO_MATERIAL,' ',''),0,CHARINDEX('/',replace(ANCHO_MATERIAL,' ',''),0)))=4
and not len(substring(ANCHO_MATERIAL,0,CHARINDEX('/',ANCHO_MATERIAL,0)))=3

group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------------------------------------
/*Caso division de fracciones ya en milimetros, solo recortar los 3 primeros digitos*/
select ANCHO_MATERIAL,(left(ANCHO_MATERIAL,charindex('/',ANCHO_MATERIAL)-1))
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
and ANCHO_MATERIAL not like '%mm%' and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and not len(substring(replace(ANCHO_MATERIAL,' ',''),0,CHARINDEX('/',replace(ANCHO_MATERIAL,' ',''),0)))=4
and  len(substring(ANCHO_MATERIAL,0,CHARINDEX('/',ANCHO_MATERIAL,0)))=3
group by ANCHO_MATERIAL
union all

---------------------------------------------------------------------------------------
/*Caso division de fracciones mixtas en pulg*/
select ANCHO_MATERIAL,
round((left(ltrim(ANCHO_MATERIAL),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
and ANCHO_MATERIAL not like '%mm%' and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%' 
and (ANCHO_MATERIAL like '% __/%' or ANCHO_MATERIAL like '% _/%')
group by ANCHO_MATERIAL

----------------------------------------------------------------------------------------
/*Caso especial 1000 (39  3/8")*/
--select ANCHO_MATERIAL,1000
--from SIQM_ENC_AUDI_LAMI
--where ANCHO_MATERIAL='1000 (39  3/8")'
--group by ANCHO_MATERIAL
--/*Solucion*/
--update SIQM_ENC_AUDI_LAMI
--set ANCHO_MATERIAL=1000
--where ANCHO_MATERIAL='1000 (39  3/8")'

) as t
/*
union all

-----------------------------------------------------------------------------------------------------
/*caso especial*/
select ANCHO_MATERIAL,(left(ltrim(ANCHO_MATERIAL),3))
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL not like '%___/___%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
 and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and not len(substring(replace(ANCHO_MATERIAL,' ',''),0,CHARINDEX('/',replace(ANCHO_MATERIAL,' ',''),0)))=4
and  len(substring(ANCHO_MATERIAL,0,CHARINDEX('/',ANCHO_MATERIAL,0)))=3
or ANCHO_MATERIAL like '% mm/%' or ANCHO_MATERIAL like '%mm /%' or ANCHO_MATERIAL like '%mm/_%' 
group by ANCHO_MATERIAL

union all

-----------------------------------------------------------------------------------------------------
/*caso especial*/
select ANCHO_MATERIAL,(left(ltrim(ANCHO_MATERIAL),4))
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL not like '%___/___%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
 and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and len(substring(replace(ANCHO_MATERIAL,' ',''),0,CHARINDEX('/',replace(ANCHO_MATERIAL,' ',''),0)))=4
and not len(substring(ANCHO_MATERIAL,0,CHARINDEX('/',ANCHO_MATERIAL,0)))=3
or ANCHO_MATERIAL like '% mm/%' or ANCHO_MATERIAL like '%mm /%' or ANCHO_MATERIAL like '%mm/_%' 
group by ANCHO_MATERIAL


 and (left(ltrim(ANCHO_MATERIAL),3))<>3
--select COD_PRODUCTO from SIQM_ENC_AUDI_LAMI 
--where ANCHO_MATERIAL='991mm + 1085mm' --ANCHO_MATERIAL='1000MM / 1030MM'-- or ANCHO_MATERIAL='34 7/8"/ 33 1/2"'

/*Caso a definir xd*/
--SELECT ANCHO_MATERIAL, ISNUMERIC(ANCHO_MATERIAL)
--FROM SIQM_ENC_AUDI_LAMI
--where ISNUMERIC(ANCHO_MATERIAL)=0 and ANCHO_MATERIAL is not null
--group by ANCHO_MATERIAL

/*SIN TRATAR*/
/*Aqui estan los casos donde hay '+' y num/num*/
--SELECT ANCHO_MATERIAL, replace(replace(ANCHO_MATERIAL,'MM',''),'"','')ANCHO 
--FROM SIQM_ENC_AUDI_LAMI
--where ANCHO_MATERIAL like '%mm%' and ANCHO_MATERIAL not like '%(%'
--group by ANCHO_MATERIAL




*/