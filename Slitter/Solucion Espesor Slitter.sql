use APP_SISTEMAS


-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor 
from SIQM_ENC_AUDI_SLTR
where TRY_CAST(espesor as float) >10 
group by ESPESOR 

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, ESPESOR as x 
from SIQM_ENC_AUDI_SLTR 
where espesor is null 
group by ESPESOR

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,round(cast(ESPESOR as float)*25.4,0)
from SIQM_ENC_AUDI_SLTR
where TRY_CAST(espesor as float) <10 
group by ESPESOR 

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR=round(cast(ESPESOR as float)*25.4,0)
where tRY_CAST(espesor as float) <10 

-------------------------------------------------------------------
/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
FROM SIQM_ENC_AUDI_SLTR
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR= round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
where (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'

-------------------------------------------------------------------
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(ESPESOR),'micras','mc'))-4,4)),'m','')
FROM SIQM_ENC_AUDI_SLTR
where  (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR= replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(ESPESOR),'micras','mc'))-4,4)),'m','')
where (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'

-------------------------------------------------------------------
/*Caso especial 3.4 "*/
SELECT ESPESOR,86
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='3.4 "'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR=86
where ESPESOR='3.4 "'

-------------------------------------------------------------------
/*Caso especial 0.79(20MICRAS)*/
SELECT ESPESOR,20
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='0.79(20MICRAS)'
group by ESPESOR

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR=20
where ESPESOR='0.79(20MICRAS)'

-------------------------------------------------------------------
/*Caso especial 2.9 (73.66 MICRAS)*/
SELECT ESPESOR,73.66
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='2.9 (73.66 MICRAS)'

/*Solucion*/
update SIQM_ENC_AUDI_SLTR
set ESPESOR=73.66
where ESPESOR='2.9 (73.66 MICRAS)'


go
-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_SLTR ALTER COLUMN ESPESOR DECIMAL(15,2)
GO 