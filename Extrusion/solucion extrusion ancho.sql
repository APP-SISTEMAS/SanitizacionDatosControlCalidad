use APP_SISTEMAS

/*EN BUEN ESTADO*/
select ancho as conversion from SIQM_ENC_AUDI_EXT 
where ISNUMERIC(ancho)<>0 and CAST(ancho as float)>100 group by ANCHO


/*NULOS*/
select ancho from SIQM_ENC_AUDI_EXT 
where ANCHO is null


/*NOTA: este caso presenta un formato extraño, por ejemplo
"25 1/4" + 4FL + 1 1/2"" es uno de los valores, resuelto a excepcion del antes expuesto
*/
select ancho,
round(cast(LEFT(replace(ancho,'"',''),CHARINDEX('+',replace(ancho,'"',''))-1) as float)*25.4,0)
from SIQM_ENC_AUDI_EXT
where ANCHO like '%+%' and ancho not like '25 1/4" + 4FL + 1 1/2"'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=round(cast(LEFT(replace(ancho,'"',''),CHARINDEX('+',replace(ancho,'"',''))-1) as float)*25.4,0)
where ANCHO like '%+%' and ancho not like '25 1/4" + 4FL + 1 1/2"'


/*Caso excluido arriba*/
select ancho,641
from SIQM_ENC_AUDI_EXT
where ANCHO='25 1/4" + 4FL + 1 1/2"'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=641
where ANCHO='25 1/4" + 4FL + 1 1/2"'


/*CASO ESPECIAL 27 5"
NOTA: update a este caso único
*/
select ancho,round(cast(REPLACE(REPLACE(ancho,' ','.'),'"','')as float)*25.4,0)
from SIQM_ENC_AUDI_EXT where ANCHO='27 5"'

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ancho=round(cast(REPLACE(REPLACE(ancho,' ','.'),'"','')as float)*25.4,0)
where ANCHO='27 5"'


/*Primer caso, quitar el MM y el "(signo de pulgadas) en el mismo campo*/
SELECT ancho, replace(replace(ANCHO,'MM',''),'"','')ANCHO FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm%' and ANCHO not like '%(%'
group by ancho

/*Solucion*/
update SIQM_ENC_AUDI_EXT set ANCHO=replace(replace(ANCHO,'MM',''),'"','')
where ANCHO like '%mm%' and ANCHO not like '%(%'


/*Segundo caso, quitar el "(signo de pulgadas)*/
SELECT ancho, replace(replace(ANCHO,'"',''),'"','')ANCHO FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%"' and isnumeric(REPLACE(ancho,'"',''))=1
group by ancho

/*Solucion*/
update SIQM_ENC_AUDI_EXT set ANCHO=replace(replace(ANCHO,'"',''),'"','')
where ANCHO like '%"' and isnumeric(REPLACE(ancho,'"',''))=1


/*Tercer caso, datos en formato de pulg con fraccion(algunos con el signo " y (mm),
solo se etrae el numero de adentro de los parentesis, correspondiente a la
unidad de medida solicitada*/
SELECT ancho,
replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),'mm)','')
FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm)%' or ANCHO like '%mm )%'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),'mm)','')
where ANCHO like '%mm)%' or ANCHO like '%mm )%'


/*Cuarto caso de pulgadas sin unidad de medida*/
select ancho,
round(CAST(ancho as float)*25.4,0) 
from SIQM_ENC_AUDI_EXT 
where ISNUMERIC(ancho)<>0 and CAST(ancho as float)<100 
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT set ANCHO=round(CAST(ancho as float)*25.4,0)
where ISNUMERIC(ancho)<>0 and CAST(ancho as float)<100 


/*Quinto caso, de mm y (pulg), solo se extrae el numero afuera 
de los parentesis que esta en la unidad solicitada*/
SELECT ancho,
LEFT(replace(ancho,' ',''),CHARINDEX('mm',replace(ancho,' ',''))-1)
FROM SIQM_ENC_AUDI_EXT 
where ANCHO like '%mm(%' or ANCHO like '%mm (%'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT set ANCHO=LEFT(replace(ancho,' ',''),CHARINDEX('mm',replace(ancho,' ',''))-1)
where ANCHO like '%mm(%' or ANCHO like '%mm (%'


/*Sexto caso, conversion de fraccion en pulgadas a un entero en mm*/
select ancho,
round((left(ltrim(ancho),2)+(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))-2,2)/cast(replace(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))+1,2),'"','') as float)))*25.4,0)
from SIQM_ENC_AUDI_EXT 
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '%mm%' and ANCHO not like '%+%'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=round((left(ltrim(ancho),2)+(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))-2,2)/cast(replace(substring(replace(replace(ANCHO,'"',''),'¨',''),
CHARINDEX('/',replace(replace(ANCHO,'"',''),'¨',''))+1,2),'"','') as float)))*25.4,0)
where ANCHO like '%/%' and ANCHO not like '%(%' and ANCHO not like '%mm%' and ANCHO not like '%+%'


/*Septimo caso, caso especial de pulgadas sin conversion, substrayendo las pulgadas dentro
de los parentesis para su consecuente conversion*/
select ancho,
round(cast(replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),')','') as float)*25.4,0)
from SIQM_ENC_AUDI_EXT 
where ANCHO like '%/%' and ANCHO like '%(%' and ANCHO not like '%mm%' and ANCHO not like '%+%'
group by ANCHO

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=round(cast(replace(replace(right(ancho,len(ancho)-CHARINDEX('(',ancho)),' ',''),')','') as float)*25.4,0)
where ANCHO like '%/%' and ANCHO like '%(%' and ANCHO not like '%mm%' and ANCHO not like '%+%'


/*Octavo caso, caso especial, valor de formato unico, con su tratamiento especial*/
select ancho,1422 from SIQM_ENC_AUDI_EXT where ANCHO='56" (1422)'

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ANCHO=1422
where ANCHO='56" (1422)'