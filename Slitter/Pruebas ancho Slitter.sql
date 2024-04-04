use APP_SISTEMAS

--SELECT ancho, ESPESOR, ALTO_REPE
--FROM SIQM_ENC_AUDI_SLTR
--group by ANCHO, ESPESOR,ALTO_REPE


SELECT ancho
FROM SIQM_ENC_AUDI_SLTR
group by ANCHO
except

select ancho from (

--------------------------------------------------------------------------------
	/*En buen estado*/
SELECT ancho, cast(ANCHO as decimal(15,2)) as conversion 
FROM SIQM_ENC_AUDI_SLTR
where isnumeric(ancho)=1 and cast(ANCHO as float)>100
group by ANCHO
union all

--------------------------------------------------------------------------------
	/*NULOS NOTA:QUITAR EL 0*/
select ANCHO_MATERIAL,0 from SIQM_ENC_AUDI_LAMI
where ANCHO_MATERIAL is null
group by ANCHO_MATERIAL
union all

----------------------------------------------------------------------------------------
	/*Caso especial texto sin formato */
select ANCHO,null
from SIQM_ENC_AUDI_SLTR
where ANCHO='CARA COLOR NEGRO EXTERNA' or ANCHO='CARA COLOR EXTERNA' or ANCHO='CARA NEGRA EXTERNA' or ANCHO='N/A'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,990
from SIQM_ENC_AUDI_SLTR
where ANCHO='39", 38.5", 38.75"'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,920
from SIQM_ENC_AUDI_SLTR
where ANCHO='920/991'
group by ANCHO
union all
----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,820
from SIQM_ENC_AUDI_SLTR
where ANCHO='32.25" Y 32"'
group by ANCHO
union all

----------------------------------------------------------------------------------------
	/*Caso especial */
select ANCHO,510
from SIQM_ENC_AUDI_SLTR
where ANCHO='510mm" (20")'
group by ANCHO
union all

------------------------------------------------------------------------------
	/*caso de numeros que falta convertir de pulgadas a milimetros*/
SELECT ancho, cast((ANCHO*25.4) as decimal(15,2))
FROM SIQM_ENC_AUDI_SLTR
where isnumeric(ancho)=1 and cast(ANCHO as float)<100
group by ANCHO
union all

---------------------------------------------------------------------------------------
	/*Caso de pulg y (mm)*/
SELECT ANCHO,
replace(replace(replace(right(ANCHO,len(ANCHO)-
CHARINDEX('(',ANCHO)+1),' ',''),'mm)',''),'(','')
FROM SIQM_ENC_AUDI_SLTR 
where ANCHO like '%mm)%' or ANCHO like '%mm )%' 
group by ANCHO
UNION ALL


---------------------------------------------------------------------------------------
/*Caso de mm y (pulg)*/
SELECT ANCHO,
LEFT(replace(ANCHO,' ',''),CHARINDEX('mm',replace(ANCHO,' ',''))-1)
FROM SIQM_ENC_AUDI_SLTR 
where ANCHO like '%mm(%' or ANCHO like '%mm (%' or ANCHO like '%mm  (%'
group by ANCHO
union all


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
union all

-----------------------------------------------------------------------------
	/*Caso reemplazar las " y pasar a milimetros*/
SELECT ANCHO, replace(replace(ANCHO,'"',''),'"','')*25.4 as ANCHO
FROM SIQM_ENC_AUDI_SLTR
where ANCHO like '%"' and isnumeric(REPLACE(ANCHO,'"',''))=1
group by ANCHO
union all

/*caso 36" //39" (920mm / 991mm)*/
SELECT ancho, 920
FROM SIQM_ENC_AUDI_SLTR
where ANCHO='36" //39" (920mm / 991mm)'
group by ancho
union all

----------------------------------------------------------------------
/*Caso mm */
SELECT ancho, replace(replace(ANCHO,'MM',''),'"','')ANCHO 
FROM SIQM_ENC_AUDI_SLTR
where ANCHO like '%mm%' and ANCHO not like '%(%'
group by ancho

) as h