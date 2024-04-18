
----------------------------------------------------------------
	/*En buen estado*/
select ANCHO_MATERIAL,cast(ANCHO_MATERIAL as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_LAMI 
where ISNUMERIC(ANCHO_MATERIAL)<>0 and CAST(ANCHO_MATERIAL as decimal(15,2))>100
group by ANCHO_MATERIAL


---------------------------------------------------------------------------
	/*NULOS */
select ANCHO_MATERIAL from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL is null
group by ANCHO_MATERIAL


----------------------------------------------------------------------------------------
	/*Caso especial 1000 (39  3/8")*/
select ANCHO_MATERIAL,1000
from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='1000 (39  3/8")'
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ANCHO_MATERIAL=1000
where ANCHO_MATERIAL='1000 (39  3/8")'

----------------------------------------------------------------------------------------
	/*Caso especial 1000 (39  3/8")*/
select ANCHO_MATERIAL,991 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='991mm + 1085mm'

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=991
where ANCHO_MATERIAL='991mm + 1085mm'

----------------------------------------------------------------------------------------------------
	/*Caso especial formato pulg pero en vez de un punto, tienen un espacio*/
select ancho_material,
round(cast(REPLACE(REPLACE(ancho_material,' ','.'),'"','')as float)*25.4,0)
from SIQM_ENC_AUDI_lami where ANCHO_MATERIAL='20 7' or 
ANCHO_MATERIAL='24 7' or ANCHO_MATERIAL='25 5' or ANCHO_MATERIAL='30 5'
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ANCHO_MATERIAL=round(cast(REPLACE(REPLACE(ancho_material,' ','.'),'"','')as float)*25.4,0)
where ANCHO_MATERIAL='20 7' or 
ANCHO_MATERIAL='24 7' or ANCHO_MATERIAL='25 5' or ANCHO_MATERIAL='30 5'

----------------------------------------------------------------------------------------
	/*Caso especial 34 7/8"/ 33 1/2"*/
select ANCHO_MATERIAL,886 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='34 7/8"  /  33 1/2"' or ANCHO_MATERIAL='34 7/8"/ 33 1/2"'

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=886
where ANCHO_MATERIAL='34 7/8"  /  33 1/2"' or ANCHO_MATERIAL='34 7/8"/ 33 1/2"'

----------------------------------------------------------------------------------------
	/*Caso especial 35"/ 33 1/2"*/
select ANCHO_MATERIAL,889 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='35"/ 33 1/2"'

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=889
where ANCHO_MATERIAL='35"/ 33 1/2"'

----------------------------------------------------------------------------------------
	/*Caso especial 26.77" / 27"*/
select ANCHO_MATERIAL,680 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='26.77" / 27"'

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=680
where ANCHO_MATERIAL='26.77" / 27"'

----------------------------------------------------------------------------------------
	/*Caso especial Pulgadas representadas con un " y divididas con un (Y)
	ejemplo=26.77" Y 27"*/
SELECT ANCHO_MATERIAL, round(left(ANCHO_MATERIAL,charindex('"',ANCHO_MATERIAL)-1)*25.4,0)
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL like '%Y%'  
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=round(left(ANCHO_MATERIAL,charindex('"',ANCHO_MATERIAL)-1)*25.4,0)
where ANCHO_MATERIAL like '%Y%'

-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ANCHO_MATERIAL,cast((ANCHO_MATERIAL*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_LAMI
where ISNUMERIC(ANCHO_MATERIAL)=1 and cast(ANCHO_MATERIAL as float)<100
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=cast((ANCHO_MATERIAL*25.4) as decimal(15,2))
where ISNUMERIC(ANCHO_MATERIAL)=1 and cast(ANCHO_MATERIAL as float)<100

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

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=left(ANCHO_MATERIAL,charindex('mm',ANCHO_MATERIAL)-1)
where ANCHO_MATERIAL like '%mm%' and 
ANCHO_MATERIAL not like '%(%' and
ANCHO_MATERIAL not like '%/%' and 
ANCHO_MATERIAL not like '%+%'
or ANCHO_MATERIAL like '% mm/%' or ANCHO_MATERIAL like '%mm /%' or ANCHO_MATERIAL like '%mm/_%' 

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO_MATERIAL, replace(replace(ANCHO_MATERIAL,'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL like '%"' and isnumeric(REPLACE(ANCHO_MATERIAL,'"',''))=1
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL= replace(replace(ANCHO_MATERIAL,'"',''),'"','')*25.4
where ANCHO_MATERIAL like '%"' and isnumeric(REPLACE(ANCHO_MATERIAL,'"',''))=1

---------------------------------------------------------------------------------
	/*Caso especial 1000 (MM), presentaba un conflicto para el caso de abajo
	NOTA: darle prioridad a ejecutar este update primero*/
SELECT ANCHO_MATERIAL, 1000
FROM SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL='1000 (MM)'

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ANCHO_MATERIAL=1000
where ANCHO_MATERIAL='1000 (MM)'

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO_MATERIAL,
replace(replace(replace(right(ANCHO_MATERIAL,len(ANCHO_MATERIAL)-
CHARINDEX('(',ANCHO_MATERIAL)+1),' ',''),'mm)',''),'(','')
FROM SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%mm)%' 
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=replace(replace(replace(right(ANCHO_MATERIAL,len(ANCHO_MATERIAL)-
CHARINDEX('(',ANCHO_MATERIAL)+1),' ',''),'mm)',''),'(','')
where ANCHO_MATERIAL like '%mm)%'

---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO_MATERIAL,
LEFT(replace(ANCHO_MATERIAL,' ',''),CHARINDEX('mm',replace(ANCHO_MATERIAL,' ',''))-1)
FROM SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%mm(%' or ANCHO_MATERIAL like '%mm (%' or ANCHO_MATERIAL like '%mm  (%'
group by ANCHO_MATERIAL

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=LEFT(replace(ANCHO_MATERIAL,' ',''),CHARINDEX('mm',replace(ANCHO_MATERIAL,' ',''))-1)
where ANCHO_MATERIAL like '%mm(%' or ANCHO_MATERIAL like '%mm (%' or ANCHO_MATERIAL like '%mm  (%'

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

/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=left((left(replace(ANCHO_MATERIAL,'MM',''),
charindex('/',replace(ANCHO_MATERIAL,'MM',''))-1)),
charindex('/',replace(ANCHO_MATERIAL,'MM',''))-1)
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' 
and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%'
and ANCHO_MATERIAL not like '%"'
and ANCHO_MATERIAL like '%__/__%'

----------------------------------------------------------------------------------------------------
	/*Caso division de fracciones mixtas en pulg*/
select ANCHO_MATERIAL,
round((left(ltrim(ANCHO_MATERIAL),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_LAMI 
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
and ANCHO_MATERIAL not like '%mm%' and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%' 
and (ANCHO_MATERIAL like '% __/%' or ANCHO_MATERIAL like '% _/%')
group by ANCHO_MATERIAL


/*Solucion*/
update SIQM_ENC_AUDI_LAMI 
set ANCHO_MATERIAL=round((left(ltrim(ANCHO_MATERIAL),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho_material,'  ',' '),'  ',' '),'"',''),'�',''))+1,2),'"','') as float)))
*25.4,0)
where ANCHO_MATERIAL like '%/%' and ANCHO_MATERIAL not like '%(%' and ANCHO_MATERIAL not like '% / %'
and ANCHO_MATERIAL not like '%mm%' and ANCHO_MATERIAL not like '%+%'  and ANCHO_MATERIAL not like '%"/%' 
and (ANCHO_MATERIAL like '% __/%' or ANCHO_MATERIAL like '% _/%')


go

-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_LAMI ALTER COLUMN ANCHO_MATERIAL DECIMAL(15,2)
GO 