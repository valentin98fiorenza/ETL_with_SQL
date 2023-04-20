USE DW_COMERCIAL;

--- VALIDACIONES DIM ---


-- Comparación entre la cantidad de registros en la tabla STG_DIM_CATEGORIA y DIM_CATEGORIA

SELECT COUNT(stg.COD_CATEGORIA) AS RegistrosSTG, 
COUNT(dim.COD_CATEGORIA) AS RegistrosDIM 
FROM STG_DIM_CATEGORIA stg
LEFT JOIN DIM_CATEGORIA dim 
ON stg.COD_CATEGORIA = dim.COD_CATEGORIA;


/* Comparación entre el nombre completo en la columna DESC_CLIENTE de la tabla
STG_DIM_CLIENTE y la separación a los campos NOMBRE y APELLIDO en la tabla DIM_CLIENTE */

-- En primer lugar descartamos la posibilidad de un nombre completo con 4 partes

SELECT DESC_CLIENTE FROM STG_DIM_CLIENTE
WHERE DESC_CLIENTE LIKE '% % % %';

-- Vemos los registros con nombres y apellidos no compuestos en ambas tablas

SELECT stg.DESC_CLIENTE, dim.NOMBRE, dim.APELLIDO 
FROM STG_DIM_CLIENTE stg 
JOIN DIM_CLIENTE dim 
ON stg.COD_CLIENTE = dim.COD_CLIENTE
WHERE stg.DESC_CLIENTE NOT LIKE '% % %';

-- Registros con nombres y apellidos compuestos en ambas tablas

SELECT stg.DESC_CLIENTE, dim.NOMBRE, dim.APELLIDO 
FROM STG_DIM_CLIENTE stg 
JOIN DIM_CLIENTE dim 
ON stg.COD_CLIENTE = dim.COD_CLIENTE
WHERE stg.DESC_CLIENTE LIKE '% % %';



-- Comparación entre la cantidad de registros en la tabla STG_DIM_PAIS y DIM_PAIS

SELECT COUNT(stg.COD_PAIS) AS RegistrosSTG, 
COUNT(dim.COD_PAIS) AS RegistrosDIM 
FROM STG_DIM_PAIS stg
LEFT JOIN DIM_PAIS dim 
ON stg.COD_PAIS = dim.COD_PAIS;



-- Comparación entre la cantidad de registros en la tabla STG_DIM_PRODUCTO y DIM_PRODUCTO

SELECT COUNT(stg.COD_PRODUCTO) AS RegistrosSTG, 
COUNT(dim.COD_PRODUCTO) AS RegistrosDIM 
FROM STG_DIM_PRODUCTO stg
LEFT JOIN DIM_PRODUCTO dim 
ON stg.COD_PRODUCTO = dim.COD_PRODUCTO;



-- Comparación entre la cantidad de registros en la tabla STG_DIM_SUCURSAL y DIM_SUCURSAL

SELECT COUNT(stg.COD_SUCURSAL) AS RegistrosSTG, 
COUNT(dim.COD_SUCURSAL) AS RegistrosDIM 
FROM STG_DIM_SUCURSAL stg
LEFT JOIN DIM_SUCURSAL dim 
ON stg.COD_SUCURSAL = dim.COD_SUCURSAL;



-- Comparación entre la cantidad de registros en la tabla STG_DIM_VENDEDOR y DIM_VENDEDOR

SELECT COUNT(stg.COD_VENDEDOR) AS RegistrosSTG, 
COUNT(dim.COD_VENDEDOR) AS RegistrosDIM 
FROM STG_DIM_VENDEDOR stg
LEFT JOIN DIM_VENDEDOR dim 
ON stg.COD_VENDEDOR = dim.COD_VENDEDOR;


/* Comparación entre el nombre completo en la columna DESC_VENDEDOR de la tabla
STG_DIM_VENDEDOR y la separación a los campos NOMBRE y APELLIDO en la tabla DIM_VENDEDOR */

-- En primer lugar descartamos la posibilidad de un nombre completo con 4 partes

SELECT DESC_VENDEDOR FROM STG_DIM_VENDEDOR
WHERE DESC_VENDEDOR LIKE '% % % %';

-- Vemos los registros con nombres y apellidos no compuestos en ambas tablas

