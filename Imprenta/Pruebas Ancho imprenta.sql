use APP_SISTEMAS


SELECT ancho
FROM SIQM_ENC_AUDI_IMP
group by ANCHO
except

select ancho from (

--------------------------------------------------------------------------------
	/*En buen estado*/
SELECT ancho, cast(ANCHO as decimal(15,2)) as conversion 
FROM SIQM_ENC_AUDI_IMP
where isnumeric(ancho)=1 and cast(ANCHO as float)>100
group by ANCHO
union all

--------------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select ANCHO,0 
from SIQM_ENC_AUDI_IMP
where ANCHO is null
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,1010
from SIQM_ENC_AUDI_IMP
where ANCHO='1010mm 39.76"'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,445
from SIQM_ENC_AUDI_IMP
where ANCHO='17.51 445'
group by ANCHO
union all

------------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ancho, cast((ANCHO*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_IMP
where isnumeric(ancho)=1 and cast(ANCHO as float)<100
group by ANCHO
union all

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO,
replace(replace(replace(right(ANCHO,len(ANCHO)-
CHARINDEX('(',ANCHO)+1),' ',''),'mm)',''),'(','')
FROM SIQM_ENC_AUDI_IMP
where ANCHO like '%mm)%' or ANCHO like '%mm )%' 
group by ANCHO
UNION ALL


---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO,
LEFT(replace(ANCHO,' ',''),CHARINDEX('mm',replace(ANCHO,' ',''))-1)
FROM SIQM_ENC_AUDI_IMP
where ANCHO like '%mm(%' or ANCHO like '%mm (%' or ANCHO like '%mm  (%'
group by ANCHO
union all


----------------------------------------------------------------------------------------------------
	/*Caso division de fracciones mixtas en pulg*/
select ANCHO,
round((left(ltrim(ANCHO),2)+
(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'�',''))-2,2)/
cast(replace(substring(replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'�',''),
CHARINDEX('/',replace(replace(REPLACE(REPLACE(ancho,'  ',' '),'  ',' '),'"',''),'�',''))+1,2),'"','') as float)))
*25.4,0)
from SIQM_ENC_AUDI_IMP
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '% / %'
and ANCHO not like '%mm%' and ANCHO not like '%+%'  and ANCHO not like '%"/%' 
and (ANCHO like '% __/%' or ANCHO like '% _/%')
group by ANCHO
union all

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO, replace(replace(ANCHO,'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_IMP
where ANCHO like '%"' and isnumeric(REPLACE(ANCHO,'"',''))=1
group by ANCHO
union all

----------------------------------------------------------------------
/*Caso mm */
SELECT ancho, replace(replace(ANCHO,'MM',''),'"','')ANCHO 
FROM SIQM_ENC_AUDI_IMP
where (ANCHO like '%mm%' and ANCHO not like '%(%')
and ANCHO!='1010mm 39.76"'
group by ancho
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,1035
from SIQM_ENC_AUDI_IMP
where ANCHO='40 3/4" (40.75)'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,489
from SIQM_ENC_AUDI_IMP
where ANCHO='19.25 Y 21 '
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,630
from SIQM_ENC_AUDI_IMP
where ANCHO='24 13/16" (24.80)'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,603
from SIQM_ENC_AUDI_IMP
where ANCHO='24.75 / (23.75)'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,785
from SIQM_ENC_AUDI_IMP
where ANCHO='30 15/16" (30.90)'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,514
from SIQM_ENC_AUDI_IMP
where ANCHO='20.25 Y 21'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,1000
from SIQM_ENC_AUDI_IMP
where ANCHO='1000 / 1085'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,445
from SIQM_ENC_AUDI_IMP
where ANCHO='17.5" TUBO U'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,641
from SIQM_ENC_AUDI_IMP
where ANCHO='25.1/4"'
group by ANCHO


) as h

