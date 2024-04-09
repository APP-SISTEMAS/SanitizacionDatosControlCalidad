use APP_SISTEMAS


-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor from SIQM_ENC_AUDI_LAMI 
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, ESPESOR as x from SIQM_ENC_AUDI_LAMI 
where espesor is null 
group by ESPESOR
union all

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,cast(ESPESOR as float)*25.4 
from SIQM_ENC_AUDI_LAMI
where TRY_CAST(espesor as float) <10 
group by ESPESOR 

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ESPESOR=cast(ESPESOR as float)*25.4 
where TRY_CAST(espesor as float) <10 

-------------------------------------------------------------------
/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4 
FROM SIQM_ENC_AUDI_LAMI
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ESPESOR=cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4 
where (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'

-------------------------------------------------------------------
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(ESPESOR),'micras','mc'))-5,5)),'m','')
FROM SIQM_ENC_AUDI_LAMI
where  ESPESOR like '%mc%' or ESPESOR like '%micras%' 
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ESPESOR=replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(ESPESOR),'micras','mc'))-5,5)),'m','')
where ESPESOR like '%mc%' or ESPESOR like '%micras%'

-------------------------------------------------------------------
/*Caso especial "20 MIC"*/
SELECT ESPESOR,20
FROM SIQM_ENC_AUDI_LAMI
where  ESPESOR='20 MIC'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_LAMI
set ESPESOR=20
where ESPESOR='20 MIC'

GO 


ALTER TABLE SIQM_ENC_AUDI_LAMI ALTER COLUMN ESPESOR DECIMAL(15,2)
GO 