SELECT stg.DESC_VENDEDOR, dim.NOMBRE, dim.APELLIDO 
FROM STG_DIM_VENDEDOR stg 
JOIN DIM_VENDEDOR dim 
ON stg.COD_VENDEDOR = dim.COD_VENDEDOR
WHERE stg.DESC_VENDEDOR NOT LIKE '% % %';

-- Registros con nombres y apellidos compuestos en ambas tablas

SELECT stg.DESC_VENDEDOR, dim.NOMBRE, dim.APELLIDO 
FROM STG_DIM_VENDEDOR stg 
JOIN DIM_VENDEDOR dim 
ON stg.COD_VENDEDOR = dim.COD_VENDEDOR
WHERE stg.DESC_VENDEDOR LIKE '% % %';



--- VALIDACIONES FACT_VENTAS ---


-- Cantidad de registros en la tabla STG_FACT_VENTAS

SELECT COUNT(*) RegistrosSTG
FROM STG_FACT_VENTAS;

-- Cantidad de registros en la tabla FACT_VENTAS

SELECT COUNT(*) RegistrosFACT
FROM FACT_VENTAS;

-- Cantidad de registros al agrupar por la PK compuesta

SELECT PRODUCTO_KEY, CLIENTE_KEY, VENDEDOR_KEY, SUCURSAL_KEY, TIEMPO_KEY
FROM FACT_VENTAS
GROUP BY PRODUCTO_KEY, CLIENTE_KEY, VENDEDOR_KEY, SUCURSAL_KEY, TIEMPO_KEY;



--- Comparaciones entre precios totales, agrupado por diferentes campos ---

/* Precio total por producto insertado en tabla temporal para realizar la suma total
y luego comparar con el total de la tabla FACT_VENTAS */

SELECT PRODUCTO_KEY, SUM(PRECIO) PRECIO_TOTAL 
INTO #PRECIO_GROUPBY_PRODUCTO
FROM FACT_VENTAS 
GROUP BY PRODUCTO_KEY;

-- Vemos qué hay en la tmp

SELECT * FROM #PRECIO_GROUPBY_PRODUCTO;

-- Unimos ambos resultados en una consulta. Si los valores coinciden, la validación es correcta.

SELECT SUM(PRECIO_TOTAL) TOTAL_PRECIO FROM #PRECIO_GROUPBY_PRODUCTO 
UNION ALL  
SELECT SUM(PRECIO) TOTAL_PRECIO
FROM FACT_VENTAS;



/* Precio total por cliente insertado en tabla temporal para realizar la suma total
y luego comparar con el total de la tabla FACT_VENTAS */

SELECT CLIENTE_KEY, SUM(PRECIO) PRECIO_TOTAL 
INTO #VENTAS_GROUPBY_CLIENTE
FROM FACT_VENTAS 
GROUP BY CLIENTE_KEY;

-- Vemos qué hay en la tmp

SELECT * FROM #VENTAS_GROUPBY_CLIENTE;

-- Unimos ambos resultados en una consulta. Si los valores coinciden, la validación es correcta.

SELECT SUM(PRECIO_TOTAL) TOTAL_PRECIO FROM #VENTAS_GROUPBY_CLIENTE 
UNION ALL  
SELECT SUM(PRECIO) TOTAL_PRECIO
FROM FACT_VENTAS;



--- Comparaciones entre montos totales, agrupado por diferentes campos ---


/* Monto total por vendedor insertado en tabla temporal para realizar la suma total
y luego comparar con el total de la tabla FACT_VENTAS */

SELECT VENDEDOR_KEY, SUM(MONTO_VENDIDO) MONTO_VENDIDO 
INTO #MONTO_GROUPBY_VENDEDOR
FROM FACT_VENTAS 
GROUP BY VENDEDOR_KEY;

-- Vemos qué hay en la tmp

SELECT * FROM #MONTO_GROUPBY_VENDEDOR;

-- Unimos la suma total de los resultados obtenidos en ambas tablas

SELECT SUM(MONTO_VENDIDO) MONTO_TOTAL FROM #MONTO_GROUPBY_VENDEDOR 
UNION ALL  
SELECT SUM(MONTO_VENDIDO) MONTO_TOTAL
FROM FACT_VENTAS;


