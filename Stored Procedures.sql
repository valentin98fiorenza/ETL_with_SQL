USE DW_COMERCIAL;

-- Carga DIM Tiempo mediante la SP ubicada en el anexo.

CREATE PROCEDURE [dbo].[sp_carga_dim_tiempo]
 @anio Int
As
SET NOCOUNT ON
SET arithabort off
SET arithignore on
 
/**************/
/* Variables  */
/**************/
 
SET DATEFIRST 1;
SET DATEFORMAT mdy
DECLARE @dia smallint
DECLARE @mes smallint
DECLARE @f_txt  	varchar(10)
DECLARE @fecha  smalldatetime
DECLARE @key int
DECLARE @vacio  smallint
DECLARE @fin smallint
DECLARE @fin_mes int
DECLARE @anioperiodicidad int
  	
SELECT @dia  = 1
SELECT @mes  = 1
SELECT @f_txt = Convert(char(2), @mes) + '/' + Convert(char(2), @dia) + '/' + Convert(char(4), @anio)
SELECT @fecha = Convert(smalldatetime, @f_txt)
select @anioperiodicidad = @anio
 
 
/************************************/
/* Se chequea que el a¤o a procesar */
/* no exista en la tabla TIME   	*/
/************************************/
 
 
IF (SELECT Count(*) FROM dim_tiempo WHERE anio = @anio) > 0
  BEGIN
    	Print 'El año que ingreso ya existe en la tabla'
         	Print 'Procedimiento CANCELADO.................'
         	 Return 0
  END
 
 
/*************************/
/* Se inserta d¡a a d¡a  */
/* hasta terminar el a¤o */
/*************************/
 
SELECT @fin = @anio + 1
WHILE (@anio < @fin)
  BEGIN
   	--Armo la fecha
   	IF Len(Rtrim(Convert(Char(2),Datepart(mm, @fecha))))=1
   	  BEGIN
         	IF Len(Rtrim(Convert(Char(2),Datepart(dd, @fecha))))=1
                	SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(mm, @fecha))) + '0' + Rtrim(Convert(Char(2),Datepart(dd, @fecha)))
         	ELSE
                	SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(mm, @fecha))) + Convert(Char(2),Datepart(dd, @fecha))
   	  END
   	ELSE
   	  BEGIN
         	IF Len(Rtrim(Convert(Char(2),Datepart(dd, @fecha))))=1
                	SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + Convert(Char(2),Datepart(mm, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(dd, @fecha)))
         	ELSE
                	SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + Convert(Char(2),Datepart(mm, @fecha)) + Convert(Char(2),Datepart(dd, @fecha))
   	  END
   	--Calculo el último día del mes  
   	SET @fin_mes = day(dateadd(d, -1, dateadd(m, 1, dateadd(d, - day(@fecha) + 1, @fecha))))
 
INSERT Dim_Tiempo (Tiempo_Key, Anio, Mes_nro, Mes_Nombre, Semestre, Trimestre, Semana_Anio
                	,Semana_Nro_Mes, Dia, Dia_Nombre, Dia_Semana_Nro)
 
   	SELECT
         	  tiempo_key    	= @fecha
         	, anio                 	= Datepart(yyyy, @fecha)
         	, mes                  	= Datepart(mm, @fecha)
         	--, mes_nombre = Datename(mm, @fecha)
         	, mes_nombre  = CASE Datename(mm, @fecha)
                                    	when 'January'         	then 'Enero'
                                    	when 'February'        	then 'Febrero'
                                    	when 'March'    	then 'Marzo'
                                    	when 'April'    	then 'Abril'
                                    	when 'May'             	then 'Mayo'
                                    	when 'June'            	then 'Junio'
                                    	when 'July'            	then 'Julio'
                                    	when 'August'   	then 'Agosto'
                                    	when 'September'	then 'Septiembre'
                                    	when 'October'         	then 'Octubre'
                                    	when 'November'        	then 'Noviembre'
                                    	when 'December'        	then 'Diciembre'
                                    	else Datename(mm, @fecha)
                              	END
         	, semestre      	= CASE Datepart(mm, @fecha)
                                    	when (SELECT Datepart(mm, @fecha)
   	                                          	WHERE Datepart(mm, @fecha) between 1 and 6) then 1
                                    	else   2
                              	  END 
         	, trimestre            	= Datepart(qq, @fecha)
         	, semana_anio   	= Datepart(wk, @fecha)
         	, semana_nro_mes	= Datepart(wk, @fecha) - datepart(week, dateadd(dd,-day(@fecha)+1,@fecha)) +1
         	, dia                  	= Datepart(dd, @fecha)
   	   	, dia_nombre    	= CASE Datename(dw, @fecha)
                                    	when 'Monday'   	then 'Lunes'
                                    	when 'Tuesday'         	then 'Martes'
                                    	when 'Wednesday'	then 'Miercoles'
                                    	when 'Thursday'        	then 'Jueves'
                                    	when 'Friday'   	then 'Viernes'
                                    	when 'Saturday'        	then 'Sabado'
                                    	when 'Sunday'   	then 'Domingo'
                                    	else Datename(dw, @fecha)
                       	END
   	   	--, dia_nombre         	= Datename(dw, @fecha)
         	, dia_semana_nro	= Datepart(dw, @fecha)
         	   
   	SELECT @fecha = Dateadd(dd, 1, @fecha)
   	SELECT @dia     	= Datepart(dd, @fecha)
   	SELECT @mes     	= Datepart(mm, @fecha)
   	SELECT @anio  = Datepart(yy, @fecha) 	CONTINUE
   	
