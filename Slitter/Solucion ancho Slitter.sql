--/*Solucion*/
--update SIQM_ENC_AUDI_LAMI
--set ANCHO_MATERIAL=1000
--where ANCHO_MATERIAL='1000 (39  3/8")'

use APP_SISTEMAS


--------------------------------------------------------------------------------
	/*En buen estado*/
SELECT ancho, cast(ANCHO as decimal(15,2)) as conversion 
FROM SIQM_ENC_AUDI_SLTR
where isnumeric(ancho)=1 and cast(ANCHO as float)>100
group by ANCHO

--------------------------------------------------------------------------------
	/*NULOS */
select ANCHO_MATERIAL from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL is null
group by ANCHO_MATERIAL

----------------------------------------------------------------------------------------
	/*Caso especial texto sin formato */
select ANCHO,null
from SIQM_ENC_AUDI_SLTR
where ANCHO='CARA COLOR NEGRO EXTERNA' or ANCHO='CARA COLOR EXTERNA' or ANCHO='CARA NEGRA EXTERNA' or ANCHO='N/A'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=null
where ANCHO ='CARA COLOR NEGRO EXTERNA' or ANCHO='CARA COLOR EXTERNA' or ANCHO='CARA NEGRA EXTERNA' or ANCHO='N/A'

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,920
from SIQM_ENC_AUDI_SLTR
where ANCHO='920/991'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=920
where ANCHO ='920/991'

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,990
from SIQM_ENC_AUDI_SLTR
where ANCHO='39", 38.5", 38.75"'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=990
where ANCHO ='39", 38.5", 38.75"'

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,820
from SIQM_ENC_AUDI_SLTR
where ANCHO='32.25" Y 32"'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=820
where ANCHO ='32.25" Y 32"'

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,510
from SIQM_ENC_AUDI_SLTR
where ANCHO='510mm" (20")'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=510
where ANCHO ='510mm" (20")'

------------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ancho, cast((ANCHO*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_SLTR
where isnumeric(ancho)=1 and cast(ANCHO as float)<100
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=cast((ANCHO*25.4) as decimal(15,2))
where isnumeric(ancho)=1 and cast(ANCHO as float)<100

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO,
replace(replace(replace(right(ANCHO,len(ANCHO)-
CHARINDEX('(',ANCHO)+1),' ',''),'mm)',''),'(','')
FROM SIQM_ENC_AUDI_SLTR 
where ANCHO like '%mm)%' or ANCHO like '%mm )%' 
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=replace(replace(replace(right(ANCHO,len(ANCHO)-
CHARINDEX('(',ANCHO)+1),' ',''),'mm)',''),'(','')
where ANCHO like '%mm)%' or ANCHO like '%mm )%' 


---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO,
LEFT(replace(ANCHO,' ',''),CHARINDEX('mm',replace(ANCHO,' ',''))-1)
FROM SIQM_ENC_AUDI_SLTR 
where ANCHO like '%mm(%' or ANCHO like '%mm (%' or ANCHO like '%mm  (%'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=LEFT(replace(ANCHO,' ',''),CHARINDEX('mm',replace(ANCHO,' ',''))-1)
where ANCHO like '%mm(%' or ANCHO like '%mm (%' or ANCHO like '%mm  (%'


----------------------------------------------------------------------------------------------------
	/*Caso division de fracciones mixtas en pulg*/
select ANCHO,
round((left(ltrim(ANCHO),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_SLTR
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '% / %'
and ANCHO not like '%mm%' and ANCHO not like '%+%'  and ANCHO not like '%"/%' 
and (ANCHO like '% __/%' or ANCHO like '% _/%')
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=round((left(ltrim(ANCHO),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '% / %'
and ANCHO not like '%mm%' and ANCHO not like '%+%'  and ANCHO not like '%"/%' 
and (ANCHO like '% __/%' or ANCHO like '% _/%')

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO, replace(replace(ANCHO,'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_SLTR
where ANCHO like '%"' and isnumeric(REPLACE(ANCHO,'"',''))=1
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=replace(replace(ANCHO,'"',''),'"','')*25.4 
where ANCHO like '%"' and isnumeric(REPLACE(ANCHO,'"',''))=1

----------------------------------------------------------------------
/*caso 36" //39" (920mm / 991mm)*/
SELECT ancho, 920
FROM SIQM_ENC_AUDI_SLTR
where ANCHO='36" //39" (920mm / 991mm)'
group by ancho

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=920
where ANCHO ='36" //39" (920mm / 991mm)'

----------------------------------------------------------------------
/*Caso mm */
SELECT ancho, replace(replace(ANCHO,'MM',''),'"','')ANCHO 
FROM SIQM_ENC_AUDI_SLTR
where ANCHO like '%mm%' and ANCHO not like '%(%'
group by ancho

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ANCHO=replace(replace(ANCHO,'MM',''),'"','')
where ANCHO like '%mm%' and ANCHO not like '%(%'

go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_EXT ALTER COLUMN ANCHO DECIMAL(15,2)
GO 