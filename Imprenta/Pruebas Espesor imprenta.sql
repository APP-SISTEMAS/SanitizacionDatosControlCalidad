use APP_SISTEMAS

--SELECT  ESPESOR  FROM SIQM_ENC_AUDI_IMP 
--where ISNUMERIC(ESPESOR)=0
--group by ESPESOR 


select ESPESOR from SIQM_ENC_AUDI_IMP
where TRY_CAST(espesor as float) <10 or TRY_CAST(espesor as float) is null 
group by ESPESOR 
except

select espesor from (

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
union all

-------------------------------------------------------------------
/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, 
round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
FROM SIQM_ENC_AUDI_IMP
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, 
trim(replace(replace(replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(replace(ESPESOR,' ','')),'micras','mc'))-3,4)),'m',''),'l',''),'c',''))
FROM SIQM_ENC_AUDI_IMP
where  (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso especial 0.79(20micras)*/
SELECT ESPESOR,20
FROM SIQM_ENC_AUDI_IMP
where  ESPESOR='0.79(20micras)'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso especial 0.4724 (12 MIC)*/
SELECT ESPESOR,12
FROM SIQM_ENC_AUDI_IMP
where  ESPESOR='0.4724 (12 MIC)'
group by ESPESOR
--union all

---------------------------------------------------------------------
--/*Caso especial 2.9 (73.66 MICRAS)*/
--SELECT ESPESOR,73.66
--FROM SIQM_ENC_AUDI_SLTR
--where  ESPESOR='2.9 (73.66 MICRAS)'
--group by ESPESOR
) as v