END;





-- Creación sp_carga_int_dim_categoria.


CREATE PROCEDURE dbo.sp_carga_int_dim_categoria
AS
BEGIN

TRUNCATE TABLE INT_DIM_CATEGORIA;

INSERT INTO INT_DIM_CATEGORIA (
	[COD_CATEGORIA],
	[DESC_CATEGORIA]
	)
	SELECT [COD_CATEGORIA],
	[DESC_CATEGORIA]
	FROM STG_DIM_CATEGORIA
END;




-- Creación sp_carga_int_dim_cliente.

CREATE PROCEDURE dbo.sp_carga_int_dim_cliente
AS
BEGIN

TRUNCATE TABLE INT_DIM_CLIENTE;

INSERT INTO INT_DIM_CLIENTE(
	[COD_CLIENTE],
	[NOMBRE],
	[APELLIDO]
	)
	SELECT [COD_CLIENTE],
		CASE WHEN DESC_CLIENTE LIKE '% % %' THEN PARSENAME(REPLACE(DESC_CLIENTE, ' ','.'), 3)
		ELSE PARSENAME(REPLACE(DESC_CLIENTE, ' ','.'), 2)
		END,
		CASE WHEN DESC_CLIENTE LIKE '% % %' 
		THEN CONCAT(PARSENAME(REPLACE(DESC_CLIENTE, ' ','.'), 2), ' ',PARSENAME(REPLACE(DESC_CLIENTE, ' ','.'),1))
		ELSE PARSENAME(REPLACE(DESC_CLIENTE, ' ','.'), 1)
		END
	FROM STG_DIM_CLIENTE
END;	




-- Creación sp_carga_int_dim_pais.

CREATE PROCEDURE dbo.sp_carga_int_dim_pais
AS

BEGIN

TRUNCATE TABLE INT_DIM_PAIS;

INSERT INTO INT_DIM_PAIS(
	[COD_PAIS],
	[DESC_PAIS]
	)
	SELECT [COD_PAIS],
	[DESC_PAIS]
	FROM STG_DIM_PAIS
END;




-- Creación sp_carga_int_dim_producto

CREATE PROCEDURE dbo.sp_carga_int_dim_producto
AS

BEGIN

TRUNCATE TABLE INT_DIM_PRODUCTO;

INSERT INTO INT_DIM_PRODUCTO(
	[COD_PRODUCTO],
	[DESC_PRODUCTO]
	)
	SELECT [COD_PRODUCTO],
	[DESC_PRODUCTO]
	FROM STG_DIM_PRODUCTO
END;




-- Creación sp_carga_int_dim_sucursal

CREATE PROCEDURE dbo.sp_carga_int_dim_sucursal
AS

BEGIN

TRUNCATE TABLE INT_DIM_SUCURSAL;

INSERT INTO INT_DIM_SUCURSAL(
	[COD_SUCURSAL],
	[DESC_SUCURSAL]
	)
	SELECT [COD_SUCURSAL],
	[DESC_SUCURSAL]
	FROM STG_DIM_SUCURSAL
END;




-- Creación sp_carga_int_dim_vendedor

CREATE PROCEDURE dbo.sp_carga_int_dim_vendedor
AS

BEGIN

TRUNCATE TABLE INT_DIM_VENDEDOR;

