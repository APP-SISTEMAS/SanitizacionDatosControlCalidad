use APP_SISTEMAS

/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor from SIQM_ENC_AUDI_EXT 
where TRY_CAST(espesor as float) >10 
group by ESPESOR 


/*caso especial, NULOS*/
select ESPESOR, ESPESOR as x from SIQM_ENC_AUDI_EXT 
where espesor is null 
group by ESPESOR


/*caso #1 solo numeros*/
select ESPESOR,
cast(ESPESOR as float)*25.4 
from SIQM_ENC_AUDI_EXT 
where TRY_CAST(espesor as float) <10 
group by ESPESOR 

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ESPESOR=cast(ESPESOR as float)*25.4 
where TRY_CAST(espesor as float) <10 


/*caso #2 reemplazar los miles y multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, 
cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4 
FROM SIQM_ENC_AUDI_EXT 
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ESPESOR=cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4 
where (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'


/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, 
substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(ESPESOR,'micras','mc'))-4,3)
FROM SIQM_ENC_AUDI_EXT 
where  ESPESOR like '%mc%' or ESPESOR like '%micras%' 
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_EXT 
set ESPESOR=substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(ESPESOR,'micras','mc'))-4,3)
where ESPESOR like '%mc%' or ESPESOR like '%micras%'