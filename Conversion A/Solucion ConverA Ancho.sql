use APP_SISTEMAS
----------------------------------------------------------------
	/*En buen estado*/
select ANCHO_BOLSA,cast(ANCHO_BOLSA as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_CONVE_A
where ISNUMERIC(ANCHO_BOLSA)<>0 and CAST(ANCHO_BOLSA as decimal(15,2))>100
group by ANCHO_BOLSA

----------------------------------------------------------------------------------------
	/*Caso especial texto sin formato */
select ANCHO_BOLSA,null
from SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA='#3' or ANCHO_BOLSA='CARA PLATA EXTERNA' or ANCHO_BOLSA='CARA COLOR NEGRO EXTERNA' 
or ANCHO_BOLSA='CARA COLOR EXTERNA' or ANCHO_BOLSA='CARA NEGRA EXTERNA'
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=null
where ANCHO_BOLSA='#3' or ANCHO_BOLSA='CARA PLATA EXTERNA' or ANCHO_BOLSA='CARA COLOR NEGRO EXTERNA' 
or ANCHO_BOLSA='CARA COLOR EXTERNA' or ANCHO_BOLSA='CARA NEGRA EXTERNA'

----------------------------------------------------------------------------------------
	/*Caso especial 18 15/16"+4FL*/
select ANCHO_BOLSA,481
from SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA='18 15/16"+4FL'
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=481
where ANCHO_BOLSA='18 15/16"+4FL'

----------------------------------------------------------------------------------------
	/*Caso especial 7 1/2"+2" FL y 7 1/2"+1 1/4" FL*/
select ANCHO_BOLSA,191
from SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA='7 1/2"+1 1/4" FL' or ANCHO_BOLSA='7 1/2"+2" FL'

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=191
where ANCHO_BOLSA='7 1/2"+1 1/4" FL' or ANCHO_BOLSA='7 1/2"+2" FL'

----------------------------------------------------------------------------------------
	/*Caso especial 5 1/8"+ 7/8" FL y 5 1/8"+1 1/8" FLL*/
select ANCHO_BOLSA,130
from SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA='5 1/8"+ 7/8" FL' or ANCHO_BOLSA='5 1/8"+1 1/8" FL'

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=130
where ANCHO_BOLSA='5 1/8"+ 7/8" FL' or ANCHO_BOLSA='5 1/8"+1 1/8" FL'

---------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select ANCHO_BOLSA,0
from SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA is null
group by ANCHO_BOLSA

----------------------------------------------------------------------------------------
	/*Caso especial Pulgadas representadas con un " y divididas con un (+)
	ejemplo=26" + 9" fl*/
SELECT ANCHO_BOLSA,
try_cast(left(ANCHO_BOLSA,charindex('"',ANCHO_BOLSA)-1)as float)*25.4 as total
FROM SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA like '%+%' and ANCHO_BOLSA not like '_ %' and ANCHO_BOLSA!='18 15/16"+4FL'
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=try_cast(left(ANCHO_BOLSA,charindex('"',ANCHO_BOLSA)-1)as float)*25.4 
where ANCHO_BOLSA like '%+%' and ANCHO_BOLSA not like '_ %' and ANCHO_BOLSA!='18 15/16"+4FL'

-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ANCHO_BOLSA,
cast((ANCHO_BOLSA*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_CONVE_A
where ISNUMERIC(ANCHO_BOLSA)=1 and cast(ANCHO_BOLSA as float)<100
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=cast((ANCHO_BOLSA*25.4) as decimal(15,2))
where ISNUMERIC(ANCHO_BOLSA)=1 and cast(ANCHO_BOLSA as float)<100

----------------------------------------------------------------------
	/*Caso numeros en la unidad correcta pero con su signo (mm) y caso mm/mm eligiendo el de la izquierda*/

SELECT ANCHO_BOLSA, 
left(ANCHO_BOLSA,charindex('mm',ANCHO_BOLSA)-1)
FROM SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA like '%mm%' and 
ANCHO_BOLSA not like '%(%' and
ANCHO_BOLSA not like '%/%' and 
ANCHO_BOLSA not like '%+%'
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=left(ANCHO_BOLSA,charindex('mm',ANCHO_BOLSA)-1)
where ANCHO_BOLSA like '%mm%' and 
ANCHO_BOLSA not like '%(%' and
ANCHO_BOLSA not like '%/%' and 
ANCHO_BOLSA not like '%+%'

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO_BOLSA,
replace(replace(replace(ANCHO_BOLSA,'¨',''),'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_CONVE_A
where (ANCHO_BOLSA like '%"' or ANCHO_BOLSA like '%¨') and isnumeric(REPLACE(replace(ANCHO_BOLSA,'¨',''),'"',''))=1
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=replace(replace(replace(ANCHO_BOLSA,'¨',''),'"',''),'"','')*25.4 
where (ANCHO_BOLSA like '%"' or ANCHO_BOLSA like '%¨') and isnumeric(REPLACE(replace(ANCHO_BOLSA,'¨',''),'"',''))=1

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO_BOLSA,
replace(replace(replace(replace(right(ANCHO_BOLSA,len(ANCHO_BOLSA)-
CHARINDEX('(',ANCHO_BOLSA)+1),' ',''),'mm)',''),'(',''),'"','')
FROM SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA like '%mm)%' or ANCHO_BOLSA like '%mm )%' 
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=replace(replace(replace(replace(right(ANCHO_BOLSA,len(ANCHO_BOLSA)-
CHARINDEX('(',ANCHO_BOLSA)+1),' ',''),'mm)',''),'(',''),'"','')
where ANCHO_BOLSA  like '%mm)%' or ANCHO_BOLSA like '%mm )%' 

---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO_BOLSA,
LEFT(replace(ANCHO_BOLSA,' ',''),CHARINDEX('mm',replace(ANCHO_BOLSA,' ',''))-1)
FROM SIQM_ENC_AUDI_CONVE_A
where ANCHO_BOLSA like '%mm(%' or ANCHO_BOLSA like '%mm (%' or ANCHO_BOLSA like '%mm  (%'
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=LEFT(replace(ANCHO_BOLSA,' ',''),CHARINDEX('mm',replace(ANCHO_BOLSA,' ',''))-1)
where ANCHO_BOLSA like '%mm(%' or ANCHO_BOLSA like '%mm (%' or ANCHO_BOLSA like '%mm  (%'

----------------------------------------------------------------------------------------------------
	/*Caso division de fracciones mixtas en pulg*/
select ANCHO_BOLSA,
round((left(ltrim(ANCHO_BOLSA),2)+
(substring(replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_CONVE_A 
where ANCHO_BOLSA like '%/%' and ANCHO_BOLSA not like '%(%' and ANCHO_BOLSA not like '% / %'
and ANCHO_BOLSA not like '%mm%' and ANCHO_BOLSA not like '%+%'  and ANCHO_BOLSA not like '%"/%' 
and (ANCHO_BOLSA like '% __/%' or ANCHO_BOLSA like '% _/%')
group by ANCHO_BOLSA

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_A
set ANCHO_BOLSA=round((left(ltrim(ANCHO_BOLSA),2)+
(substring(replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ANCHO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
where ANCHO_BOLSA like '%/%' and ANCHO_BOLSA not like '%(%' and ANCHO_BOLSA not like '% / %'
and ANCHO_BOLSA not like '%mm%' and ANCHO_BOLSA not like '%+%'  and ANCHO_BOLSA not like '%"/%' 
and (ANCHO_BOLSA like '% __/%' or ANCHO_BOLSA like '% _/%')


go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_EXT ALTER COLUMN ANCHO DECIMAL(15,2)
GO 