INSERT INTO INT_DIM_VENDEDOR(
	[COD_VENDEDOR],
	[NOMBRE],
	[APELLIDO]
	)
	SELECT [COD_VENDEDOR],
	CASE WHEN DESC_VENDEDOR LIKE '% % %' 
		THEN CONCAT(PARSENAME(REPLACE(DESC_VENDEDOR, ' ','.'), 3), ' ',PARSENAME(REPLACE(DESC_VENDEDOR, ' ','.'),2))
		ELSE PARSENAME(REPLACE(DESC_VENDEDOR, ' ','.'), 2)
		END,
		PARSENAME(REPLACE(DESC_VENDEDOR, ' ','.'), 1)
		FROM STG_DIM_VENDEDOR
END;


-- Creación sp_carga_int_fact_ventas

CREATE PROCEDURE dbo.sp_carga_int_fact_ventas

AS

BEGIN

TRUNCATE TABLE [dbo].[INT_FACT_VENTAS]

INSERT INTO [dbo].[INT_FACT_VENTAS](
	 [COD_PRODUCTO],
	 [COD_CATEGORIA],
	 [COD_CLIENTE],
	 [COD_PAIS],
	 [COD_VENDEDOR],
	 [COD_SUCURSAL],
	 [FECHA],
	 [CANTIDAD_VENDIDA],
	 [MONTO_VENDIDO],
	 [PRECIO],
	 [COMISION_COMERCIAL])

	SELECT [COD_PRODUCTO],
		  [COD_CATEGORIA],
		  [COD_CLIENTE],
		  [COD_PAIS],
		  [COD_VENDEDOR],
		  [COD_SUCURSAL],
		  CAST([FECHA] AS smalldatetime),
		  ISNULL(CAST([CANTIDAD_VENDIDA] AS decimal(18,2)),0),
		  ISNULL(CAST([MONTO_VENDIDO] AS decimal(18,2)),0),
		  ISNULL(CAST([PRECIO] AS decimal(18,2)),0),
		  ISNULL(CAST([COMISION_COMERCIAL] AS decimal(18,2)),0)
	FROM [dbo].[STG_FACT_VENTAS] 
END;




-- Creación sp carga dim categoria

