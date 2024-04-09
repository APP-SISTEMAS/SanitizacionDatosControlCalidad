use APP_SISTEMAS

--SELECT  ESPESOR , ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_CONVE_A 
--group by ESPESOR

--SELECT  ANCHO_BOLSA,ISNUMERIC(ANCHO_BOLSA), LARGO_BOLSA,ISNUMERIC(LARGO_BOLSA), ESPESOR , ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_CONVE_B 
--group by ANCHO_BOLSA,LARGO_BOLSA,ESPESOR


select ESPESOR
from SIQM_ENC_AUDI_CONVE_A
where TRY_CAST(espesor as float) <10 or TRY_CAST(espesor as float) is null 
group by ESPESOR 
except

select espesor from (

-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor 
from SIQM_ENC_AUDI_CONVE_A
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, 0
from SIQM_ENC_AUDI_CONVE_A
where espesor is null 
group by ESPESOR
union all

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,
round(cast(ESPESOR as float)*25.4,0)
from SIQM_ENC_AUDI_CONVE_A
where TRY_CAST(espesor as float) <10 
group by ESPESOR 


) as v
group by ESPESOR