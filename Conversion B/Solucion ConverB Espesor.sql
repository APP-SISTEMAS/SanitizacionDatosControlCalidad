
--SELECT  ESPESOR , ISNUMERIC(ESPESOR)
--FROM SIQM_ENC_AUDI_CONVE_B
--group by ESPESOR

-------------------------------------------------------------------
/*NO TOCAR,en buen estado*/
select ESPESOR,ESPESOR as valor 
from SIQM_ENC_AUDI_CONVE_B
where TRY_CAST(espesor as float) >10 
group by ESPESOR 
union all

-------------------------------------------------------------------
/*caso especial, NULOS*/
select ESPESOR, 0
from SIQM_ENC_AUDI_CONVE_B
where espesor is null 
group by ESPESOR
union all

-------------------------------------------------------------------
/*caso #1 solo numeros*/
select ESPESOR,null
from SIQM_ENC_AUDI_CONVE_B
where TRY_CAST(espesor as float) <10 
group by ESPESOR 

/*Solucion*/
update SIQM_ENC_AUDI_CONVE_B
set ESPESOR=null
where TRY_CAST(espesor as float) <10 


go

-- Convirtiendo el campo a tipo Numerico
ALTER TABLE  SIQM_ENC_AUDI_conve_B ALTER COLUMN espesor DECIMAL(15,2)
GO 