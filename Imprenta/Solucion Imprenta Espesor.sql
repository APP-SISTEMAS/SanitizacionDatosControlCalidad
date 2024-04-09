use APP_SISTEMAS

-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor 
from SIQM_ENC_AUDI_IMP
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, ESPESOR as x 
from SIQM_ENC_AUDI_IMP
where espesor is null 
group by ESPESOR
union all

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,
round(cast(ESPESOR as float)*25.4,0)
from SIQM_ENC_AUDI_IMP
where TRY_CAST(espesor as float) <10 
group by ESPESOR 

/*Solucion*/
update SIQM_ENC_AUDI_IMP
set ESPESOR=round(cast(ESPESOR as float)*25.4,0)
where TRY_CAST(espesor as float) <10 

-------------------------------------------------------------------
/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR,
round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
FROM SIQM_ENC_AUDI_IMP
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_IMP
set ESPESOR=round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'

-------------------------------------------------------------------
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR,
trim(replace(replace(replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(replace(ESPESOR,' ','')),'micras','mc'))-3,4)),'m',''),'l',''),'c',''))
FROM SIQM_ENC_AUDI_IMP
where  (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_IMP
set ESPESOR=trim(replace(replace(replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(replace(ESPESOR,' ','')),'micras','mc'))-3,4)),'m',''),'l',''),'c',''))
where (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'

-------------------------------------------------------------------
/*Caso especial 0.79(20micras)*/
SELECT ESPESOR,20
FROM SIQM_ENC_AUDI_IMP
where  ESPESOR='0.79(20micras)'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_IMP
set ESPESOR=20
where ESPESOR='0.79(20micras)'

-------------------------------------------------------------------
/*Caso especial 0.4724 (12 MIC)*/
SELECT ESPESOR,12
FROM SIQM_ENC_AUDI_IMP
where  ESPESOR='0.4724 (12 MIC)'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_IMP
set ESPESOR=12
where ESPESOR='0.4724 (12 MIC)'

go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_IMP ALTER COLUMN ESPESOR DECIMAL(15,2)
GO 