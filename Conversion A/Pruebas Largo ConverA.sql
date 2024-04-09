use APP_SISTEMAS

SELECT  LARGO_BOLSA,ISNUMERIC(LARGO_BOLSA)/*, ESPESOR , ISNUMERIC(ESPESOR) */
FROM SIQM_ENC_AUDI_CONVE_A 
group by LARGO_BOLSA--,ESPESOR

--SELECT  ANCHO_BOLSA,ISNUMERIC(ANCHO_BOLSA), LARGO_BOLSA,ISNUMERIC(LARGO_BOLSA), ESPESOR , ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_CONVE_B 
--group by ANCHO_BOLSA,LARGO_BOLSA,ESPESOR


SELECT LARGO_BOLSA
FROM SIQM_ENC_AUDI_CONVE_A
group by LARGO_BOLSA
except

SELECT LARGO_bolsa
FROM (

----------------------------------------------------------------
	/*En buen estado*/
select LARGO_BOLSA,
cast(LARGO_BOLSA as decimal(15,2)) as conversion 
from SIQM_ENC_AUDI_CONVE_A
where ISNUMERIC(LARGO_BOLSA)<>0 and CAST(LARGO_BOLSA as decimal(15,2))>100
group by LARGO_BOLSA
union all

----------------------------------------------------------------------------------------
	/*Caso especial texto sin formato */
select LARGO_BOLSA,null
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='N/A'
group by LARGO_BOLSA
union all

------------------------------------------------------------------------------------------
	/*Caso especial 11 1/2¨ +2¨ FF, 
	representa un problema en los formatos de las querys, 
	hacer update con urgencia*/
select LARGO_BOLSA,292
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='11 1/2¨ +2¨ FF'
group by LARGO_BOLSA
union all

/*Solucion*/
--update SIQM_ENC_AUDI_CONVE_A
--set largo_bolsa=292
--where LARGO_BOLSA='11 1/2¨ +2¨ FF'

------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,457
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='17  3/4¨+1 3/4¨ff'
union all

------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,368
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='14 /2" '
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,292
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='11 1/2¨+1 1/2¨FF'
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,470
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='18 1/2"+3 1/2"FF'
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,240
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='9 7/16" + 2"FF'
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,210
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='8 1/4"+1"FF'
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,464
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='18 1/4"+1 3/4"FF'
union all
------------------------------------------------------------------------------------------
	/*Caso especial */
select LARGO_BOLSA,254
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA='10" (254M)'
union all
---------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select LARGO_BOLSA,0 
from SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA is null
group by LARGO_BOLSA
union all

----------------------------------------------------------------------------------------
	/*Caso especial Pulgadas representadas con un " y divididas con un (+)
	ejemplo=26" + 9" fl*/
SELECT LARGO_BOLSA,
try_cast(left(replace(replace(LARGO_BOLSA,'¨','"'),'"',''),
charindex('+',replace(replace(LARGO_BOLSA,'¨','"'),'"',''))-1)as float)*25.4 as total
FROM SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA like '%+%' and LARGO_BOLSA not like '%mm%'  and
(LARGO_BOLSA not like '% _/_"+%' and LARGO_BOLSA not like '% _/__" +%' and LARGO_BOLSA not like '% _/_¨+%' )
group by LARGO_BOLSA
union all

-----------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT LARGO_BOLSA,
cast((LARGO_BOLSA*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_CONVE_A
where ISNUMERIC(LARGO_BOLSA)=1 and cast(LARGO_BOLSA as float)<100
group by LARGO_BOLSA
union all

----------------------------------------------------------------------
	/*Caso numeros en la unidad correcta pero con su signo (mm) y caso mm/mm eligiendo el de la izquierda*/

SELECT LARGO_BOLSA,
left(LARGO_BOLSA,charindex('mm',LARGO_BOLSA)-1)
FROM SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA like '%mm%' and 
LARGO_BOLSA not like '%(%' and
LARGO_BOLSA not like '%/%' and 
LARGO_BOLSA not like '%+%'
group by LARGO_BOLSA
union all

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT LARGO_BOLSA, 
replace(replace(replace(LARGO_BOLSA,'¨',''),'"',''),'"','')*25.4 as LARGO
FROM SIQM_ENC_AUDI_CONVE_A
where (LARGO_BOLSA like '%"' or LARGO_BOLSA like '%¨') and isnumeric(REPLACE(replace(LARGO_BOLSA,'¨',''),'"',''))=1
group by LARGO_BOLSA
union all

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT LARGO_BOLSA,
replace(left(replace(replace(replace(replace(right(LARGO_BOLSA,len(LARGO_BOLSA)-
CHARINDEX('(',LARGO_BOLSA)+1),' ',''),'mm)',''),'(',''),'"',''),
4),'+','')
FROM SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA like '%mm)%' or LARGO_BOLSA like '%mm )%' 
group by LARGO_BOLSA
union all

---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT LARGO_BOLSA,
LEFT(replace(LARGO_BOLSA,' ',''),CHARINDEX('mm',replace(LARGO_BOLSA,' ',''))-1)
FROM SIQM_ENC_AUDI_CONVE_A
where LARGO_BOLSA like '%mm(%' or LARGO_BOLSA like '%mm (%' or LARGO_BOLSA like '%mm  (%'
group by LARGO_BOLSA
union all

----------------------------------------------------------------------------------------------------
	/*Caso division de fracciones mixtas en pulg*/
select LARGO_BOLSA,
round((left(ltrim(LARGO_BOLSA),2)+
(substring(replace(replace(REPLACE(REPLACE(LARGO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(LARGO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(LARGO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(LARGO_BOLSA,'  ',' '),'  ',' '),'"',''),'¨',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_CONVE_A 
where LARGO_BOLSA like '%/%' and LARGO_BOLSA not like '%(%' and LARGO_BOLSA not like '% / %'
and LARGO_BOLSA not like '%mm%' and LARGO_BOLSA not like '%+%'  and LARGO_BOLSA not like '%"/%' 
and (LARGO_BOLSA like '% __/%' or LARGO_BOLSA like '% _/%')
group by LARGO_BOLSA

) as t
group by LARGO_bolsa
