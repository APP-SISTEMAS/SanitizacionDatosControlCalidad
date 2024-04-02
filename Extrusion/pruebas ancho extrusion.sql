use APP_SISTEMAS

/*ejecutar sin filtros*/
/*consulta para saber si hay datos sin tratar*/

select ancho from SIQM_ENC_AUDI_EXT group by ANCHO
EXCEPt

select ancho from (
-----------------------------------------------------------------------
/*EN BUEN ESTADO*/
select ancho,cast(ANCHO as float) as conversion from SIQM_ENC_AUDI_EXT 
where ISNUMERIC(ancho)<>0 and CAST(ancho as float)>100 group by ANCHO
union all

/*NULOS NOTA:QUITAR EL 0*/
select ancho,0 from SIQM_ENC_AUDI_EXT 
where ANCHO is null
union all

/*NOTA: este caso presenta un formato extraño, por ejemplo
"25 1/4" + 4FL + 1 1/2"" es uno de los valores, resuelto a excepcion del antes expuesto
*/
select ancho,
round(cast(LEFT(replace(ancho,'"',''),CHARINDEX('+',replace(ancho,'"',''))-1) as float)*25.4,0)
from SIQM_ENC_AUDI_EXT
where ANCHO like '%+%' and ancho not like '25 1/4" + 4FL + 1 1/2"'
group by ANCHO
union all

/*caso excluido arriba*/
select ancho,641
from SIQM_ENC_AUDI_EXT
where ANCHO='25 1/4" + 4FL + 1 1/2"'
group by ANCHO
union all

/*CASO ESPECIAL 27 5"*/
select ancho,round(cast(REPLACE(REPLACE(ancho,' ','.'),'"','')as float)*25.4,0)
from SIQM_ENC_AUDI_EXT where ANCHO='27 5"'
union all

/*reemplazo de caso 1 y 2*/
SELECT ancho, replace(replace(ANCHO,'MM',''),'"','')ANCHO FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm%' and ANCHO not like '%(%'
group by ancho
union all

/*caso "*/
SELECT ancho, replace(replace(ANCHO,'"',''),'"','')ANCHO FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%"' and isnumeric(REPLACE(ancho,'"',''))=1
group by ancho
union all

/*caso de pulg y (mm)*/
SELECT ancho,
replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),'mm)','')
FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm)%' or ANCHO like '%mm )%'
group by ANCHO
union all

/*caso de pulgadas sin unidad de medida*/
select ancho,round(CAST(ancho as float)*25.4,0) from SIQM_ENC_AUDI_EXT 
where ISNUMERIC(ancho)<>0 and CAST(ancho as float)<100 group by ANCHO
union all

/*caso de mm y (pulg)*/
SELECT ancho,
LEFT(replace(ancho,' ',''),CHARINDEX('mm',replace(ancho,' ',''))-1)
FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm(%' or ANCHO like '%mm (%'
group by ANCHO
union all

/*Solucion division de fraccion*/
select ancho,round((left(ltrim(ancho),2)+(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))-2,2)/cast(replace(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))+1,2),'"','') as float)))*25.4,0)
from SIQM_ENC_AUDI_EXT 
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '%mm%' and ANCHO not like '%+%'
group by ANCHO
union all

/*caso especial de pulgadas sin conversion, substrayendo las pulgadas dentro
de los parentesis para su consecuente conversion*/
select ancho,round(
cast(replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),')','')
as float)*25.4,0)
from SIQM_ENC_AUDI_EXT 
where ANCHO like '%/%' and ANCHO like '%(%' 
and ANCHO not like '%mm%' and ANCHO not like '%+%'
group by ANCHO
union all

/*caso especial, valor de formato unico, con su tratamiento especial*/
select ancho,1422 from SIQM_ENC_AUDI_EXT where ANCHO='56" (1422)'

) as T
