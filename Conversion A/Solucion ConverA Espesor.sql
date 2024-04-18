
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

update SIQM_ENC_AUDI_CONVE_A
set ESPESOR=round(cast(ESPESOR as float)*25.4,0)
where TRY_CAST(espesor as float) < 10 

go

-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_conve_A ALTER COLUMN espesor DECIMAL(15,2)
GO 