CREATE PROCEDURE dbo.sp_carga_dim_categoria
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D
	SET 
	D.DESC_CATEGORIA = I.DESC_CATEGORIA,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_CATEGORIA D 
	JOIN INT_DIM_CATEGORIA I
	ON D.COD_CATEGORIA = I.COD_CATEGORIA;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_CATEGORIA](
            D.[COD_CATEGORIA],
            D.[DESC_CATEGORIA],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_CATEGORIA, I.DESC_CATEGORIA, GETDATE(), CURRENT_USER
		FROM INT_DIM_CATEGORIA I 
		LEFT JOIN DIM_CATEGORIA D
		ON I.COD_CATEGORIA = D.COD_CATEGORIA
		WHERE D.COD_CATEGORIA IS NULL
END;



-- Creación sp carga dim cliente

CREATE PROCEDURE dbo.sp_carga_dim_cliente
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D  
	SET 
	D.NOMBRE = I.NOMBRE,
	D.APELLIDO = I.APELLIDO,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_CLIENTE D 
	JOIN INT_DIM_CLIENTE I
	ON D.COD_CLIENTE = I.COD_CLIENTE;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_CLIENTE](
            D.[COD_CLIENTE],
			D.[NOMBRE],
            D.[APELLIDO],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_CLIENTE ,I.NOMBRE, I.APELLIDO, GETDATE(), CURRENT_USER 
		FROM INT_DIM_CLIENTE I 
		LEFT JOIN DIM_CLIENTE D
		ON I.COD_CLIENTE = D.COD_CLIENTE
		WHERE D.COD_CLIENTE IS NULL

END;



-- Creación sp carga dim pais

CREATE PROCEDURE dbo.sp_carga_dim_pais
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D  
	SET 
	D.DESC_PAIS = I.DESC_PAIS,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_PAIS D 
	JOIN INT_DIM_PAIS I
	ON D.COD_PAIS = I.COD_PAIS;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_PAIS](
            D.[COD_PAIS],
            D.[DESC_PAIS],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_PAIS, I.DESC_PAIS, GETDATE(), CURRENT_USER 
		FROM INT_DIM_PAIS I 
		LEFT JOIN DIM_PAIS D
		ON I.COD_PAIS = D.COD_PAIS
		WHERE D.COD_PAIS IS NULL

END;




-- Creación sp carga dim producto

CREATE PROCEDURE dbo.sp_carga_dim_producto
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D  
	SET 
	D.DESC_PRODUCTO = I.DESC_PRODUCTO,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_PRODUCTO D 
	JOIN INT_DIM_PRODUCTO I
	ON D.COD_PRODUCTO = I.COD_PRODUCTO;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_PRODUCTO](
            D.[COD_PRODUCTO],
            D.[DESC_PRODUCTO],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_PRODUCTO, I.DESC_PRODUCTO, GETDATE(), CURRENT_USER 
		FROM INT_DIM_PRODUCTO I 
		LEFT JOIN DIM_PRODUCTO D
		ON I.COD_PRODUCTO = D.COD_PRODUCTO
		WHERE D.COD_PRODUCTO IS NULL

END;



-- Creación sp carga dim sucursal

CREATE PROCEDURE dbo.sp_carga_dim_sucursal
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D  
	SET 
	D.DESC_SUCURSAL = I.DESC_SUCURSAL,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_SUCURSAL D 
	JOIN INT_DIM_SUCURSAL I
	ON D.COD_SUCURSAL = I.COD_SUCURSAL;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_SUCURSAL](
            D.[COD_SUCURSAL],
            D.[DESC_SUCURSAL],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_SUCURSAL, I.DESC_SUCURSAL, GETDATE(), CURRENT_USER 
		FROM INT_DIM_SUCURSAL I 
		LEFT JOIN DIM_SUCURSAL D
		ON I.COD_SUCURSAL = D.COD_SUCURSAL
		WHERE D.COD_SUCURSAL IS NULL

END;



-- Creación sp carga dim vendedor

CREATE PROCEDURE dbo.sp_carga_dim_vendedor
AS
BEGIN
-- Actualizacion registros existentes
	
	UPDATE D  
	SET 
	D.NOMBRE = I.NOMBRE,
	D.APELLIDO = I.APELLIDO,
	D.FECHA_UPDATE = GETDATE(),
	D.USUARIO_UPDATE = CURRENT_USER
	FROM DIM_VENDEDOR D 
	JOIN INT_DIM_VENDEDOR I
	ON D.COD_VENDEDOR = I.COD_VENDEDOR;

-- Inserción nuevos registros

	INSERT INTO [dbo].[DIM_VENDEDOR](
            D.[COD_VENDEDOR],
			D.[NOMBRE],
            D.[APELLIDO],
			D.FECHA_ALTA,
			D.USUARIO_ALTA)

		SELECT I.COD_VENDEDOR ,I.NOMBRE, I.APELLIDO, GETDATE(), CURRENT_USER 
		FROM INT_DIM_VENDEDOR I 
		LEFT JOIN DIM_VENDEDOR D
		ON I.COD_VENDEDOR = D.COD_VENDEDOR
		WHERE D.COD_VENDEDOR IS NULL

END;




-- Creación sp carga fact ventas

CREATE PROCEDURE sp_carga_fact_ventas

-- Parámetros de fecha para borrar e insertar registros dentro de un rango determinado

@FechaDesde smalldatetime,
@FechaHasta smalldatetime

AS 
BEGIN

-- Se borran los registros ya existentes en el período temporal seleccionado

	DELETE FROM FACT_VENTAS
	WHERE TIEMPO_KEY between @FechaDesde and @FechaHasta

	INSERT INTO dbo.FACT_VENTAS(
		[PRODUCTO_KEY],
		[CATEGORIA_KEY],
		[CLIENTE_KEY],
		[PAIS_KEY],
		[VENDEDOR_KEY],
		[SUCURSAL_KEY],
		[TIEMPO_KEY],
		[CANTIDAD_VENDIDA],
		[MONTO_VENDIDO],
		[PRECIO],
		[COMISION_COMERCIAL],
		[FECHA_ALTA],
		[USUARIO_ALTA]
		)
	SELECT 
		prod.PRODUCTO_KEY,
		MAX(cat.CATEGORIA_KEY),
		cli.CLIENTE_KEY,
		MAX(pais.PAIS_KEY),
		vend.VENDEDOR_KEY,
		suc.SUCURSAL_KEY,
		tiempo.TIEMPO_KEY,
		SUM(vent.CANTIDAD_VENDIDA),
		SUM(vent.MONTO_VENDIDO),
		SUM(vent.PRECIO),
		SUM(vent.COMISION_COMERCIAL),
		GETDATE(), 
		CURRENT_USER
	FROM INT_FACT_VENTAS vent 
		LEFT JOIN DIM_PRODUCTO prod ON vent.COD_PRODUCTO = prod.COD_PRODUCTO  
		LEFT JOIN DIM_CATEGORIA cat ON vent.COD_CATEGORIA = cat.COD_CATEGORIA
		LEFT JOIN DIM_CLIENTE cli ON vent.COD_CLIENTE = cli.COD_CLIENTE
		LEFT JOIN DIM_PAIS pais ON vent.COD_PAIS = pais.COD_PAIS
		LEFT JOIN DIM_VENDEDOR vend ON vent.COD_VENDEDOR = vend.COD_VENDEDOR
		LEFT JOIN DIM_SUCURSAL suc ON vent.COD_SUCURSAL = suc.COD_SUCURSAL
		LEFT JOIN DIM_TIEMPO tiempo ON vent.FECHA = tiempo.TIEMPO_KEY
	WHERE TIEMPO_KEY between @FechaDesde and @FechaHasta
	GROUP BY prod.PRODUCTO_KEY,
		cli.CLIENTE_KEY,
		vend.VENDEDOR_KEY,
		suc.SUCURSAL_KEY,
		tiempo.TIEMPO_KEY


END;





---- INSERTS EN TABLAS ----		


-- Carga de la DIM Tiempo desde 2015 hasta 2025


EXEC [dbo].[sp_carga_dim_tiempo] 2015;
EXEC [dbo].[sp_carga_dim_tiempo] 2016;
EXEC [dbo].[sp_carga_dim_tiempo] 2017;
EXEC [dbo].[sp_carga_dim_tiempo] 2018;
EXEC [dbo].[sp_carga_dim_tiempo] 2019;
EXEC [dbo].[sp_carga_dim_tiempo] 2020;
EXEC [dbo].[sp_carga_dim_tiempo] 2021;
EXEC [dbo].[sp_carga_dim_tiempo] 2022;
EXEC [dbo].[sp_carga_dim_tiempo] 2023;
EXEC [dbo].[sp_carga_dim_tiempo] 2024;
EXEC [dbo].[sp_carga_dim_tiempo] 2025;


SELECT * FROM DIM_TIEMPO;


-- Carga INT_DIM_CATEGORIA

EXEC dbo.sp_carga_int_dim_categoria;

SELECT * FROM INT_DIM_CATEGORIA;


-- Carga INT_DIM_CLIENTE

EXEC dbo.sp_carga_int_dim_cliente;

SELECT * FROM INT_DIM_CLIENTE;


-- Carga INT_DIM_PAIS

EXEC dbo.sp_carga_int_dim_pais;

SELECT * FROM INT_DIM_PAIS;


-- Carga INT_DIM_PRODUCTO

EXEC dbo.sp_carga_int_dim_producto;

SELECT * FROM INT_DIM_PRODUCTO;


-- Carga INT_DIM_SUCURSAL

EXEC dbo.sp_carga_int_dim_sucursal;

SELECT * FROM INT_DIM_SUCURSAL;


-- Carga INT_DIM_VENDEDOR

EXEC dbo.sp_carga_int_dim_vendedor;

SELECT * FROM INT_DIM_VENDEDOR;


-- Carga INT_FACT_VENTAS

EXEC dbo.sp_carga_int_fact_ventas;

SELECT * FROM INT_FACT_VENTAS;



-- Carga DIM_CATEGORIA

EXEC dbo.sp_carga_dim_categoria;

SELECT * FROM DIM_CATEGORIA;


-- Carga DIM_CLIENTE

EXEC dbo.sp_carga_dim_cliente;

SELECT * FROM DIM_CLIENTE;


-- Carga DIM_PAIS

EXEC dbo.sp_carga_dim_pais;

SELECT * FROM DIM_PAIS;


-- Carga DIM_PRODUCTO

EXEC dbo.sp_carga_dim_producto;

SELECT * FROM DIM_PRODUCTO;


-- Carga DIM_SUCURSAL

EXEC dbo.sp_carga_dim_sucursal;

SELECT * FROM DIM_SUCURSAL;


-- Carga DIM_VENDEDOR

EXEC dbo.sp_carga_dim_vendedor;

SELECT * FROM DIM_VENDEDOR;


-- Carga FACT_VENTAS

EXEC dbo.sp_carga_fact_ventas '2015-01-01', '2025-01-01';

SELECT * FROM FACT_VENTAS;    