/* Monto total por sucursal insertado en tabla temporal para realizar la suma total
y luego comparar con el total de la tabla FACT_VENTAS */

SELECT SUCURSAL_KEY, SUM(MONTO_VENDIDO) MONTO_VENDIDO 
INTO #MONTO_GROUPBY_SUCURSAL
FROM FACT_VENTAS 
GROUP BY SUCURSAL_KEY;

-- Vemos qué hay en la tmp

SELECT * FROM #MONTO_GROUPBY_SUCURSAL;

-- Unimos la suma total de los resultados obtenidos en ambas tablas

SELECT SUM(MONTO_VENDIDO) MONTO_TOTAL FROM #MONTO_GROUPBY_SUCURSAL 
UNION ALL  
SELECT SUM(MONTO_VENDIDO) MONTO_TOTAL
FROM FACT_VENTAS;



--- Productos vendidos ---

SELECT distinct dim.PRODUCTO_KEY, dim.COD_PRODUCTO, dim.DESC_PRODUCTO 
FROM FACT_VENTAS fact JOIN DIM_PRODUCTO dim
ON fact.PRODUCTO_KEY = dim.PRODUCTO_KEY;


--- COMPROBACIONES REGLAS DE NEGOCIO ---

-- Un producto puede estar en más de una venta.

SELECT PRODUCTO_KEY, COUNT(*) Cantidad_de_apariciones
FROM FACT_VENTAS
GROUP BY PRODUCTO_KEY;


-- En una venta un producto puede tener más de una cantidad vendida.

SELECT TOP 10 PRODUCTO_KEY, CLIENTE_KEY, VENDEDOR_KEY, SUCURSAL_KEY,TIEMPO_KEY, CANTIDAD_VENDIDA
FROM FACT_VENTAS 
WHERE CANTIDAD_VENDIDA > 1;

-- Una Sucursal puede contener más de una venta.

SELECT SUCURSAL_KEY, COUNT(*) Cantidad_de_apariciones
FROM FACT_VENTAS
GROUP BY SUCURSAL_KEY;

-- Un Producto corresponde a una Categoría.

SELECT PRODUCTO_KEY, CATEGORIA_KEY
FROM FACT_VENTAS
GROUP BY PRODUCTO_KEY, CATEGORIA_KEY
ORDER BY PRODUCTO_KEY

-- Un vendedor puede estar en más de una venta.

SELECT VENDEDOR_KEY, COUNT(*) Cantidad_de_apariciones
FROM FACT_VENTAS
GROUP BY VENDEDOR_KEY;

-- El nivel de detalle de ventas es diario.

SELECT TIEMPO_KEY, SUM(PRECIO) SUM_PRECIO, SUM(MONTO_VENDIDO) SUM_MONTO
, SUM(CANTIDAD_VENDIDA) SUM_CANTIDAD FROM FACT_VENTAS
GROUP BY TIEMPO_KEY
ORDER BY TIEMPO_KEY;


--- MÉTRICAS ---

----- Monto Total de Ventas ($) -----

SELECT SUM(MONTO_VENDIDO) MONTO_TOTAL_VENTAS
FROM FACT_VENTAS;

