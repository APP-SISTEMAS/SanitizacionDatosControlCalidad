use APP_SISTEMAS


select ESPESOR from SIQM_ENC_AUDI_SLTR 
where TRY_CAST(espesor as float) <10 or TRY_CAST(espesor as float) is null 
group by ESPESOR --order by ESPESOR asc
except

select espesor from (

-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor 
from SIQM_ENC_AUDI_SLTR
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, ESPESOR as x 
from SIQM_ENC_AUDI_SLTR 
where espesor is null 
group by ESPESOR
union all

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,round(cast(ESPESOR as float)*25.4,0)
from SIQM_ENC_AUDI_SLTR
where TRY_CAST(espesor as float) <10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso #2 reemplazar los miles y
multiplicarlos por 25.4 exceptuando
los que contienen micras*/
SELECT ESPESOR, round(cast(replace(replace(ESPESOR,'Ml',''),'Mil','') as float)*25.4,0)
FROM SIQM_ENC_AUDI_SLTR
where  (ESPESOR like '%ml%' or ESPESOR like '%mil%') and ESPESOR not like '%(%'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso #3 substraer las micas o MC*/
SELECT ESPESOR, replace(trim(substring(replace(replace(ESPESOR,'(',''),'micras','mc'),
CHARINDEX('mc',replace(trim(ESPESOR),'micras','mc'))-4,4)),'m','')
FROM SIQM_ENC_AUDI_SLTR
where  (ESPESOR like '%mc%' or ESPESOR like '%micras%' ) 
and ESPESOR!='0.79(20MICRAS)' and ESPESOR!='2.9 (73.66 MICRAS)'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso especial 3.4 "*/
SELECT ESPESOR,86
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='3.4 "'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso especial 0.79(20MICRAS)*/
SELECT ESPESOR,20
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='0.79(20MICRAS)'
group by ESPESOR
union all

-------------------------------------------------------------------
/*Caso especial 2.9 (73.66 MICRAS)*/
SELECT ESPESOR,73.66
FROM SIQM_ENC_AUDI_SLTR
where  ESPESOR='2.9 (73.66 MICRAS)'
group by ESPESOR
) as v

