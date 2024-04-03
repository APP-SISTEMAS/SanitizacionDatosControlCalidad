use APP_SISTEMAS


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

----------------------------------------------------------------------------------------
	/*Caso especial 1000 (39  3/8")*/
select ANCHO_MATERIAL,1000
from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='1000 (39  3/8")'
group by ANCHO_MATERIAL
union all

--/*Solucion*/
--update SIQM_ENC_AUDI_LAMI
--set ANCHO_MATERIAL=1000
--where ANCHO_MATERIAL='1000 (39  3/8")'

----------------------------------------------------------------------------------------
	/*Caso especial 1000 (39  3/8")*/
select ANCHO_MATERIAL,991 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='991mm + 1085mm'
union all

----------------------------------------------------------------------------------------
	/*Caso especial 34 7/8"/ 33 1/2"*/
select ANCHO_MATERIAL,886 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='34 7/8"  /  33 1/2"' or ANCHO_MATERIAL='34 7/8"/ 33 1/2"'
union all

----------------------------------------------------------------------------------------
	/*Caso especial 35"/ 33 1/2"*/
select ANCHO_MATERIAL,889 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='35"/ 33 1/2"'
union all

----------------------------------------------------------------------------------------
	/*Caso especial 26.77" / 27"*/
select ANCHO_MATERIAL,680 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='26.77" / 27"'
union all

---------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select ANCHO_MATERIAL,0 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL is null
group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------------------------
	/*Caso especial Pulgadas representadas con un " y divididas con un (Y)
	ejemplo=26.77" Y 27"*/
SELECT ANCHO_MATERIAL, round(left(ANCHO_MATERIAL,charindex('"',ANCHO_MATERIAL)-1)*25.4,0)
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL like '%Y%'  
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
	/*Caso especial 1000 (MM), presentaba un conflicto para el caso de abajo
	NOTA: darle prioridad a ejecutar este update primero*/
SELECT ANCHO_MATERIAL, 1000
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='1000 (MM)'
--/*Solucion*/
--update SIQM_ENC_AUDI_LAMI
--set ANCHO_MATERIAL=1000
--where ANCHO_MATERIAL='1000 (MM)'
union all

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO_MATERIAL,
replace(replace(replace(right(ANCHO_MATERIAL,len(ANCHO_MATERIAL)-
CHARINDEX('(',ANCHO_MATERIAL)+1),' ',''),'mm)',''),'(','')
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
	/*Caso division de fracciones ya en milimetros, solo recortar los 4 o 3 primeros digitos*/
select ANCHO_MATERIAL,
left((left(replace(ANCHO_MATERIAL,'MM',''),
charindex('/',replace(ANCHO_MATERIAL,'MM',''))-1)),
charindex('/',replace(ANCHO_MATERIAL,'MM',''))-1)
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' 
and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and ANCHO_MATERIAL not like '%"'
and ANCHO_MATERIAL like '%__/__%'
group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------------------------------------
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

) as t
group by ANCHO_MATERIAL
