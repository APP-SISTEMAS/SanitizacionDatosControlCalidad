# SanitizacionDatosControlCalidad
Repositorio para realizar los scripts de sanitizacion de datos para los campos de las auditorias del sistema de control de calidad.
Link [https://github.com/APP-SISTEMAS/SanitizacionDatosControlCalidad].

---

## Acerca de Sistema de Control de Calidad (SYSIQM)
Es un sub-sistema derivado del sistema principal de produccion SYSPROD, el cual se encarga de recolectar los datos de las auditorias de calidad en los procesos de *Extrusion, Imprenta, Laminado, Slitter, Conversion A, Conversion B* de la planta de produccion de Polietileno.
El Control de calidad toma las especificaciones o caracteristicas de un producto, definidas en el maestro de ingenieria (*Receta del producto*) y se comparan contra las datos recolectados por los auditores de calidad en el piso de produccion, este flujo se realiza en cada proceso de produccion y la comparacion se da en diferentes undiades de medidas dependiendo el proceso.

El asunto a tomar en cuenta es que tenemos datos que se toman de manera automática desde tablas del (maestro de ingeniería/orden de produccion) que trabaja en unidades de medida mas pequeñas (milimetros y micras) y los datos ingresados por los auditores estan en unidades mas grandes (pulgadas y milesimas). Por lo cual toca realizar conversiones de undiades de medida para poder calcular las tolerancias y validacion de datos.

> Nota Importante:
>   25.4 milimetros => 1 pulgada.
>   25.4 micras     => 1 milesima de pulgada

---
## Detalle de Asignacion de Trabajo



### 1. Proceso de Extrusion.   

Comenzaremos con el proceso de extrusion, en la tabla *SIQM_ENC_AUDI_EXT* hay dos campos *ANCHO* y *ESPESOR* estos campos se llenan automaticamente desde la orden de produccion y ya tienen implicito en los valores las unidades de medida, para el **ANCHO** son **milimetros** para el **Espesor** son **micras**, sin embargo, en los primeros registros se encuentran valores con diferentes unidades de medida y ademas hay valores que son interpretados como texto y no como numero.

```sql
    SELECT ANCHO, ESPESOR FROM SIQM_ENC_AUDI_EXT

    --Puede utilizar la funcion ISNUMERIC() para determinar si el valor es numerico, devuelve 1 en caso verdadero, 0 para falso.
    SELECT  ANCHO, ESPESOR, ISNUMERIC(ANCHO), ISNUMERIC(ESPESOR) FROM SIQM_ENC_AUDI_EXT
```
- [x] Se pide sanitizar los valores del campo *Ancho* a que se manejen todos en la undia de de medida *mililmetros*.
- [x] Convertir los valores del campo *Ancho* que se encuentra en pulgadas interpretados como texto a milimetros en valores numericos, ejemplo: **40 1/2" => 1028.7, 28 3/4" => 730.25, 24 => 609.6**
- [x] En los registros mas recientes los valores del campo *Ancho*, ya se encuentran en milimetros, se notará la deferencia ya que se visualizan valores altos como por ejemplo: **1016.00, 787.40, 584.00, 813.00**

- [x] Se pide sanitizar los valores del campo *Espesor* a que se manejen todos en la undia de de medida *micras*.
- [x] Convertir los valores del campo *Espesor* que se encuentra en mil (milesimas de pulgada) interpretados como texto a micras en valores numericos, ejemplo: **1.3 mil => 33.02, 2 => 50.8, 0.6 => 15.24**
- [x] En los registros mas recientes los valores del campo *Espesor*, ya se encuentran en micras, se notará la deferencia ya que se visualizan valores altos como por ejemplo: **40.64, 76.20, 22.86, 12.70**
- [x] Puede hacer uso de la calculadora de conversion de unidades de medida do google para validar [https://convertlive.com/es/u/convertir/micr%C3%B3metros/a/mil%C3%A9simas-de-pulgada]
[https://convertlive.com/es/u/convertir/pulgadas-de/a/mil%C3%ADmetros#1]

### 2. Proceso de Laminado.   

Continuamos con el proceso de Laminado, en la tabla *SIQM_ENC_AUDI_LAMI* hay dos campos *ANCHO_MATERIAL* y *ESPESOR* estos campos se llenan automaticamente desde la orden de produccion y ya tienen implicito en los valores las unidades de medida, para el **ANCHO_MATERIAL** son **milimetros**, **ESPESOR** son **micras**, sin embargo, en los primeros registros se encuentran valores con diferentes unidades de medida y ademas hay valores que son interpretados como texto y no como numero.

```sql
    SELECT ANCHO_MATERIAL, ESPESOR FROM SIQM_ENC_AUDI_LAMI

    --Puede utilizar la funcion ISNUMERIC() para determinar si el valor es numerico, devuelve 1 en caso verdadero, 0 para falso.
    SELECT  ANCHO_MATERIAL, ESPESOR, ISNUMERIC(ANCHO_MATERIAL),  ISNUMERIC(ESPESOR) FROM SIQM_ENC_AUDI_LAMI
```
- [ ] Se pide sanitizar los valores del campo *Ancho_Material* a que se manejen todos en la unidad de de medida *mililmetros*.
- [ ] Convertir los valores del campo *Ancho_Material* que se encuentra en pulgadas interpretados como texto a milimetros en valores numericos
- [ ] En los registros mas recientes los valores del campo *Ancho_Material*, ya se encuentran en milimetros, se notará la deferencia ya que se visualizan valores altos.

- [ ] Se pide sanitizar los valores del campo *Espesor* a que se manejen todos en la undia de de medida *micras*.
- [ ] Convertir los valores del campo *Espesor* que se encuentra en mil (milesimas de pulgada) interpretados como texto a micras en valores numericos.
- [ ] En los registros mas recientes los valores del campo *Espesor*, ya se encuentran en micras, se notará la deferencia ya que se visualizan valores altos.

