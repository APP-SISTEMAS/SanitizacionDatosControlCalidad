use APP_SISTEMAS

/*ejecutar sin filtros*/
/*consulta para saber si hay datos sin tratar*/

select ESPESOR from SIQM_ENC_AUDI_EXT 
where TRY_CAST(espesor as float) <10 or TRY_CAST(espesor as float) is null 
group by ESPESOR --order by ESPESOR asc
except

select espesor from (

/*NO TOCAR, CASOS BUENOS*/
select ESPESOR,ESPESOR as valor from SIQM_ENC_AUDI_EXT 
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

 /* caso sin resolver, NULOS*/
select ESPESOR, ESPESOR as x from SIQM_ENC_AUDI_EXT 
where espesor is null 
group by ESPESOR
union all

/*caso #1 solo numeros*/
select ESPESOR,cast(ESPESOR as float)*25.4 from SIQM_ENC_AUDI_EXT 
where TRY_CAST(espesor as float) <10 
group by ESPESOR 
union all

/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4 FROM SIQM_ENC_AUDI_EXT 
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR
union all
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(ESPESOR,'micras','mc'))-4,3) FROM SIQM_ENC_AUDI_EXT 
where  ESPESOR like '%mc%' or ESPESOR like '%micras%' 
group by ESPESOR

) as t