----- Cantidad vendida (#) -----

--- Cantidad total de ventas ---

SELECT SUM(CANTIDAD_VENDIDA) AS CANTIDAD_TOTAL_VENDIDA
FROM FACT_VENTAS;

--- Cantidad total de ventas por producto ---

SELECT dim.COD_PRODUCTO, dim.DESC_PRODUCTO, SUM(CANTIDAD_VENDIDA) AS CANTIDAD_VENDIDA_POR_PRODUCTO
FROM FACT_VENTAS fact
JOIN DIM_PRODUCTO dim 
ON dim.PRODUCTO_KEY = fact.PRODUCTO_KEY
GROUP BY dim.COD_PRODUCTO, dim.DESC_PRODUCTO;

--- Cantidad total de ventas por cliente ---

SELECT dim.COD_CLIENTE, NOMBRE, APELLIDO, SUM(CANTIDAD_VENDIDA) AS CANTIDAD_COMPRADA
FROM FACT_VENTAS fact
JOIN DIM_CLIENTE dim
ON fact.CLIENTE_KEY = dim.CLIENTE_KEY
GROUP BY dim.COD_CLIENTE, NOMBRE, APELLIDO;

--- Cantidad total de ventas por vendedor ---

SELECT dim.VENDEDOR_KEY, NOMBRE, APELLIDO, SUM(CANTIDAD_VENDIDA) AS CANTIDAD_VENDIDA_POR_VENDEDOR
FROM FACT_VENTAS fact
JOIN DIM_VENDEDOR dim
ON dim.VENDEDOR_KEY = fact.VENDEDOR_KEY
GROUP BY dim.VENDEDOR_KEY, NOMBRE, APELLIDO;

--- Cantidad total de ventas por día ---

SELECT TIEMPO_KEY, SUM(CANTIDAD_VENDIDA) AS CANTIDAD_VENDIDA_POR_DIA
FROM FACT_VENTAS
GROUP BY TIEMPO_KEY
ORDER BY TIEMPO_KEY;

--- Cantidad total de ventas por pais ---

SELECT dim.COD_PAIS, dim.DESC_PAIS, SUM(CANTIDAD_VENDIDA) AS CANTIDAD_VENDIDA_POR_PAIS
FROM FACT_VENTAS fact
JOIN DIM_PAIS dim
ON dim.PAIS_KEY = fact.PAIS_KEY
GROUP BY dim.COD_PAIS, dim.DESC_PAIS
ORDER BY dim.COD_PAIS;

----- Monto promedio de Ventas ($) -----

--- Monto promedio de ventas ---

SELECT AVG(MONTO_VENDIDO) AS MONTO_PROMEDIO_VENTAS 
FROM FACT_VENTAS;

--- Monto promedio de ventas por vendedor ---

SELECT dim.VENDEDOR_KEY, NOMBRE, APELLIDO, AVG(MONTO_VENDIDO) AS MONTO_PROMEDIO_POR_VENDEDOR
FROM FACT_VENTAS fact
JOIN DIM_VENDEDOR dim
ON dim.VENDEDOR_KEY = fact.VENDEDOR_KEY
GROUP BY dim.VENDEDOR_KEY, NOMBRE, APELLIDO;

--- Promedio de monto vendido por día por sucursal ---

SELECT fact.TIEMPO_KEY, dim.COD_SUCURSAL, dim.DESC_SUCURSAL, AVG(MONTO_VENDIDO) AS MONTO_PROMEDIO_POR_SUCURSAL_DIARIO
FROM FACT_VENTAS fact
JOIN DIM_SUCURSAL dim
ON dim.SUCURSAL_KEY = fact.SUCURSAL_KEY
GROUP BY fact.TIEMPO_KEY, dim.COD_SUCURSAL, dim.DESC_SUCURSAL;


-- Importe Comisión Comercial ($)

SELECT SUM(COMISION_COMERCIAL) AS IMPORTE_TOTAL_COMISION_COMERCIAL 
FROM FACT_VENTAS;


----- Cantidad de Clientes (#) -----

-- Comparación entre la cantidad de registros en la tabla STG_DIM_CLIENTE y DIM_CLIENTE

SELECT COUNT(stg.COD_CLIENTE) AS RegistrosSTG, 
COUNT(dim.COD_CLIENTE) AS RegistrosDIM 
FROM STG_DIM_CLIENTE stg
LEFT JOIN DIM_CLIENTE dim 
ON stg.COD_CLIENTE = dim.COD_CLIENTE;

--- Clientes que realizaron compras ---

SELECT distinct dim.CLIENTE_KEY, dim.COD_CLIENTE, dim.NOMBRE, dim.APELLIDO 
FROM FACT_VENTAS fact JOIN DIM_CLIENTE dim
ON fact.CLIENTE_KEY = dim.CLIENTE_KEY;


----- COMPROBACIONES DEL FUNCIONAMIENTO DE LA CARGA POR PERÍODOS EN LA TABLA FACT_VENTAS ------

EXEC dbo.sp_carga_fact_ventas '2018-01-01', '2019-01-01';

/* Al tener previamente estos registros cargados, la cantidad de registros no debe cambiar.
Sin embargo, los campos FECHA_ALTA y USUARIO_ALTA (en caso de que sea un nuevo usuario), 
deberíaN ser diferente para los registros comprendidos en este período */

SELECT * FROM FACT_VENTAS
ORDER BY FECHA_ALTA;
